import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_bottom_navigation.dart';

/// A production-ready Material 3 Navigation Rail for adaptive multi-device formats.
/// Follows BankYar design tokens, accessibility, and RTL mirroring.
class CustomNavigationRail extends StatelessWidget {
  /// Constructor for CustomNavigationRail.
  const CustomNavigationRail({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });

  /// Selected navigation index.
  final int currentIndex;

  /// Desired rail items list.
  final List<NavigationDestinationItem> items;

  /// Selection change callback.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        HapticFeedback.selectionClick();
        onTap(index);
      },
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primaryContainer,
      labelType: NavigationRailLabelType.all,
      destinations: items.map((item) {
        return NavigationRailDestination(
          icon: item.icon,
          selectedIcon: item.selectedIcon,
          label: Text(item.label),
        );
      }).toList(),
    );
  }
}
