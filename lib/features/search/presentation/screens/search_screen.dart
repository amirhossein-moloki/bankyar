import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/entities/search_models.dart';
import '../state/search_notifier.dart';
import '../state/search_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/sort_dialog.dart';

/// Screen exhibiting advanced search, filtering, and sorting for parsed transactions.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context, SearchFilters currentFilters, SearchNotifier notifier) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(
          initialFilters: currentFilters,
          onApply: notifier.updateFilters,
        );
      },
    );
  }

  void _showSortDialog(BuildContext context, SearchSort currentSort, SearchNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return SortDialog(
          initialSort: currentSort,
          onApply: notifier.updateSort,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(searchViewModelProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(searchViewModelProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'جستجو و فیلتر تراکنش‌ها',
        showBackButton: true,
      ),
      body: uiState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: (_) => const Center(child: CircularProgressIndicator()),
        error: (failure) => ErrorState(
          message: failure.message,
          onRetry: notifier.executeSearch,
        ),
        success: (data) {
          final query = data.query;
          final filters = query.filters;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Zone A: Sticky Search Box & Filters Bar
              Padding(
                padding: EdgeInsets.all(spacing.m),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchInputField(
                        controller: _searchController,
                        hintText: 'جستجو در مبالغ، بانک‌ها، یادداشت‌ها...',
                        onChanged: notifier.updateQueryText,
                        onClear: () => notifier.updateQueryText(''),
                      ),
                    ),
                    SizedBox(width: spacing.s),
                    Semantics(
                      label: 'فیلتر پیشرفته',
                      child: IconButton(
                        icon: const Icon(Icons.tune),
                        style: IconButton.styleFrom(
                          backgroundColor: filters.isAnyActive
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.surfaceVariant,
                        ),
                        onPressed: () => _showFilterBottomSheet(context, filters, notifier),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Semantics(
                      label: 'مرتب‌سازی',
                      child: IconButton(
                        icon: const Icon(Icons.sort),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                        onPressed: () => _showSortDialog(context, query.sort, notifier),
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal Quick Filter Chips row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: spacing.m),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('همه'),
                      selected: filters.transactionType == 'All' && !filters.isAnyActive,
                      onSelected: (selected) {
                        if (selected) notifier.resetFilters();
                      },
                    ),
                    SizedBox(width: spacing.xs),
                    ChoiceChip(
                      label: const Text('واریزها'),
                      selected: filters.transactionType == 'Credit',
                      onSelected: (selected) {
                        notifier.updateFilters(
                          filters.copyWith(transactionType: selected ? 'Credit' : 'All'),
                        );
                      },
                    ),
                    SizedBox(width: spacing.xs),
                    ChoiceChip(
                      label: const Text('برداشت‌ها'),
                      selected: filters.transactionType == 'Debit',
                      onSelected: (selected) {
                        notifier.updateFilters(
                          filters.copyWith(transactionType: selected ? 'Debit' : 'All'),
                        );
                      },
                    ),
                    SizedBox(width: spacing.xs),
                    ChoiceChip(
                      label: const Text('یادداشت‌دار'),
                      selected: filters.hasNote == true,
                      onSelected: (selected) {
                        notifier.updateFilters(
                          filters.copyWith(hasNote: () => selected ? true : null),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),

              // Active Filters Indicators (if any)
              if (filters.isAnyActive)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.m),
                  child: Wrap(
                    spacing: spacing.xs,
                    runSpacing: spacing.xs,
                    children: [
                      if (filters.transactionType != 'All')
                        InputChip(
                          label: Text(filters.transactionType == 'Credit' ? 'فقط واریزها' : 'فقط برداشت‌ها'),
                          onDeleted: () {
                            notifier.updateFilters(filters.copyWith(transactionType: 'All'));
                          },
                        ),
                      if (filters.bank != null)
                        InputChip(
                          label: Text('بانک: ${filters.bank}'),
                          onDeleted: () {
                            notifier.updateFilters(filters.copyWith(bank: () => null));
                          },
                        ),
                      if (filters.categoryId != null)
                        InputChip(
                          label: const Text('فیلتر دسته‌بندی'),
                          onDeleted: () {
                            notifier.updateFilters(filters.copyWith(categoryId: () => null));
                          },
                        ),
                      if (filters.hasNote == true)
                        InputChip(
                          label: const Text('یادداشت‌دار'),
                          onDeleted: () {
                            notifier.updateFilters(filters.copyWith(hasNote: () => null));
                          },
                        ),
                      if (filters.minAmount != null || filters.maxAmount != null)
                        InputChip(
                          label: const Text('محدوده مبلغ'),
                          onDeleted: () {
                            notifier.updateFilters(
                              filters.copyWith(minAmount: () => null, maxAmount: () => null),
                            );
                          },
                        ),
                      TextButton(
                        onPressed: notifier.resetFilters,
                        child: const Text('پاک کردن همه'),
                      ),
                    ],
                  ),
                ),

              // Zone B: Scrollable workspace
              Expanded(
                child: _buildWorkspace(context, data, notifier, spacing, theme),
              ),

              // Zone C: Sticky system navigation & offline control
              Container(
                padding: EdgeInsets.symmetric(vertical: spacing.s),
                color: theme.colorScheme.surface,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.security,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                      SizedBox(width: spacing.xs),
                      Text(
                        'آفلاین و امن - رمزنگاری شده در دستگاه',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWorkspace(
    BuildContext context,
    SearchState data,
    SearchNotifier notifier,
    SpacingExtension spacing,
    ThemeData theme,
  ) {
    // Stage A: Empty Input & Filters => Show History and suggestions
    if (data.query.text.trim().isEmpty && !data.query.filters.isAnyActive) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (data.history.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'جستجوهای اخیر',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: notifier.clearHistory,
                    child: const Text('پاک کردن تاریخچه'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data.history.length,
                itemBuilder: (context, index) {
                  final term = data.history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(term),
                    trailing: const Icon(Icons.arrow_outward, size: 16),
                    onTap: () {
                      _searchController.text = term;
                      notifier.updateQueryText(term);
                    },
                  );
                },
              ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(spacing.xl),
                  child: const EmptyState(
                    title: 'آماده جستجو',
                    message: 'عبارت مورد نظر خود را برای جستجو در تراکنش‌ها وارد کنید یا فیلترهای پیشرفته را اعمال نمایید.',
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }

    // Stage D: No Results State
    if (data.transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: EmptyState(
            title: 'تراکنشی یافت نشد',
            message: 'هیچ تراکنشی متناسب با مشخصات جستجو یا فیلترهای اعمال شده پیدا نشد.',
            actionLabel: 'پاک کردن فیلترها',
            onActionPressed: () {
              _searchController.clear();
              notifier.resetFilters();
            },
          ),
        ),
      );
    }

    // Stage C: Active Results Ledger List
    final countText = DateFormatter.toPersianDigits(data.transactions.length.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
          child: Text(
            'تعداد نتایج: $countText تراکنش',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.transactions.length,
            padding: EdgeInsets.symmetric(horizontal: spacing.m),
            itemBuilder: (context, index) {
              final tx = data.transactions[index];
              final isCredit = tx.transactionType == SmsTransactionType.credit;
              final formattedAmount = CurrencyFormatter.formatToman(tx.amount);
              final date = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
              final formattedDate = DateFormatter.formatFriendly(date);

              return Padding(
                padding: EdgeInsets.only(bottom: spacing.s),
                child: TransactionCard(
                  amount: formattedAmount,
                  timestamp: formattedDate,
                  category: tx.normalizedMerchant.isNotEmpty ? tx.normalizedMerchant : 'پذیرنده نامشخص',
                  accountLabel: tx.cardIdentifier ?? 'حساب بانکی',
                  isCredit: isCredit,
                  onTap: () {
                    context.push('/transactions/${tx.id}');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
