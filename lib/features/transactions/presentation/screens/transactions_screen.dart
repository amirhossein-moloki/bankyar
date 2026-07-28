import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../state/transactions_notifier.dart';
import '../widgets/transactions_filter_chips.dart';
import '../widgets/transactions_list_view.dart';
import '../widgets/transactions_search_bar.dart';
import '../widgets/transactions_sort_controls.dart';

/// Screen exhibiting all parsed transactions with filters, sorting, grouping, pagination, and multi-selection mode.
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

  void _showBatchDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف گروهی تراکنش‌ها'),
          content: const Text(
            'آیا از حذف دائمی تراکنش‌های انتخاب شده اطمینان دارید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('انصراف'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                await ref
                    .read(transactionsViewModelProvider.notifier)
                    .batchDelete();
              },
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _showBatchCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> selectedIds,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return Consumer(
          builder: (context, ref, _) {
            final categoriesAsync = ref.watch(categoriesListProvider);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('تغییر دسته‌ب بندی گروهی'),
                content: categoriesAsync.when(
                  data: (categories) => SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(
                              int.parse(cat.colorHex.replaceFirst('#', '0xFF')),
                            ).withOpacity(0.2),
                            child: Icon(
                              Icons.category,
                              color: Color(
                                int.parse(
                                  cat.colorHex.replaceFirst('#', '0xFF'),
                                ),
                              ),
                            ),
                          ),
                          title: Text(cat.name),
                          onTap: () async {
                            Navigator.pop(dialogCtx);
                            await ref
                                .read(transactionsViewModelProvider.notifier)
                                .batchAssignCategory(cat.id);
                          },
                        );
                      },
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text('خطا در بارگذاری دسته‌بندی‌ها: $err'),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text('انصراف'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogCtx);
                      await ref
                          .read(transactionsViewModelProvider.notifier)
                          .batchAssignCategory(null);
                    },
                    child: const Text('بدون دسته‌بندی'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionsViewModelProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(transactionsViewModelProvider.notifier);

    final isSelectedMode = state.when(
      initial: () => false,
      loading: (_) => false,
      error: (_) => false,
      success: (data) => data.isMultiSelectionMode,
    );

    final selectedCount = state.when(
      initial: () => 0,
      loading: (_) => 0,
      error: (_) => 0,
      success: (data) => data.selectedIds.length,
    );

    return Scaffold(
      appBar: isSelectedMode
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: notifier.clearSelection,
              ),
              title: Text('$selectedCount تراکنش انتخاب شده'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  tooltip: 'انتخاب همه',
                  onPressed: notifier.selectAll,
                ),
                IconButton(
                  icon: const Icon(Icons.category_outlined),
                  tooltip: 'تغییر دسته‌بندی گروهی',
                  onPressed: () {
                    state.when(
                      initial: () {},
                      loading: (_) {},
                      error: (_) {},
                      success: (data) {
                        _showBatchCategoryDialog(
                          context,
                          ref,
                          data.selectedIds.toList(),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'حذف گروهی',
                  onPressed: () => _showBatchDeleteConfirmation(context, ref),
                ),
              ],
            )
          : const CustomAppBar(title: 'دفترچه تراکنش‌ها', showBackButton: true),
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
