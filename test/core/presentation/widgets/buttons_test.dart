import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/buttons/primary_button.dart';
import 'package:bankyar/core/presentation/widgets/buttons/secondary_button.dart';
import 'package:bankyar/core/presentation/widgets/buttons/text_button_widget.dart';
import 'package:bankyar/core/presentation/widgets/buttons/icon_button_widget.dart';
import 'package:bankyar/core/presentation/widgets/buttons/fab_button.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Buttons Tests', () {
    testWidgets('PrimaryButton renders label and triggers callback', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        buildTestableWidget(
          PrimaryButton(label: 'Confirm', onPressed: () => pressed = true),
        ),
      );

      expect(find.text('Confirm'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      expect(pressed, isTrue);
    });

    testWidgets('PrimaryButton displays loading indicator', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          PrimaryButton(label: 'Confirm', onPressed: () {}, isLoading: true),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('SecondaryButton renders label and triggers callback', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        buildTestableWidget(
          SecondaryButton(label: 'Cancel', onPressed: () => pressed = true),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      expect(pressed, isTrue);
    });

    testWidgets('TextButtonWidget renders label and triggers callback', (
      tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        buildTestableWidget(
          TextButtonWidget(label: 'Edit', onPressed: () => pressed = true),
        ),
      );

      expect(find.text('Edit'), findsOneWidget);
      await tester.tap(find.text('Edit'));
      expect(pressed, isTrue);
    });

    testWidgets('IconButtonWidget renders icon and tooltip', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        buildTestableWidget(
          IconButtonWidget(
            icon: const Icon(Icons.add),
            onPressed: () => pressed = true,
            tooltip: 'Add Item',
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      expect(pressed, isTrue);
    });

    testWidgets('FabButton renders standard and extended variants', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(
          FabButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
            tooltip: 'Create',
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.pumpWidget(
        buildTestableWidget(
          FabButton(
            icon: const Icon(Icons.add),
            label: 'Create Rule',
            onPressed: () {},
            tooltip: 'Create',
          ),
        ),
      );

      expect(find.text('Create Rule'), findsOneWidget);
    });
  });
}
