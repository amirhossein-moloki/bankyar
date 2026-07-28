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
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockTransactionRepository mockRepository;

  const tx1 = ParsedTransaction(
    id: 'tx-1',
    amount: 10000.0,
    currency: 'IRR',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'Snapp',
    normalizedMerchant: 'Snapp',
    timestamp: 1697360400000,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: 1697360400000,
    updatedAt: 1697360400000,
  );

  const tx2 = ParsedTransaction(
    id: 'tx-2',
    amount: 20000.0,
    currency: 'IRR',
    transactionType: SmsTransactionType.credit,
    rawMerchant: 'Melli',
    normalizedMerchant: 'Melli',
    timestamp: 1697360410000,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: 1697360410000,
    updatedAt: 1697360410000,
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
    when(() => mockPrefs.getString(any())).thenAnswer((_) async => null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});
    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) async => 0);

    // Mock paginated fetching
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
    ).thenAnswer((_) async => const Result.success([tx1, tx2]));

    when(
      () => mockRepository.getCategories(),
    ).thenAnswer((_) async => Result.success([]));
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
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    );
  }

  testWidgets(
    'Transactions Screen supports long-press multi-selection and select all',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            transactionRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: buildTestableWidget(const TransactionsScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify transactions are loaded and displayed
      expect(find.text('دفترچه تراکنش‌ها'), findsOneWidget);
      expect(find.text('Snapp'), findsOneWidget);
      expect(find.text('Melli'), findsOneWidget);

      // Verify Checkboxes are NOT displayed yet (multi-selection mode inactive)
      expect(find.byType(Checkbox), findsNothing);

      // Long press on Snapp transaction card
      await tester.longPress(find.text('Snapp'));
      await tester.pumpAndSettle();

      // Checkboxes should now be visible and Snapp should be checked
      expect(find.byType(Checkbox), findsNWidgets(2));
      expect(find.text('1 تراکنش انتخاب شده'), findsOneWidget);

      // Tap on Select All button in the AppBar actions
      final selectAllIcon = find.byIcon(Icons.select_all);
      expect(selectAllIcon, findsOneWidget);
      await tester.tap(selectAllIcon);
      await tester.pumpAndSettle();

      // Both Snapp and Melli should be checked
      expect(find.text('2 تراکنش انتخاب شده'), findsOneWidget);

      // Tap on the close icon to clear selection
      final closeIcon = find.byIcon(Icons.close);
      expect(closeIcon, findsOneWidget);
      await tester.tap(closeIcon);
      await tester.pumpAndSettle();

      // Contextual app bar should be gone, checkboxes should be gone
      expect(find.byType(Checkbox), findsNothing);
      expect(find.text('دفترچه تراکنش‌ها'), findsOneWidget);
    },
  );
}
