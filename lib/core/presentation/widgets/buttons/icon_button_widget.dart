import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Icon Button.
/// Follows BankYar design tokens and accessibility guidelines.
class IconButtonWidget extends StatelessWidget {
  /// Constructor for IconButtonWidget.
  const IconButtonWidget({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    super.key,
  });

  /// The icon widget to render.
  final Widget icon;

  /// The callback to execute on press.
  final VoidCallback? onPressed;

  /// The accessibility tooltip/label description.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    final isActive = onPressed != null;

    return Semantics(
      button: true,
      enabled: isActive,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: 48.0, // Minimum accessibility touch target
          height: 48.0,
          child: IconButton(
            onPressed: isActive
                ? () {
                    HapticFeedback.lightImpact();
                    onPressed!();
                  }
                : null,
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(
                0.38,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.max),
              ),
            ),
            icon: icon,
          ),
        ),
      ),
    );
  }
}
