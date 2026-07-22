import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/cards/base_card.dart';
import 'package:bankyar/core/presentation/widgets/cards/transaction_card.dart';
import 'package:bankyar/core/presentation/widgets/cards/statistic_card.dart';
import 'package:bankyar/core/presentation/widgets/cards/info_card.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Cards Tests', () {
    testWidgets('BaseCard renders child and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          BaseCard(
            onTap: () => tapped = true,
            child: const Text('Inner Content'),
          ),
        ),
      );

      expect(find.text('Inner Content'), findsOneWidget);
      await tester.tap(find.text('Inner Content'));
      expect(tapped, isTrue);
    });

    testWidgets('TransactionCard exhibits ledger amounts correctly for credit and debit', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const TransactionCard(
            amount: '500,000',
            timestamp: '1402/07/15',
            category: 'Salary',
            accountLabel: 'Melli',
            isCredit: true,
          ),
        ),
      );

      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('+500,000'), findsOneWidget);

      await tester.pumpWidget(
        buildTestableWidget(
          const TransactionCard(
            amount: '120,000',
            timestamp: '1402/07/16',
            category: 'Groceries',
            accountLabel: 'Melli',
            isCredit: false,
          ),
        ),
      );

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('-120,000'), findsOneWidget);
    });

    testWidgets('StatisticCard displays financial totals with arrow trends', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const StatisticCard(
            title: 'Savings',
            value: '4,500,000 ریال',
            trendLabel: '15%',
            isPositiveTrend: true,
          ),
        ),
      );

      expect(find.text('Savings'), findsOneWidget);
      expect(find.text('4,500,000 ریال'), findsOneWidget);
      expect(find.text('15%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      await tester.pumpWidget(
        buildTestableWidget(
          const StatisticCard(
            title: 'Expenses',
            value: '1,200,000 ریال',
            trendLabel: '8%',
            isPositiveTrend: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('InfoCard exhibits messages based on semantic type', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const InfoCard(
            title: 'Security Alert',
            message: 'Encryption is active.',
            type: InfoCardType.success,
          ),
        ),
      );

      expect(find.text('Security Alert'), findsOneWidget);
      expect(find.text('Encryption is active.'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

      await tester.pumpWidget(
        buildTestableWidget(
          const InfoCard(
            message: 'Warning regarding backup storage.',
            type: InfoCardType.warning,
          ),
        ),
      );

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });
  });
}
