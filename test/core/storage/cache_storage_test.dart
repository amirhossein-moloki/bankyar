import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/storage/cache_storage.dart';
import 'package:bankyar/core/logging/logger.dart';

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockAppLogger mockLogger;
  late CacheStorage cacheStorage;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    cacheStorage = CacheStorage(mockLogger);
  });

  group('CacheStorage Tests', () {
    test('set and get retrieve valid cache items', () {
      cacheStorage.set<String>(
        'session_token',
        'token_123',
        const Duration(minutes: 5),
      );

      final result = cacheStorage.get<String>('session_token');
      expect(result, 'token_123');
    });

    test('get returns null and removes item when expired', () async {
      cacheStorage.set<String>(
        'temp_key',
        'expired_val',
        const Duration(milliseconds: 1),
      );

      // Wait for expiration
      await Future<void>.delayed(const Duration(milliseconds: 5));

      final result = cacheStorage.get<String>('temp_key');
      expect(result, isNull);
    });

    test('remove deletes item from cache', () {
      cacheStorage.set<String>('key', 'val', const Duration(minutes: 5));
      cacheStorage.remove('key');

      final result = cacheStorage.get<String>('key');
      expect(result, isNull);
    });

    test('clear removes all entries', () {
      cacheStorage.set<String>('key1', 'val1', const Duration(minutes: 5));
      cacheStorage.set<String>('key2', 'val2', const Duration(minutes: 5));

      cacheStorage.clear();

      expect(cacheStorage.get<String>('key1'), isNull);
      expect(cacheStorage.get<String>('key2'), isNull);
    });

    test('pruneExpired cleans only expired items', () async {
      cacheStorage.set<String>('valid', 'ok', const Duration(minutes: 5));
      cacheStorage.set<String>(
        'expired',
        'no',
        const Duration(milliseconds: 1),
      );

      await Future<void>.delayed(const Duration(milliseconds: 5));

      cacheStorage.pruneExpired();

      expect(cacheStorage.get<String>('valid'), 'ok');
      expect(cacheStorage.get<String>('expired'), isNull);
    });

    test('get returns null and logs warning on type casting mismatch', () {
      cacheStorage.set<int>('attempts', 5, const Duration(minutes: 5));

      final result = cacheStorage.get<String>('attempts');
      expect(result, isNull);
      verify(
        () => mockLogger.log(
          LogLevel.warn,
          any(),
          any(),
          any(),
          metadata: any(named: 'metadata'),
        ),
      ).called(1);
    });
  });
}
