import 'package:flutter/material.dart';
import '../../../theme/color_tokens.dart';
import '../../../theme/spacing_tokens.dart';
import 'base_card.dart';

/// A production-ready Material 3 Statistic Card.
/// Follows BankYar design tokens, trend statuses, and accessibility.
class StatisticCard extends StatelessWidget {
  /// Constructor for StatisticCard.
  const StatisticCard({
    required this.title,
    required this.value,
    required this.trendLabel,
    required this.isPositiveTrend,
    super.key,
    this.onTap,
  });

  /// Metric name/title.
  final String title;

  /// Aggregate financial sum/value text.
  final String value;

  /// Trend comparison percentage or text (e.g. '10%').
  final String trendLabel;

  /// True if trend represents active visual improvement (e.g., higher savings, lower expenses).
  final bool isPositiveTrend;

  /// Optional card tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    final trendColor = isPositiveTrend
        ? semanticColor.success
        : semanticColor.error;

    final trendIcon = isPositiveTrend
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return BaseCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: spacing.xs),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            Row(
              children: [
                Icon(trendIcon, size: 16.0, color: trendColor),
                SizedBox(width: spacing.xxs),
                Text(
                  trendLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: trendColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
