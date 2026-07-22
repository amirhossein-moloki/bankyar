import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Central declarative router mapping paths to lightweight route screens.
/// Conforms to BankYar NAVIGATION_ARCHITECTURE.md specifications.
abstract class AppRouter {
  /// Unique route path for the secure authentication lock screen.
  static const String lockRoute = '/lock';

  /// Unique route path for the home transactions feed ledger dashboard.
  static const String homeRoute = '/';

  /// Declares the central routing graph.
  static final GoRouter router = GoRouter(
    initialLocation: lockRoute,
    routes: [
      GoRoute(
        path: lockRoute,
        builder: (context, state) => const _PlaceholderLockScreen(),
      ),
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const _PlaceholderHomeScreen(),
      ),
    ],
  );
}

/// Lightweight private placeholder lock screen for routing configuration.
class _PlaceholderLockScreen extends StatelessWidget {
  const _PlaceholderLockScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Unlock BankYar (Security Locked Placeholder)')),
    );
  }
}

/// Lightweight private placeholder home screen for routing configuration.
class _PlaceholderHomeScreen extends StatelessWidget {
  const _PlaceholderHomeScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('BankYar Transactions Ledger Dashboard (Placeholder)'),
      ),
    );
  }
}
