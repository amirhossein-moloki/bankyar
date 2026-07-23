import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/platform/clock.dart';
import '../../../../core/platform/uuid.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/bank_message_entity.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/repository/sms_parser_repository.dart';
import '../datasources/bank_message_dao.dart';
import '../models/bank_message_dto.dart';
import '../parser/duplicate_detector.dart';
import '../parser/sms_pipeline_engine.dart';

/// Concrete database-bound implementation of [SmsParserRepository].
/// Handles pipeline execution, duplicate detection, and transactional atomic persistence.
class SmsParserRepositoryImpl implements SmsParserRepository {
  /// Constructor injecting required system adapters and DAOs.
  SmsParserRepositoryImpl({
    required this.dbService,
    required this.bankMessageDao,
    required this.uuidGenerator,
    required this.clock,
    required this.logger,
    this.pipelineEngine = const SmsPipelineEngine(),
  });

  /// Relational database service.
  final DatabaseServiceImpl dbService;

  /// Direct captured message DAO.
  final BankMessageDao bankMessageDao;

  /// System UUID v4 generator.
  final UuidGenerator uuidGenerator;

  /// System clock.
  final Clock clock;

  /// System logger.
  final AppLogger logger;

  /// Pipeline engine helper.
  final SmsPipelineEngine pipelineEngine;

  @override
  Future<Result<ParsedTransaction?>> processAndSaveSms({
    required String rawText,
    required String senderId,
    required int receivedAt,
  }) async {
    return logger.tracePerformanceAsync(
      category: LogCategories.parser,
      operationName: 'ProcessAndSaveSms',
      computation: () async {
        try {
          // 1. Generate Deduplication Hash
          final hash = DuplicateDetector.calculateHash(
            rawText: rawText,
            receivedAt: receivedAt,
            senderId: senderId,
          );

          // 2. Perform Duplication Lookup
          final duplicateResult = await isDuplicate(hash);
          if (duplicateResult is FailureResult<bool>) {
            return Result.failure(duplicateResult.failure);
          }
          final isDupe = (duplicateResult as Success<bool>).data;

          // 3. Generate IDs ahead of pipeline execution
          final messageId = uuidGenerator.generateV4();
          final transactionId = uuidGenerator.generateV4();

          // 4. Run Pipeline parsing checks
          final pipelineResult = pipelineEngine.process(
            rawText: rawText,
            senderId: senderId,
            receivedAt: receivedAt,
            isDuplicate: isDupe,
            messageId: messageId,
            transactionId: transactionId,
          );

          // 5. Atomic transaction block write
          final db = dbService.database;
          await db.transaction((txn) async {
            // Write Bank Message Log
            await txn.insert(
              'bank_messages',
              BankMessageDto.toMap(pipelineResult.message),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );

            // Write Transaction if available
            final tx = pipelineResult.transaction;
            if (tx != null &&
                pipelineResult.status == IngestionStatus.success) {
              await txn.insert(
                'transactions',
                _parsedTransactionToMap(tx),
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          });

          logger.log(
            LogLevel.info,
            LogCategories.parser,
            'BY_PARSER_PIPELINE_COMPLETE',
            'SMS processing pipeline run complete.',
            metadata: {
              'status': pipelineResult.status.name,
              'reason': pipelineResult.reason,
            },
          );

          return Result.success(pipelineResult.transaction);
        } on Exception catch (e, stack) {
          logger.log(
            LogLevel.error,
            LogCategories.parser,
            'BY_PARSER_PIPELINE_ERROR',
            'Exception captured during SMS ingestion pipeline execution.',
            error: e,
            stackTrace: stack,
          );
          return Result.failure(
            ParserFailure(
              code: 'BY_PARSER_PIPELINE_ERROR',
              message: 'Failed to process incoming SMS: ${e.toString()}',
            ),
          );
        }
      },
    );
  }

  @override
  Future<Result<bool>> isDuplicate(String deduplicationHash) async {
    try {
      final db = dbService.database;
      final result = await db.query(
        'bank_messages',
        where: 'deduplication_hash = ?',
        whereArgs: [deduplicationHash],
        limit: 1,
      );
      return Result.success(result.isNotEmpty);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.parser,
        'BY_PARSER_DEDUP_ERROR',
        'Duplicate lookup query failed.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_PARSER_DEDUP_ERROR',
          message: 'Deduplication lookup failed: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void>> saveBankMessage(BankMessageEntity message) async {
    return bankMessageDao.insert(message);
  }

  @override
  Future<Result<BankMessageEntity?>> getBankMessageById(String id) async {
    return bankMessageDao.findById(id);
  }

  @override
  Future<Result<void>> saveParsedTransaction(
    ParsedTransaction transaction,
  ) async {
    try {
      final db = dbService.database;
      await db.insert(
        'transactions',
        _parsedTransactionToMap(transaction),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Result.success(null);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.parser,
        'BY_PARSER_TX_SAVE_ERROR',
        'Direct transaction ledger write failed.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_PARSER_TX_SAVE_ERROR',
          message: 'Direct transaction save failed: ${e.toString()}',
        ),
      );
    }
  }

  Map<String, dynamic> _parsedTransactionToMap(ParsedTransaction tx) {
    return {
      'id': tx.id,
      'amount': tx.amount,
      'currency': tx.currency,
      'transaction_type': tx.transactionType.name,
      'raw_merchant': tx.rawMerchant,
      'normalized_merchant': tx.normalizedMerchant,
      'card_identifier': tx.cardIdentifier,
      'timestamp': tx.timestamp,
      'category_id': tx.categoryId,
      'source_sms_id': tx.sourceSmsId,
      'account_id': tx.accountId,
      'confidence_score': tx.confidenceScore,
      'parsing_method': tx.parsingMethod,
      'created_at': tx.createdAt,
      'updated_at': tx.updatedAt,
      'version': 1,
    };
  }
}
