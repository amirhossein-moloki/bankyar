import 'dart:async';
import 'package:flutter/widgets.dart' as widgets;

/// Supported application lifecycle states inside BankYar.
enum AppLifecycleState {
  /// App is in the foreground and interacting with the user.
  resumed,

  /// App is in an inactive state (e.g. phone call or task switcher view).
  inactive,

  /// App is in the background; RAM key eviction counters start ticking.
  paused,

  /// App process is detached and about to be terminated by the OS.
  detached,
}

/// Abstraction tracking application foreground/background state transitions.
/// Conforms to STATE_MANAGEMENT.md and SECURITY_ARCHITECTURE.md guidelines.
abstract class AppLifecycleService {
  /// Stream broadcasting application lifecycle state changes.
  Stream<AppLifecycleState> get onStateChanged;

  /// Returns the current active application lifecycle state.
  AppLifecycleState get currentState;
}

/// Concrete implementation of [AppLifecycleService] binding to Flutter's Widgets Binding system.
class SystemAppLifecycleService extends widgets.WidgetsBindingObserver
    implements AppLifecycleService {
  /// Constructor registering widgets binding observers.
  SystemAppLifecycleService() {
    widgets.WidgetsBinding.instance.addObserver(this);
  }

  final StreamController<AppLifecycleState> _controller =
      StreamController<AppLifecycleState>.broadcast();

  AppLifecycleState _currentState = AppLifecycleState.resumed;

  @override
  Stream<AppLifecycleState> get onStateChanged => _controller.stream;

  @override
  AppLifecycleState get currentState => _currentState;

  @override
  void didChangeAppLifecycleState(widgets.AppLifecycleState state) {
    final nextState = _mapState(state);
    if (nextState != _currentState) {
      _currentState = nextState;
      _controller.add(nextState);
    }
  }

  /// Removes observers during system disposal.
  void dispose() {
    widgets.WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }

  AppLifecycleState _mapState(widgets.AppLifecycleState state) {
    switch (state) {
      case widgets.AppLifecycleState.resumed:
        return AppLifecycleState.resumed;
      case widgets.AppLifecycleState.inactive:
        return AppLifecycleState.inactive;
      case widgets.AppLifecycleState.paused:
        return AppLifecycleState.paused;
      case widgets.AppLifecycleState.detached:
        return AppLifecycleState.detached;
      default:
        return AppLifecycleState.resumed;
    }
  }
}
