import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';

/// Data access object for Payment Verification Requests and System Logs.
class PaymentRequestDao {
  /// Constructor injecting DatabaseServiceImpl and AppLogger.
  PaymentRequestDao(this._dbService, this._logger);

  final DatabaseServiceImpl _dbService;
  final AppLogger _logger;

  static const String _tableName = 'payment_request_logs';
  static const String _logsTableName = 'payment_system_logs';

  /// Insert a new payment request log record.
  Future<Result<void>> insertRequest(Map<String, dynamic> row) async {
    try {
      final db = _dbService.database;
      await db.insert(
        _tableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_INSERT_ERR',
        'Failed to insert payment request log',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_INSERT_ERR',
          message: 'Error inserting payment request: ${e.toString()}',
        ),
      );
    }
  }

  /// Update an existing payment request log record.
  Future<Result<void>> updateRequest(Map<String, dynamic> row) async {
    try {
      final db = _dbService.database;
      final id = row['id'] as String;
      await db.update(
        _tableName,
        row,
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_UPDATE_ERR',
        'Failed to update payment request log',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_UPDATE_ERR',
          message: 'Error updating payment request: ${e.toString()}',
        ),
      );
    }
  }

  /// Find payment request log by ID.
  Future<Result<Map<String, dynamic>?>> findRequestById(String id) async {
    try {
      final db = _dbService.database;
      final maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Result.success(maps.first);
      }
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_FIND_ERR',
        'Failed to find payment request by id',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_FIND_ERR',
          message: 'Error finding payment request: ${e.toString()}',
        ),
      );
    }
  }

  /// Find payment request log by reference number.
  Future<Result<Map<String, dynamic>?>> findRequestByReferenceNumber(
    String referenceNumber,
  ) async {
    if (referenceNumber.isEmpty) return const Result.success(null);
    try {
      final db = _dbService.database;
      final maps = await db.query(
        _tableName,
        where: 'reference_number = ?',
        whereArgs: [referenceNumber],
      );
      if (maps.isNotEmpty) {
        return Result.success(maps.first);
      }
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_FIND_REF_ERR',
        'Failed to find payment request by reference number',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_FIND_REF_ERR',
          message: 'Error finding payment request by ref: ${e.toString()}',
        ),
      );
    }
  }

  /// Get all payment requests ordered by detected_at DESC.
  Future<Result<List<Map<String, dynamic>>>> getAllRequests() async {
    try {
      final db = _dbService.database;
      final maps = await db.query(
        _tableName,
        orderBy: 'detected_at DESC',
      );
      return Result.success(maps);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_GET_ALL_ERR',
        'Failed to get all payment requests',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_GET_ALL_ERR',
          message: 'Error getting payment requests: ${e.toString()}',
        ),
      );
    }
  }

  /// Get pending requests count (Detected, Parsed, Waiting Upload, Sending).
  Future<Result<int>> getPendingCount() async {
    try {
      final db = _dbService.database;
      final result = await db.rawQuery(
        "SELECT COUNT(*) as cnt FROM $_tableName WHERE status IN ('Detected', 'Parsed', 'Waiting Upload', 'Sending')",
      );
      final count = Sqflite.firstIntValue(result) ?? 0;
      return Result.success(count);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_PENDING_CNT_ERR',
        'Failed to get pending count',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_PENDING_CNT_ERR',
          message: 'Error counting pending requests: ${e.toString()}',
        ),
      );
    }
  }

  /// Get failed requests count.
  Future<Result<int>> getFailedCount() async {
    try {
      final db = _dbService.database;
      final result = await db.rawQuery(
        "SELECT COUNT(*) as cnt FROM $_tableName WHERE status = 'Failed'",
      );
      final count = Sqflite.firstIntValue(result) ?? 0;
      return Result.success(count);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_FAILED_CNT_ERR',
        'Failed to get failed count',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_FAILED_CNT_ERR',
          message: 'Error counting failed requests: ${e.toString()}',
        ),
      );
    }
  }

  /// Get pending and failed requests for retry.
  Future<Result<List<Map<String, dynamic>>>> getRequestsForRetry() async {
    try {
      final db = _dbService.database;
      final maps = await db.query(
        _tableName,
        where: "status IN ('Failed', 'Waiting Upload', 'Detected', 'Parsed')",
        orderBy: 'detected_at ASC',
      );
      return Result.success(maps);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_REQ_RETRY_LIST_ERR',
        'Failed to get requests for retry',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_REQ_RETRY_LIST_ERR',
          message: 'Error getting retry requests: ${e.toString()}',
        ),
      );
    }
  }

  /// Insert a system event log.
  Future<Result<void>> insertSystemLog(Map<String, dynamic> row) async {
    try {
      final db = _dbService.database;
      await db.insert(
        _logsTableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_SYS_LOG_INSERT_ERR',
        'Failed to insert system log',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_SYS_LOG_INSERT_ERR',
          message: 'Error inserting system log: ${e.toString()}',
        ),
      );
    }
  }

  /// Get system event logs ordered by timestamp DESC.
  Future<Result<List<Map<String, dynamic>>>> getSystemLogs({int limit = 100}) async {
    try {
      final db = _dbService.database;
      final maps = await db.query(
        _logsTableName,
        orderBy: 'timestamp DESC',
        limit: limit,
      );
      return Result.success(maps);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAY_SYS_LOG_GET_ERR',
        'Failed to get system logs',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_DAO_PAY_SYS_LOG_GET_ERR',
          message: 'Error getting system logs: ${e.toString()}',
        ),
      );
    }
  }
}
