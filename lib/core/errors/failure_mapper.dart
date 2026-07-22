import 'exceptions.dart';
import 'failures.dart';

/// Class containing pure static routines to map exceptions to failures cleanly.
/// Conforms to BankYar ERROR_HANDLING_ARCHITECTURE.md specifications.
abstract class FailureMapper {
  /// Converts a caught [Object] (typically an Exception or AppException) to a domain-safe [Failure].
  static Failure map(Object error, [StackTrace? stackTrace]) {
    if (error is DatabaseException) {
      if (error.code == 'BY_INF_DB_CORRUPTED') {
        return const DatabaseCorruptionFailure();
      } else if (error.code == 'BY_INF_STORAGE_FULL') {
        return const StorageDiskFullFailure();
      }
      return InfrastructureFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is SecureStorageException) {
      if (error.code == 'BY_INF_KEYSTORE_LOST') {
        return const KeystoreLostFailure();
      }
      return InfrastructureFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is ParserException) {
      return ParserFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is SecurityException) {
      if (error.code == 'BY_SEC_PIN_LOCKOUT') {
        return const UserLockoutFailure();
      } else if (error.code == 'BY_SEC_BIOMETRIC_MISMATCH') {
        return const BiometricMismatchFailure();
      } else if (error.code == 'BY_SEC_SESSION_TIMEOUT') {
        return const SessionTimeoutFailure();
      }
      return SecurityFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is ValidationException) {
      if (error.code == 'BY_VAL_INVALID_MONETARY') {
        return InvalidMonetaryValue(
          code: error.code,
          message: error.message,
        );
      } else if (error.code == 'BY_VAL_FORMAT_DRIFT') {
        return FormatDriftMismatch(
          code: error.code,
          message: error.message,
        );
      } else if (error.code == 'BY_VAL_INVALID_PIN_HASH') {
        return InvalidPINHash(
          code: error.code,
          message: error.message,
        );
      } else if (error.code == 'BY_VAL_CORRUPTED_CSV') {
        return CorruptedCSVFormat(
          code: error.code,
          message: error.message,
        );
      }
      return ValidationFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is FileStorageException) {
      return FileAccessFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is UnknownException) {
      return UnknownFailure(
        code: error.code,
        message: error.message,
      );
    } else if (error is AppException) {
      return UnknownFailure(
        code: error.code,
        message: error.message,
      );
    }

    // Fallback for standard Exceptions or generic Errors
    return UnknownFailure(
      code: 'BY_DOM_UNKNOWN_EXCEPTION',
      message: error.toString(),
    );
  }
}
