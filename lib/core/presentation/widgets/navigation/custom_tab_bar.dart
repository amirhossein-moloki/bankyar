import 'package:flutter/material.dart';

/// A production-ready Material 3 Tab Bar wrapper.
/// Follows BankYar design tokens, accessibility, and RTL bounds.
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Constructor for CustomTabBar.
  const CustomTabBar({required this.controller, required this.tabs, super.key});

  /// The active tab controller.
  final TabController controller;

  /// List of tab elements (usually containing text/icons).
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TabBar(
      controller: controller,
      tabs: tabs,
      labelColor: theme.colorScheme.primary,
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      indicatorColor: theme.colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: theme.textTheme.labelLarge,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
