import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/navigation/custom_app_bar.dart';
import '../../../../core/presentation/widgets/status/error_state.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../state/home_notifier.dart';
import '../widgets/greeting_section.dart';
import '../widgets/total_balance_card.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/bank_status_indicators.dart';
import '../widgets/recent_transactions_section.dart';
import '../widgets/home_skeleton_loader.dart';
import '../widgets/manual_log_fab.dart';

/// Central landing workspace for offline personal financial management.
class HomeScreen extends ConsumerWidget {
  /// Constructor.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(homeViewModelProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: l10n.appTitle, showBackButton: false),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: uiState.when(
          initial: () => const HomeSkeletonLoader(key: ValueKey('loading')),
          loading: (_) => const HomeSkeletonLoader(key: ValueKey('loading')),
          error: (failure) => ErrorState(
            key: const ValueKey('error'),
            message: failure.message,
            onRetry: () => ref.read(homeViewModelProvider.notifier).refresh(),
          ),
          success: (state) =>
              _DashboardContentWidget(key: const ValueKey('content')),
        ),
      ),
      floatingActionButton: const ManualLogFab(),
    );
  }
}

class _DashboardContentWidget extends ConsumerWidget {
  const _DashboardContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(homeViewModelProvider.notifier);

    // Watch selected filter from state to only trigger rebuild when filter changes
    final selectedFilter = ref.watch(
      homeViewModelProvider.select(
        (s) => s.when(
          initial: () => 'All',
          loading: (_) => 'All',
          error: (_) => 'All',
          success: (d) => d.selectedBankFilter,
        ),
      ),
    );

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: CustomScrollView(
        key: const PageStorageKey('home_dashboard_scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: GreetingSection()),
          SliverToBoxAdapter(child: SizedBox(height: spacing.s)),
          const SliverToBoxAdapter(child: TotalBalanceCard()),
          SliverToBoxAdapter(child: SizedBox(height: spacing.m)),
          const SliverToBoxAdapter(child: MonthlySummaryCard()),
          SliverToBoxAdapter(child: SizedBox(height: spacing.m)),
          SliverToBoxAdapter(
            child: QuickActionsSection(
              selectedFilter: selectedFilter,
              onFilterChanged: notifier.selectBankFilter,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: spacing.m)),
          const SliverToBoxAdapter(child: BankStatusIndicators()),
          SliverToBoxAdapter(child: SizedBox(height: spacing.m)),
          const RecentTransactionsHeaderSliver(),
          RecentTransactionsListSliver(
            onTapTransaction: (tx) => _showDeleteConfirmation(context, ref, tx),
          ),
          SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    ParsedTransaction tx,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف تراکنش'),
        content: const Text('آیا از حذف این تراکنش از صندوقچه اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(transactionRepositoryProvider);
              await repo.deleteTransaction(tx.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
