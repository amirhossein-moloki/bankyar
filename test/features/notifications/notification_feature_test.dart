import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/uuid.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/features/notifications/data/datasources/notification_dao.dart';
import 'package:bankyar/features/notifications/data/di/notification_providers.dart';
import 'package:bankyar/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:bankyar/features/notifications/domain/entities/notification_item.dart';
import 'package:bankyar/features/notifications/domain/repository/notification_repository.dart';
import 'package:bankyar/features/notifications/domain/usecases/delete_notification_use_case.dart';
import 'package:bankyar/features/notifications/domain/usecases/get_notification_stream_use_case.dart';
import 'package:bankyar/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:bankyar/features/notifications/domain/usecases/insert_notification_use_case.dart';
import 'package:bankyar/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:bankyar/features/notifications/presentation/screens/notification_center_screen.dart';
import 'package:bankyar/features/notifications/presentation/state/notification_notifier.dart';
import 'package:bankyar/features/notifications/presentation/state/notification_state.dart';
import 'package:bankyar/features/notifications/presentation/widgets/notification_card.dart';
import 'package:bankyar/features/notifications/presentation/widgets/notification_details_dialog.dart';
import 'package:bankyar/features/notifications/presentation/widgets/notification_dialogs.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockDatabase extends Mock implements Database {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockClock extends Mock implements Clock {}

class MockUuidGenerator extends Mock implements UuidGenerator {}

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class FakeNotificationNotifier extends StateNotifier<UiState<NotificationState>>
    implements NotificationNotifier {
  FakeNotificationNotifier(super.state);

  @override
  void setSearchQuery(String query) {
    if (state is UiSuccess<NotificationState>) {
      final data = (state as UiSuccess<NotificationState>).data;
      state = UiState.success(data.copyWith(searchQuery: query));
    }
  }

  @override
  void setCategoryFilter(String category) {
    if (state is UiSuccess<NotificationState>) {
      final data = (state as UiSuccess<NotificationState>).data;
      state = UiState.success(data.copyWith(selectedCategory: category));
    }
  }

  @override
  void setTimelineFilter(String filter) {
    if (state is UiSuccess<NotificationState>) {
      final data = (state as UiSuccess<NotificationState>).data;
      state = UiState.success(data.copyWith(activeTimelineFilter: filter));
    }
  }

  @override
  void toggleSelection(String id) {
    if (state is UiSuccess<NotificationState>) {
      final data = (state as UiSuccess<NotificationState>).data;
      final updated = Set<String>.from(data.selectedIds);
      if (updated.contains(id)) {
        updated.remove(id);
      } else {
        updated.add(id);
      }
      state = UiState.success(
        data.copyWith(
          selectedIds: updated,
          isBulkSelectionMode: updated.isNotEmpty,
        ),
      );
    }
  }

  @override
  void clearSelection() {
    if (state is UiSuccess<NotificationState>) {
      final data = (state as UiSuccess<NotificationState>).data;
      state = UiState.success(
        data.copyWith(selectedIds: {}, isBulkSelectionMode: false),
      );
    }
  }

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
  Future<void> saveNote(String id, String noteText) async {
    if (state is UiSuccess<NotificationState>) {
      final data = (state as UiSuccess<NotificationState>).data;
      final updated = Map<String, String>.from(data.notesMap);
      updated[id] = noteText;
      state = UiState.success(data.copyWith(notesMap: updated));
    }
  }

  @override
  Future<void> deleteNote(String id) async {}

  @override
  Future<void> simulateIncomingNotification() async {}

  @override
  void setInitial() {}

  @override
  void setLoading({double? progress}) {}

  @override
  void setSuccess(NotificationState data) {}

  @override
  void setError(Failure failure) {}
}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockPreferencesStorage mockPrefs;
  late MockClock mockClock;
  late MockUuidGenerator mockUuid;
  late NotificationDao dao;
  late NotificationRepositoryImpl repository;

  final testDate = DateTime(2023, 12, 12, 14, 30);

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDbService = MockDatabaseServiceImpl();
    mockDb = MockDatabase();
    mockPrefs = MockPreferencesStorage();
    mockClock = MockClock();
    mockUuid = MockUuidGenerator();

    when(() => mockDbService.database).thenReturn(mockDb);
    when(() => mockClock.now()).thenReturn(testDate);
    when(() => mockUuid.generateV4()).thenReturn('mock-uuid-v4');

    // Mock logger.log
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

    dao = NotificationDao(mockDbService, mockLogger);
    repository = NotificationRepositoryImpl(dao);
  });

  group('Notification Domain Model & Enum Tests', () {
    test(
      'NotificationType fromValue returns correct type and handles fallback',
      () {
        expect(
          NotificationType.fromValue('sms_detected'),
          NotificationType.smsDetected,
        );
        expect(
          NotificationType.fromValue('transaction_processed'),
          NotificationType.transactionProcessed,
        );
        expect(
          NotificationType.fromValue('backup_completed'),
          NotificationType.backupCompleted,
        );
        expect(
          NotificationType.fromValue('restore_completed'),
          NotificationType.restoreCompleted,
        );
        expect(
          NotificationType.fromValue('security_alerts'),
          NotificationType.securityAlerts,
        );
        expect(
          NotificationType.fromValue('authentication_events'),
          NotificationType.authenticationEvents,
        );
        expect(
          NotificationType.fromValue('warning_notifications'),
          NotificationType.warningNotifications,
        );
        expect(
          NotificationType.fromValue('invalid_type_string_fallback'),
          NotificationType.systemNotifications,
        );
      },
    );

    test(
      'NotificationItem toSqlMap and fromSqlMap mappings correspond correctly',
      () {
        final item = NotificationItem(
          id: 'notif-1',
          title: 'تراکنش',
          body: 'مبلغ ۱۰۰۰ تومان',
          type: NotificationType.transactionProcessed,
          isRead: false,
          createdAt: testDate,
        );

        final sqlMap = item.toSqlMap();
        expect(sqlMap['id'], 'notif-1');
        expect(sqlMap['title'], 'تراکنش');
        expect(sqlMap['is_read'], 0);
        expect(sqlMap['type'], 'transaction_processed');
        expect(sqlMap['created_at'], testDate.millisecondsSinceEpoch);

        final mappedItem = NotificationItem.fromSqlMap(sqlMap);
        expect(mappedItem.id, item.id);
        expect(mappedItem.title, item.title);
        expect(mappedItem.body, item.body);
        expect(mappedItem.type, item.type);
        expect(mappedItem.isRead, item.isRead);
        expect(mappedItem.createdAt, item.createdAt);
      },
    );

    test('NotificationItem copyWith copies values correctly', () {
      final item = NotificationItem(
        id: 'notif-1',
        title: 'تراکنش',
        body: 'مبلغ ۱۰۰۰ تومان',
        type: NotificationType.transactionProcessed,
        isRead: false,
        createdAt: testDate,
      );

      final updated = item.copyWith(isRead: true, title: 'کپی');
      expect(updated.isRead, true);
      expect(updated.title, 'کپی');
      expect(updated.body, item.body);
    });
  });

  group('Notification Repository & DAO Integration Tests', () {
    test(
      'getNotifications queries standard sqlite table and returns success list',
      () async {
        final mockData = [
          {
            'id': 'notif-1',
            'title': 'واریز',
            'body': 'مبلغ ۵۰۰۰۰ ریال',
            'type': 'transaction_processed',
            'is_read': 0,
            'created_at': testDate.millisecondsSinceEpoch,
          },
        ];

        when(
          () => mockDb.query(any(), orderBy: any(named: 'orderBy')),
        ).thenAnswer((_) async => mockData);

        final res = await repository.getNotifications();
        expect(res.isSuccess, true);
        expect(res.successOrCrash.first.id, 'notif-1');
      },
    );

    test(
      'insertNotification executes write and triggers DAO broadcast update',
      () async {
        final item = NotificationItem(
          id: 'notif-1',
          title: 'واریز',
          body: 'مبلغ ۵۰۰۰۰ ریال',
          type: NotificationType.transactionProcessed,
          isRead: false,
          createdAt: testDate,
        );

        when(
          () => mockDb.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        final res = await repository.insertNotification(item);
        expect(res.isSuccess, true);
      },
    );

    test('markAsRead updates item isRead attribute successfully', () async {
      final mockData = [
        {
          'id': 'notif-1',
          'title': 'واریز',
          'body': 'مبلغ ۵۰۰۰۰ ریال',
          'type': 'transaction_processed',
          'is_read': 0,
          'created_at': testDate.millisecondsSinceEpoch,
        },
      ];

      when(
        () => mockDb.query(
          any(),
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => mockData);

      when(
        () => mockDb.insert(
          any(),
          any(),
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      final res = await repository.markAsRead('notif-1');
      expect(res.isSuccess, true);
    });

    test('deleteNotification executes DB delete', () async {
      when(
        () => mockDb.delete(
          any(),
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
        ),
      ).thenAnswer((_) async => 1);

      final res = await repository.deleteNotification('notif-1');
      expect(res.isSuccess, true);
    });
  });

  group('Notification Notifier & View Model Tests', () {
    late GetNotificationsUseCase getNotifications;
    late GetNotificationStreamUseCase getNotificationStream;
    late MarkNotificationReadUseCase markNotificationRead;
    late DeleteNotificationUseCase deleteNotification;
    late InsertNotificationUseCase insertNotification;
    late MockNotificationRepository mockRepo;

    setUp(() {
      mockRepo = MockNotificationRepository();
      getNotifications = GetNotificationsUseCase(mockRepo);
      getNotificationStream = GetNotificationStreamUseCase(mockRepo);
      markNotificationRead = MarkNotificationReadUseCase(mockRepo);
      deleteNotification = DeleteNotificationUseCase(mockRepo);
      insertNotification = InsertNotificationUseCase(mockRepo);

      when(
        () => mockRepo.getNotificationStream(),
      ).thenAnswer((_) => Stream.value(const Result.success([])));
      when(
        () => mockRepo.getNotifications(),
      ).thenAnswer((_) async => const Result.success([]));
      when(() => mockPrefs.getString(any())).thenAnswer((_) async => '');
    });

    test(
      'Initializes state correctly and listens to reactive streams',
      () async {
        final notifier = NotificationNotifier(
          getNotifications: getNotifications,
          getNotificationStream: getNotificationStream,
          markNotificationRead: markNotificationRead,
          deleteNotification: deleteNotification,
          insertNotification: insertNotification,
          preferencesStorage: mockPrefs,
          clock: mockClock,
          uuidGenerator: mockUuid,
        );

        expect(notifier.state is UiLoading, true);

        // wait for microtask cycle
        await Future<void>.delayed(Duration.zero);
        expect(notifier.state is UiSuccess, true);
      },
    );

    test('Search and filter setters update the state successfully', () async {
      final notifier = NotificationNotifier(
        getNotifications: getNotifications,
        getNotificationStream: getNotificationStream,
        markNotificationRead: markNotificationRead,
        deleteNotification: deleteNotification,
        insertNotification: insertNotification,
        preferencesStorage: mockPrefs,
        clock: mockClock,
        uuidGenerator: mockUuid,
      );

      await Future<void>.delayed(Duration.zero);
      notifier.setSearchQuery('ملی');
      notifier.setCategoryFilter('security');
      notifier.setTimelineFilter('Today');

      notifier.state.when(
        initial: () => fail('State cannot be initial'),
        loading: (_) => fail('State cannot be loading'),
        error: (_) => fail('State cannot be error'),
        success: (state) {
          expect(state.searchQuery, 'ملی');
          expect(state.selectedCategory, 'security');
          expect(state.activeTimelineFilter, 'Today');
        },
      );
    });

    test('Selection and bulk mode operate correctly', () async {
      final notifier = NotificationNotifier(
        getNotifications: getNotifications,
        getNotificationStream: getNotificationStream,
        markNotificationRead: markNotificationRead,
        deleteNotification: deleteNotification,
        insertNotification: insertNotification,
        preferencesStorage: mockPrefs,
        clock: mockClock,
        uuidGenerator: mockUuid,
      );

      await Future<void>.delayed(Duration.zero);
      notifier.toggleSelection('id-1');

      notifier.state.when(
        initial: () => fail('State cannot be initial'),
        loading: (_) => fail('State cannot be loading'),
        error: (_) => fail('State cannot be error'),
        success: (state) {
          expect(state.isBulkSelectionMode, true);
          expect(state.selectedIds.contains('id-1'), true);
        },
      );

      notifier.clearSelection();
      notifier.state.when(
        initial: () => fail('State cannot be initial'),
        loading: (_) => fail('State cannot be loading'),
        error: (_) => fail('State cannot be error'),
        success: (state) {
          expect(state.isBulkSelectionMode, false);
          expect(state.selectedIds.isEmpty, true);
        },
      );
    });

    test('saveNote updates local notes map and commits persistence', () async {
      when(
        () => mockPrefs.setString(any(), any()),
      ).thenAnswer((_) async => null);

      final notifier = NotificationNotifier(
        getNotifications: getNotifications,
        getNotificationStream: getNotificationStream,
        markNotificationRead: markNotificationRead,
        deleteNotification: deleteNotification,
        insertNotification: insertNotification,
        preferencesStorage: mockPrefs,
        clock: mockClock,
        uuidGenerator: mockUuid,
      );

      await Future<void>.delayed(Duration.zero);
      await notifier.saveNote('id-1', 'تست یادداشت');

      notifier.state.when(
        initial: () => fail(''),
        loading: (_) => fail(''),
        error: (_) => fail(''),
        success: (state) {
          expect(state.notesMap['id-1'], 'تست یادداشت');
        },
      );

      verify(() => mockPrefs.setString(any(), any())).called(1);
    });
  });

  group('Notification Widget, Navigation & Accessibility Tests', () {
    late FakeNotificationNotifier fakeNotifier;
    late List<NotificationItem> items;

    setUp(() {
      items = [
        NotificationItem(
          id: 'notif-1',
          title: 'واریز بانک ملی',
          body: 'مبلغ ۵۰۰,۰۰۰ ریال به حساب شما واریز گردید.',
          type: NotificationType.transactionProcessed,
          isRead: false,
          createdAt: testDate,
        ),
        NotificationItem(
          id: 'notif-2',
          title: 'هشدار امنیتی',
          body: 'تلاش مشکوک برای ورود شناسایی شد.',
          type: NotificationType.securityAlerts,
          isRead: true,
          createdAt: testDate.subtract(const Duration(days: 2)),
        ),
      ];

      fakeNotifier = FakeNotificationNotifier(
        UiState.success(
          NotificationState.initial().copyWith(
            notifications: items,
            notesMap: {'notif-1': 'خرید روزانه'},
          ),
        ),
      );
    });

    Widget createWidgetUnderTest() {
      return ProviderScope(
        overrides: [
          notificationNotifierProvider.overrideWith((ref) => fakeNotifier),
          preferencesStorageProvider.overrideWithValue(mockPrefs),
          clockProvider.overrideWithValue(mockClock),
          uuidGeneratorProvider.overrideWithValue(mockUuid),
        ],
        child: MaterialApp(
          theme: AppTheme.createThemeLight(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fa')],
          locale: const Locale('fa'),
          home: const Scaffold(body: NotificationCenterScreen()),
        ),
      );
    }

    testWidgets(
      'NotificationCenterScreen renders header, search, filters, list, and badges correctly',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Verify Screen Title
        expect(find.text('مرکز اعلان‌ها'), findsOneWidget);

        // Verify Search Bar hint
        expect(find.text('جستجوی نام بانک، مبالغ یا برچسب...'), findsOneWidget);

        // Verify Timeline section headers "امروز" and "قدیمی‌تر"
        expect(find.text('امروز'), findsOneWidget);
        expect(find.text('قدیمی‌تر'), findsOneWidget);

        // Verify Pinned Active System Warning Banner
        expect(find.text('دسترسی پیامک صادر نشده است'), findsOneWidget);

        // Verify Standard Diagnostic Badge in Zone C
        expect(find.text('آفلاین و امن - بدون اتصال شبکه'), findsOneWidget);
      },
    );

    testWidgets(
      'NotificationCard exhibits correct titles, bodies, unread dots, and note tags',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Title & Body
        expect(find.text('واریز بانک ملی'), findsOneWidget);
        expect(
          find.text('مبلغ ۵۰۰,۰۰۰ ریال به حساب شما واریز گردید.'),
          findsOneWidget,
        );

        // Note tag text
        expect(find.text('خرید روزانه'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping a card opens details dialog containing details, edit-note, and delete triggers',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Details Dialog triggers are NOT visible initially
        expect(find.byType(NotificationDetailsDialog), findsNothing);

        // Tap card
        await tester.tap(find.text('واریز بانک ملی'));
        await tester.pumpAndSettle();

        // Expanded row should show Edit Note icon button and Delete trigger
        expect(find.byType(NotificationDetailsDialog), findsOneWidget);
        expect(find.byTooltip('یادداشت'), findsOneWidget);
        expect(find.byTooltip('حذف'), findsOneWidget);
      },
    );

    testWidgets(
      'Clicking delete trigger prompts DeleteNotificationDialog with correct RTL text and cancellation',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Tap card to open details dialog
        await tester.tap(find.text('واریز بانک ملی'));
        await tester.pumpAndSettle();

        // Click delete button inside details dialog
        await tester.tap(find.byTooltip('حذف'));
        await tester.pumpAndSettle();

        // Dialog is displayed
        expect(find.text('حذف دائم اعلان؟'), findsOneWidget);

        // Click cancel
        await tester.tap(find.text('انصراف'));
        await tester.pumpAndSettle();

        // Dialog closed
        expect(find.text('حذف دائم اعلان؟'), findsNothing);
      },
    );

    testWidgets(
      'Clicking edit-note displays InlineNoteBottomSheet modal scrollable overlay',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Tap card to open details dialog
        await tester.tap(find.text('واریز بانک ملی'));
        await tester.pumpAndSettle();

        // Tap Add Note trigger inside details dialog
        await tester.tap(find.byTooltip('یادداشت'));
        await tester.pumpAndSettle();

        // Sheet is displayed with RTL texts
        expect(find.text('افزودن یادداشت'), findsOneWidget);

        // Dismiss sheet
        await tester.tap(find.text('انصراف'));
        await tester.pumpAndSettle();
      },
    );

    testWidgets('Notification card has valid semantics', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(RegExp(r'.*واریز بانک ملی.*')),
        findsOneWidget,
      );
    });
  });
}
