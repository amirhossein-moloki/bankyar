import 'package:flutter/material.dart';

/// A production-ready Material 3 Section Header layout element.
/// Follows BankYar design tokens, RTL direction, and accessibility.
class SectionHeader extends StatelessWidget {
  /// Constructor for SectionHeader.
  const SectionHeader({
    required this.title,
    super.key,
    this.actionLabel,
    this.onActionPressed,
  });

  /// The header section title.
  final String title;

  /// Optional action text label.
  final String? actionLabel;

  /// Optional action tap callback.
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            if (actionLabel != null && onActionPressed != null)
              TextButton(
                onPressed: onActionPressed,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
