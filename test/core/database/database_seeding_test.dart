import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/logging/logger.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

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
  late MockDatabase mockDb;
  late MockBatch mockBatch;
  late TestDatabaseServiceImpl dbService;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogCategories.database);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDb = MockDatabase();
    mockBatch = MockBatch();
    dbService = TestDatabaseServiceImpl(mockLogger, mockDb);

    when(
      () => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
  });

  group('DatabaseServiceImpl Account Seeding Tests', () {
    test('seeds standard accounts when accounts table is empty', () async {
      // 1. Mock count query returning 0
      when(
        () => mockDb.rawQuery('SELECT COUNT(*) as cnt FROM accounts'),
      ).thenAnswer(
        (_) async => [
          {'cnt': 0},
        ],
      );

      // 2. Mock batch
      when(() => mockDb.batch()).thenReturn(mockBatch);
      when(
        () => mockBatch.insert(
          any(),
          any(),
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
        ),
      ).thenReturn(null);
      when(
        () => mockBatch.commit(noResult: any(named: 'noResult')),
      ).thenAnswer((_) async => []);

      // 3. Run seeding
      await dbService.seedAccountsIfEmpty(mockDb);

      // 4. Verify count query and batch creation
      verify(
        () => mockDb.rawQuery('SELECT COUNT(*) as cnt FROM accounts'),
      ).called(1);
      verify(() => mockDb.batch()).called(1);

      // 5. Verify standard 7 bank profiles are inserted
      final captured = verify(
        () => mockBatch.insert(
          captureAny(),
          captureAny(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        ),
      ).captured;

      expect(
        captured,
        hasLength(14),
      ); // 7 calls * 2 captured arguments per call
      final capturedTables = <String>[];
      final capturedMaps = <Map<String, dynamic>>[];
      for (int i = 0; i < captured.length; i += 2) {
        capturedTables.add(captured[i] as String);
        capturedMaps.add(captured[i + 1] as Map<String, dynamic>);
      }

      expect(capturedTables, hasLength(7));
      expect(capturedTables.every((t) => t == 'accounts'), isTrue);

      final bankIds = capturedMaps.map((m) => m['id'] as String).toList();
      expect(
        bankIds,
        containsAll([
          'melli',
          'mellat',
          'tejarat',
          'saman',
          'pasargad',
          'saderat',
          'parsian',
        ]),
      );

      // 6. Verify batch commit
      verify(() => mockBatch.commit(noResult: true)).called(1);
    });

    test('does not seed accounts when accounts table is not empty', () async {
      // 1. Mock count query returning 7
      when(
        () => mockDb.rawQuery('SELECT COUNT(*) as cnt FROM accounts'),
      ).thenAnswer(
        (_) async => [
          {'cnt': 7},
        ],
      );

      // 2. Run seeding
      await dbService.seedAccountsIfEmpty(mockDb);

      // 3. Verify count query run, but batch NOT created (no double-seeding)
      verify(
        () => mockDb.rawQuery('SELECT COUNT(*) as cnt FROM accounts'),
      ).called(1);
      verifyNever(() => mockDb.batch());
    });
  });
}
