import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/database/database_service_impl.dart';

class MockDatabase extends Mock implements Database {}
class MockAppLogger extends Mock implements AppLogger {}

class TestDatabaseServiceImpl extends DatabaseServiceImpl {
  TestDatabaseServiceImpl(super.logger);

  Future<void> testExecutePragma(Database db, String pragmaSql) async {
    await executePragma(db, pragmaSql);
  }
}

void main() {
  late MockDatabase mockDb;
  late MockAppLogger mockLogger;
  late TestDatabaseServiceImpl dbService;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
  });

  setUp(() {
    mockDb = MockDatabase();
    mockLogger = MockAppLogger();
    dbService = TestDatabaseServiceImpl(mockLogger);
  });

  group('Database Migration and Bootstrap Tests', () {
    test('onConfigure mock test structure', () async {
      final executedSqls = <String>[];
      final rawQueries = <String>[];
      when(() => mockDb.execute(any())).thenAnswer((invocation) async {
        executedSqls.add(invocation.positionalArguments[0] as String);
      });
      when(() => mockDb.rawQuery(any())).thenAnswer((invocation) async {
        rawQueries.add(invocation.positionalArguments[0] as String);
        return [];
      });

      final openDatabaseOptions = OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) async {
          // Replicate our executePragma logic in the local test stub
          Future<void> localExecutePragma(Database d, String sql) async {
            try {
              await d.rawQuery(sql);
            } catch (_) {
              await d.execute(sql);
            }
          }

          await localExecutePragma(db, "PRAGMA key = '0102030405';");
          await localExecutePragma(db, 'PRAGMA journal_mode = WAL;');
          await localExecutePragma(db, 'PRAGMA synchronous = NORMAL;');
          await localExecutePragma(db, 'PRAGMA secure_delete = ON;');
          await localExecutePragma(db, 'PRAGMA page_size = 4096;');
          await localExecutePragma(db, 'PRAGMA cache_size = 2000;');
          await localExecutePragma(db, 'PRAGMA foreign_keys = ON;');
        },
      );

      await openDatabaseOptions.onConfigure!(mockDb);

      expect(rawQueries, contains("PRAGMA key = '0102030405';"));
      expect(rawQueries, contains('PRAGMA journal_mode = WAL;'));
      expect(rawQueries, contains('PRAGMA synchronous = NORMAL;'));
      expect(rawQueries, contains('PRAGMA secure_delete = ON;'));
      expect(rawQueries, contains('PRAGMA page_size = 4096;'));
      expect(rawQueries, contains('PRAGMA cache_size = 2000;'));
      expect(rawQueries, contains('PRAGMA foreign_keys = ON;'));
    });

    test('executePragma uses rawQuery first and succeeds', () async {
      when(() => mockDb.rawQuery(any())).thenAnswer((_) async => []);

      await dbService.testExecutePragma(mockDb, 'PRAGMA journal_mode = WAL;');

      verify(() => mockDb.rawQuery('PRAGMA journal_mode = WAL;')).called(1);
      verifyNever(() => mockDb.execute(any()));
    });

    test('executePragma falls back to execute when rawQuery fails', () async {
      when(() => mockDb.rawQuery(any())).thenThrow(Exception('Queries only'));
      when(() => mockDb.execute(any())).thenAnswer((_) async {});

      await dbService.testExecutePragma(mockDb, 'PRAGMA synchronous = NORMAL;');

      verify(() => mockDb.rawQuery('PRAGMA synchronous = NORMAL;')).called(1);
      verify(() => mockDb.execute('PRAGMA synchronous = NORMAL;')).called(1);
    });

    test('executePragma rethrows exception when both rawQuery and execute fail', () async {
      when(() => mockDb.rawQuery(any())).thenThrow(Exception('Queries only'));
      when(() => mockDb.execute(any())).thenThrow(Exception('Disk failure'));

      expect(
        () => dbService.testExecutePragma(mockDb, 'PRAGMA synchronous = NORMAL;'),
        throwsException,
      );
    });
  });
}
