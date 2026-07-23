import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/navigation/custom_app_bar.dart';
import 'package:bankyar/core/presentation/widgets/navigation/custom_bottom_navigation.dart';
import 'package:bankyar/core/presentation/widgets/navigation/custom_navigation_rail.dart';
import 'package:bankyar/core/presentation/widgets/navigation/custom_drawer.dart';
import 'package:bankyar/core/presentation/widgets/navigation/custom_tab_bar.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      home: Scaffold(body: child),
    );
  }

  group('Shared Navigation Tests', () {
    testWidgets('CustomAppBar displays title', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CustomAppBar(title: 'Overview Ledger', showBackButton: false),
        ),
      );

      expect(find.text('Overview Ledger'), findsOneWidget);
    });

    testWidgets(
      'CustomBottomNavigation displays options and triggers selection',
      (tester) async {
        var activeIndex = 0;
        final destinations = const [
          NavigationDestinationItem(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestinationItem(
            label: 'Ledger',
            icon: Icon(Icons.list_alt),
          ),
        ];

        await tester.pumpWidget(
          buildTestableWidget(
            CustomBottomNavigation(
              currentIndex: activeIndex,
              items: destinations,
              onTap: (index) => activeIndex = index,
            ),
          ),
        );

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Ledger'), findsOneWidget);

        await tester.tap(find.text('Ledger'));
        expect(activeIndex, equals(1));
      },
    );

    testWidgets('CustomNavigationRail displays options', (tester) async {
      final destinations = const [
        NavigationDestinationItem(label: 'Home', icon: Icon(Icons.home)),
        NavigationDestinationItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          Row(
            children: [
              CustomNavigationRail(
                currentIndex: 0,
                items: destinations,
                onTap: (_) {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('CustomDrawer exhibits items', (tester) async {
      final items = [
        DrawerItem(
          title: 'Diagnostics',
          icon: const Icon(Icons.developer_board),
          onTap: () {},
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          CustomDrawer(header: const Text('BankYar User'), items: items),
        ),
      );

      expect(find.text('BankYar User'), findsOneWidget);
      expect(find.text('Diagnostics'), findsOneWidget);
    });

    testWidgets('CustomTabBar exhibits tabs', (tester) async {
      final controller = TabController(length: 2, vsync: const TestVSync());
      await tester.pumpWidget(
        buildTestableWidget(
          CustomTabBar(
            controller: controller,
            tabs: const [
              Tab(text: 'Incoming'),
              Tab(text: 'Outgoing'),
            ],
          ),
        ),
      );

      expect(find.text('Incoming'), findsOneWidget);
      expect(find.text('Outgoing'), findsOneWidget);
      controller.dispose();
    });
  });
}

class TestVSync implements TickerProvider {
  const TestVSync();
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
