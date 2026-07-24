import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/search/data/di/search_dependencies.dart';
import 'package:bankyar/features/search/domain/entities/search_models.dart';
import 'package:bankyar/features/search/domain/repository/search_repository.dart';
import 'package:bankyar/features/search/domain/usecases/search_transactions_usecase.dart';
import 'package:bankyar/features/search/presentation/screens/search_screen.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_notifier.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}
class MockSearchRepository extends Mock implements SearchRepository {}
class MockSearchTransactionsUseCase extends Mock implements SearchTransactionsUseCase {}
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockAppLogger mockLogger;
  late MockSearchRepository mockRepository;
  late MockSearchTransactionsUseCase mockUseCase;
  late MockTransactionRepository mockTxRepository;

  setUpAll(() {
    registerFallbackValue(SearchQuery.empty());
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogCategories.database);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockRepository = MockSearchRepository();
    mockUseCase = MockSearchTransactionsUseCase();
    mockTxRepository = MockTransactionRepository();

    when(() => mockLogger.log(
      any(),
      any(),
      any(),
      any(),
      metadata: any(named: 'metadata'),
      error: any(named: 'error'),
      stackTrace: any(named: 'stackTrace'),
    )).thenReturn(null);

    when(() => mockRepository.getSearchHistory())
        .thenAnswer((_) async => const Result.success(['taxi', 'food']));
    when(() => mockTxRepository.getCategories())
        .thenAnswer((_) async => const Result.success([]));
    when(() => mockRepository.saveSearchToHistory(any()))
        .thenAnswer((_) async => const Result.success(null));
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
        child: child,
      ),
    );
  }

  testWidgets('SearchScreen renders input box, history list, and transitions beautifully', (tester) async {
    // Set test viewport
    tester.view.physicalSize = const Size(1200, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    when(() => mockUseCase(any()))
        .thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(
      buildTestableWidget(
        ProviderScope(
          overrides: [
            searchTransactionsUseCaseProvider.overrideWithValue(mockUseCase),
            searchRepositoryProvider.overrideWithValue(mockRepository),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            loggerProvider.overrideWithValue(mockLogger),
            categoriesListProvider.overrideWith((ref) async => []),
          ],
          child: const SearchScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify search app bar is visible
    expect(find.text('جستجو و فیلتر تراکنش‌ها'), findsOneWidget);

    // Verify search input field hint text
    expect(find.text('جستجو در مبالغ، بانک‌ها، یادداشت‌ها...'), findsOneWidget);

    // Recent search items from mock history are visible
    expect(find.text('جستجوهای اخیر'), findsOneWidget);
    expect(find.text('taxi'), findsOneWidget);
    expect(find.text('food'), findsOneWidget);

    // Verify quick filter chips are rendered
    expect(find.text('همه'), findsOneWidget);
    expect(find.text('واریزها'), findsOneWidget);
    expect(find.text('برداشت‌ها'), findsOneWidget);
  });

  testWidgets('SearchScreen displays transactions list when search returns matched items', (tester) async {
    tester.view.physicalSize = const Size(1200, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const tx = ParsedTransaction(
      id: 'tx-match-1',
      amount: 12000.0,
      currency: 'IRR',
      transactionType: SmsTransactionType.debit,
      rawMerchant: 'Tejarat Store',
      normalizedMerchant: 'Tejarat Store',
      cardIdentifier: 'Tejarat',
      timestamp: 1697360400000,
      confidenceScore: 0.99,
      parsingMethod: 'deterministic',
      createdAt: 1697360400000,
      updatedAt: 1697360400000,
    );

    // Mock search matching a transaction when query is executed
    when(() => mockUseCase(any()))
        .thenAnswer((_) async => const Result.success([tx]));

    await tester.pumpWidget(
      buildTestableWidget(
        ProviderScope(
          overrides: [
            searchTransactionsUseCaseProvider.overrideWithValue(mockUseCase),
            searchRepositoryProvider.overrideWithValue(mockRepository),
            transactionRepositoryProvider.overrideWithValue(mockTxRepository),
            loggerProvider.overrideWithValue(mockLogger),
            categoriesListProvider.overrideWith((ref) async => []),
          ],
          child: const SearchScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Type in search field to trigger query match
    final textInput = find.byType(TextField);
    await tester.enterText(textInput, 'Tejarat');

    // Wait for debounce time and match results to populate
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // Matched card should be visible
    expect(find.text('Tejarat Store'), findsOneWidget);
    expect(find.text('تعداد نتایج: ۱ تراکنش'), findsOneWidget);
  });
}
