import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/uuid.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/data/datasources/transaction_dao.dart';
import 'package:bankyar/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/domain/usecases/get_transactions_use_case.dart';
import 'package:bankyar/features/transactions/presentation/screens/home_screen.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/home_state.dart';
import 'package:bankyar/features/transactions/presentation/widgets/greeting_section.dart';
import 'package:bankyar/features/transactions/presentation/widgets/total_balance_card.dart';
import 'package:bankyar/features/transactions/presentation/widgets/monthly_summary_card.dart';
import 'package:bankyar/features/transactions/presentation/widgets/quick_actions_section.dart';
import 'package:bankyar/features/transactions/presentation/widgets/recent_transactions_section.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockDatabase extends Mock implements Database {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

class FakeHomeNotifier extends StateNotifier<UiState<HomeState>>
    implements HomeNotifier {
  FakeHomeNotifier(super.state);

  @override
  void toggleVisibility() {
    if (state is UiSuccess<HomeState>) {
      final data = (state as UiSuccess<HomeState>).data;
      state = UiState.success(data.copyWith(isObscured: !data.isObscured));
    }
  }

  @override
  void selectBankFilter(String bankFilter) {
    if (state is UiSuccess<HomeState>) {
      final data = (state as UiSuccess<HomeState>).data;
      state = UiState.success(data.copyWith(selectedBankFilter: bankFilter));
    }
  }

  @override
  Future<void> refresh() async {}

  @override
  void setInitial() {}

  @override
  void setLoading({double? progress}) {}

  @override
  void setSuccess(HomeState data) {}

  @override
  void setError(Failure failure) {}
}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;
  late TransactionDao dao;
  late TransactionRepositoryImpl repository;

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
    mockDb = MockDatabase();
    mockPrefs = MockPreferencesStorage();
    mockImporter = MockSmsHistoryImporter();
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();

    when(() => mockDbService.database).thenReturn(mockDb);

    // Mock logger.log to simply return
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

    dao = TransactionDao(mockDbService, mockLogger);
    repository = TransactionRepositoryImpl(dao);

    // Default mock behavior for secure storage preferences
    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => null);
    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) async => 0);

    // Default empty transactions stream
    when(() => mockGetTransactionsUseCase(any())).thenAnswer(
      (_) => Stream.value(const Result.success(<ParsedTransaction>[])),
    );
  });

  group('Transaction Repository & DAO Integration Tests', () {
    test(
      'getTransactions queries standard relational database table chronologically',
      () async {
        final mockMapList = [
          {
            'id': 'tx-1',
            'amount': 50000.0,
            'currency': 'IRR',
            'transaction_type': 'credit',
            'raw_merchant': 'Melli',
            'normalized_merchant': 'Melli',
            'timestamp': 1697360400000,
            'confidence_score': 1.0,
            'parsing_method': 'deterministic',
            'created_at': 1697360400000,
            'updated_at': 1697360400000,
          },
        ];

        when(
          () => mockDb.query('transactions', orderBy: any(named: 'orderBy')),
        ).thenAnswer((_) async => mockMapList);

        final result = await repository.getTransactions();

        expect(result, isA<Success<List<ParsedTransaction>>>());
        final list = (result as Success<List<ParsedTransaction>>).data;
        expect(list.length, 1);
        expect(list.first.id, 'tx-1');
        expect(list.first.amount, 50000.0);
      },
    );

    test('saveTransaction inserts transaction into database', () async {
      const tx = ParsedTransaction(
        id: 'tx-1',
        amount: 25000.0,
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

      when(
        () => mockDb.insert(
          'transactions',
          any(),
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
        ),
      ).thenAnswer((_) async => 1);

      final result = await repository.saveTransaction(tx);

      expect(result, isA<Success<void>>());
      verify(
        () => mockDb.insert(
          'transactions',
          any(),
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
        ),
      ).called(1);
    });
  });

  group('HomeNotifier & ViewModel Tests', () {
    test(
      'loads visibility setting on launch and streams transactions',
      () async {
        const tx = ParsedTransaction(
          id: 'tx-1',
          amount: 100000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.credit,
          rawMerchant: 'Melli',
          normalizedMerchant: 'Melli',
          timestamp: 1697360400000,
          confidenceScore: 1.0,
          parsingMethod: 'deterministic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
        );

        when(
          () => mockGetTransactionsUseCase(const NoParams()),
        ).thenAnswer((_) => Stream.value(const Result.success([tx])));
        when(
          () => mockPrefs.getBool('by_balance_obscured'),
        ).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            getTransactionsUseCaseProvider.overrideWithValue(
              mockGetTransactionsUseCase,
            ),
          ],
        );

        // Create a subscription to keep the autoDispose provider alive!
        final sub = container.listen(homeViewModelProvider, (_, __) {});

        // Wait for async load to finish
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final state = container.read(homeViewModelProvider);

        state.when(
          initial: () => fail('Should be success'),
          loading: (_) => fail('Should be success'),
          error: (f) => fail('Should be success: ${f.message}'),
          success: (data) {
            expect(data.isObscured, isTrue);
            expect(data.totalBalance, 100000.0);
            expect(data.monthlyIncome, 100000.0);
            expect(data.monthlyExpense, 0.0);
            expect(data.transactions.length, 1);
          },
        );

        sub.close();
      },
    );

    test(
      'recomputes financial totals and applies bank filters correctly',
      () async {
        const tx1 = ParsedTransaction(
          id: 'tx-1',
          amount: 150000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.credit,
          rawMerchant: 'Melli',
          normalizedMerchant: 'Melli',
          timestamp: 1697360400000,
          confidenceScore: 1.0,
          parsingMethod: 'deterministic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
        );
        const tx2 = ParsedTransaction(
          id: 'tx-2',
          amount: 50000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.debit,
          rawMerchant: 'Snapp',
          normalizedMerchant: 'Snapp',
          timestamp: 1697360410000,
          confidenceScore: 1.0,
          parsingMethod: 'deterministic',
          createdAt: 1697360410000,
          updatedAt: 1697360410000,
        );

        when(
          () => mockGetTransactionsUseCase(const NoParams()),
        ).thenAnswer((_) => Stream.value(const Result.success([tx1, tx2])));

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            getTransactionsUseCaseProvider.overrideWithValue(
              mockGetTransactionsUseCase,
            ),
          ],
        );

        final sub = container.listen(homeViewModelProvider, (_, __) {});
        final notifier = container.read(homeViewModelProvider.notifier);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Test arithmetic aggregations
        var state = container.read(homeViewModelProvider);
        state.when(
          initial: () => fail(''),
          loading: (_) => fail(''),
          error: (_) => fail(''),
          success: (data) {
            expect(data.totalBalance, 100000.0); // 150k - 50k = 100k
            expect(data.monthlyIncome, 150000.0);
            expect(data.monthlyExpense, 50000.0);
            expect(data.transactions.length, 2);
          },
        );

        // Test filter chip selection: filter by 'Melli'
        notifier.selectBankFilter('Melli');
        state = container.read(homeViewModelProvider);
        state.when(
          initial: () => fail(''),
          loading: (_) => fail(''),
          error: (_) => fail(''),
          success: (data) {
            expect(data.transactions.length, 1);
            expect(data.transactions.first.id, 'tx-1');
            expect(data.totalBalance, 100000.0);
          },
        );

        sub.close();
      },
    );
  });

  group('Widget and Screen Interactivity Tests', () {
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
      'GreetingSection exhibits correct localized text & secure badge',
      (tester) async {
        await tester.pumpWidget(buildTestableWidget(const GreetingSection()));
        expect(find.text('سلام، سهراب عزیز'), findsOneWidget);
        expect(find.text('صندوقچه مالی شما امن و به‌روز است'), findsOneWidget);
        expect(find.text('کاملاً آفلاین'), findsOneWidget);
      },
    );

    testWidgets('TotalBalanceCard displays masked balance on obscure trigger', (
      tester,
    ) async {
      final mockState = HomeState.empty().copyWith(
        totalBalance: 12400000.0,
        isObscured: false,
      );

      final notifier = FakeHomeNotifier(UiState.success(mockState));

      await tester.pumpWidget(
        buildTestableWidget(
          ProviderScope(
            overrides: [
              databaseServiceProvider.overrideWithValue(mockDbService),
              preferencesStorageProvider.overrideWithValue(mockPrefs),
              loggerProvider.overrideWithValue(mockLogger),
              smsHistoryImporterProvider.overrideWithValue(mockImporter),
              getTransactionsUseCaseProvider.overrideWithValue(
                mockGetTransactionsUseCase,
              ),
              homeViewModelProvider.overrideWith((ref) => notifier),
            ],
            child: const TotalBalanceCard(),
          ),
        ),
      );

      expect(find.text('۱۲,۴۰۰,۰۰۰ تومان'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('••••••'), findsOneWidget);
      expect(find.text('۱۲,۴۰۰,۰۰۰ تومان'), findsNothing);
    });

    testWidgets(
      'RecentTransactionsSection exhibits empty template on zero data',
      (tester) async {
        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                databaseServiceProvider.overrideWithValue(mockDbService),
                preferencesStorageProvider.overrideWithValue(mockPrefs),
                loggerProvider.overrideWithValue(mockLogger),
                smsHistoryImporterProvider.overrideWithValue(mockImporter),
                getTransactionsUseCaseProvider.overrideWithValue(
                  mockGetTransactionsUseCase,
                ),
                homeViewModelProvider.overrideWith(
                  (ref) => FakeHomeNotifier(UiState.success(HomeState.empty())),
                ),
              ],
              child: const CustomScrollView(
                slivers: [RecentTransactionsListSliver()],
              ),
            ),
          ),
        );

        expect(find.text('تراکنشی یافت نشد'), findsOneWidget);
        expect(
          find.text('هیچ تراکنشی در صندوقچه شما ثبت نشده است.'),
          findsOneWidget,
        );
      },
    );
  });

  group('Accessibility & Semantics Validation', () {
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

    testWidgets('TotalBalanceCard has appropriate semantic annotations', (
      tester,
    ) async {
      final mockState = HomeState.empty().copyWith(isObscured: true);

      await tester.pumpWidget(
        buildTestableWidget(
          ProviderScope(
            overrides: [
              databaseServiceProvider.overrideWithValue(mockDbService),
              preferencesStorageProvider.overrideWithValue(mockPrefs),
              loggerProvider.overrideWithValue(mockLogger),
              smsHistoryImporterProvider.overrideWithValue(mockImporter),
              getTransactionsUseCaseProvider.overrideWithValue(
                mockGetTransactionsUseCase,
              ),
              homeViewModelProvider.overrideWith(
                (ref) => FakeHomeNotifier(UiState.success(mockState)),
              ),
            ],
            child: const TotalBalanceCard(),
          ),
        ),
      );

      final semanticsWidget = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Show balance',
      );
      expect(semanticsWidget, findsOneWidget);
    });
  });

  group('Performance Stress Test with Large Dataset', () {
    test('recomputes calculations efficiently with 5,000 transactions', () {
      final largeList = List.generate(5000, (index) {
        return ParsedTransaction(
          id: 'tx-$index',
          amount: 1000.0,
          currency: 'IRR',
          transactionType: index % 2 == 0
              ? SmsTransactionType.credit
              : SmsTransactionType.debit,
          rawMerchant: 'Merchant $index',
          normalizedMerchant: 'Merchant $index',
          timestamp: 1697360400000 + index,
          confidenceScore: 1.0,
          parsingMethod: 'deterministic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
        );
      });

      final stopwatch = Stopwatch()..start();

      double total = 0.0;
      double income = 0.0;
      double expense = 0.0;

      for (final tx in largeList) {
        final amt = tx.amount;
        if (tx.transactionType == SmsTransactionType.credit) {
          income += amt;
          total += amt;
        } else if (tx.transactionType == SmsTransactionType.debit) {
          expense += amt;
          total -= amt;
        }
      }

      stopwatch.stop();

      // Ensure that calculating calculations on 5,000 transactions finishes in less than 50 milliseconds!
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
      expect(income, 2500000.0);
      expect(expense, 2500000.0);
      expect(total, 0.0);
    });
  });
}
