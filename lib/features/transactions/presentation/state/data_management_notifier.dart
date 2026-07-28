import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logging/logger.dart';
import '../../../sms_detection/data/parser/duplicate_detector.dart';
import '../../../sms_detection/data/parser/sms_pipeline_engine.dart';
import '../../../sms_detection/domain/entities/bank_message_entity.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../../sms_detection/presentation/state/sms_detection_providers.dart';
import '../../../notifications/presentation/state/notification_notifier.dart';
import '../../../analytics/presentation/state/analytics_notifier.dart';
import '../../../search/presentation/state/search_notifier.dart';
import '../state/home_notifier.dart';
import '../state/transactions_notifier.dart';

/// Enum representing the historical SMS import selection options.
enum ImportRange {
  /// Scan all messages in system inbox.
  all,

  /// Scan messages from last 3 months.
  last3Months,

  /// Scan messages from last 6 months.
  last6Months,

  /// Scan messages from last 12 months.
  last12Months,

  /// Scan messages within a custom date range.
  custom,
}

/// Representation of historical SMS ingestion statistics summary.
class ImportSummary {
  /// Constructor.
  const ImportSummary({
    required this.totalScanned,
    required this.bankSmsDetected,
    required this.newTransactionsImported,
    required this.duplicateSmsSkipped,
    required this.unsupportedSmsSkipped,
    required this.scanDurationSeconds,
  });

  /// Total count of SMS scanned.
  final int totalScanned;

  /// Count of bank SMS messages detected.
  final int bankSmsDetected;

  /// Count of new transactions actually imported.
  final int newTransactionsImported;

  /// Count of duplicate SMS skipped.
  final int duplicateSmsSkipped;

  /// Count of unsupported/failed parsing SMS skipped.
  final int unsupportedSmsSkipped;

  /// Duration of the scan in seconds.
  final double scanDurationSeconds;
}

/// Combined UI state for the Data Management controls.
class DataManagementState {
  /// Constructor.
  const DataManagementState({
    required this.isImporting,
    required this.importedCount,
    required this.totalSmsCount,
    required this.isCancelled,
    required this.successfulParsedCount,
    this.errorMessage,
    this.successMessage,
    this.lastImportDate,
    this.summary,
  });

  /// Default initial state.
  factory DataManagementState.initial() => const DataManagementState(
        isImporting: false,
        importedCount: 0,
        totalSmsCount: 0,
        isCancelled: false,
        successfulParsedCount: 0,
      );

  /// True when the historical SMS parsing task is in progress.
  final bool isImporting;

  /// Index representing currently analyzed SMS in progress.
  final int importedCount;

  /// Total count of SMS found in system inbox.
  final int totalSmsCount;

  /// True if scanning is cancelled.
  final bool isCancelled;

  /// Successfully parsed banking transactions.
  final int successfulParsedCount;

  /// Error feedback.
  final String? errorMessage;

  /// Success feedback.
  final String? successMessage;

  /// Timestamp of the last successful import date.
  final DateTime? lastImportDate;

  /// Complete statistics outcome of the last scan.
  final ImportSummary? summary;

  /// Copy with.
  DataManagementState copyWith({
    bool? isImporting,
    int? importedCount,
    int? totalSmsCount,
    bool? isCancelled,
    int? successfulParsedCount,
    String? errorMessage,
    String? successMessage,
    DateTime? lastImportDate,
    ImportSummary? summary,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSummary = false,
  }) {
    return DataManagementState(
      isImporting: isImporting ?? this.isImporting,
      importedCount: importedCount ?? this.importedCount,
      totalSmsCount: totalSmsCount ?? this.totalSmsCount,
      isCancelled: isCancelled ?? this.isCancelled,
      successfulParsedCount:
          successfulParsedCount ?? this.successfulParsedCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      lastImportDate: lastImportDate ?? this.lastImportDate,
      summary: clearSummary ? null : (summary ?? this.summary),
    );
  }
}

/// StateNotifier controlling bulk operations, and progressive historical SMS ingestion.
class DataManagementNotifier extends StateNotifier<DataManagementState> {
  /// Constructor.
  DataManagementNotifier({required Ref ref})
      : _ref = ref,
        super(DataManagementState.initial()) {
    loadLastImportDate();
  }

  final Ref _ref;
  static const _lastImportKey = 'bankyar.sms_history.last_import_date';

  /// Loads last successful import date.
  Future<void> loadLastImportDate() async {
    final prefs = _ref.read(preferencesStorageProvider);
    final lastImportStr = await prefs.getString(_lastImportKey);
    if (lastImportStr != null && lastImportStr.isNotEmpty) {
      final parsed = DateTime.tryParse(lastImportStr);
      if (parsed != null && mounted) {
        state = state.copyWith(lastImportDate: parsed);
      }
    }
  }

  /// Helper to check if duplicate hash exists.
  Future<bool> _checkHashExists(String hash) async {
    final dbService = _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
    final db = dbService.database;
    final res = await db.query(
      'bank_messages',
      where: 'deduplication_hash = ?',
      whereArgs: [hash],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  /// Specific duplicate detection following RB-013 duplicate criteria.
  /// A message is duplicate when: Same SMS ID OR Same Sender + Same Timestamp + Same Amount + Same Transaction Type.
  Future<bool> _checkIsDuplicate({
    required String? smsId,
    required String senderId,
    required int timestamp,
    required double amount,
    required String transactionType,
  }) async {
    final dbService = _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
    final db = dbService.database;

    // 1. Same SMS ID check
    if (smsId != null && smsId.isNotEmpty) {
      final resId = await db.query(
        'bank_messages',
        where: 'id = ?',
        whereArgs: [smsId],
        limit: 1,
      );
      if (resId.isNotEmpty) return true;
    }

    // 2. Same Sender + Same Timestamp + Same Amount + Same Transaction Type
    final resTx = await db.rawQuery('''
      SELECT 1 FROM transactions t
      INNER JOIN bank_messages m ON t.source_sms_id = m.id
      WHERE m.sender_id = ? AND t.timestamp = ? AND t.amount = ? AND t.transaction_type = ?
      LIMIT 1
    ''', [senderId, timestamp, amount, transactionType]);

    return resTx.isNotEmpty;
  }

  /// Initiates scanning of system SMS inbox for past banking logs with custom date selection bounds.
  Future<void> startHistoricalImport({
    required ImportRange range,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    if (state.isImporting) return;

    state = DataManagementState.initial().copyWith(isImporting: true);
    final stopwatch = Stopwatch()..start();

    try {
      int sinceTimestamp = 0;
      final now = DateTime.now();

      switch (range) {
        case ImportRange.last3Months:
          sinceTimestamp =
              now.subtract(const Duration(days: 90)).millisecondsSinceEpoch;
          break;
        case ImportRange.last6Months:
          sinceTimestamp =
              now.subtract(const Duration(days: 180)).millisecondsSinceEpoch;
          break;
        case ImportRange.last12Months:
          sinceTimestamp =
              now.subtract(const Duration(days: 365)).millisecondsSinceEpoch;
          break;
        case ImportRange.custom:
          sinceTimestamp = customStartDate?.millisecondsSinceEpoch ?? 0;
          break;
        case ImportRange.all:
        default:
          sinceTimestamp = 0;
          break;
      }

      const channel = MethodChannel('com.bankyar.app/platform');
      final List<dynamic>? rawMessages =
          await channel.invokeMethod<List<dynamic>>(
        'queryHistoricalSms',
        {'since': sinceTimestamp},
      );

      if (rawMessages == null || rawMessages.isEmpty) {
        stopwatch.stop();
        state = state.copyWith(
          isImporting: false,
          successMessage: 'هیچ پیامکی برای وارد کردن یافت نشد.',
        );
        return;
      }

      // Filter messages further if custom range has an end date
      Iterable<dynamic> filteredRaw = rawMessages;
      if (range == ImportRange.custom && customEndDate != null) {
        final untilTimestamp = customEndDate.millisecondsSinceEpoch;
        filteredRaw = rawMessages.where((msg) {
          if (msg is Map<dynamic, dynamic>) {
            final ts = (msg['timestamp'] as int?) ?? 0;
            return ts <= untilTimestamp;
          }
          return false;
        });
      }

      final messagesList = filteredRaw.toList();
      final totalCount = messagesList.length;
      state = state.copyWith(totalSmsCount: totalCount);

      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      final uuidGen = _ref.read(uuidGeneratorProvider);

      int processed = 0;
      int bankDetected = 0;
      int successfulParsed = 0;
      int duplicateSkipped = 0;
      int unsupportedSkipped = 0;

      // Lists to perform highly optimized final batch write
      final List<BankMessageEntity> messagesToWrite = [];
      final List<ParsedTransaction> transactionsToWrite = [];

      for (final raw in messagesList) {
        if (state.isCancelled) {
          break;
        }

        if (raw is Map<dynamic, dynamic>) {
          final String? smsId = raw['id']?.toString();
          final String sender = (raw['sender'] as String?) ?? '';
          final String body = (raw['body'] as String?) ?? '';
          final int timestamp = (raw['timestamp'] as int?) ?? 0;

          // Standard deduplication hash
          final hash = DuplicateDetector.calculateHash(
            rawText: body,
            receivedAt: timestamp,
            senderId: sender,
          );

          final hashExists = await _checkHashExists(hash);
          if (hashExists) {
            duplicateSkipped++;
            processed++;
            state = state.copyWith(importedCount: processed);
            await Future.delayed(Duration.zero);
            continue;
          }

          final messageId = smsId ?? uuidGen.generateV4();
          final transactionId = uuidGen.generateV4();

          final engine = const SmsPipelineEngine();
          final pipelineResult = engine.process(
            rawText: body,
            senderId: sender,
            receivedAt: timestamp,
            isDuplicate: false,
            messageId: messageId,
            transactionId: transactionId,
          );

          final tx = pipelineResult.transaction;
          if (tx != null && pipelineResult.status == IngestionStatus.success) {
            bankDetected++;

            final isDupeInDb = await _checkIsDuplicate(
              smsId: smsId,
              senderId: pipelineResult.message.senderId,
              timestamp: tx.timestamp,
              amount: tx.amount,
              transactionType: tx.transactionType.name,
            );

            if (isDupeInDb) {
              duplicateSkipped++;
              final duplicateMessage = pipelineResult.message.copyWith(
                ingestionStatus: IngestionStatus.duplicate,
              );
              messagesToWrite.add(duplicateMessage);
            } else {
              messagesToWrite.add(pipelineResult.message);
              transactionsToWrite.add(tx);
              successfulParsed++;
            }
          } else {
            if (pipelineResult.status == IngestionStatus.failure) {
              bankDetected++;
              unsupportedSkipped++;
            } else {
              unsupportedSkipped++;
            }
            messagesToWrite.add(pipelineResult.message);
          }
        }

        processed++;
        state = state.copyWith(
          importedCount: processed,
          successfulParsedCount: successfulParsed,
        );
        // Ensure UI thread renders progress flawlessly
        await Future.delayed(Duration.zero);
      }

      // Execute final highly-optimized atomic batch commit
      if (!state.isCancelled && messagesToWrite.isNotEmpty) {
        await db.transaction((txn) async {
          final batch = txn.batch();
          for (final msg in messagesToWrite) {
            batch.insert(
              'bank_messages',
              _bankMessageToMap(msg),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          for (final tx in transactionsToWrite) {
            batch.insert(
              'transactions',
              _parsedTransactionToMap(tx),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          await batch.commit(noResult: true);
        });
      }

      stopwatch.stop();
      final durationSecs = stopwatch.elapsedMilliseconds / 1000.0;

      final wasCancelled = state.isCancelled;

      if (!wasCancelled) {
        final nowStr = DateTime.now().toIso8601String();
        final prefs = _ref.read(preferencesStorageProvider);
        await prefs.setString(_lastImportKey, nowStr);
        await loadLastImportDate();
      }

      state = state.copyWith(
        isImporting: false,
        successMessage: wasCancelled
            ? 'وارد کردن پیامک‌ها متوقف شد.'
            : 'وارد کردن پیامک‌های قبلی به پایان رسید.',
        summary: wasCancelled
            ? null
            : ImportSummary(
                totalScanned: totalCount,
                bankSmsDetected: bankDetected,
                newTransactionsImported: successfulParsed,
                duplicateSmsSkipped: duplicateSkipped,
                unsupportedSmsSkipped: unsupportedSkipped,
                scanDurationSeconds: durationSecs,
              ),
      );

      _invalidateAllProviders();
    } catch (e, stack) {
      stopwatch.stop();
      state = state.copyWith(
        isImporting: false,
        errorMessage: 'خطا در وارد کردن پیامک‌ها: $e',
      );
      _ref.read(loggerProvider).log(
        LogLevel.error,
        LogCategories.platform,
        'BY_HISTORICAL_IMPORT_FAILED',
        'Historical SMS ingestion exception',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Cancels progress.
  void cancelImport() {
    state = state.copyWith(isCancelled: true);
  }

  /// Deletes all imported SMS logs.
  Future<bool> deleteImportedSms() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      await db.transaction((txn) async {
        await txn.delete('bank_messages');
      });
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes all transactions and purges the search index.
  Future<bool> deleteAllTransactions() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      await db.transaction((txn) async {
        await txn.delete('transactions');
        await txn.delete('fts_transactions_search');
      });
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes all notifications.
  Future<bool> deleteAllNotifications() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      await db.transaction((txn) async {
        await txn.delete('notifications');
      });
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes all notes.
  Future<bool> deleteAllNotes() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      await db.transaction((txn) async {
        await txn.delete('notes');
      });
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes all categories.
  Future<bool> deleteAllCategories() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      await db.transaction((txn) async {
        await txn.delete('categories');
      });
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes all tags.
  Future<bool> deleteAllTags() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      final db = dbService.database;
      await db.transaction((txn) async {
        await txn.delete('tags');
        await txn.delete('transaction_tags');
      });
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Resets/Wipes the database entirely.
  Future<bool> deleteLocalDatabase() async {
    try {
      final dbService =
          _ref.read(databaseServiceProvider) as DatabaseServiceImpl;
      await dbService.wipeLocalSandboxData();
      _invalidateAllProviders();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clears outstanding alerts.
  void clearStatusMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  /// Clears active summary from state.
  void clearSummary() {
    state = state.copyWith(clearSummary: true);
  }

  void _invalidateAllProviders() {
    _ref.invalidate(homeViewModelProvider);
    _ref.invalidate(transactionsViewModelProvider);
    _ref.invalidate(analyticsViewModelProvider);
    _ref.invalidate(searchViewModelProvider);
    _ref.invalidate(notificationNotifierProvider);
  }

  Map<String, dynamic> _bankMessageToMap(BankMessageEntity msg) {
    return {
      'id': msg.id,
      'raw_text': msg.rawText,
      'sender_id': msg.senderId,
      'received_at': msg.receivedAt,
      'deduplication_hash': msg.deduplicationHash,
      'ingestion_status': msg.ingestionStatus.name,
    };
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

/// Provider exposing the DataManagementNotifier.
final dataManagementNotifierProvider =
    StateNotifierProvider<DataManagementNotifier, DataManagementState>((ref) {
  return DataManagementNotifier(ref: ref);
});
