import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/indicators/circular_progress.dart';
import 'package:bankyar/core/presentation/widgets/indicators/linear_progress.dart';
import 'package:bankyar/core/presentation/widgets/indicators/skeleton_loader.dart';
import 'package:bankyar/core/presentation/widgets/indicators/loading_overlay.dart';
import 'package:bankyar/core/presentation/widgets/status/empty_state.dart';
import 'package:bankyar/core/presentation/widgets/status/error_state.dart';
import 'package:bankyar/core/presentation/widgets/status/offline_state.dart';
import 'package:bankyar/core/presentation/widgets/status/success_state.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Indicators and Status Tests', () {
    testWidgets('CircularProgress displays caption message', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CircularProgress(message: 'Loading ledger data'),
        ),
      );

      expect(find.text('Loading ledger data'), findsOneWidget);
    });

    testWidgets('LinearProgress displays caption message', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const LinearProgress(message: 'Generating key')),
      );

      expect(find.text('Generating key'), findsOneWidget);
    });

    testWidgets('SkeletonLoader renders correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(const SkeletonLoader(width: 100.0, height: 20.0)),
      );

      expect(find.byType(SkeletonLoader), findsOneWidget);
    });

    testWidgets('LoadingOverlay blocks content', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const LoadingOverlay(
            isLoading: true,
            message: 'Decrypting DB',
            child: Text('Protected content'),
          ),
        ),
      );

      expect(find.text('Decrypting DB'), findsOneWidget);
      expect(find.text('Protected content'), findsOneWidget);
    });

    testWidgets('EmptyState exhibits titles and buttons', (tester) async {
      var triggered = false;
      await tester.pumpWidget(
        buildTestableWidget(
          EmptyState(
            title: 'No Transactions',
            message: 'All parsed SMS is empty.',
            actionLabel: 'Manual Add',
            onActionPressed: () => triggered = true,
          ),
        ),
      );

      expect(find.text('No Transactions'), findsOneWidget);
      expect(find.text('All parsed SMS is empty.'), findsOneWidget);

      await tester.tap(find.text('Manual Add'));
      expect(triggered, isTrue);
    });

    testWidgets('ErrorState exhibits message and triggers retry', (
      tester,
    ) async {
      var retried = false;
      await tester.pumpWidget(
        buildTestableWidget(
          ErrorState(
            message: 'Database corrupted.',
            retryLabel: 'Restore',
            onRetry: () => retried = true,
          ),
        ),
      );

      expect(find.text('Database corrupted.'), findsOneWidget);
      await tester.tap(find.text('Restore'));
      expect(retried, isTrue);
    });

    testWidgets('OfflineState exhibits details', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const OfflineState(message: 'Running local SQLite.'),
        ),
      );

      expect(find.text('Running local SQLite.'), findsOneWidget);
    });

    testWidgets('SuccessState exhibits titles', (tester) async {
      var done = false;
      await tester.pumpWidget(
        buildTestableWidget(
          SuccessState(
            title: 'Key Saved',
            message: 'Secured inside Keystore.',
            actionLabel: 'OK',
            onActionPressed: () => done = true,
          ),
        ),
      );

      expect(find.text('Key Saved'), findsOneWidget);
      await tester.tap(find.text('OK'));
      expect(done, isTrue);
    });
  });
}
