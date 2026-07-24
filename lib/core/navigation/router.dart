import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/transactions/presentation/screens/home_screen.dart';

/// Central declarative router mapping paths to lightweight route screens.
/// Conforms to BankYar NAVIGATION_ARCHITECTURE.md specifications.
abstract class AppRouter {
  /// Unique route path for the secure authentication lock screen.
  static const String lockRoute = '/lock';

  /// Unique route path for the home transactions feed ledger dashboard.
  static const String homeRoute = '/';

  /// Declares the central routing graph.
  static final GoRouter router = GoRouter(
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: lockRoute,
        builder: (context, state) => const _PlaceholderLockScreen(),
      ),
      GoRoute(path: homeRoute, builder: (context, state) => const HomeScreen()),
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
