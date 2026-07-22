import 'package:flutter/material.dart';
import '../../../theme/elevation_tokens.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Base Card container.
/// Follows BankYar design tokens, elevations, and layout rules.
class BaseCard extends StatelessWidget {
  /// Constructor for BaseCard.
  const BaseCard({
    required this.child,
    super.key,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderColor,
  });

  /// Nested visual elements inside the card.
  final Widget child;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Custom background color overlay.
  final Color? backgroundColor;

  /// Elevation depth (defaults to level1).
  final double? elevation;

  /// Custom border color outline.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;
    final elevExt = theme.extension<ElevationExtension>()!;

    final activeElevation = elevation ?? elevExt.level1;
    final isClickable = onTap != null;

    final cardWidget = Card(
      elevation: activeElevation,
      color: backgroundColor ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 1.0)
            : BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.12),
                width: 1.0,
              ),
      ),
      margin: EdgeInsets.zero,
      child: isClickable
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius.m),
              child: child,
            )
          : child,
    );

    return Semantics(container: true, child: cardWidget);
  }
}
