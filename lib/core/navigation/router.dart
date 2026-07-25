import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/secure_auth/presentation/screens/security_dashboard_screen.dart';
import '../../features/secure_auth/presentation/screens/unlock_screen.dart';
import '../../features/transactions/presentation/screens/home_screen.dart';
import '../../features/transactions/presentation/screens/transaction_details_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/backup/presentation/screens/backup_restore_screen.dart';
import '../../features/notifications/presentation/screens/notification_center_screen.dart';

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

  /// Unique route path for the advanced search & filter screen.
  static const String searchRoute = '/search';

  /// Unique route path for the security & privacy center dashboard.
  static const String securityRoute = '/security';

  /// Unique route path for the backup & restore center screen.
  static const String backupRoute = '/backup';

  /// Unique route path for the notification center screen.
  static const String notificationsRoute = '/notifications';

  /// Declares the central routing graph.
  static final GoRouter router = GoRouter(
    initialLocation: homeRoute,
    routes: [
      GoRoute(
        path: lockRoute,
        builder: (context, state) => const UnlockScreen(),
      ),
      GoRoute(path: homeRoute, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: transactionsRoute,
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: searchRoute,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: securityRoute,
        builder: (context, state) => const SecurityDashboardScreen(),
      ),
      GoRoute(
        path: backupRoute,
        builder: (context, state) => const BackupRestoreScreen(),
      ),
      GoRoute(
        path: notificationsRoute,
        builder: (context, state) => const NotificationCenterScreen(),
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
