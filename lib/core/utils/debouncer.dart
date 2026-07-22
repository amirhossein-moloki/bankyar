import 'dart:async';
import 'package:flutter/foundation.dart';

/// Reusable utility class debouncing UI actions (e.g. search box typing queries).
/// Delays execution until no events are dispatched for the specified duration.
class Debouncer {
  /// Constructor defining the debounce delay in milliseconds.
  Debouncer({required this.milliseconds});

  /// The delay duration in milliseconds.
  final int milliseconds;

  Timer? _timer;

  /// Queues and executes [action] after the specified delay has passed.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels any scheduled timer tasks.
  void dispose() {
    _timer?.cancel();
  }
}
