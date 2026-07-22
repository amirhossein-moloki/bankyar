import 'package:meta/meta.dart';

/// Base class for all application-specific exceptions.
/// Conforms to BankYar ERROR_HANDLING_ARCHITECTURE.md specifications.
@immutable
abstract class AppException implements Exception {
  /// Constructor for baseline [AppException] representation.
  const AppException({
    required this.code,
    required this.message,
    this.originalException,
    this.stackTrace,
  });

  /// The unique taxonomy error code (e.g. BY_INF_DB_CORRUPTED)
  final String code;

  /// Human-readable error description
  final String message;

  /// The original underlying technical exception, if any.
  final Object? originalException;

  /// The associated stack trace, if any.
  final StackTrace? stackTrace;

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType(code: $code, message: $message)');
    if (originalException != null) {
      buffer.write(', original: $originalException');
    }
    return buffer.toString();
  }
}

/// Represents exceptions thrown at database and caching level.
class DatabaseException extends AppException {
  /// Constructor for database exceptions.
  const DatabaseException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Represents exceptions thrown by secure preferences or Keystore systems.
class SecureStorageException extends AppException {
  /// Constructor for secure storage exceptions.
  const SecureStorageException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Represents exceptions occurring inside text engines or pattern parsing.
class ParserException extends AppException {
  /// Constructor for parser exceptions.
  const ParserException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Represents exceptions occurring during auth or biometric verification.
class SecurityException extends AppException {
  /// Constructor for security exceptions.
  const SecurityException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Represents validation or structural exceptions.
class ValidationException extends AppException {
  /// Constructor for validation exceptions.
  const ValidationException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Represents file-level read, write, or access exceptions.
class FileStorageException extends AppException {
  /// Constructor for file storage exceptions.
  const FileStorageException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

/// Represents unclassified or unexpected exceptions.
class UnknownException extends AppException {
  /// Constructor for unknown exceptions.
  const UnknownException({
    required super.code,
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}
