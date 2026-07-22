import 'package:flutter/material.dart';

/// A production-ready Material 3 Tooltip wrapper.
/// Follows BankYar design tokens and accessibility guidelines.
class CustomTooltip extends StatelessWidget {
  /// Constructor for CustomTooltip.
  const CustomTooltip({required this.message, required this.child, super.key});

  /// Helpful message description.
  final String message;

  /// The child layout anchor target.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: message,
      textStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onInverseSurface,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: child,
    );
  }
}
