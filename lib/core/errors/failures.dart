import 'package:meta/meta.dart';

/// Base abstract class for all domain-specific failures.
/// Conforms to BankYar ERROR_HANDLING_ARCHITECTURE.md specifications.
@immutable
abstract class Failure {
  /// Constructor for baseline [Failure] representation.
  const Failure({
    required this.code,
    required this.message,
    this.isUserAlertRequired = true,
  });

  /// The unique taxonomy error code (e.g. BY_INF_DB_CORRUPTED)
  final String code;

  /// Human-readable localized error description
  final String message;

  /// Whether this failure requires prompting an alert dialog or banner in UI
  final bool isUserAlertRequired;

  @override
  String toString() => '$runtimeType(code: $code, message: $message)';
}

/// Represents infrastructure-level failures (e.g. Database, storage, IO, file locks).
class InfrastructureFailure extends Failure {
  /// Constructor for infrastructure-level failures.
  const InfrastructureFailure({
    required super.code,
    required super.message,
    super.isUserAlertRequired = true,
  });
}

/// Represents security and authentication failures (e.g. biometric mismatch, PIN timeout).
class SecurityFailure extends Failure {
  /// Constructor for security-level failures.
  const SecurityFailure({
    required super.code,
    required super.message,
    super.isUserAlertRequired = true,
  });
}

/// Represents pure business domain failures (e.g. transaction invariants violated, rule collisions).
class DomainFailure extends Failure {
  /// Constructor for pure business domain failures.
  const DomainFailure({
    required super.code,
    required super.message,
    super.isUserAlertRequired = true,
  });
}

/// Represents UI input validation failures (e.g. malformed values, invalid formats).
class ValidationFailure extends Failure {
  /// Constructor for form and config validation failures.
  const ValidationFailure({
    required super.code,
    required super.message,
    super.isUserAlertRequired = false,
  });
}

/// Represents parsing exceptions (e.g. unrecognized SMS format, malformed regex).
class ParserFailure extends Failure {
  /// Constructor for SMS parsing failures.
  const ParserFailure({
    required super.code,
    required super.message,
    super.isUserAlertRequired = true,
  });
}

/// Represents unclassified or unexpected system failures.
class UnknownFailure extends Failure {
  /// Constructor for unknown or unclassified failures.
  const UnknownFailure({
    required super.code,
    required super.message,
    super.isUserAlertRequired = true,
  });
}

// Concrete Infrastructure Failures
class DatabaseCorruptionFailure extends InfrastructureFailure {
  const DatabaseCorruptionFailure({
    super.code = 'BY_INF_DB_CORRUPTED',
    super.message = 'The secure database file appears to be corrupted.',
  }) : super(isUserAlertRequired: true);
}

class StorageDiskFullFailure extends InfrastructureFailure {
  const StorageDiskFullFailure({
    super.code = 'BY_INF_STORAGE_FULL',
    super.message = 'Device storage is full. Cannot write database files.',
  }) : super(isUserAlertRequired: true);
}

class KeystoreLostFailure extends InfrastructureFailure {
  const KeystoreLostFailure({
    super.code = 'BY_INF_KEYSTORE_LOST',
    super.message = 'Cryptographic keys could not be retrieved from secure enclave.',
  }) : super(isUserAlertRequired: true);
}

class FileAccessFailure extends InfrastructureFailure {
  const FileAccessFailure({
    required super.code,
    required super.message,
  }) : super(isUserAlertRequired: true);
}

// Concrete Security Failures
class BiometricMismatchFailure extends SecurityFailure {
  const BiometricMismatchFailure({
    super.code = 'BY_SEC_BIOMETRIC_MISMATCH',
    super.message = 'Biometric authentication failed.',
  }) : super(isUserAlertRequired: true);
}

class SessionTimeoutFailure extends SecurityFailure {
  const SessionTimeoutFailure({
    super.code = 'BY_SEC_SESSION_TIMEOUT',
    super.message = 'Session expired due to inactivity.',
  }) : super(isUserAlertRequired: true);
}

class UserLockoutFailure extends SecurityFailure {
  const UserLockoutFailure({
    super.code = 'BY_SEC_PIN_LOCKOUT',
    super.message = 'Too many failed PIN attempts. Access locked temporarily.',
  }) : super(isUserAlertRequired: true);
}

// Concrete Domain Failures
class TransactionInvariantsFailure extends DomainFailure {
  const TransactionInvariantsFailure({
    required super.code,
    required super.message,
  }) : super(isUserAlertRequired: true);
}

class DeduplicationMatchFailure extends DomainFailure {
  const DeduplicationMatchFailure({
    super.code = 'BY_DOM_DEDUPLICATION_MATCH',
    super.message = 'Duplicate SMS or transaction already captured.',
  }) : super(isUserAlertRequired: false);
}

class RuleCollisionsFailure extends DomainFailure {
  const RuleCollisionsFailure({
    required super.code,
    required super.message,
  }) : super(isUserAlertRequired: true);
}

class CategoryNotFoundFailure extends DomainFailure {
  const CategoryNotFoundFailure({
    super.code = 'BY_DOM_CATEGORY_NOT_FOUND',
    super.message = 'Selected category does not exist.',
  }) : super(isUserAlertRequired: true);
}

// Concrete Validation Failures
class InvalidMonetaryValue extends ValidationFailure {
  const InvalidMonetaryValue({
    required super.code,
    required super.message,
  }) : super();
}

class FormatDriftMismatch extends ValidationFailure {
  const FormatDriftMismatch({
    required super.code,
    required super.message,
  }) : super();
}

class InvalidPINHash extends ValidationFailure {
  const InvalidPINHash({
    required super.code,
    required super.message,
  }) : super();
}

class CorruptedCSVFormat extends ValidationFailure {
  const CorruptedCSVFormat({
    required super.code,
    required super.message,
  }) : super();
}
