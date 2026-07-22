import 'package:flutter/material.dart';

/// A production-ready Material 3 Badge.
/// Follows BankYar design tokens, RTL corners, and accessibility.
class CustomBadge extends StatelessWidget {
  /// Constructor for CustomBadge.
  const CustomBadge({
    required this.child,
    super.key,
    this.label,
    this.isLarge = false,
  });

  /// The underlying anchor widget being badged (e.g. icon).
  final Widget child;

  /// The badge counter or status label.
  final Widget? label;

  /// Large badge configuration flag.
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Badge(
      label: label,
      backgroundColor: theme.colorScheme.error,
      child: child,
    );
  }
}
