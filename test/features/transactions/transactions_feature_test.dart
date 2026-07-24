import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/entities/transaction_category.dart';
import 'package:bankyar/features/transactions/domain/entities/transaction_details.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/screens/transaction_details_screen.dart';
import 'package:bankyar/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transaction_details_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_state.dart';
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

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(<String>[]);
    registerFallbackValue(
      const ParsedTransaction(
        id: '',
        amount: 0.0,
        currency: '',
        transactionType: SmsTransactionType.unknown,
        rawMerchant: '',
        normalizedMerchant: '',
        timestamp: 0,
        confidenceScore: 0.0,
        parsingMethod: '',
        createdAt: 0,
        updatedAt: 0,
      ),
    );
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

    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) async => 0);

    // Default mock responses for category list
    final defaultCategories = [
      const TransactionCategory(
        id: 'cat-food',
        name: 'غذا و رستوران',
        colorHex: '#FF9800',
        isSystemDefined: true,
      ),
      const TransactionCategory(
        id: 'cat-transport',
        name: 'حمل و نقل',
        colorHex: '#2196F3',
        isSystemDefined: true,
      ),
    ];
    when(
      () => mockRepository.getCategories(),
    ).thenAnswer((_) async => Result.success(defaultCategories));
  });

  group('Transactions Unit & Notifier Tests', () {
    test(
      'TransactionsNotifier initial state is success with empty query',
      () async {
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
        ).thenAnswer((_) async => const Result.success(<ParsedTransaction>[]));

        final container = ProviderContainer(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
          ],
        );

        final notifier = container.read(transactionsViewModelProvider.notifier);
        await notifier.loadInitial();

        final state = container.read(transactionsViewModelProvider);
        state.when(
          initial: () => fail(''),
          loading: (_) => fail(''),
          error: (_) => fail(''),
          success: (data) {
            expect(data.transactions, isEmpty);
            expect(data.searchQuery, isEmpty);
            expect(data.bankFilter, 'All');
          },
        );
      },
    );

    test(
      'TransactionsNotifier filters and sorts and pages successfully',
      () async {
        const tx = ParsedTransaction(
          id: 'tx-1',
          amount: 25000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.debit,
          rawMerchant: 'Snapp',
          normalizedMerchant: 'Snapp',
          timestamp: 1697360400000,
          confidenceScore: 0.95,
          parsingMethod: 'heuristic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
        );

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
        ).thenAnswer((_) async => const Result.success([tx]));

        final container = ProviderContainer(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
          ],
        );

        final notifier = container.read(transactionsViewModelProvider.notifier);
        await notifier.loadInitial();

        var state = container.read(transactionsViewModelProvider);
        state.when(
          initial: () => fail(''),
          loading: (_) => fail(''),
          error: (_) => fail(''),
          success: (data) {
            expect(data.transactions.length, 1);
            expect(data.transactions.first.id, 'tx-1');
          },
        );

        // Trigger search query
        notifier.setSearchQuery('Snapp');
        await Future<void>.delayed(const Duration(milliseconds: 10));

        state = container.read(transactionsViewModelProvider);
        state.when(
          initial: () => null,
          loading: (_) => null,
          error: (_) => null,
          success: (data) {
            expect(data.searchQuery, 'Snapp');
          },
        );
      },
    );

    test(
      'TransactionDetailsNotifier actions and mutations work successfully',
      () async {
        const tx = ParsedTransaction(
          id: 'tx-2',
          amount: 15000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.debit,
          rawMerchant: 'Melli',
          normalizedMerchant: 'Melli',
          timestamp: 1697360400000,
          confidenceScore: 0.8,
          parsingMethod: 'heuristic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
        );

        const details = TransactionDetails(
          transactionId: 'tx-2',
          transaction: tx,
          note: 'Taxi ride',
          category: TransactionCategory(
            id: 'cat-transport',
            name: 'حمل و نقل',
            colorHex: '#2196F3',
            isSystemDefined: true,
          ),
          tags: ['taxi', 'work'],
          rawSmsText: 'Melli SMS payload',
        );

        when(
          () => mockRepository.getTransactionDetails('tx-2'),
        ).thenAnswer((_) async => Result.success(details));
        when(
          () => mockRepository.saveTransaction(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => mockRepository.saveNote(any(), any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => mockRepository.assignTags(any(), any()),
        ).thenAnswer((_) async => const Result.success(null));

        final container = ProviderContainer(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
          ],
        );

        final notifier = container.read(
          transactionDetailsViewModelProvider('tx-2').notifier,
        );
        await notifier.loadDetails();

        final state = container.read(
          transactionDetailsViewModelProvider('tx-2'),
        );
        state.when(
          initial: () => fail(''),
          loading: (_) => fail(''),
          error: (_) => fail(''),
          success: (data) {
            expect(data.note, 'Taxi ride');
            expect(data.category?.id, 'cat-transport');
            expect(data.tags, contains('taxi'));
          },
        );

        // Verify transaction promotes confidence score to 1.0
        await notifier.verifyTransaction();
        verify(() => mockRepository.saveTransaction(any())).called(1);

        // Edit Note
        await notifier.saveNote('Updated taxi note');
        verify(
          () => mockRepository.saveNote('tx-2', 'Updated taxi note'),
        ).called(1);

        // Assign Tags
        await notifier.assignTags(['new', 'tags']);
        verify(
          () => mockRepository.assignTags('tx-2', ['new', 'tags']),
        ).called(1);
      },
    );
  });

  group('Transactions Screen Widget & Interactivity Tests', () {
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
      'TransactionsScreen renders list search, filters, and empty state correctly',
      (tester) async {
        // Increase test viewport to prevent vertical overflow on small test frames
        tester.view.physicalSize = const Size(1200, 1920);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

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
        ).thenAnswer((_) async => const Result.success(<ParsedTransaction>[]));

        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                transactionRepositoryProvider.overrideWithValue(mockRepository),
                loggerProvider.overrideWithValue(mockLogger),
                smsHistoryImporterProvider.overrideWithValue(mockImporter),
              ],
              child: const TransactionsScreen(),
            ),
          ),
        );

        // Pump frames to let async load finish and transition from initial -> success state
        await tester.pump();

        // Search field is present (TextFormField)
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('جستجو در تراکنش‌ها...'), findsOneWidget);

        // Sorting labels present
        expect(find.text('مرتب‌سازی براساس:'), findsOneWidget);
        expect(find.text('تاریخ'), findsOneWidget);
        expect(find.text('مبلغ'), findsOneWidget);

        // Empty state visible when list is empty
        expect(find.text('تراکنشی یافت نشد'), findsOneWidget);
      },
    );

    testWidgets(
      'TransactionDetailsScreen renders fields, note, copy reference, and action buttons',
      (tester) async {
        const tx = ParsedTransaction(
          id: 'tx-2',
          amount: 45000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.debit,
          rawMerchant: 'Snapp',
          normalizedMerchant: 'Snapp Taxi',
          timestamp: 1697360400000,
          confidenceScore: 0.95,
          parsingMethod: 'heuristic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
          referenceNumber: '887766554433',
        );

        const details = TransactionDetails(
          transactionId: 'tx-2',
          transaction: tx,
          note: 'Taxi note content',
          category: TransactionCategory(
            id: 'cat-transport',
            name: 'حمل و نقل',
            colorHex: '#2196F3',
            isSystemDefined: true,
          ),
          tags: ['taxi', 'work'],
          rawSmsText: 'Snapp SMS text',
        );

        when(
          () => mockRepository.getTransactionDetails('tx-2'),
        ).thenAnswer((_) async => Result.success(details));

        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                transactionRepositoryProvider.overrideWithValue(mockRepository),
                loggerProvider.overrideWithValue(mockLogger),
                smsHistoryImporterProvider.overrideWithValue(mockImporter),
              ],
              child: const TransactionDetailsScreen(transactionId: 'tx-2'),
            ),
          ),
        );

        // Wait for loading to finish
        await tester.pump();

        // Inspect summary elements
        expect(find.text('-۴۵,۰۰۰ تومان'), findsOneWidget);
        expect(find.text('هزینه / خروجی'), findsOneWidget);

        // Inspect metadata grid
        expect(find.text('پذیرنده / مبدأ'), findsOneWidget);
        expect(find.text('Snapp Taxi'), findsOneWidget);
        expect(find.text('شماره پیگیری'), findsOneWidget);
        expect(find.text('۸۸۷۷۶۶۵۵۴۴۳۳'), findsOneWidget);

        // Notes & Tags
        expect(find.text('Taxi note content'), findsOneWidget);
        expect(find.text('افزودن برچسب'), findsOneWidget);

        // Security indicator
        expect(find.byIcon(Icons.security_outlined), findsOneWidget);

        // Bottom verification and delete triggers
        expect(find.text('تأیید صحت اطلاعات'), findsOneWidget);
        expect(find.text('حذف تراکنش'), findsOneWidget);
      },
    );
  });
}
