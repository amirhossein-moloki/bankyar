import 'package:flutter/material.dart';
import '../buttons/primary_button.dart';

/// A production-ready Empty State visual feedback component.
/// Follows BankYar design tokens, localized layouts, and accessibility guidelines.
class EmptyState extends StatelessWidget {
  /// Constructor for EmptyState.
  const EmptyState({
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onActionPressed,
    this.icon,
  });

  /// Main heading title.
  final String title;

  /// Secondary explanation message.
  final String message;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional action callback.
  final VoidCallback? onActionPressed;

  /// Optional custom leading icon or illustration placeholder.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 16.0),
            ] else ...[
              Icon(
                Icons.folder_open_outlined,
                size: 64.0,
                color: theme.colorScheme.onSurface.withOpacity(0.38),
              ),
              const SizedBox(height: 16.0),
            ],
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
