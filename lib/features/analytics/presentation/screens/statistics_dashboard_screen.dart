import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/presentation/widgets/indicators/skeleton_loader.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/time_range.dart';
import '../state/analytics_notifier.dart';
import '../state/analytics_state.dart';
import '../widgets/custom_charts.dart';

/// Central analytical command center transforming raw financial data into interactive visualizations.
/// Follows BankYar STATISTICS_ANALYTICS_SCREEN_SPECIFICATION.md and Material Design 3 guidelines.
class StatisticsDashboardScreen extends ConsumerWidget {
  /// Constructor.
  const StatisticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(analyticsViewModelProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'آموزش و آمار مالی',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showShareSnapshotBottomSheet(context),
            tooltip: 'اشتراک‌گذاری گزارش',
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () => _showExportBottomSheet(context),
            tooltip: 'خروجی فایل اکسل',
          ),
        ],
      ),
      body: uiState.when(
        initial: () => const _LoadingSkeletonWorkspace(),
        loading: (_) => const _LoadingSkeletonWorkspace(),
        error: (failure) => ErrorState(
          message: failure.message,
          onRetry: () => ref.read(analyticsViewModelProvider.notifier).loadAnalytics(),
        ),
        success: (data) {
          if (data.summary.transactionCount == 0) {
            return _buildEmptyState(context, data, ref);
          }
          return _DashboardScrollWorkspace(data: data);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AnalyticsState data, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(analyticsViewModelProvider.notifier);

    if (data.selectedBankFilter != 'All') {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: EmptyState(
            title: 'تراکنشی با فیلترهای انتخابی یافت نشد',
            message: 'هیچ‌کدام از پیامک‌های بانکی حساب "${data.selectedBankFilter}" در این بازه زمانی یافت نشد.',
            actionLabel: 'پاک کردن فیلتر حساب',
            onActionPressed: () => notifier.selectBankFilter('All'),
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyState(
              title: 'آماری برای نمایش وجود ندارد',
              message: 'برای محاسبه نمودارها و تحلیل‌ها، حداقل یک تراکنش مالی در محدوده زمانی انتخاب شده مورد نیاز است.',
              actionLabel: 'تغییر محدوده زمانی',
              onActionPressed: () => _showCustomDateRangeSelector(context, notifier),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareSnapshotBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        return Container(
          padding: EdgeInsets.all(spacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اشتراک‌گذاری تصویر نمودار',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: spacing.s),
              const Text('شما می‌توانید یک تصویر فوری امن از گزارش دارایی خود تهیه و ذخیره نمایید.'),
              SizedBox(height: spacing.m),
              PrimaryButton(
                label: 'ذخیره عکس در گالری',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExportBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        return Container(
          padding: EdgeInsets.all(spacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'خروجی اطلاعات مالی',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: spacing.s),
              const Text('دریافت خروجی گزارش با فرمت CSV یا اکسل کاملاً رمزنگاری شده در دستگاه.'),
              SizedBox(height: spacing.m),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'خروجی CSV',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: spacing.s),
                  Expanded(
                    child: SecondaryButton(
                      label: 'انصراف',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomDateRangeSelector(BuildContext context, AnalyticsNotifier notifier) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('انتخاب بازه زمانی گزارش'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('امروز'),
                onTap: () {
                  notifier.selectTimeRangePreset(TimeRangePreset.today);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('دیروز'),
                onTap: () {
                  notifier.selectTimeRangePreset(TimeRangePreset.yesterday);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('هفته جاری'),
                onTap: () {
                  notifier.selectTimeRangePreset(TimeRangePreset.thisWeek);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ماه جاری'),
                onTap: () {
                  notifier.selectTimeRangePreset(TimeRangePreset.thisMonth);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('سال جاری'),
                onTap: () {
                  notifier.selectTimeRangePreset(TimeRangePreset.thisYear);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('کل تاریخچه'),
                onTap: () {
                  notifier.selectTimeRangePreset(TimeRangePreset.allTime);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardScrollWorkspace extends ConsumerWidget {
  const _DashboardScrollWorkspace({required this.data});

  final AnalyticsState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(analyticsViewModelProvider.notifier);

    final summary = data.summary;
    final formattedStart = DateFormatter.formatFriendly(data.timeRange.startDate);
    final formattedEnd = DateFormatter.formatFriendly(data.timeRange.endDate);

    return RefreshIndicator(
      onRefresh: notifier.loadAnalytics,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.m),
              child: BaseCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.s, vertical: spacing.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        label: 'دوره قبلی',
                        button: true,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: notifier.shiftBackward,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$formattedStart تا $formattedEnd',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'دوره بعدی',
                        button: true,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: notifier.shiftForward,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: spacing.m),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('همه حساب‌ها'),
                    selected: data.selectedBankFilter == 'All',
                    onSelected: (selected) {
                      if (selected) notifier.selectBankFilter('All');
                    },
                  ),
                  SizedBox(width: spacing.xs),
                  ChoiceChip(
                    label: const Text('ملی'),
                    selected: data.selectedBankFilter == 'ملی',
                    onSelected: (selected) {
                      notifier.selectBankFilter(selected ? 'ملی' : 'All');
                    },
                  ),
                  SizedBox(width: spacing.xs),
                  ChoiceChip(
                    label: const Text('ملت'),
                    selected: data.selectedBankFilter == 'ملت',
                    onSelected: (selected) {
                      notifier.selectBankFilter(selected ? 'ملت' : 'All');
                    },
                  ),
                  SizedBox(width: spacing.xs),
                  ChoiceChip(
                    label: const Text('تجارت'),
                    selected: data.selectedBankFilter == 'تجارت',
                    onSelected: (selected) {
                      notifier.selectBankFilter(selected ? 'تجارت' : 'All');
                    },
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(spacing.m),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: spacing.s,
                mainAxisSpacing: spacing.s,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildListDelegate([
                StatisticCard(
                  title: 'تراز خالص دوره',
                  value: CurrencyFormatter.formatToman(summary.netBalance),
                  trendLabel: summary.netBalance >= 0 ? 'مثبت' : 'منفی',
                  isPositiveTrend: summary.netBalance >= 0,
                ),
                StatisticCard(
                  title: 'مجموع دریافتی',
                  value: CurrencyFormatter.formatToman(summary.totalIncome),
                  trendLabel: 'ورودی',
                  isPositiveTrend: true,
                ),
                StatisticCard(
                  title: 'مجموع مخارج',
                  value: CurrencyFormatter.formatToman(summary.totalExpenses),
                  trendLabel: 'خروجی',
                  isPositiveTrend: false,
                ),
                StatisticCard(
                  title: 'تعداد تراکنش‌ها',
                  value: DateFormatter.toPersianDigits(summary.transactionCount.toString()),
                  trendLabel: 'تراکنش',
                  isPositiveTrend: true,
                ),
                StatisticCard(
                  title: 'میانگین تراکنش',
                  value: CurrencyFormatter.formatToman(summary.averageTransaction),
                  trendLabel: 'مبلغ واحد',
                  isPositiveTrend: true,
                ),
                StatisticCard(
                  title: 'بزرگترین هزینه',
                  value: CurrencyFormatter.formatToman(summary.largestExpense),
                  trendLabel: 'حداکثر خرج',
                  isPositiveTrend: false,
                ),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.m),
              child: BaseCard(
                child: Padding(
                  padding: EdgeInsets.all(spacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _ChartSegmentTab(
                              label: 'روند روزانه',
                              isActive: data.activeChartTabIndex == 0,
                              onTap: () => notifier.selectChartTab(0),
                            ),
                            SizedBox(width: spacing.xs),
                            _ChartSegmentTab(
                              label: 'روند هفتگی',
                              isActive: data.activeChartTabIndex == 1,
                              onTap: () => notifier.selectChartTab(1),
                            ),
                            SizedBox(width: spacing.xs),
                            _ChartSegmentTab(
                              label: 'روند ماهانه',
                              isActive: data.activeChartTabIndex == 2,
                              onTap: () => notifier.selectChartTab(2),
                            ),
                            SizedBox(width: spacing.xs),
                            _ChartSegmentTab(
                              label: 'سهم دسته‌بندی',
                              isActive: data.activeChartTabIndex == 3,
                              onTap: () => notifier.selectChartTab(3),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing.m),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _buildSelectedChart(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.m),
              child: const SectionHeader(
                title: 'بینش‌های مالی اخیر',
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: spacing.m),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final insight = summary.recentInsights[index];
                  final color = insight.isPositive ? Colors.green : Colors.red;
                  final icon = insight.isPositive ? Icons.lightbulb_outline : Icons.analytics_outlined;

                  return Padding(
                    padding: EdgeInsets.only(bottom: spacing.s),
                    child: BaseCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.1),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        title: Text(
                          insight.title,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: spacing.xxs),
                          child: Text(
                            insight.description,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                        trailing: Text(
                          CurrencyFormatter.formatToman(insight.value),
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
                childCount: summary.recentInsights.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: spacing.xl)),
        ],
      ),
    );
  }

  Widget _buildSelectedChart(BuildContext context) {
    switch (data.activeChartTabIndex) {
      case 0:
        return LineChart(
          key: const ValueKey('daily_line_chart'),
          points: data.summary.dailyTrends,
          height: 180,
        );
      case 1:
        return BarChart(
          key: const ValueKey('weekly_bar_chart'),
          points: data.summary.weeklyTrends,
          height: 180,
        );
      case 2:
        return BarChart(
          key: const ValueKey('monthly_bar_chart'),
          points: data.summary.monthlyTrends,
          height: 180,
        );
      case 3:
        return PieDonutChart(
          key: const ValueKey('category_pie_chart'),
          data: data.summary.categoryTotals,
          height: 120,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ChartSegmentTab extends StatelessWidget {
  const _ChartSegmentTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.xs),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _LoadingSkeletonWorkspace extends StatelessWidget {
  const _LoadingSkeletonWorkspace();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          children: [
            const SkeletonLoader(height: 56, width: double.infinity),
            SizedBox(height: spacing.m),
            Row(
              children: [
                Expanded(child: const SkeletonLoader(height: 100, width: double.infinity)),
                SizedBox(width: spacing.s),
                Expanded(child: const SkeletonLoader(height: 100, width: double.infinity)),
              ],
            ),
            SizedBox(height: spacing.s),
            Row(
              children: [
                Expanded(child: const SkeletonLoader(height: 100, width: double.infinity)),
                SizedBox(width: spacing.s),
                Expanded(child: const SkeletonLoader(height: 100, width: double.infinity)),
              ],
            ),
            SizedBox(height: spacing.m),
            const SkeletonLoader(height: 180, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
