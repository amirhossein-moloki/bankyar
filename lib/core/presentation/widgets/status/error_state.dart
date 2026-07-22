import 'package:flutter/material.dart';
import '../buttons/primary_button.dart';

/// A production-ready Error State component.
/// Follows BankYar design tokens, localized layouts, and accessibility guidelines.
class ErrorState extends StatelessWidget {
  /// Constructor for ErrorState.
  const ErrorState({
    required this.message,
    super.key,
    this.title,
    this.retryLabel,
    this.onRetry,
  });

  /// Friendly user-facing error message explanation.
  final String message;

  /// Optional error title.
  final String? title;

  /// Optional retry button label.
  final String? retryLabel;

  /// Optional retry action callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.0,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              title ?? 'An Error Occurred',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (retryLabel != null && onRetry != null) ...[
              const SizedBox(height: 24.0),
              PrimaryButton(label: retryLabel!, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
