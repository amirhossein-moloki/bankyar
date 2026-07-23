import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/errors/failures.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

class TestDatabaseServiceImpl extends DatabaseServiceImpl {
  TestDatabaseServiceImpl(super.logger, this.testDb);
  final Database testDb;

  @override
  Database get database => testDb;

  @override
  bool get isOpen => true;
}

void main() {
  late MockAppLogger mockLogger;
  late TestDatabaseServiceImpl databaseService;
  late MockDatabase mockDb;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDb = MockDatabase();
    databaseService = TestDatabaseServiceImpl(mockLogger, mockDb);
  });

  group('Database Transaction and Rollback Tests', () {
    test(
      'wipeLocalSandboxData rolls back completely and returns FileAccessFailure on error',
      () async {
        // Force database transaction to throw Exception to simulate failure and verify rollback handling
        when(() => mockDb.transaction<void>(any())).thenAnswer((
          invocation,
        ) async {
          final transactionCallback =
              invocation.positionalArguments[0]
                  as Future<void> Function(Transaction);
          final mockTxn = MockTransaction();
          when(
            () => mockTxn.delete(any()),
          ).thenThrow(Exception('disk full during delete'));

          // Execute the callback which will throw and rollback
          await transactionCallback(mockTxn);
        });

        final result = await databaseService.wipeLocalSandboxData();

        expect(result, isA<FailureResult<void>>());
        final failure = (result as FailureResult<void>).failure;
        expect(failure, isA<FileAccessFailure>());
        expect(failure.code, 'BY_INF_DB_WIPE_FAILED');
      },
    );
  });
}
