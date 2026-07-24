import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../state/transactions_notifier.dart';
import '../widgets/transactions_filter_chips.dart';
import '../widgets/transactions_list_view.dart';
import '../widgets/transactions_search_bar.dart';
import '../widgets/transactions_sort_controls.dart';

/// Screen exhibiting all parsed transactions with filters, sorting, grouping, and pagination.
class TransactionsScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsViewModelProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(transactionsViewModelProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'دفترچه تراکنش‌ها',
        showBackButton: true,
      ),
      body: state.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: (_) => const Center(child: CircularProgressIndicator()),
        error: (failure) =>
            ErrorState(message: failure.message, onRetry: notifier.loadInitial),
        success: (data) => RefreshIndicator(
          onRefresh: notifier.refresh,
          child: Column(
            children: [
              SizedBox(height: spacing.s),
              TransactionsSearchBar(
                controller: _searchController,
                hintText: 'جستجو در تراکنش‌ها...',
                onChanged: notifier.setSearchQuery,
                onClear: () => notifier.setSearchQuery(''),
              ),
              SizedBox(height: spacing.xs),
              TransactionsFilterChips(
                selectedBank: data.bankFilter,
                selectedType: data.typeFilter,
                selectedCategoryId: data.categoryId,
                onBankChanged: notifier.setBankFilter,
                onTypeChanged: notifier.setTypeFilter,
                onCategoryChanged: notifier.setCategoryFilter,
              ),
              const Divider(height: 16),
              TransactionsSortControls(
                selectedSortBy: data.sortBy,
                descending: data.descending,
                selectedGroupBy: data.groupBy,
                onSortChanged: notifier.setSortBy,
                onGroupChanged: notifier.setGroupBy,
              ),
              const Divider(height: 1),
              Expanded(
                child: data.transactions.isEmpty
                    ? const EmptyState(
                        title: 'تراکنشی یافت نشد',
                        message: 'هیچ تراکنشی با فیلترهای مشخص شده وجود ندارد.',
                      )
                    : TransactionsListView(
                        transactions: data.transactions,
                        groupBy: data.groupBy,
                        isLoadingMore: data.isLoadingMore,
                        onLoadMore: notifier.loadNextPage,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
