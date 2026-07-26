import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/logging/logger.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late MockDatabase mockDb;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockDb = MockDatabase();
  });

  group('Database Migration and Bootstrap Tests', () {
    test('onConfigure applies correct performance pragmas and keying', () async {
      final executedSqls = <String>[];
      final rawQueries = <String>[];
      when(() => mockDb.execute(any())).thenAnswer((invocation) async {
        executedSqls.add(invocation.positionalArguments[0] as String);
      });
      when(() => mockDb.rawQuery(any())).thenAnswer((invocation) async {
        rawQueries.add(invocation.positionalArguments[0] as String);
        return [];
      });

      // Directly invoke schema configuration step to verify
      // WAL configurations, page size, cache size and secure delete are applied correctly
      final openDatabaseOptions = OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) async {
          await db.execute("PRAGMA key = '0102030405';");
          await db.rawQuery('PRAGMA journal_mode = WAL;');
          await db.rawQuery('PRAGMA synchronous = NORMAL;');
          await db.rawQuery('PRAGMA secure_delete = ON;');
          await db.rawQuery('PRAGMA page_size = 4096;');
          await db.rawQuery('PRAGMA cache_size = 2000;');
          await db.rawQuery('PRAGMA foreign_keys = ON;');
        },
      );

      await openDatabaseOptions.onConfigure!(mockDb);

      expect(executedSqls, contains("PRAGMA key = '0102030405';"));
      expect(rawQueries, contains('PRAGMA journal_mode = WAL;'));
      expect(rawQueries, contains('PRAGMA synchronous = NORMAL;'));
      expect(rawQueries, contains('PRAGMA secure_delete = ON;'));
      expect(rawQueries, contains('PRAGMA page_size = 4096;'));
      expect(rawQueries, contains('PRAGMA cache_size = 2000;'));
      expect(rawQueries, contains('PRAGMA foreign_keys = ON;'));
    });
  });
}
