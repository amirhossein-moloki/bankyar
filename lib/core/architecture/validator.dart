import '../utils/result.dart';

/// Base interface for all input and business validators.
/// Conforms to FORMS_INPUT_SYSTEM.md guidelines.
abstract class Validator<T> {
  /// Validates the object [value].
  /// Returns a [Success] result if valid, or a [FailureResult] with details.
  Result<void> validate(T value);
}
