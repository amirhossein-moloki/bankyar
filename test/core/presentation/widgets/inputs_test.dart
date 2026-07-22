import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/inputs/text_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/search_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/pin_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/amount_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/dropdown_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/checkbox_widget.dart';
import 'package:bankyar/core/presentation/widgets/inputs/radio_widget.dart';
import 'package:bankyar/core/presentation/widgets/inputs/switch_widget.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Inputs Tests', () {
    testWidgets('TextInputField enters text and shows validation error', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          TextInputField(
            label: 'Comment',
            controller: controller,
            errorText: 'Required',
          ),
        ),
      );

      expect(find.text('Comment'), findsOneWidget);
      expect(find.text('Required'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Test Comment');
      expect(controller.text, equals('Test Comment'));
    });

    testWidgets('SearchInputField updates value and clears search query', (tester) async {
      final controller = TextEditingController();
      var query = '';
      await tester.pumpWidget(
        buildTestableWidget(
          SearchInputField(
            controller: controller,
            hintText: 'Search ledger...',
            onChanged: (val) => query = val,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Refactored');
      expect(query, equals('Refactored'));

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.clear), findsOneWidget);

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      expect(controller.text, isEmpty);
    });

    testWidgets('PinInputField enters pin digits sequentially', (tester) async {
      var completedPin = '';
      await tester.pumpWidget(
        buildTestableWidget(
          PinInputField(
            length: 4,
            onCompleted: (val) => completedPin = val,
          ),
        ),
      );

      final inputs = find.byType(TextFormField);
      expect(inputs, findsNWidgets(4));

      await tester.enterText(inputs.at(0), '1');
      await tester.enterText(inputs.at(1), '2');
      await tester.enterText(inputs.at(2), '3');
      await tester.enterText(inputs.at(3), '4');

      expect(completedPin, equals('1234'));
    });

    testWidgets('AmountInputField enters financial values with currency suffix', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          AmountInputField(
            label: 'Amount',
            controller: controller,
            currencySymbol: 'Toman',
          ),
        ),
      );

      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Toman'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '15,000');
      expect(controller.text, equals('15,000'));
    });

    testWidgets('DropdownField displays label and selected item value', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DropdownField<String>(
            label: 'Choose Card',
            value: 'Melli',
            items: const [
              DropdownMenuItem(value: 'Melli', child: Text('Melli Bank')),
              DropdownMenuItem(value: 'Saman', child: Text('Saman Bank')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Choose Card'), findsOneWidget);
      expect(find.text('Melli Bank'), findsOneWidget);
    });

    testWidgets('CheckboxWidget row is toggled on tap', (tester) async {
      var val = false;
      await tester.pumpWidget(
        buildTestableWidget(
          CheckboxWidget(
            label: 'Enable backups',
            value: val,
            onChanged: (newVal) => val = newVal ?? false,
          ),
        ),
      );

      expect(find.text('Enable backups'), findsOneWidget);
      await tester.tap(find.text('Enable backups'));
      expect(val, isTrue);
    });

    testWidgets('RadioWidget option is selected', (tester) async {
      var val = 'Light';
      await tester.pumpWidget(
        buildTestableWidget(
          RadioWidget<String>(
            label: 'Dark Mode',
            value: 'Dark',
            groupValue: val,
            onChanged: (newVal) => val = newVal!,
          ),
        ),
      );

      expect(find.text('Dark Mode'), findsOneWidget);
      await tester.tap(find.text('Dark Mode'));
      expect(val, equals('Dark'));
    });

    testWidgets('SwitchWidget row updates on touch triggers', (tester) async {
      var val = false;
      await tester.pumpWidget(
        buildTestableWidget(
          SwitchWidget(
            label: 'SMS detection',
            value: val,
            onChanged: (newVal) => val = newVal,
          ),
        ),
      );

      expect(find.text('SMS detection'), findsOneWidget);
      await tester.tap(find.text('SMS detection'));
      expect(val, isTrue);
    });
  });
}
