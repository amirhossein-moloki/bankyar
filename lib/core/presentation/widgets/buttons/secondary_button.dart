import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Secondary Outlined Button.
/// Follows BankYar design tokens and accessibility guidelines.
class SecondaryButton extends StatelessWidget {
  /// Constructor for SecondaryButton.
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.startIcon,
    this.endIcon,
    this.isLoading = false,
  });

  /// The button text label.
  final String label;

  /// The callback to execute on press.
  final VoidCallback? onPressed;

  /// Optional icon to render at the start.
  final Widget? startIcon;

  /// Optional icon to render at the end.
  final Widget? endIcon;

  /// Displays a loading spinner and deactivates button when true.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    final isActive = onPressed != null && !isLoading;

    return Semantics(
      button: true,
      enabled: isActive,
      label: label,
      child: SizedBox(
        height: 48.0, // Minimum accessibility touch target
        child: OutlinedButton(
          onPressed: isActive
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                }
              : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.12),
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.m),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: spacing.l,
              vertical: spacing.s,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                )
              : Row(
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
                    if (endIcon != null) ...[
                      SizedBox(width: spacing.xs),
                      endIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
