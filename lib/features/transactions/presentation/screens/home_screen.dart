// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../../sms_detection/presentation/state/sms_detection_providers.dart';
import '../../../secure_auth/presentation/state/permission_notifier.dart';
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
/// Provider managing session-level warning banner dismissals.
final permissionBannerDismissedProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  void _checkOnboarding() async {
    final prefs = ref.read(preferencesStorageProvider);
    final completed = await prefs.getBool('by_onboarding_completed') ?? false;
    if (!completed && mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(homeViewModelProvider);
    final l10n = AppLocalizations.of(context);

    // Auto start SMS engine and refresh when critical permissions are granted later
    ref.listen<PermissionState>(permissionNotifierProvider, (previous, next) async {
      final prevSmsRead = previous?.isSmsReadGranted ?? false;
      final prevSmsRec = previous?.isSmsReceiveGranted ?? false;
      final nextSmsRead = next.isSmsReadGranted;
      final nextSmsRec = next.isSmsReceiveGranted;

      if ((!prevSmsRead && nextSmsRead) || (!prevSmsRec && nextSmsRec)) {
        try {
          final importer = ref.read(smsHistoryImporterProvider);
          await importer.performIncrementalSync();
          await ref.read(homeViewModelProvider.notifier).refresh();
        } catch (_) {}

        try {
          final receiver = ref.read(smsReceiverServiceProvider);
          await receiver.startListening();
        } catch (_) {}
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.appTitle,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'آموزش و آمار مالی',
            onPressed: () => context.push('/analytics'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'مرکز اعلان‌ها',
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
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
              const _DashboardContentWidget(key: ValueKey('content')),
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

    // Watch current permission state to reactively draw missing warning banner
    final permState = ref.watch(permissionNotifierProvider);
    final bannerDismissed = ref.watch(permissionBannerDismissedProvider);

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

    final showWarningBanner = permState.isAnyCriticalMissing && !bannerDismissed;

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: CustomScrollView(
        key: const PageStorageKey('home_dashboard_scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (showWarningBanner)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.m,
                  vertical: spacing.s,
                ),
                child: CustomBanner(
                  message:
                      'بانک‌یار به برخی مجوزهای حیاتی دسترسی ندارد و ممکن است پیامک‌های جدید پردازش نشوند.',
                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  backgroundColor: Colors.orange.withOpacity(0.12),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.push('/security/permissions');
                      },
                      child: const Text(
                        'مدیریت مجوزها',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(permissionBannerDismissedProvider.notifier).state = true;
                      },
                      child: const Text(
                        'بستن',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    showDialog<void>(
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
