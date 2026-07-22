import 'dart:async';
import 'package:flutter/foundation.dart';

/// Reusable utility class throttling UI actions (e.g., submit button clicks).
/// Enforces a maximum execution rate of once per specified duration.
class Throttler {
  /// Constructor defining the throttle block duration in milliseconds.
  Throttler({required this.milliseconds});

  /// The throttling duration in milliseconds.
  final int milliseconds;

  bool _isBlocked = false;

  /// Runs [action] immediately if not blocked, then blocks executions for [milliseconds].
  void run(VoidCallback action) {
    if (_isBlocked) return;
    action();
    _isBlocked = true;
    Timer(Duration(milliseconds: milliseconds), () {
      _isBlocked = false;
    });
  }
}
