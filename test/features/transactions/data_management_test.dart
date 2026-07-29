import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/features/secure_auth/presentation/screens/security_dashboard_screen.dart';
import 'package:bankyar/features/secure_auth/presentation/state/permission_notifier.dart';
import 'package:bankyar/features/transactions/presentation/screens/home_screen.dart';
import 'package:bankyar/features/transactions/presentation/state/data_management_notifier.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/home_state.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_state.dart';
import 'package:bankyar/features/notifications/domain/repository/notification_repository.dart';
import 'package:bankyar/features/notifications/data/di/notification_providers.dart';
import 'package:bankyar/features/notifications/domain/entities/notification_item.dart';
import 'package:bankyar/features/search/domain/repository/search_repository.dart';
import 'package:bankyar/features/search/data/di/search_dependencies.dart';
import 'package:bankyar/features/search/domain/entities/search_models.dart';
import 'package:bankyar/features/analytics/domain/repository/statistics_repository.dart';
import 'package:bankyar/features/analytics/data/di/analytics_dependencies.dart';
import 'package:bankyar/features/analytics/domain/entities/analytics_models.dart';
import 'package:bankyar/features/analytics/domain/entities/time_range.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/state_management/base_providers.dart';
import 'package:bankyar/features/notifications/presentation/state/notification_state.dart';
import 'package:bankyar/features/notifications/presentation/state/notification_notifier.dart';
import 'package:bankyar/features/search/presentation/state/search_state.dart';
import 'package:bankyar/features/search/presentation/state/search_notifier.dart';
import 'package:bankyar/features/analytics/presentation/state/analytics_state.dart';
import 'package:bankyar/features/analytics/presentation/state/analytics_notifier.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/uuid.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/platform/sms_receiver_service.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';

// Fake Permission Service
class FakePermissionService implements PermissionService {
  final Map<AppPermission, PermissionStatus> _statuses = {
    AppPermission.smsRead: PermissionStatus.granted,
    AppPermission.smsReceive: PermissionStatus.granted,
    AppPermission.notifications: PermissionStatus.granted,
    AppPermission.batteryExclusion: PermissionStatus.granted,
    AppPermission.localFiles: PermissionStatus.granted,
    AppPermission.biometrics: PermissionStatus.granted,
    AppPermission.foregroundService: PermissionStatus.granted,
    AppPermission.autoStart: PermissionStatus.granted,
    AppPermission.exactAlarm: PermissionStatus.granted,
  };
  final _controller =
      StreamController<Map<AppPermission, PermissionStatus>>.broadcast();

  void setMockStatus(AppPermission perm, PermissionStatus status) {
    _statuses[perm] = status;
    _controller.add(Map.unmodifiable(_statuses));
  }

  @override
  Future<PermissionStatus> checkStatus(AppPermission permission) async {
    return _statuses[permission] ?? PermissionStatus.denied;
  }

  @override
  Future<PermissionStatus> request(AppPermission permission) async {
    final status = _statuses[permission] ?? PermissionStatus.granted;
    _statuses[permission] = status;
    _controller.add(Map.unmodifiable(_statuses));
    return status;
  }

  @override
  Stream<Map<AppPermission, PermissionStatus>> get onStatusesChanged =>
      _controller.stream;

  @override
  Future<void> openSettings() async {}

  void dispose() {
    _controller.close();
  }
}

// Subclassed Fakes for StateNotifiers to completely avoid mocktail getState() != null exception
class FakeHomeNotifier extends BaseUiNotifier<HomeState>
    implements HomeNotifier {
  FakeHomeNotifier() {
    state = UiState.success(HomeState.empty());
  }

  @override
  Future<void> refresh() async {}

  @override
  void selectBankFilter(String bankFilter) {}

  @override
  void toggleVisibility() {}
}

class FakeSearchNotifier extends BaseUiNotifier<SearchState>
    implements SearchNotifier {
  FakeSearchNotifier() {
    state = UiState.success(SearchState.initial());
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> loadHistory() async {}

  @override
  Future<void> saveToHistory(String queryText) async {}

  @override
  Future<void> clearHistory() async {}

  @override
  void updateQueryText(String text) {}

  @override
  void updateFilters(SearchFilters filters) {}

  @override
  void resetFilters() {}

  @override
  void updateSort(SearchSort sort) {}

  @override
  Future<void> executeSearch() async {}
}

class FakeNotificationNotifier extends BaseUiNotifier<NotificationState>
    implements NotificationNotifier {
  FakeNotificationNotifier() {
    state = UiState.success(NotificationState.initial());
  }

  @override
  Future<void> refresh() async {}

  @override
  void setSearchQuery(String query) {}

  @override
  void setCategoryFilter(String category) {}

  @override
  void setTimelineFilter(String filter) {}

  @override
  void toggleSelection(String id) {}

  @override
  void clearSelection() {}

  @override
  Future<void> markAsRead(String id) async {}

  @override
  Future<void> markAllAsRead() async {}

  @override
  Future<void> insertNotification(NotificationItem notification) async {}

  @override
  Future<void> deleteNotification(String id) async {}

  @override
  Future<void> deleteSelected() async {}

  @override
  Future<void> clearAll() async {}

  @override
  Future<void> saveNote(String id, String noteText) async {}

  @override
  Future<void> deleteNote(String id) async {}

  @override
  Future<void> simulateIncomingNotification() async {}
}

class FakeAnalyticsNotifier extends BaseUiNotifier<AnalyticsState>
    implements AnalyticsNotifier {
  FakeAnalyticsNotifier() {
    state = UiState.success(AnalyticsState.initial());
  }

  @override
  Future<void> loadAnalytics() async {}

  @override
  void selectTimeRangePreset(TimeRangePreset preset) {}

  @override
  void shiftForward() {}

  @override
  void shiftBackward() {}

  @override
  void selectBankFilter(String bankFilter) {}

  @override
  void selectChartTab(int index) {}
}

class FakeTransactionsNotifier extends BaseUiNotifier<TransactionsState>
    implements TransactionsNotifier {
  FakeTransactionsNotifier() {
    state = UiState.success(TransactionsState.initial());
  }

  @override
  Future<void> loadInitial({bool isRefreshing = false}) async {}

  @override
  Future<void> loadNextPage() async {}

  @override
  void toggleSelection(String id) {}

  @override
  void selectAll() {}

  @override
  void clearSelection() {}

  @override
  Future<void> batchDelete() async {}

  @override
  Future<void> batchAssignCategory(String? categoryId) async {}

  @override
  Future<void> refresh() async {}

  @override
  void setSearchQuery(String query) {}

  @override
  void setBankFilter(String bank) {}

  @override
  void setCategoryFilter(String? categoryId) {}

  @override
  void setTypeFilter(String type) {}

  @override
  void setSortBy(String field, bool descending) {}

  @override
  void setGroupBy(String group) {}
}

class MockAppLogger extends Mock implements AppLogger {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

class MockBatch extends Mock implements Batch {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockSmsReceiverService extends Mock implements SmsReceiverService {}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockTransaction mockTxn;
  late FakePermissionService fakePermissionService;
  late MockBatch mockBatch;
  late MockTransactionRepository mockTxRepository;
  late MockSmsHistoryImporter mockImporter;
  late MockSmsReceiverService mockReceiver;

  late FakeSearchNotifier fakeSearchNotifier;
  late FakeNotificationNotifier fakeNotificationNotifier;
  late FakeAnalyticsNotifier fakeAnalyticsNotifier;
  late FakeHomeNotifier fakeHomeNotifier;
  late FakeTransactionsNotifier fakeTransactionsNotifier;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(AppPermission.smsRead);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockPrefs = MockPreferencesStorage();
    mockDbService = MockDatabaseServiceImpl();
    mockDb = MockDatabase();
    mockTxn = MockTransaction();
    fakePermissionService = FakePermissionService();
    mockBatch = MockBatch();
    mockTxRepository = MockTransactionRepository();
    mockImporter = MockSmsHistoryImporter();
    mockReceiver = MockSmsReceiverService();

    fakeSearchNotifier = FakeSearchNotifier();
    fakeNotificationNotifier = FakeNotificationNotifier();
    fakeAnalyticsNotifier = FakeAnalyticsNotifier();
    fakeHomeNotifier = FakeHomeNotifier();
    fakeTransactionsNotifier = FakeTransactionsNotifier();

    when(() => mockDbService.database).thenReturn(mockDb);
    when(() => mockDbService.isOpen).thenReturn(true);

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

    // Synchronous preferences mocks
    when(
      () => mockPrefs.getBool(any()),
    ).thenAnswer((_) => SynchronousFuture(false));
    when(
      () => mockPrefs.getBool('by_onboarding_completed'),
    ).thenAnswer((_) => SynchronousFuture(true));
    when(
      () => mockPrefs.getString(any()),
    ).thenAnswer((_) => SynchronousFuture(null));
    when(
      () => mockPrefs.setBool(any(), any()),
    ).thenAnswer((_) => SynchronousFuture(null));
    when(
      () => mockPrefs.setString(any(), any()),
    ).thenAnswer((_) => SynchronousFuture(null));

    // Platform engine mocks
    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) => SynchronousFuture(0));
    when(
      () => mockReceiver.startListening(),
    ).thenAnswer((_) => SynchronousFuture(null));

    // Transaction Repository Mocking
    when(
      () => mockTxRepository.getTransactionsPaged(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        bankFilter: any(named: 'bankFilter'),
        categoryId: any(named: 'categoryId'),
        typeFilter: any(named: 'typeFilter'),
        searchQuery: any(named: 'searchQuery'),
        sortBy: any(named: 'sortBy'),
        descending: any(named: 'descending'),
      ),
    ).thenAnswer((_) => SynchronousFuture(const Result.success([])));
    when(
      () => mockTxRepository.getCategories(),
    ).thenAnswer((_) => SynchronousFuture(const Result.success([])));
    when(
      () => mockTxRepository.getTransactions(),
    ).thenAnswer((_) => SynchronousFuture(const Result.success([])));
    when(
      () => mockTxRepository.watchTransactions(),
    ).thenAnswer((_) => const Stream.empty());

    // Method Channel mocking globally
    const channel = MethodChannel('com.bankyar.app/platform');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'queryHistoricalSms') {
            return <dynamic>[];
          }
          return null;
        });
  });

  Widget buildTestableWidget(Widget child, ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.createThemeLight(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fa'), Locale('en')],
        locale: const Locale('fa'),
        home: Scaffold(
          body: Directionality(textDirection: TextDirection.rtl, child: child),
        ),
      ),
    );
  }

  group('DataManagementNotifier Ingestion & Deletion Unit Tests', () {
    test(
      'startHistoricalImport correctly manages scanning state and handles empty rawMessages',
      () async {
        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            searchViewModelProvider.overrideWith((ref) => fakeSearchNotifier),
            notificationNotifierProvider.overrideWith(
              (ref) => fakeNotificationNotifier,
            ),
            analyticsViewModelProvider.overrideWith(
              (ref) => fakeAnalyticsNotifier,
            ),
            homeViewModelProvider.overrideWith((ref) => fakeHomeNotifier),
            transactionsViewModelProvider.overrideWith(
              (ref) => fakeTransactionsNotifier,
            ),
          ],
        );

        final notifier = container.read(
          dataManagementNotifierProvider.notifier,
        );

        expect(
          container.read(dataManagementNotifierProvider).isImporting,
          isFalse,
        );

        final importFuture = notifier.startHistoricalImport(
          range: ImportRange.all,
        );
        expect(
          container.read(dataManagementNotifierProvider).isImporting,
          isTrue,
        );

        await importFuture;

        final state = container.read(dataManagementNotifierProvider);
        expect(state.isImporting, isFalse);
        expect(state.successMessage, 'هیچ پیامکی برای وارد کردن یافت نشد.');
      },
    );

    test(
      'startHistoricalImport processes messages, checks duplicates, and executes batch database commits',
      () async {
        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            searchViewModelProvider.overrideWith((ref) => fakeSearchNotifier),
            notificationNotifierProvider.overrideWith(
              (ref) => fakeNotificationNotifier,
            ),
            analyticsViewModelProvider.overrideWith(
              (ref) => fakeAnalyticsNotifier,
            ),
            homeViewModelProvider.overrideWith((ref) => fakeHomeNotifier),
            transactionsViewModelProvider.overrideWith(
              (ref) => fakeTransactionsNotifier,
            ),
          ],
        );

        final notifier = container.read(
          dataManagementNotifierProvider.notifier,
        );

        const channel = MethodChannel('com.bankyar.app/platform');
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'queryHistoricalSms') {
                return <dynamic>[
                  {
                    'id': 'sms-1',
                    'sender': 'Melli',
                    'body': 'بانک ملی\nواریز مبلغ ۱۰,۰۰۰ ریال\nبه حساب *۱۲۳۴',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                ];
              }
              return null;
            });

        // Mock database queries
        when(
          () => mockDb.query(
            'bank_messages',
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => []);

        when(() => mockDb.rawQuery(any(), any())).thenAnswer((_) async => []);

        when(() => mockDb.transaction<Null>(any())).thenAnswer((inv) async {
          final Function transactionCallback =
              inv.positionalArguments[0] as Function;
          await transactionCallback(mockTxn);
          return null;
        });

        when(() => mockTxn.batch()).thenReturn(mockBatch);
        when(
          () => mockBatch.commit(noResult: any(named: 'noResult')),
        ).thenAnswer((_) async => []);

        await notifier.startHistoricalImport(range: ImportRange.all);

        final state = container.read(dataManagementNotifierProvider);
        expect(state.isImporting, isFalse);
        expect(state.importedCount, equals(1));
        expect(state.successfulParsedCount, equals(1));
        expect(
          state.successMessage,
          contains('وارد کردن پیامک‌های قبلی به پایان رسید.'),
        );

        // Verify batch insert call
        verify(
          () => mockBatch.insert(
            'bank_messages',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).called(1);
        verify(
          () => mockBatch.insert(
            'transactions',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).called(1);
        verify(() => mockBatch.commit(noResult: true)).called(1);
      },
    );

    test(
      'startHistoricalImport handles selection range options and filters correct bounds',
      () async {
        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            searchViewModelProvider.overrideWith((ref) => fakeSearchNotifier),
            notificationNotifierProvider.overrideWith(
              (ref) => fakeNotificationNotifier,
            ),
            analyticsViewModelProvider.overrideWith(
              (ref) => fakeAnalyticsNotifier,
            ),
            homeViewModelProvider.overrideWith((ref) => fakeHomeNotifier),
            transactionsViewModelProvider.overrideWith(
              (ref) => fakeTransactionsNotifier,
            ),
          ],
        );

        final notifier = container.read(
          dataManagementNotifierProvider.notifier,
        );

        int capturedSinceTimestamp = -1;
        const channel = MethodChannel('com.bankyar.app/platform');
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
              if (call.method == 'queryHistoricalSms') {
                capturedSinceTimestamp = call.arguments['since'] as int;
                return <dynamic>[];
              }
              return null;
            });

        await notifier.startHistoricalImport(range: ImportRange.last3Months);

        expect(capturedSinceTimestamp, greaterThan(0));
        final threeMonthsAgo = DateTime.now()
            .subtract(const Duration(days: 90))
            .millisecondsSinceEpoch;
        expect((capturedSinceTimestamp - threeMonthsAgo).abs(), lessThan(5000));
      },
    );

    test(
      'Bulk delete operations execute atomically and return success',
      () async {
        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            searchViewModelProvider.overrideWith((ref) => fakeSearchNotifier),
            notificationNotifierProvider.overrideWith(
              (ref) => fakeNotificationNotifier,
            ),
            analyticsViewModelProvider.overrideWith(
              (ref) => fakeAnalyticsNotifier,
            ),
            homeViewModelProvider.overrideWith((ref) => fakeHomeNotifier),
            transactionsViewModelProvider.overrideWith(
              (ref) => fakeTransactionsNotifier,
            ),
          ],
        );

        final notifier = container.read(
          dataManagementNotifierProvider.notifier,
        );

        when(() => mockDb.transaction<Null>(any())).thenAnswer((inv) async {
          final Function callback = inv.positionalArguments[0] as Function;
          await callback(mockTxn);
          return null;
        });

        when(
          () => mockTxn.delete(
            any(),
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
          ),
        ).thenAnswer((_) async => 1);
        when(
          () => mockDbService.wipeLocalSandboxData(),
        ).thenAnswer((_) async => const Success<void>(null));

        final delSms = await notifier.deleteImportedSms();
        expect(delSms, isTrue);
        verify(() => mockTxn.delete('bank_messages')).called(1);

        final delTx = await notifier.deleteAllTransactions();
        expect(delTx, isTrue);
        verify(() => mockTxn.delete('transactions')).called(1);
        verify(() => mockTxn.delete('fts_transactions_search')).called(1);

        final delNotif = await notifier.deleteAllNotifications();
        expect(delNotif, isTrue);
        verify(() => mockTxn.delete('notifications')).called(1);

        final delNotes = await notifier.deleteAllNotes();
        expect(delNotes, isTrue);
        verify(() => mockTxn.delete('notes')).called(1);

        final delDb = await notifier.deleteLocalDatabase();
        expect(delDb, isTrue);
        verify(() => mockDbService.wipeLocalSandboxData()).called(1);
      },
    );
  });

  group('HomeScreen & SecurityDashboardScreen Integration Widget Tests', () {
    testWidgets(
      'HomeScreen triggers historical SMS prompt when SMS read permission is granted',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            smsReceiverServiceProvider.overrideWithValue(mockReceiver),
            searchViewModelProvider.overrideWith((ref) => fakeSearchNotifier),
            notificationNotifierProvider.overrideWith(
              (ref) => fakeNotificationNotifier,
            ),
            analyticsViewModelProvider.overrideWith(
              (ref) => fakeAnalyticsNotifier,
            ),
            homeViewModelProvider.overrideWith((ref) => fakeHomeNotifier),
            transactionsViewModelProvider.overrideWith(
              (ref) => fakeTransactionsNotifier,
            ),
          ],
        );

        // Setup initial state: SMS read is granted, not previously offered
        when(
          () => mockPrefs.getBool('by_historical_sms_import_offered'),
        ).thenAnswer((_) => SynchronousFuture(false));

        await tester.pumpWidget(
          buildTestableWidget(const HomeScreen(), container),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify one-time import prompt appears
        expect(find.text('وارد کردن پیامک‌های قبلی'), findsOneWidget);
        expect(
          find.text(
            'بانک‌یار می‌تواند پیامک‌های بانکی قبلی شما را نیز بررسی و وارد کند.',
          ),
          findsOneWidget,
        );
        expect(find.text('بعداً'), findsOneWidget);
        expect(find.text('شروع اسکن'), findsOneWidget);

        // Tap 'شروع اسکن' to view Range Selection options
        await tester.tap(find.text('شروع اسکن'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('بازه زمانی اسکن را انتخاب کنید'), findsOneWidget);
        expect(find.text('کل پیامک‌ها'), findsOneWidget);
        expect(find.text('۳ ماه اخیر'), findsOneWidget);

        // Tap 'کل پیامک‌ها' to dismiss and start scanning
        await tester.tap(find.text('کل پیامک‌ها'));
        await tester.pumpAndSettle();

        expect(find.text('بازه زمانی اسکن را انتخاب کنید'), findsNothing);
      },
    );

    testWidgets(
      'SecurityDashboardScreen renders Data Management card and prompts destructive warning',
      (tester) async {
        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            smsReceiverServiceProvider.overrideWithValue(mockReceiver),
            searchViewModelProvider.overrideWith((ref) => fakeSearchNotifier),
            notificationNotifierProvider.overrideWith(
              (ref) => fakeNotificationNotifier,
            ),
            analyticsViewModelProvider.overrideWith(
              (ref) => fakeAnalyticsNotifier,
            ),
            homeViewModelProvider.overrideWith((ref) => fakeHomeNotifier),
            transactionsViewModelProvider.overrideWith(
              (ref) => fakeTransactionsNotifier,
            ),
          ],
        );

        await tester.pumpWidget(
          buildTestableWidget(const SecurityDashboardScreen(), container),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Scroll to view Data Management
        final tileFinder = find.text('حذف تمامی تراکنش‌ها');
        await tester.ensureVisible(tileFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify tiles are rendered
        expect(find.text('مدیریت داده‌ها (Data Management)'), findsOneWidget);
        expect(find.text('حذف پیامک‌های بانکی'), findsOneWidget);
        expect(find.text('حذف تمامی تراکنش‌ها'), findsOneWidget);
        expect(find.text('حذف کامل پایگاه داده محلی'), findsOneWidget);

        // Tap 'حذف تمامی تراکنش‌ها'
        await tester.tap(find.text('حذف تمامی تراکنش‌ها'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify destructive confirmation dialog matches specification
        expect(find.text('تمام اطلاعات حذف خواهند شد.'), findsOneWidget);
        expect(find.text('لغو'), findsOneWidget);
        expect(find.text('حذف همه'), findsOneWidget);

        // Cancel out and let transitions finish
        await tester.tap(find.text('لغو'));
        await tester.pumpAndSettle();
        expect(find.text('تمام اطلاعات حذف خواهند شد.'), findsNothing);
      },
    );
  });
}
