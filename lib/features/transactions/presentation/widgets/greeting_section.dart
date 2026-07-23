import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/layout/section_header.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Section showing the welcome greeting and safe offline badge.
class GreetingSection extends StatelessWidget {
  /// Constructor.
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.greetingTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  l10n.greetingSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const _OfflineBadgeWidget(),
        ],
      ),
    );
  }
}

class _OfflineBadgeWidget extends StatelessWidget {
  const _OfflineBadgeWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: semanticColor.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(spacing.xs),
        border: Border.all(
          color: semanticColor.success.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: semanticColor.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: spacing.xs),
          Text(
            l10n.fullyOfflineBadge,
            style: theme.textTheme.labelSmall?.copyWith(
              color: semanticColor.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
