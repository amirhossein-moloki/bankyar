import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:bankyar/core/state_management/undo_delete_notifier.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_notifier.dart';
import 'package:bankyar/features/transactions/presentation/screens/home_screen.dart';
import 'package:bankyar/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:bankyar/features/notifications/presentation/screens/notification_center_screen.dart';
import 'package:bankyar/features/notifications/domain/entities/notification_item.dart';
import 'package:bankyar/features/notifications/domain/repository/notification_repository.dart';
import 'package:bankyar/features/notifications/data/di/notification_providers.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}
class MockPreferencesStorage extends Mock implements PreferencesStorage {}
class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockTransactionRepository mockRepository;
  late MockNotificationRepository mockNotificationRepository;

  const testTx = ParsedTransaction(
    id: 'tx-test-id',
    amount: 50000.0,
    currency: 'IRR',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'Snapp',
    normalizedMerchant: 'اسنپ',
    timestamp: 1697360400000,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: 1697360400000,
    updatedAt: 1697360400000,
  );

  final testNotif = NotificationItem(
    id: 'notif-1',
    title: 'واریز وجه',
    body: 'مبلغ ۱۰,۰۰۰,۰۰۰ ریال واریز شد.',
    type: NotificationType.transactionProcessed,
    isRead: false,
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockPrefs = MockPreferencesStorage();
    mockImporter = MockSmsHistoryImporter();
    mockRepository = MockTransactionRepository();
    mockNotificationRepository = MockNotificationRepository();

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
    when(() => mockPrefs.getBool('by_onboarding_completed')).thenAnswer((_) async => true);
    when(() => mockPrefs.getString(any())).thenAnswer((_) async => null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async {});

    when(() => mockImporter.performIncrementalSync()).thenAnswer((_) async => 0);

    when(
      () => mockRepository.getTransactionsPaged(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        bankFilter: any(named: 'bankFilter'),
        categoryId: any(named: 'categoryId'),
        typeFilter: any(named: 'typeFilter'),
        searchQuery: any(named: 'searchQuery'),
        sortBy: any(named: 'sortBy'),
        descending: any(named: 'descending'),
      ),
    ).thenAnswer((_) async => const Result.success([testTx]));

    when(() => mockRepository.getCategories()).thenAnswer((_) async => Result.success([]));
    when(() => mockRepository.getTransactions()).thenAnswer((_) async => const Result.success([testTx]));
    when(() => mockRepository.watchTransactions()).thenAnswer((_) => Stream.value(const Result.success([testTx])));
    when(() => mockRepository.deleteTransactions(any())).thenAnswer((_) async => const Result.success(null));
    when(() => mockRepository.deleteTransaction(any())).thenAnswer((_) async => const Result.success(null));

    // Notifications mocks
    when(() => mockNotificationRepository.getNotifications()).thenAnswer((_) async => Result.success([testNotif]));
    when(() => mockNotificationRepository.getNotificationStream()).thenAnswer((_) => Stream.value(Result.success([testNotif])));
  });

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
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }

  group('DeleteConfirmationDialog Tests', () {
    testWidgets('Displays Material Design 3 layout, RTL, and standard texts', (tester) async {
      bool confirmClicked = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                    onConfirm: () => confirmClicked = true,
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify title and description in RTL
      expect(find.text('حذف اطلاعات'), findsOneWidget);
      expect(find.text('آیا از حذف این مورد اطمینان دارید؟ این عملیات قابل بازگردانی نخواهد بود.'), findsOneWidget);

      // Verify buttons
      expect(find.text('لغو'), findsOneWidget);
      expect(find.text('حذف'), findsOneWidget);

      // Tap Confirm
      await tester.tap(find.text('حذف'));
      await tester.pumpAndSettle();

      expect(confirmClicked, isTrue);
    });

    testWidgets('Prevents double tap actions', (tester) async {
      int confirmCount = 0;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(
                    onConfirm: () => confirmCount++,
                  ),
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap Confirm multiple times quickly
      await tester.tap(find.text('حذف'), warnIfMissed: false);
      await tester.tap(find.text('حذف'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Confirm callback should only be triggered once due to processing lock
      expect(confirmCount, equals(1));
    });
  });

  group('Undo Delete State & Notifier Tests', () {
    testWidgets('Undo action correctly restores transactions/notes', (tester) async {
      final container = ProviderContainer(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepository),
          loggerProvider.overrideWithValue(mockLogger),
        ],
      );

      final notifier = container.read(undoDeleteProvider.notifier);

      // Initially, no pending deletions
      expect(container.read(undoDeleteProvider).pendingTransactionIds, isEmpty);

      // Trigger deletion of transaction
      BuildContext? capturedContext;
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: buildTestableWidget(
            Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      bool refreshCalled = false;
      notifier.deleteTransaction(capturedContext!, testTx, () {
        refreshCalled = true;
      });

      await tester.pump();

      // Transaction ID should be in pending deletions instantly
      expect(container.read(undoDeleteProvider).pendingTransactionIds, contains(testTx.id));
      expect(refreshCalled, isTrue);

      // Verify snackbar is displayed
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('تراکنش حذف شد.'), findsOneWidget);

      // Programmatically invoke the SnackBar Action callback to avoid layout & viewport offsets
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      snackBar.action!.onPressed();
      await tester.pumpAndSettle();

      // Pending deletion should be cleared instantly, meaning it was restored!
      expect(container.read(undoDeleteProvider).pendingTransactionIds, isEmpty);
      verifyNever(() => mockRepository.deleteTransactions(any()));
    });
  });

  group('Pull To Refresh Tests', () {
    testWidgets('Pull to refresh calls correct refresh methods on Dashboard', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
          ],
          child: buildTestableWidget(const HomeScreen()),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Programmatically trigger RefreshIndicator
      final dynamic state = tester.state(find.byType(RefreshIndicator));
      state.show();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Verify importer performIncrementalSync was called
      verify(() => mockImporter.performIncrementalSync()).called(greaterThanOrEqualTo(1));
    });

    testWidgets('Pull to refresh calls correct refresh methods on Transactions list', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
          ],
          child: buildTestableWidget(const TransactionsScreen()),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Programmatically trigger RefreshIndicator
      final dynamic state = tester.state(find.byType(RefreshIndicator));
      state.show();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Verify list reload & sync check triggers
      verify(() => mockImporter.performIncrementalSync()).called(greaterThanOrEqualTo(1));
    });

    testWidgets('Pull to refresh calls correct refresh methods on Notification center', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(mockNotificationRepository),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
          ],
          child: buildTestableWidget(const NotificationCenterScreen()),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Programmatically trigger RefreshIndicator
      final dynamic state = tester.state(find.byType(RefreshIndicator));
      state.show();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      // Verify query is updated and refreshed
      verify(() => mockNotificationRepository.getNotificationStream()).called(greaterThanOrEqualTo(1));
    });
  });
}
