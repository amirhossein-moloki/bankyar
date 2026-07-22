import 'package:flutter/material.dart';

/// A production-ready Material 3 circular Avatar.
/// Follows BankYar design tokens, colors, and accessibility.
class CustomAvatar extends StatelessWidget {
  /// Constructor for CustomAvatar.
  const CustomAvatar({super.key, this.initials, this.icon, this.radius = 20.0});

  /// Initials text (max 2 characters).
  final String? initials;

  /// Optional center icon.
  final Widget? icon;

  /// Circle radius.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? childWidget;

    if (icon != null) {
      childWidget = icon;
    } else if (initials != null) {
      childWidget = Text(
        initials!,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      );
    }

    return Semantics(
      label: initials != null ? 'Avatar of $initials' : 'Avatar logo',
      child: CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary,
        child: childWidget,
      ),
    );
  }
}
