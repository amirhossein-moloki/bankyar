import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/navigation/router.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/usecases/get_transactions_use_case.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/analytics/domain/repository/statistics_repository.dart';
import 'package:bankyar/features/analytics/data/di/analytics_dependencies.dart';
import 'package:bankyar/features/analytics/domain/entities/analytics_models.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/core/theme/app_theme.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

class MockStatisticsRepository extends Mock implements StatisticsRepository {}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;
  late MockStatisticsRepository mockStatsRepository;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDbService = MockDatabaseServiceImpl();
    mockPrefs = MockPreferencesStorage();
    mockImporter = MockSmsHistoryImporter();
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();
    mockStatsRepository = MockStatisticsRepository();

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

    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(
      () => mockPrefs.getBool('by_onboarding_completed'),
    ).thenAnswer((_) async => true);
    when(
      () => mockPrefs.getString('by_username'),
    ).thenAnswer((_) async => 'سهراب');
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async {});

    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) async => 0);

    when(() => mockGetTransactionsUseCase(any())).thenAnswer(
      (_) => Stream.value(const Result.success(<ParsedTransaction>[])),
    );

    final emptySummary = AnalyticsSummary.empty();
    when(
      () => mockStatsRepository.getStatistics(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        bankFilter: any(named: 'bankFilter'),
      ),
    ).thenAnswer((_) async => Result.success(emptySummary));
  });

  testWidgets(
    'GoRouter registers /analytics and can navigate from HomeScreen',
    (tester) async {
      // Force reset location to avoid stale router state from other tests
      try {
        AppRouter.router.go('/');
      } catch (_) {}

      tester.view.physicalSize = const Size(1200, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Override the providers
      final container = ProviderScope(
        overrides: [
          databaseServiceProvider.overrideWithValue(mockDbService),
          preferencesStorageProvider.overrideWithValue(mockPrefs),
          loggerProvider.overrideWithValue(mockLogger),
          smsHistoryImporterProvider.overrideWithValue(mockImporter),
          getTransactionsUseCaseProvider.overrideWithValue(
            mockGetTransactionsUseCase,
          ),
          statisticsRepositoryProvider.overrideWithValue(mockStatsRepository),
          databaseBootstrapProvider.overrideWith(
            (ref) => const Result.success(null),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.createThemeLight(),
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fa'), Locale('en')],
          locale: const Locale('fa'),
        ),
      );

      await tester.pumpWidget(container);
      await tester.pumpAndSettle();

      // Verify we are on HomeScreen
      expect(find.text('بانک‌یار'), findsOneWidget);

      // Verify analytics icon button is displayed in appBar
      final analyticsIcon = find.byIcon(Icons.analytics_outlined);
      expect(analyticsIcon, findsOneWidget);

      // Tap on analytics icon
      await tester.tap(analyticsIcon);
      await tester.pumpAndSettle();

      // Verify we are now on StatisticsDashboardScreen
      expect(find.text('آموزش و آمار مالی'), findsOneWidget);
    },
  );

  test(
    'AppRouter contains registered declarative security sub-routes statically',
    () {
      final router = AppRouter.router;
      final routes = router.configuration.routes;

      // Find security route
      final securityRoute =
          routes.firstWhere((r) => r is GoRoute && r.path == '/security')
              as GoRoute;
      expect(securityRoute.routes.length, 4);

      final paths = securityRoute.routes
          .map((r) => (r as GoRoute).path)
          .toList();
      expect(paths, contains('create-pin'));
      expect(paths, contains('change-pin'));
      expect(paths, contains('permissions'));
      expect(paths, contains('confirm-pin/:proposedPin'));
    },
  );
}
