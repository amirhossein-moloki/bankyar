import 'dart:math';
import '../errors/exceptions.dart';

/// Reusable utility orchestrating resilient retries using exponential backoffs.
/// Conforms to ERROR_HANDLING_ARCHITECTURE.md specifications.
class RetryPolicy {
  /// Constructor defining operational bounds.
  const RetryPolicy({
    this.maxAttempts = 3,
    this.baseDelayMs = 200,
    this.maxDelayMs = 2000,
  });

  /// The maximum number of retry attempts.
  final int maxAttempts;

  /// The base backoff delay in milliseconds.
  final int baseDelayMs;

  /// The absolute ceiling delay in milliseconds.
  final int maxDelayMs;

  /// Executes an asynchronous [computation] safely, automatically retrying on recoverable exceptions.
  Future<T> execute<T>(Future<T> Function() computation) async {
    int attempt = 0;
    while (true) {
      try {
        return await computation();
      } catch (exception) {
        attempt++;
        if (attempt >= maxAttempts || !_isRecoverable(exception)) {
          rethrow;
        }

        // Compute delay: min(baseDelay * 2^attempt, maxDelay) + Jitter
        final jitter = Random().nextInt(50);
        final rawDelay = baseDelayMs * pow(2, attempt).toInt();
        final backoff = min(rawDelay, maxDelayMs) + jitter;

        await Future<void>.delayed(Duration(milliseconds: backoff));
      }
    }
  }

  /// Evaluates whether an exception is recoverable or represents a strict security/integrity error.
  bool _isRecoverable(Object exception) {
    if (exception is SecurityException) {
      // PIN inputs or biometric mismatch are strictly non-retryable
      return false;
    }
    if (exception is DatabaseException) {
      // Database corruptions are non-retryable on the active connection thread
      if (exception.code == 'BY_INF_DB_CORRUPTED') {
        return false;
      }
    }
    return true;
  }
}
