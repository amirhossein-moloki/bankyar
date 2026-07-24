import 'package:flutter/material.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Segmented sort and group options bar for transactions list.
class TransactionsSortControls extends StatelessWidget {
  /// Constructor.
  const TransactionsSortControls({
    required this.selectedSortBy,
    required this.descending,
    required this.selectedGroupBy,
    required this.onSortChanged,
    required this.onGroupChanged,
    super.key,
  });

  /// Selected sorting option.
  final String selectedSortBy;

  /// Direction.
  final bool descending;

  /// Selected grouping option.
  final String selectedGroupBy;

  /// Callback on sort option changed.
  final void Function(String field, bool descending) onSortChanged;

  /// Callback on group option changed.
  final ValueChanged<String> onGroupChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.m,
        vertical: spacing.xs,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مرتب‌سازی براساس:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildSortOption(theme, 'تاریخ', 'Date'),
                  SizedBox(width: spacing.xs),
                  _buildSortOption(theme, 'مبلغ', 'Amount'),
                  SizedBox(width: spacing.xs),
                  _buildSortOption(theme, 'دقت', 'Confidence'),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'گروه‌بندی:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _buildGroupOption(theme, 'روز', 'Day'),
                  SizedBox(width: spacing.xs),
                  _buildGroupOption(theme, 'هفته', 'Week'),
                  SizedBox(width: spacing.xs),
                  _buildGroupOption(theme, 'ماه', 'Month'),
                  SizedBox(width: spacing.xs),
                  _buildGroupOption(theme, 'هیچ‌کدام', 'None'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(ThemeData theme, String label, String value) {
    final isSelected = selectedSortBy == value;
    final iconData = isSelected
        ? (descending
              ? Icons.arrow_downward_outlined
              : Icons.arrow_upward_outlined)
        : null;

    final style = OutlinedButton.styleFrom(
      foregroundColor: isSelected
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurfaceVariant,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      minimumSize: Size.zero,
    );

    final textChild = Text(label, style: const TextStyle(fontSize: 12));

    if (iconData != null) {
      return OutlinedButton.icon(
        style: style,
        icon: Icon(iconData, size: 14),
        label: textChild,
        onPressed: () => onSortChanged(value, !descending),
      );
    }

    return OutlinedButton(
      style: style,
      onPressed: () => onSortChanged(value, true),
      child: textChild,
    );
  }

  Widget _buildGroupOption(ThemeData theme, String label, String value) {
    final isSelected = selectedGroupBy == value;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
        backgroundColor: isSelected
            ? theme.colorScheme.primaryContainer.withOpacity(0.2)
            : null,
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        minimumSize: Size.zero,
      ),
      onPressed: () => onGroupChanged(value),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
