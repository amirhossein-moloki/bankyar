import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/entities/search_models.dart';
import '../../../transactions/presentation/state/transactions_notifier.dart';

/// Advanced filter bottom sheet displaying date/amount ranges, banks, categories, and note existence.
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({
    required this.initialFilters,
    required this.onApply,
    super.key,
  });

  final SearchFilters initialFilters;
  final ValueChanged<SearchFilters> onApply;

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late SearchFilters _tempFilters;
  late TextEditingController _minAmountController;
  late TextEditingController _maxAmountController;

  final List<String> _banksList = [
    'All',
    'Melli',
    'Mellat',
    'Tejarat',
    'Saman',
    'Pasargad',
    'Saderat',
    'Parsian',
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = widget.initialFilters;
    _minAmountController = TextEditingController(
      text: _tempFilters.minAmount?.toStringAsFixed(0) ?? '',
    );
    _maxAmountController = TextEditingController(
      text: _tempFilters.maxAmount?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _tempFilters.startDate != null && _tempFilters.endDate != null
          ? DateTimeRange(start: _tempFilters.startDate!, end: _tempFilters.endDate!)
          : null,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fa'),
    );

    if (picked != null) {
      setState(() {
        _tempFilters = _tempFilters.copyWith(
          startDate: () => picked.start,
          endDate: () => picked.end,
        );
      });
    }
  }

  void _clearDateRange() {
    setState(() {
      _tempFilters = _tempFilters.copyWith(
        startDate: () => null,
        endDate: () => null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final categoriesAsync = ref.watch(categoriesListProvider);

    return CustomBottomSheet(
      title: 'فیلترهای پیشرفته',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Transaction Type Choice Chips
          Text(
            'نوع تراکنش',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacing.xs),
          Row(
            children: [
              ChoiceChip(
                label: const Text('همه'),
                selected: _tempFilters.transactionType == 'All',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _tempFilters = _tempFilters.copyWith(transactionType: 'All');
                    });
                  }
                },
              ),
              SizedBox(width: spacing.xs),
              ChoiceChip(
                label: const Text('ورودی (واریز)'),
                selected: _tempFilters.transactionType == 'Credit',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _tempFilters = _tempFilters.copyWith(transactionType: 'Credit');
                    });
                  }
                },
              ),
              SizedBox(width: spacing.xs),
              ChoiceChip(
                label: const Text('خروجی (برداشت)'),
                selected: _tempFilters.transactionType == 'Debit',
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _tempFilters = _tempFilters.copyWith(transactionType: 'Debit');
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(height: spacing.m),

          // 2. Bank Dropdown
          DropdownField<String>(
            label: 'بانک یا مؤسسه مالی',
            value: _tempFilters.bank ?? 'All',
            items: _banksList.map((bankName) {
              return DropdownMenuItem<String>(
                value: bankName,
                child: Text(bankName == 'All' ? 'همه بانک‌ها' : bankName),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _tempFilters = _tempFilters.copyWith(
                  bank: () => val == 'All' ? null : val,
                );
              });
            },
          ),
          SizedBox(height: spacing.m),

          // 3. Category Dropdown
          categoriesAsync.when(
            data: (categories) {
              final items = [
                const DropdownMenuItem<String>(
                  value: 'All',
                  child: Text('همه دسته‌بندی‌ها'),
                ),
                ...categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c.id,
                    child: Text(c.name),
                  );
                }),
              ];

              return DropdownField<String>(
                label: 'دسته‌بندی',
                value: _tempFilters.categoryId ?? 'All',
                items: items,
                onChanged: (val) {
                  setState(() {
                    _tempFilters = _tempFilters.copyWith(
                      categoryId: () => val == 'All' ? null : val,
                    );
                  });
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('خطا در دریافت دسته‌بندی‌ها'),
          ),
          SizedBox(height: spacing.m),

          // 4. Amount Range inputs
          Text(
            'محدوده مبلغ (ریال)',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacing.xs),
          Row(
            children: [
              Expanded(
                child: TextInputField(
                  label: 'از مبلغ',
                  controller: _minAmountController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final numVal = double.tryParse(val);
                    _tempFilters = _tempFilters.copyWith(
                      minAmount: () => numVal,
                    );
                  },
                ),
              ),
              SizedBox(width: spacing.s),
              Expanded(
                child: TextInputField(
                  label: 'تا مبلغ',
                  controller: _maxAmountController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final numVal = double.tryParse(val);
                    _tempFilters = _tempFilters.copyWith(
                      maxAmount: () => numVal,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.m),

          // 5. Date Range Selector
          Text(
            'محدوده تاریخ',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: spacing.xs),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: _tempFilters.startDate != null && _tempFilters.endDate != null
                      ? 'انتخاب شده'
                      : 'انتخاب تاریخ...',
                  onPressed: () => _selectDateRange(context),
                ),
              ),
              if (_tempFilters.startDate != null) ...[
                SizedBox(width: spacing.xs),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearDateRange,
                ),
              ],
            ],
          ),
          SizedBox(height: spacing.m),

          // 6. Has Note Toggle
          SwitchListTile.adaptive(
            title: const Text('فقط تراکنش‌های یادداشت‌دار'),
            value: _tempFilters.hasNote ?? false,
            onChanged: (val) {
              setState(() {
                _tempFilters = _tempFilters.copyWith(
                  hasNote: () => val ? true : null,
                );
              });
            },
          ),
          SizedBox(height: spacing.m),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'پاک کردن فیلترها',
                  onPressed: () {
                    setState(() {
                      _tempFilters = SearchFilters.empty();
                      _minAmountController.clear();
                      _maxAmountController.clear();
                    });
                  },
                ),
              ),
              SizedBox(width: spacing.s),
              Expanded(
                child: PrimaryButton(
                  label: 'اعمال فیلتر',
                  onPressed: () {
                    widget.onApply(_tempFilters);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.s),
        ],
      ),
    );
  }
}
