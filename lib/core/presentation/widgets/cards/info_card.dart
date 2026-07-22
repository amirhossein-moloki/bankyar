import 'package:flutter/material.dart';
import '../../../theme/color_tokens.dart';
import '../../../theme/spacing_tokens.dart';
import 'base_card.dart';

/// Types of info cards supported.
enum InfoCardType {
  /// General information/tip card.
  info,

  /// Warning alert card.
  warning,

  /// Error/Failure alert card.
  error,

  /// Success alert card.
  success,
}

/// A production-ready Material 3 Info / Alert Card.
/// Follows BankYar design tokens, semantic extensions, and accessibility.
class InfoCard extends StatelessWidget {
  /// Constructor for InfoCard.
  const InfoCard({
    required this.message,
    super.key,
    this.title,
    this.type = InfoCardType.info,
    this.icon,
  });

  /// Main message content.
  final String message;

  /// Optional card title.
  final String? title;

  /// Informational or status type of this card.
  final InfoCardType type;

  /// Optional custom leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    // Resolve semantic colors and icons based on type
    final Color strokeColor;
    final Color bgColor;
    final IconData defaultIcon;

    switch (type) {
      case InfoCardType.info:
        strokeColor = theme.colorScheme.primary.withOpacity(0.4);
        bgColor = theme.colorScheme.primaryContainer.withOpacity(0.12);
        defaultIcon = Icons.info_outline;
        break;
      case InfoCardType.warning:
        strokeColor = semanticColor.warning;
        bgColor = semanticColor.warning.withOpacity(0.08);
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case InfoCardType.error:
        strokeColor = semanticColor.error;
        bgColor = semanticColor.error.withOpacity(0.08);
        defaultIcon = Icons.error_outline_rounded;
        break;
      case InfoCardType.success:
        strokeColor = semanticColor.success;
        bgColor = semanticColor.success.withOpacity(0.08);
        defaultIcon = Icons.check_circle_outline_rounded;
        break;
    }

    return BaseCard(
      backgroundColor: bgColor,
      borderColor: strokeColor,
      child: Padding(
        padding: EdgeInsets.all(spacing.l),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? defaultIcon, color: strokeColor),
            SizedBox(width: spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                  ],
                  Text(message, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
