import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../state/transactions_notifier.dart';

/// Choice chips row for filtering transactions by bank, type, and categories.
class TransactionsFilterChips extends ConsumerWidget {
  /// Constructor.
  const TransactionsFilterChips({
    required this.selectedBank,
    required this.selectedType,
    this.selectedCategoryId,
    required this.onBankChanged,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    super.key,
  });

  /// Selected bank filter.
  final String selectedBank;

  /// Selected type filter.
  final String selectedType;

  /// Selected category filter ID.
  final String? selectedCategoryId;

  /// Callback on bank filter changed.
  final ValueChanged<String> onBankChanged;

  /// Callback on type filter changed.
  final ValueChanged<String> onTypeChanged;

  /// Callback on category filter changed.
  final ValueChanged<String?> onCategoryChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'بانک‌ها'),
        _buildChipsRow(
          spacing: spacing,
          children: [
            _buildChoiceChip(
              'همه',
              selectedBank == 'All',
              () => onBankChanged('All'),
            ),
            _buildChoiceChip(
              'ملی',
              selectedBank == 'Melli',
              () => onBankChanged('Melli'),
            ),
            _buildChoiceChip(
              'ملت',
              selectedBank == 'Mellat',
              () => onBankChanged('Mellat'),
            ),
            _buildChoiceChip(
              'تجارت',
              selectedBank == 'Tejarat',
              () => onBankChanged('Tejarat'),
            ),
            _buildChoiceChip(
              'سامان',
              selectedBank == 'Saman',
              () => onBankChanged('Saman'),
            ),
            _buildChoiceChip(
              'پاسارگاد',
              selectedBank == 'Pasargad',
              () => onBankChanged('Pasargad'),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        _buildSectionHeader(context, 'نوع تراکنش'),
        _buildChipsRow(
          spacing: spacing,
          children: [
            _buildChoiceChip(
              'همه',
              selectedType == 'All',
              () => onTypeChanged('All'),
            ),
            _buildChoiceChip(
              'درآمد (+)',
              selectedType == 'Credit',
              () => onTypeChanged('Credit'),
            ),
            _buildChoiceChip(
              'هزینه (-)',
              selectedType == 'Debit',
              () => onTypeChanged('Debit'),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        _buildSectionHeader(context, 'دسته‌بندی‌ها'),
        categoriesAsync.when(
          data: (categories) => _buildChipsRow(
            spacing: spacing,
            children: [
              _buildChoiceChip(
                'همه',
                selectedCategoryId == null,
                () => onCategoryChanged(null),
              ),
              ...categories.map(
                (cat) => _buildChoiceChip(
                  cat.name,
                  selectedCategoryId == cat.id,
                  () => onCategoryChanged(cat.id),
                ),
              ),
            ],
          ),
          loading: () => Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.m),
            child: const SizedBox(
              height: 32,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.m,
        vertical: spacing.xxs,
      ),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildChipsRow({
    required SpacingExtension spacing,
    required List<Widget> children,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: Row(
        children: children
            .map(
              (c) => Padding(
                padding: EdgeInsets.only(left: spacing.xs),
                child: c,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChoiceChip(
    String label,
    bool isSelected,
    VoidCallback onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}
