import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/layout/section_header.dart';
import 'package:bankyar/core/presentation/widgets/layout/custom_divider.dart';
import 'package:bankyar/core/presentation/widgets/layout/custom_list_tile.dart';
import 'package:bankyar/core/presentation/widgets/layout/custom_chip.dart';
import 'package:bankyar/core/presentation/widgets/layout/custom_badge.dart';
import 'package:bankyar/core/presentation/widgets/layout/custom_avatar.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Layout Tests', () {
    testWidgets('SectionHeader renders title and action label', (tester) async {
      var triggered = false;
      await tester.pumpWidget(
        buildTestableWidget(
          SectionHeader(
            title: 'October Transactions',
            actionLabel: 'See All',
            onActionPressed: () => triggered = true,
          ),
        ),
      );

      expect(find.text('October Transactions'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);

      await tester.tap(find.text('See All'));
      expect(triggered, isTrue);
    });

    testWidgets('CustomDivider renders correctly', (tester) async {
      await tester.pumpWidget(buildTestableWidget(const CustomDivider()));

      expect(find.byType(CustomDivider), findsOneWidget);
    });

    testWidgets('CustomListTile renders and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          CustomListTile(
            title: 'SMS Parser',
            subtitle: 'Configure custom regex rules',
            leading: const Icon(Icons.code),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('SMS Parser'), findsOneWidget);
      expect(find.text('Configure custom regex rules'), findsOneWidget);
      expect(find.byIcon(Icons.code), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

      await tester.tap(find.text('SMS Parser'));
      expect(tapped, isTrue);
    });

    testWidgets('CustomChip toggle state on selected', (tester) async {
      var selected = false;
      await tester.pumpWidget(
        buildTestableWidget(
          CustomChip(
            label: 'Melli',
            isSelected: selected,
            onSelected: (val) => selected = val,
          ),
        ),
      );

      expect(find.text('Melli'), findsOneWidget);
      await tester.tap(find.text('Melli'));
      expect(selected, isTrue);
    });

    testWidgets('CustomBadge displays counters', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CustomBadge(
            isLarge: true,
            label: Text('3'),
            child: Icon(Icons.notifications),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('CustomAvatar displays initials or center icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestableWidget(const CustomAvatar(initials: 'BY')),
      );

      expect(find.text('BY'), findsOneWidget);

      await tester.pumpWidget(
        buildTestableWidget(const CustomAvatar(icon: Icon(Icons.person))),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
