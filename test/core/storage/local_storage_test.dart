import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/platform/file_storage.dart';
import 'package:bankyar/core/storage/local_storage.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/errors/exceptions.dart';

class MockFileStorage extends Mock implements FileStorage {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockFileStorage mockFileStorage;
  late MockAppLogger mockLogger;
  late LocalStorage localStorage;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockFileStorage = MockFileStorage();
    mockLogger = MockAppLogger();
    localStorage = LocalStorage(mockFileStorage, mockLogger);
  });

  group('LocalStorage Tests', () {
    test('write calls fileStorage.writeString successfully', () async {
      when(
        () => mockFileStorage.writeString(any(), any()),
      ).thenAnswer((_) async {});

      await localStorage.write('test.txt', 'hello');
      verify(() => mockFileStorage.writeString('test.txt', 'hello')).called(1);
    });

    test('write throws FileStorageException when writeString fails', () async {
      when(
        () => mockFileStorage.writeString(any(), any()),
      ).thenThrow(Exception('disk error'));

      expect(
        () => localStorage.write('test.txt', 'hello'),
        throwsA(isA<FileStorageException>()),
      );
    });

    test('read returns string when file exists', () async {
      when(() => mockFileStorage.exists(any())).thenAnswer((_) async => true);
      when(
        () => mockFileStorage.readString(any()),
      ).thenAnswer((_) async => 'content');

      final result = await localStorage.read('test.txt');
      expect(result, 'content');
    });

    test('read throws FileStorageException when file does not exist', () async {
      when(() => mockFileStorage.exists(any())).thenAnswer((_) async => false);

      expect(
        () => localStorage.read('test.txt'),
        throwsA(isA<FileStorageException>()),
      );
    });

    test('exists returns fileStorage.exists value', () async {
      when(
        () => mockFileStorage.exists('test.txt'),
      ).thenAnswer((_) async => true);

      final result = await localStorage.exists('test.txt');
      expect(result, isTrue);
    });

    test('delete calls fileStorage.delete successfully', () async {
      when(() => mockFileStorage.delete(any())).thenAnswer((_) async {});

      await localStorage.delete('test.txt');
      verify(() => mockFileStorage.delete('test.txt')).called(1);
    });
  });
}
