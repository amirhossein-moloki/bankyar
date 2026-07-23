import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../architecture/pagination.dart';
import '../errors/failures.dart';
import '../logging/logger.dart';
import '../utils/result.dart';
import 'database_service.dart';
import 'database_service_impl.dart';

/// Concrete generic base DAO class for relational SQLite tables.
/// Handles database operations, batching, transaction limits, and keyset pagination.
abstract class SqliteBaseDao<T> implements BaseDao<T> {
  /// Constructor injecting the concrete database service.
  SqliteBaseDao(this.dbService, this.logger) {
    // Add this DAO instance to the change notify listeners
    _registerNotificationStream();
  }

  /// The active database service.
  final DatabaseServiceImpl dbService;

  /// The application logger.
  final AppLogger logger;

  /// The target table name for database queries.
  String get tableName;

  /// The primary key column name.
  String get idColumn => 'id';

  /// The chronological sorting column (defaults to timestamp).
  String get chronologicalColumn => 'timestamp';

  /// Maps a typed entity [T] to a relational database map.
  Map<String, dynamic> toMap(T entity);

  /// Maps a relational database map to a typed entity [T].
  T fromMap(Map<String, dynamic> map);

  /// Global broadcast stream controller to notify subscribers of database mutations.
  static final StreamController<String> _tableMutationController =
      StreamController<String>.broadcast();

  void _registerNotificationStream() {
    _tableMutationController.stream.listen((mutatedTable) {
      if (mutatedTable == tableName) {
        _triggerStreamRequery();
      }
    });
  }

  final StreamController<Result<List<T>>> _chronologicalStreamController =
      StreamController<Result<List<T>>>.broadcast();

  void _triggerStreamRequery() async {
    if (_chronologicalStreamController.hasListener) {
      final result = await getChronologicalList();
      _chronologicalStreamController.add(result);
    }
  }

  @override
  Future<Result<void>> insert(T entity) async {
    try {
      final db = dbService.database;
      final map = toMap(entity);

      logger.log(
        LogLevel.debug,
        LogCategories.database,
        'BY_DAO_INSERT',
        'Inserting record into $tableName.',
        metadata: {'id': map[idColumn]},
      );

      await db.insert(
        tableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      _tableMutationController.add(tableName);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_INSERT_FAILED',
        'Insert failed for table $tableName.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_INSERT_FAILED',
          message: 'Failed to insert into $tableName: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<T?>> findById(String id) async {
    try {
      final db = dbService.database;
      final results = await db.query(
        tableName,
        where: '$idColumn = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return const Result.success(null);
      }

      final entity = fromMap(results.first);
      return Result.success(entity);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_FIND_FAILED',
        'Find by ID failed for table $tableName.',
        metadata: {'id': id},
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_FIND_FAILED',
          message: 'Find by ID failed: ${e.toString()}',
        ),
      );
    }
  }

  /// Synchronously fetch direct list of chronological relational records.
  Future<Result<List<T>>> getChronologicalList() async {
    try {
      final db = dbService.database;
      final results = await db.query(
        tableName,
        orderBy: '$chronologicalColumn DESC',
      );

      final list = results.map(fromMap).toList();
      return Result.success(list);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_LIST_FAILED',
        'List chronological query failed for table $tableName.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_LIST_FAILED',
          message: 'Failed to fetch list: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<Result<List<T>>> getChronologicalStream() {
    // Perform an initial fetch on first stream creation
    _triggerStreamRequery();
    return _chronologicalStreamController.stream;
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final db = dbService.database;
      logger.log(
        LogLevel.debug,
        LogCategories.database,
        'BY_DAO_DELETE',
        'Deleting record from $tableName.',
        metadata: {'id': id},
      );

      await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);

      _tableMutationController.add(tableName);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_DELETE_FAILED',
        'Delete failed for table $tableName.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_DELETE_FAILED',
          message: 'Delete failed: ${e.toString()}',
        ),
      );
    }
  }

  /// Bulk insert records in a single transactional batch operation.
  Future<Result<void>> insertAll(List<T> entities) async {
    try {
      final db = dbService.database;
      logger.log(
        LogLevel.debug,
        LogCategories.database,
        'BY_DAO_BATCH_INSERT',
        'Performing bulk batch insert.',
        metadata: {'count': entities.length, 'table': tableName},
      );

      await db.transaction<void>((txn) async {
        final batch = txn.batch();
        for (final entity in entities) {
          batch.insert(
            tableName,
            toMap(entity),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit(noResult: true);
      });

      _tableMutationController.add(tableName);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_BATCH_FAILED',
        'Bulk insert batch failed for table $tableName.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_BATCH_FAILED',
          message: 'Batch insert failed: ${e.toString()}',
        ),
      );
    }
  }

  /// Executes database tasks within a manual transaction boundary.
  Future<Result<R>> runInTransaction<R>(
    Future<R> Function(Transaction txn) action,
  ) async {
    try {
      final db = dbService.database;
      final R result = await db.transaction(action);
      _tableMutationController.add(tableName);
      return Result.success(result);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_TX_FAILED',
        'Manual database transaction failed.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_TX_FAILED',
          message: 'Transaction failed: ${e.toString()}',
        ),
      );
    }
  }

  /// Fetches a keyset seek paginated subset of records.
  Future<Result<PaginatedList<T>>> getPaginatedList(
    KeysetPaginationParams params,
  ) async {
    try {
      final db = dbService.database;
      final limit = params.limit;
      final anchorValue = params.anchorValue;
      final anchorId = params.anchorId;

      String whereClause = '';
      List<dynamic> whereArgs = [];

      // Keyset Pagination seeking using compound seek anchors (timestamp DESC, id DESC/ASC)
      if (anchorValue != null && anchorId != null) {
        whereClause =
            'WHERE $chronologicalColumn < ? OR ($chronologicalColumn = ? AND $idColumn < ?)';
        whereArgs = [anchorValue, anchorValue, anchorId];
      }

      final queryStr =
          '''
        SELECT * FROM $tableName
        $whereClause
        ORDER BY $chronologicalColumn DESC, $idColumn DESC
        LIMIT ${limit + 1}
      ''';

      final results = await db.rawQuery(queryStr, whereArgs);

      final hasMore = results.length > limit;
      final itemsToReturn = hasMore ? results.take(limit) : results;

      final list = itemsToReturn.map(fromMap).toList();

      Object? nextPageAnchorValue;
      String? nextPageAnchorId;

      if (list.isNotEmpty) {
        final lastItemMap = itemsToReturn.last;
        nextPageAnchorValue = lastItemMap[chronologicalColumn];
        nextPageAnchorId = lastItemMap[idColumn]?.toString();
      }

      final paginatedList = PaginatedList<T>(
        items: list,
        nextPageAnchor: hasMore
            ? {'value': nextPageAnchorValue, 'id': nextPageAnchorId}
            : null,
        hasMore: hasMore,
      );

      return Result.success(paginatedList);
    } on Exception catch (e, stack) {
      logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_DAO_PAGINATION_FAILED',
        'Keyset seek pagination failed for table $tableName.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_DAO_PAGINATION_FAILED',
          message: 'Pagination query failed: ${e.toString()}',
        ),
      );
    }
  }
}
