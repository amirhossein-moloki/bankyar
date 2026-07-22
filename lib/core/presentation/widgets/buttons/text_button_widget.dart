import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Text Button.
/// Follows BankYar design tokens and accessibility guidelines.
class TextButtonWidget extends StatelessWidget {
  /// Constructor for TextButtonWidget.
  const TextButtonWidget({
    required this.label,
    required this.onPressed,
    super.key,
    this.startIcon,
    this.endIcon,
  });

  /// The button text label.
  final String label;

  /// The callback to execute on press.
  final VoidCallback? onPressed;

  /// Optional icon to render at the start.
  final Widget? startIcon;

  /// Optional icon to render at the end.
  final Widget? endIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    final isActive = onPressed != null;

    return Semantics(
      button: true,
      enabled: isActive,
      label: label,
      child: SizedBox(
        height: 48.0, // Minimum accessibility touch target
        child: TextButton(
          onPressed: isActive
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                }
              : null,
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.m),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.m,
              vertical: spacing.s,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (startIcon != null) ...[
                startIcon!,
                SizedBox(width: spacing.xs),
              ],
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.38),
                ),
              ),
              if (endIcon != null) ...[SizedBox(width: spacing.xs), endIcon!],
            ],
          ),
        ),
      ),
    );
  }
}
