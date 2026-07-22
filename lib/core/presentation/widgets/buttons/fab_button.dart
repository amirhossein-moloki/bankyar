import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Floating Action Button.
/// Follows BankYar design tokens and accessibility guidelines.
class FabButton extends StatelessWidget {
  /// Constructor for FabButton.
  const FabButton({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    super.key,
    this.label,
  });

  /// The callback to execute on press.
  final VoidCallback onPressed;

  /// The icon widget inside FAB.
  final Widget icon;

  /// The accessibility tooltip/label description.
  final String tooltip;

  /// Optional text label (turns it into an Extended FAB).
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      button: true,
      label: label ?? tooltip,
      child: Tooltip(
        message: tooltip,
        child: label != null
            ? FloatingActionButton.extended(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onPressed();
                },
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.xl),
                ),
                icon: icon,
                label: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                  child: Text(
                    label!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : FloatingActionButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onPressed();
                },
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.l),
                ),
                child: icon,
              ),
      ),
    );
  }
}
