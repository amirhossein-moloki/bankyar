import 'package:flutter/material.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/entities/search_models.dart';

/// Interactive sort dialog for transaction results.
class SortDialog extends StatefulWidget {
  const SortDialog({
    required this.initialSort,
    required this.onApply,
    super.key,
  });

  final SearchSort initialSort;
  final ValueChanged<SearchSort> onApply;

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  late SearchSortField _field;
  late bool _descending;

  @override
  void initState() {
    super.initState();
    _field = widget.initialSort.field;
    _descending = widget.initialSort.descending;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return AlertDialog(
      title: Text(
        'مرتب‌سازی تراکنش‌ها',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.l),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Radio Options for Sort Fields
          RadioListTile<SearchSortField>(
            title: const Text('بر اساس تاریخ'),
            value: SearchSortField.date,
            groupValue: _field,
            onChanged: (val) {
              if (val != null) setState(() => _field = val);
            },
          ),
          RadioListTile<SearchSortField>(
            title: const Text('بر اساس مبلغ'),
            value: SearchSortField.amount,
            groupValue: _field,
            onChanged: (val) {
              if (val != null) setState(() => _field = val);
            },
          ),
          RadioListTile<SearchSortField>(
            title: const Text('بر اساس حروف الفبا (نام پذیرنده)'),
            value: SearchSortField.alphabetical,
            groupValue: _field,
            onChanged: (val) {
              if (val != null) setState(() => _field = val);
            },
          ),
          RadioListTile<SearchSortField>(
            title: const Text('بر اساس نام بانک'),
            value: SearchSortField.bank,
            groupValue: _field,
            onChanged: (val) {
              if (val != null) setState(() => _field = val);
            },
          ),
          RadioListTile<SearchSortField>(
            title: const Text('بر اساس دسته‌بندی'),
            value: SearchSortField.category,
            groupValue: _field,
            onChanged: (val) {
              if (val != null) setState(() => _field = val);
            },
          ),
          const Divider(),
          // Ascending / Descending Toggle
          SwitchListTile.adaptive(
            title: const Text('مرتب‌سازی نزولی (جدیدترین/بیشترین)'),
            value: _descending,
            onChanged: (val) {
              setState(() => _descending = val);
            },
          ),
        ],
      ),
      actionsPadding: EdgeInsets.only(
        left: spacing.m,
        right: spacing.m,
        bottom: spacing.m,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(SearchSort(field: _field, descending: _descending));
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.m),
            ),
          ),
          child: const Text('تأیید'),
        ),
      ],
    );
  }
}
