import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/transactions/presentation/screens/home_screen.dart';
import '../../features/transactions/presentation/screens/transaction_details_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';

/// Central declarative router mapping paths to lightweight route screens.
/// Conforms to BankYar NAVIGATION_ARCHITECTURE.md specifications.
abstract class AppRouter {
  /// Unique route path for the secure authentication lock screen.
  static const String lockRoute = '/lock';

  /// Unique route path for the home transactions feed ledger dashboard.
  static const String homeRoute = '/';

  /// Unique route path for the full transactions list ledger.
  static const String transactionsRoute = '/transactions';

  /// Unique route path for the transaction details inspector screen.
  static const String transactionDetailsRoute = '/transactions/:id';

  /// Declares the central routing graph.
  static final GoRouter router = GoRouter(
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: lockRoute,
        builder: (context, state) => const _PlaceholderLockScreen(),
      ),
      GoRoute(path: homeRoute, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: transactionsRoute,
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: transactionDetailsRoute,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null || id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('شناسه تراکنش نامعتبر است.')),
            );
          }
          return TransactionDetailsScreen(transactionId: id);
        },
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
