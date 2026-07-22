import 'package:flutter/material.dart';

/// A production-ready Material 3 Circular Progress Indicator.
/// Follows BankYar design tokens and accessibility guidelines.
class CircularProgress extends StatelessWidget {
  /// Constructor for CircularProgress.
  const CircularProgress({
    super.key,
    this.value,
    this.message,
  });

  /// Optional specific progress percentage (from 0.0 to 1.0).
  final double? value;

  /// Optional helpful caption text.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final indicator = CircularProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
    );

    if (message == null) {
      return Semantics(
        label: 'Progress indicator',
        child: indicator,
      );
    }

    return Semantics(
      label: 'Progress: $message',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 12.0),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
