import 'package:bankyar/core/errors/exceptions.dart';
import 'package:bankyar/core/errors/failure_mapper.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exception Hierarchy & Mapping Tests', () {
    test('Exceptions preserve parameters successfully', () {
      const original = 'SqliteException: disk full';
      final stack = StackTrace.current;

      const dbEx = DatabaseException(
        code: 'BY_INF_STORAGE_FULL',
        message: 'Storage full',
        originalException: original,
      );

      expect(dbEx.code, equals('BY_INF_STORAGE_FULL'));
      expect(dbEx.message, equals('Storage full'));
      expect(dbEx.originalException, equals(original));
      expect(dbEx.toString(), contains('DatabaseException'));
      expect(dbEx.toString(), contains('BY_INF_STORAGE_FULL'));
      expect(dbEx.toString(), contains(original));

      final secureEx = SecureStorageException(
        code: 'BY_INF_KEYSTORE_LOST',
        message: 'Keystore lost',
        stackTrace: stack,
      );
      expect(secureEx.code, equals('BY_INF_KEYSTORE_LOST'));
      expect(secureEx.stackTrace, equals(stack));

      const parserEx = ParserException(
        code: 'BY_PAR_ERR',
        message: 'Parser error',
      );
      expect(parserEx.code, equals('BY_PAR_ERR'));

      const secEx = SecurityException(
        code: 'BY_SEC_ERR',
        message: 'Security error',
      );
      expect(secEx.code, equals('BY_SEC_ERR'));

      const valEx = ValidationException(
        code: 'BY_VAL_ERR',
        message: 'Validation error',
      );
      expect(valEx.code, equals('BY_VAL_ERR'));

      const fileEx = FileStorageException(
        code: 'BY_FILE_ERR',
        message: 'File error',
      );
      expect(fileEx.code, equals('BY_FILE_ERR'));

      const unknownEx = UnknownException(
        code: 'BY_UNK_ERR',
        message: 'Unknown error',
      );
      expect(unknownEx.code, equals('BY_UNK_ERR'));
    });

    test('FailureMapper maps DatabaseException correctly', () {
      const dbEx = DatabaseException(
        code: 'BY_INF_DB_CORRUPTED',
        message: 'Corrupted database',
      );
      final failure = FailureMapper.map(dbEx);
      expect(failure, isA<DatabaseCorruptionFailure>());
      expect(failure.code, equals('BY_INF_DB_CORRUPTED'));
      expect(failure.isUserAlertRequired, isTrue);

      const dbEx2 = DatabaseException(
        code: 'BY_INF_STORAGE_FULL',
        message: 'Disk full',
      );
      final failure2 = FailureMapper.map(dbEx2);
      expect(failure2, isA<StorageDiskFullFailure>());

      const dbExGeneric = DatabaseException(
        code: 'BY_INF_DB_LOCK',
        message: 'Lock error',
      );
      final failureGeneric = FailureMapper.map(dbExGeneric);
      expect(failureGeneric, isA<InfrastructureFailure>());
      expect(failureGeneric, isNot(isA<DatabaseCorruptionFailure>()));
    });

    test('FailureMapper maps SecureStorageException correctly', () {
      const secEx = SecureStorageException(
        code: 'BY_INF_KEYSTORE_LOST',
        message: 'Keystore missing',
      );
      final failure = FailureMapper.map(secEx);
      expect(failure, isA<KeystoreLostFailure>());

      const secExGeneric = SecureStorageException(
        code: 'BY_INF_SEC_OTHER',
        message: 'Other',
      );
      final failureGeneric = FailureMapper.map(secExGeneric);
      expect(failureGeneric, isA<InfrastructureFailure>());
    });

    test(
      'FailureMapper maps ParserException and SecurityException correctly',
      () {
        const pEx = ParserException(code: 'BY_PAR_SMS_DRIFT', message: 'Drift');
        final failure = FailureMapper.map(pEx);
        expect(failure, isA<ParserFailure>());

        const sEx = SecurityException(
          code: 'BY_SEC_PIN_LOCKOUT',
          message: 'Locked',
        );
        final failure1 = FailureMapper.map(sEx);
        expect(failure1, isA<UserLockoutFailure>());

        const sEx2 = SecurityException(
          code: 'BY_SEC_BIOMETRIC_MISMATCH',
          message: 'Mismatch',
        );
        final failure2 = FailureMapper.map(sEx2);
        expect(failure2, isA<BiometricMismatchFailure>());

        const sEx3 = SecurityException(
          code: 'BY_SEC_SESSION_TIMEOUT',
          message: 'Timeout',
        );
        final failure3 = FailureMapper.map(sEx3);
        expect(failure3, isA<SessionTimeoutFailure>());

        const sExGeneric = SecurityException(
          code: 'BY_SEC_OTHER',
          message: 'Other',
        );
        final failureGeneric = FailureMapper.map(sExGeneric);
        expect(failureGeneric, isA<SecurityFailure>());
      },
    );

    test(
      'FailureMapper maps ValidationException and FileStorageException correctly',
      () {
        const vEx1 = ValidationException(
          code: 'BY_VAL_INVALID_MONETARY',
          message: 'Amount invalid',
        );
        expect(FailureMapper.map(vEx1), isA<InvalidMonetaryValue>());

        const vEx2 = ValidationException(
          code: 'BY_VAL_FORMAT_DRIFT',
          message: 'Drift',
        );
        expect(FailureMapper.map(vEx2), isA<FormatDriftMismatch>());

        const vEx3 = ValidationException(
          code: 'BY_VAL_INVALID_PIN_HASH',
          message: 'PIN hash',
        );
        expect(FailureMapper.map(vEx3), isA<InvalidPINHash>());

        const vEx4 = ValidationException(
          code: 'BY_VAL_CORRUPTED_CSV',
          message: 'CSV',
        );
        expect(FailureMapper.map(vEx4), isA<CorruptedCSVFormat>());

        const vExGeneric = ValidationException(
          code: 'BY_VAL_OTHER',
          message: 'Other',
        );
        expect(FailureMapper.map(vExGeneric), isA<ValidationFailure>());

        const fileEx = FileStorageException(
          code: 'BY_FILE_ERR',
          message: 'Read error',
        );
        expect(FailureMapper.map(fileEx), isA<FileAccessFailure>());
      },
    );

    test(
      'FailureMapper handles UnknownException and raw exceptions gracefully',
      () {
        const unknownEx = UnknownException(
          code: 'BY_UNK_ERR',
          message: 'Random error',
        );
        expect(FailureMapper.map(unknownEx), isA<UnknownFailure>());

        final rawEx = Exception('Raw exception');
        expect(FailureMapper.map(rawEx), isA<UnknownFailure>());
        expect(
          FailureMapper.map(rawEx).code,
          equals('BY_DOM_UNKNOWN_EXCEPTION'),
        );
      },
    );
  });
}
