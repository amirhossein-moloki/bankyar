import '../../../../core/database/sqlite_base_dao.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../models/transaction_dto.dart';

/// Relational Data Access Object mapping [ParsedTransaction] to SQLite pages.
class TransactionDao extends SqliteBaseDao<ParsedTransaction> {
  /// Constructor injecting DB Service and standard logger.
  TransactionDao(super.dbService, super.logger);

  @override
  String get tableName => 'transactions';

  @override
  String get chronologicalColumn => 'timestamp';

  @override
  Map<String, dynamic> toMap(ParsedTransaction entity) {
    return TransactionDto.toMap(entity);
  }

  @override
  ParsedTransaction fromMap(Map<String, dynamic> map) {
    return TransactionDto.fromMap(map);
  }

  @override
  Future<Result<List<ParsedTransaction>>> getChronologicalList() async {
    try {
      final db = dbService.database;
      final results = await db.rawQuery(
        '''
        SELECT t.*, n.note_text FROM transactions t
        LEFT JOIN notes n ON t.id = n.transaction_id
        ORDER BY t.$chronologicalColumn DESC
        '''
      );

      final list = results.map(fromMap).toList();
      return Result.success(list);
    } catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_LIST_FAILED',
        'List chronological query failed for table $tableName with notes join.',
        error: e,
        stackTrace: stack,
      );
      if (e is Failure) {
        return Result.failure(e);
      }
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_LIST_FAILED',
          message: 'Failed to fetch list with notes join: ${e.toString()}',
        ),
      );
    }
  }
}
