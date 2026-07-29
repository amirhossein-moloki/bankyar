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
import '../../../../core/state_management/undo_delete_notifier.dart';
import '../../../secure_auth/presentation/state/permission_notifier.dart';
import '../state/home_notifier.dart';
import '../state/transactions_notifier.dart';
import '../state/data_management_notifier.dart';
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
    } else {
      _checkAndPromptHistoricalSmsImport();
    }
  }

  Future<void> _checkAndPromptHistoricalSmsImport() async {
    final prefs = ref.read(preferencesStorageProvider);
    final offered = await prefs.getBool('by_historical_sms_import_offered') ?? false;
    if (offered) return;

    final permState = ref.read(permissionNotifierProvider);
    if (permState.isSmsReadGranted) {
      await prefs.setBool('by_historical_sms_import_offered', true);
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showImportDialog();
          }
        });
      }
    }
  }

  bool _isProgressDialogShowing = false;

  void _showImportDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'وارد کردن پیامک‌های قبلی',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'بانک‌یار می‌تواند پیامک‌های بانکی قبلی شما را نیز بررسی و وارد کند.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text(
                'بعداً',
                style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _showRangeSelectionDialog();
              },
              child: const Text(
                'شروع اسکن',
                style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRangeSelectionDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: const Text(
            'بازه زمانی اسکن را انتخاب کنید',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.all);
              },
              child: const Text('کل پیامک‌ها', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.last3Months);
              },
              child: const Text('۳ ماه اخیر', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.last6Months);
              },
              child: const Text('۶ ماه اخیر', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.last12Months);
              },
              child: const Text('۱۲ ماه اخیر', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                  locale: const Locale('fa'),
                );
                if (picked != null) {
                  _startScanningFlow(
                    ImportRange.custom,
                    customStartDate: picked.start,
                    customEndDate: picked.end,
                  );
                }
              },
              child: const Text('بازه زمانی دلخواه...', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
          ],
        ),
      ),
    );
  }

  void _startScanningFlow(
    ImportRange range, {
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    if (_isProgressDialogShowing) return;
    _isProgressDialogShowing = true;

    // Only start new import if not already active (to support background safety screen re-entry)
    final activeState = ref.read(dataManagementNotifierProvider);
    if (!activeState.isImporting) {
      ref.read(dataManagementNotifierProvider.notifier).startHistoricalImport(
            range: range,
            customStartDate: customStartDate,
            customEndDate: customEndDate,
          );
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Consumer(
          builder: (context, ref, child) {
            final scanState = ref.watch(dataManagementNotifierProvider);

            if (!scanState.isImporting) {
              _isProgressDialogShowing = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(dialogCtx)) {
                  Navigator.pop(dialogCtx);

                  if (scanState.summary != null) {
                    _showSummaryDialog(scanState.summary!);
                  } else if (scanState.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          scanState.successMessage!,
                          style: const TextStyle(fontFamily: 'Vazirmatn'),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (scanState.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          scanState.errorMessage!,
                          style: const TextStyle(fontFamily: 'Vazirmatn'),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  ref.read(dataManagementNotifierProvider.notifier).clearStatusMessages();
                }
              });
            }

            final countStr = _toPersianDigits(scanState.importedCount.toString());
            final totalStr = _toPersianDigits(scanState.totalSmsCount.toString());

            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      const Text(
                        'در حال بررسی پیامک‌ها...',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$countStr از $totalStr',
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(dataManagementNotifierProvider.notifier).cancelImport();
                    },
                    child: const Text(
                      'انصراف',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSummaryDialog(ImportSummary summary) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'گزارش وارد کردن پیامک‌ها',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('کل پیامک‌های بررسی شده:', summary.totalScanned),
              const Divider(),
              _buildSummaryRow('پیامک‌های بانکی شناسایی شده:', summary.bankSmsDetected),
              const Divider(),
              _buildSummaryRow('تراکنش‌های جدید وارد شده:', summary.newTransactionsImported),
              const Divider(),
              _buildSummaryRow('پیامک‌های تکراری نادیده گرفته شده:', summary.duplicateSmsSkipped),
              const Divider(),
              _buildSummaryRow('پیامک‌های نامعتبر یا غیربانکی:', summary.unsupportedSmsSkipped),
              const Divider(),
              _buildSummaryRow('زمان کل اسکن (ثانیه):', _toPersianDigits(summary.scanDurationSeconds.toStringAsFixed(1))),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                ref.read(dataManagementNotifierProvider.notifier).clearSummary();
              },
              child: const Text(
                'تایید',
                style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value) {
    final valueStr = value is int ? _toPersianDigits(value.toString()) : value.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13)),
          Text(
            valueStr,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  String _toPersianDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var result = input;
    for (var i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
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

        _checkAndPromptHistoricalSmsImport();
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
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'تنظیمات و امنیت',
            onPressed: () => context.push('/security'),
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
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: () {
          ref.read(undoDeleteProvider.notifier).deleteTransaction(
            context,
            tx,
            () {
              ref.invalidate(homeViewModelProvider);
              ref.invalidate(transactionsViewModelProvider);
            },
          );
        },
      ),
    );
  }
}
