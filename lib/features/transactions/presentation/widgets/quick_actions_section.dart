import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/layout/custom_chip.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Horizontally scrollable row of interactive bank/institution filter chips.
class QuickActionsSection extends StatelessWidget {
  /// Constructor.
  const QuickActionsSection({
    required this.selectedFilter,
    required this.onFilterChanged,
    super.key,
  });

  /// The currently selected bank filter.
  final String selectedFilter;

  /// Selection change callback.
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final filters = [
      {'key': 'All', 'label': 'همه'},
      {'key': 'Melli', 'label': 'بانک ملی'},
      {'key': 'Mellat', 'label': 'بانک ملت'},
      {'key': 'Tejarat', 'label': 'بانک تجارت'},
      {'key': 'Saderat', 'label': 'بانک صادرات'},
    ];

    return SizedBox(
      height: 60.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing.m),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: spacing.xs),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final key = filter['key']!;
          final label = filter['label']!;
          final isSelected = selectedFilter == key;

          return CustomChip(
            label: label,
            isSelected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onFilterChanged(key);
              }
            },
          );
        },
      ),
    );
  }
}
