import 'package:flutter/material.dart';

/// A production-ready Material 3 Linear Progress Indicator.
/// Follows BankYar design tokens, RTL filling, and accessibility guidelines.
class LinearProgress extends StatelessWidget {
  /// Constructor for LinearProgress.
  const LinearProgress({super.key, this.value, this.message});

  /// Optional specific progress percentage (from 0.0 to 1.0).
  final double? value;

  /// Optional helpful caption text.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final indicator = LinearProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.24),
    );

    if (message == null) {
      return Semantics(label: 'Progress indicator', child: indicator);
    }

    return Semantics(
      label: 'Progress: $message',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          indicator,
          const SizedBox(height: 8.0),
          Text(
            message!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
