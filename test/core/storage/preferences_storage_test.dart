import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/platform/secure_storage.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/errors/exceptions.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockSecureStorage mockSecureStorage;
  late MockAppLogger mockLogger;
  late PreferencesStorage preferencesStorage;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockLogger = MockAppLogger();
    preferencesStorage = PreferencesStorage(mockSecureStorage, mockLogger);
  });

  group('PreferencesStorage Tests', () {
    test('setString writes key successfully', () async {
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await preferencesStorage.setString('theme', 'dark');
      verify(
        () => mockSecureStorage.write(key: 'theme', value: 'dark'),
      ).called(1);
    });

    test('getString returns value when present', () async {
      when(() => mockSecureStorage.read(any())).thenAnswer((_) async => 'dark');

      final result = await preferencesStorage.getString('theme');
      expect(result, 'dark');
    });

    test('setBool writes true string', () async {
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await preferencesStorage.setBool('biometrics', true);
      verify(
        () => mockSecureStorage.write(key: 'biometrics', value: 'true'),
      ).called(1);
    });

    test('getBool returns correct boolean representation', () async {
      when(
        () => mockSecureStorage.read('biometrics'),
      ).thenAnswer((_) async => 'true');

      final result = await preferencesStorage.getBool('biometrics');
      expect(result, isTrue);
    });

    test('setInt writes integer as string', () async {
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await preferencesStorage.setInt('attempts', 3);
      verify(
        () => mockSecureStorage.write(key: 'attempts', value: '3'),
      ).called(1);
    });

    test('getInt returns parsed integer', () async {
      when(
        () => mockSecureStorage.read('attempts'),
      ).thenAnswer((_) async => '3');

      final result = await preferencesStorage.getInt('attempts');
      expect(result, 3);
    });

    test('delete removes key', () async {
      when(() => mockSecureStorage.delete(any())).thenAnswer((_) async {});

      await preferencesStorage.delete('theme');
      verify(() => mockSecureStorage.delete('theme')).called(1);
    });

    test('clear erases all keys', () async {
      when(() => mockSecureStorage.deleteAll()).thenAnswer((_) async {});

      await preferencesStorage.clear();
      verify(() => mockSecureStorage.deleteAll()).called(1);
    });

    test(
      'setString throws SecureStorageException when secureStorage fails',
      () async {
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenThrow(Exception('secure storage error'));

        expect(
          () => preferencesStorage.setString('key', 'value'),
          throwsA(isA<SecureStorageException>()),
        );
      },
    );
  });
}
