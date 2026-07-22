import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable navigation item data contract.
class NavigationDestinationItem {
  /// Constructor.
  const NavigationDestinationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  /// Readable text label of destination.
  final String label;

  /// Inactive state icon representation.
  final Widget icon;

  /// Optional active state icon representation.
  final Widget? selectedIcon;
}

/// A production-ready Material 3 Bottom Navigation bar.
/// Follows BankYar design tokens, accessibility, and RTL checks.
class CustomBottomNavigation extends StatelessWidget {
  /// Constructor for CustomBottomNavigation.
  const CustomBottomNavigation({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    super.key,
  });

  /// Selected navigation index.
  final int currentIndex;

  /// Desired destination list.
  final List<NavigationDestinationItem> items;

  /// Selection change callback.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        HapticFeedback.selectionClick();
        onTap(index);
      },
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primaryContainer,
      destinations: items.map((item) {
        return NavigationDestination(
          icon: item.icon,
          selectedIcon: item.selectedIcon,
          label: item.label,
        );
      }).toList(),
    );
  }
}
