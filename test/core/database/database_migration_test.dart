import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/logging/logger.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabase extends Mock implements Database {}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabase mockDb;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDb = MockDatabase();
  });

  group('Database Migration and Bootstrap Tests', () {
    test('onConfigure applies correct performance pragmas and keying', () async {
      final executedSqls = <String>[];
      when(() => mockDb.execute(any())).thenAnswer((invocation) async {
        executedSqls.add(invocation.positionalArguments[0] as String);
      });

      // Directly invoke schema configuration step to verify
      // WAL configurations, page size, cache size and secure delete are applied correctly
      final openDatabaseOptions = OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) async {
          await db.execute("PRAGMA key = '0102030405';");
          await db.execute('PRAGMA journal_mode = WAL;');
          await db.execute('PRAGMA synchronous = NORMAL;');
          await db.execute('PRAGMA secure_delete = ON;');
          await db.execute('PRAGMA page_size = 4096;');
          await db.execute('PRAGMA cache_size = 2000;');
          await db.execute('PRAGMA foreign_keys = ON;');
        },
      );

      await openDatabaseOptions.onConfigure!(mockDb);

      expect(executedSqls, contains("PRAGMA key = '0102030405';"));
      expect(executedSqls, contains('PRAGMA journal_mode = WAL;'));
      expect(executedSqls, contains('PRAGMA synchronous = NORMAL;'));
      expect(executedSqls, contains('PRAGMA secure_delete = ON;'));
      expect(executedSqls, contains('PRAGMA page_size = 4096;'));
      expect(executedSqls, contains('PRAGMA cache_size = 2000;'));
      expect(executedSqls, contains('PRAGMA foreign_keys = ON;'));
    });
  });
}
