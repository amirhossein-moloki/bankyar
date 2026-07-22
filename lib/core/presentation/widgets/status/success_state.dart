import 'package:flutter/material.dart';
import '../buttons/primary_button.dart';

/// A production-ready Success State confirmation layout.
/// Follows BankYar design tokens, localized layouts, and accessibility guidelines.
class SuccessState extends StatelessWidget {
  /// Constructor for SuccessState.
  const SuccessState({
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onActionPressed,
  });

  /// The bold success heading.
  final String title;

  /// Explanatory details.
  final String message;

  /// Optional primary action label.
  final String? actionLabel;

  /// Optional action callback.
  final VoidCallback? onActionPressed;

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
              Icons.check_circle_outline_rounded,
              size: 64.0,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
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
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24.0),
              PrimaryButton(label: actionLabel!, onPressed: onActionPressed),
            ],
          ],
        ),
      ),
    );
  }
}
