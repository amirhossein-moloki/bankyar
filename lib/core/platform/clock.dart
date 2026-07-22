/// Abstraction representing the system time.
/// Allows deterministic testing of time-based features (like lockouts and timeouts).
abstract class Clock {
  /// Returns the current [DateTime] representation.
  DateTime now();
}

/// Concrete implementation of [Clock] returning actual machine system times.
class SystemClock implements Clock {
  /// Constructor for standard system clock.
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
