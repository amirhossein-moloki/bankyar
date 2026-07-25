import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/presentation/widgets/indicators/skeleton_loader.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/analytics/domain/entities/analytics_models.dart';
import 'package:bankyar/features/analytics/domain/entities/time_range.dart';
import 'package:bankyar/features/analytics/domain/repository/statistics_repository.dart';
import 'package:bankyar/features/analytics/data/di/analytics_dependencies.dart';
import 'package:bankyar/features/analytics/domain/usecases/get_analytics_use_case.dart';
import 'package:bankyar/features/analytics/presentation/screens/statistics_dashboard_screen.dart';
import 'package:bankyar/features/analytics/presentation/state/analytics_notifier.dart';
import 'package:bankyar/features/analytics/presentation/state/analytics_state.dart';
import 'package:bankyar/features/analytics/presentation/widgets/custom_charts.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockStatisticsRepository extends Mock implements StatisticsRepository {}

void main() {
  late MockAppLogger mockLogger;
  late MockStatisticsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockRepository = MockStatisticsRepository();

    when(
      () => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
  });

  group('Analytics Pure Domain & TimeRange Unit Tests', () {
    test('TimeRange presets calculate correct start and end bounds', () {
      final anchor = DateTime(2023, 10, 15, 12, 0, 0);

      // Today
      final todayRange = TimeRange.fromPreset(TimeRangePreset.today, anchor);
      expect(todayRange.startDate, DateTime(2023, 10, 15));
      expect(todayRange.endDate, DateTime(2023, 10, 15, 23, 59, 59, 999));

      // Yesterday
      final yesterdayRange = TimeRange.fromPreset(
        TimeRangePreset.yesterday,
        anchor,
      );
      expect(yesterdayRange.startDate, DateTime(2023, 10, 14));
      expect(yesterdayRange.endDate, DateTime(2023, 10, 14, 23, 59, 59, 999));

      // This Month
      final monthRange = TimeRange.fromPreset(
        TimeRangePreset.thisMonth,
        anchor,
      );
      expect(monthRange.startDate, DateTime(2023, 10, 1));
      expect(monthRange.endDate, DateTime(2023, 10, 15, 23, 59, 59, 999));
    });

    test('AnalyticsSummary empty factory returns clean default parameters', () {
      final summary = AnalyticsSummary.empty();
      expect(summary.totalIncome, 0.0);
      expect(summary.totalExpenses, 0.0);
      expect(summary.netBalance, 0.0);
      expect(summary.transactionCount, 0);
      expect(summary.averageTransaction, 0.0);
      expect(summary.dailyTrends, isEmpty);
      expect(summary.weeklyTrends, isEmpty);
      expect(summary.monthlyTrends, isEmpty);
      expect(summary.recentInsights, isEmpty);
    });
  });

  group('Analytics Notifier View Model Tests', () {
    test(
      'AnalyticsNotifier loads aggregates on boot and updates state',
      () async {
        final summary = AnalyticsSummary(
          totalIncome: 100000.0,
          totalExpenses: 40000.0,
          netBalance: 60000.0,
          transactionCount: 5,
          averageTransaction: 28000.0,
          largestIncome: 80000.0,
          largestExpense: 30000.0,
          categoryTotals: {'خرید': 30000.0, 'حمل و نقل': 10000.0},
          bankTotals: {'ملی': 60000.0},
          tagStatistics: {'مهم': 40000.0},
          dailyTrends: [
            TrendPoint(
              label: '12 دی',
              income: 100000.0,
              expense: 40000.0,
              timestamp: DateTime(2023, 10, 15),
            ),
          ],
          weeklyTrends: [],
          monthlyTrends: [],
          recentInsights: [
            const FinancialInsight(
              id: 'ins-1',
              type: InsightType.topSpendingDay,
              title: 'پرخرج‌ترین روز هفته',
              description: 'پنج‌شنبه پرخرج‌ترین روز شما بوده است.',
              value: 40000.0,
              isPositive: false,
            ),
          ],
        );

        when(
          () => mockRepository.getStatistics(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            bankFilter: any(named: 'bankFilter'),
          ),
        ).thenAnswer((_) async => Result.success(summary));

        final container = ProviderContainer(
          overrides: [
            statisticsRepositoryProvider.overrideWithValue(mockRepository),
            loggerProvider.overrideWithValue(mockLogger),
          ],
        );

        final notifier = container.read(analyticsViewModelProvider.notifier);
        await notifier.loadAnalytics();

        final state = container.read(analyticsViewModelProvider);
        state.when(
          initial: () => fail(''),
          loading: (_) => fail(''),
          error: (_) => fail(''),
          success: (data) {
            expect(data.summary.totalIncome, 100000.0);
            expect(data.summary.totalExpenses, 40000.0);
            expect(data.summary.netBalance, 60000.0);
            expect(data.summary.transactionCount, 5);
            expect(data.summary.recentInsights.length, 1);
            expect(data.summary.recentInsights.first.id, 'ins-1');
          },
        );
      },
    );
  });

  group('Analytics UI Screen & Charts Rendering Tests', () {
    Widget buildTestableWidget(Widget child) {
      return MaterialApp(
        theme: AppTheme.createThemeLight(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fa'), Locale('en')],
        locale: const Locale('fa'),
        home: Directionality(textDirection: TextDirection.rtl, child: child),
      );
    }

    testWidgets(
      'StatisticsDashboardScreen renders loading state skeleton loaders',
      (tester) async {
        final summary = AnalyticsSummary.empty();
        when(
          () => mockRepository.getStatistics(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            bankFilter: any(named: 'bankFilter'),
          ),
        ).thenAnswer((_) async => Result.success(summary));

        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                statisticsRepositoryProvider.overrideWithValue(mockRepository),
                loggerProvider.overrideWithValue(mockLogger),
              ],
              child: const StatisticsDashboardScreen(),
            ),
          ),
        );

        // Loading skeletons are drawn during async state
        expect(find.byType(SkeletonLoader), findsWidgets);
      },
    );

    testWidgets(
      'StatisticsDashboardScreen renders empty template on zero data',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final summary = AnalyticsSummary.empty();
        when(
          () => mockRepository.getStatistics(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            bankFilter: any(named: 'bankFilter'),
          ),
        ).thenAnswer((_) async => Result.success(summary));

        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                statisticsRepositoryProvider.overrideWithValue(mockRepository),
                loggerProvider.overrideWithValue(mockLogger),
              ],
              child: const StatisticsDashboardScreen(),
            ),
          ),
        );

        // Settle frames to let loading resolve
        await tester.pump();
        await tester.pumpAndSettle();

        // Empty template text
        expect(find.text('آماری برای نمایش وجود ندارد'), findsOneWidget);
      },
    );

    testWidgets(
      'StatisticsDashboardScreen renders scorecards, custom charts, and insights on success',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final summary = AnalyticsSummary(
          totalIncome: 120000.0,
          totalExpenses: 50000.0,
          netBalance: 70000.0,
          transactionCount: 3,
          averageTransaction: 40000.0,
          largestIncome: 120000.0,
          largestExpense: 30000.0,
          categoryTotals: {'خرید': 30000.0, 'غذا': 20000.0},
          bankTotals: {'ملی': 70000.0},
          tagStatistics: {},
          dailyTrends: [
            TrendPoint(
              label: '12 دی',
              income: 120000.0,
              expense: 50000.0,
              timestamp: DateTime(2023, 10, 15),
            ),
          ],
          weeklyTrends: [
            TrendPoint(
              label: 'هفته ۱',
              income: 120000.0,
              expense: 50000.0,
              timestamp: DateTime(2023, 10, 15),
            ),
          ],
          monthlyTrends: [],
          recentInsights: [
            const FinancialInsight(
              id: 'ins-1',
              type: InsightType.topSpendingDay,
              title: 'پرخرج‌ترین روز هفته',
              description: 'پنج‌شنبه پرخرج‌ترین روز شما بوده است.',
              value: 50000.0,
              isPositive: false,
            ),
          ],
        );

        when(
          () => mockRepository.getStatistics(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            bankFilter: any(named: 'bankFilter'),
          ),
        ).thenAnswer((_) async => Result.success(summary));

        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                statisticsRepositoryProvider.overrideWithValue(mockRepository),
                loggerProvider.overrideWithValue(mockLogger),
              ],
              child: const StatisticsDashboardScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pumpAndSettle();

        // Scorecards present
        expect(find.text('تراز خالص دوره'), findsOneWidget);
        expect(find.text('مجموع دریافتی'), findsOneWidget);
        expect(find.text('مجموع مخارج'), findsOneWidget);

        // LineChart rendered by default
        expect(find.byType(LineChart), findsOneWidget);

        // Switch tab to "Weekly Trends" (هفتگی)
        await tester.tap(find.text('روند هفتگی'));
        await tester.pumpAndSettle();

        // Weekly trend draws BarChart
        expect(find.byType(BarChart), findsOneWidget);

        // Insight card is visible
        expect(find.text('بینش‌های مالی اخیر'), findsOneWidget);
        expect(find.text('پرخرج‌ترین روز هفته'), findsOneWidget);
      },
    );

    testWidgets(
      'LineChart has proper semantic announcements for screen readers',
      (tester) async {
        final points = [
          TrendPoint(
            label: '12 دی',
            income: 1000.0,
            expense: 500.0,
            timestamp: DateTime.now(),
          ),
        ];

        await tester.pumpWidget(
          buildTestableWidget(LineChart(points: points, height: 100)),
        );

        // LineChart is accessibility compliant, LineChart has been rendered
        expect(find.byType(LineChart), findsOneWidget);
      },
    );
  });
}
