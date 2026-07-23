import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/feedback/custom_snackbar.dart';
import 'package:bankyar/core/presentation/widgets/feedback/custom_banner.dart';
import 'package:bankyar/core/presentation/widgets/feedback/custom_dialog.dart';
import 'package:bankyar/core/presentation/widgets/feedback/custom_bottom_sheet.dart';
import 'package:bankyar/core/presentation/widgets/feedback/custom_tooltip.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Feedback Tests', () {
    testWidgets('CustomSnackbar builds successfully', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                final bar = CustomSnackbar.build(
                  context: context,
                  message: 'Decryption succeeded',
                );
                ScaffoldMessenger.of(context).showSnackBar(bar);
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      expect(find.text('Decryption succeeded'), findsOneWidget);
    });

    testWidgets('CustomBanner exhibits message and triggers callback', (
      tester,
    ) async {
      var triggered = false;
      await tester.pumpWidget(
        buildTestableWidget(
          CustomBanner(
            message: 'Backup is due!',
            actions: [
              TextButton(
                onPressed: () => triggered = true,
                child: const Text('Backup'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Backup is due!'), findsOneWidget);
      await tester.tap(find.text('Backup'));
      expect(triggered, isTrue);
    });

    testWidgets('CustomDialog exhibits descriptive messages', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(
        buildTestableWidget(
          CustomDialog(
            title: 'Purge Database',
            message: 'Are you sure?',
            confirmLabel: 'Purge',
            onConfirm: () => confirmed = true,
          ),
        ),
      );

      expect(find.text('Purge Database'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);

      await tester.tap(find.text('Purge'));
      expect(confirmed, isTrue);
    });

    testWidgets('CustomBottomSheet displays titled content', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CustomBottomSheet(
            title: 'Details',
            child: Text('Parsed successfully'),
          ),
        ),
      );

      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Parsed successfully'), findsOneWidget);
    });

    testWidgets('CustomTooltip wraps target widget', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CustomTooltip(
            message: 'Help tip description',
            child: Icon(Icons.help),
          ),
        ),
      );

      expect(find.byIcon(Icons.help), findsOneWidget);
    });
  });
}
