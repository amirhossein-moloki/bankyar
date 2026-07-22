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
  String toString() => 'Failure(code: $code, message: $message)';
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
