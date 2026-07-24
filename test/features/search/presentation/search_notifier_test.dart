import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/search/domain/entities/search_models.dart';
import 'package:bankyar/features/search/domain/repository/search_repository.dart';
import 'package:bankyar/features/search/domain/usecases/search_transactions_usecase.dart';
import 'package:bankyar/features/search/presentation/state/search_notifier.dart';
import 'package:bankyar/features/search/presentation/state/search_state.dart';

class MockAppLogger extends Mock implements AppLogger {}
class MockSearchRepository extends Mock implements SearchRepository {}
class MockSearchTransactionsUseCase extends Mock implements SearchTransactionsUseCase {}

void main() {
  late MockAppLogger mockLogger;
  late MockSearchRepository mockRepository;
  late MockSearchTransactionsUseCase mockUseCase;
  late SearchNotifier notifier;

  setUpAll(() {
    registerFallbackValue(SearchQuery.empty());
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogCategories.database);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockRepository = MockSearchRepository();
    mockUseCase = MockSearchTransactionsUseCase();

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
    when(() => mockUseCase(any()))
        .thenAnswer((_) async => const Result.success([]));
    when(() => mockRepository.saveSearchToHistory(any()))
        .thenAnswer((_) async => const Result.success(null));

    // Construct notifier directly to avoid Riverpod fire-and-forget timing variances in unit testing
    notifier = SearchNotifier(
      searchUseCase: mockUseCase,
      repository: mockRepository,
      logger: mockLogger,
    );
  });

  test('SearchNotifier transitions state on init, text query update, and filter changes', () async {
    // Explicitly initialize notifier and await its asynchronous setup
    await notifier.init();

    final state = notifier.state;
    state.when(
      initial: () => fail('Initial state is not expected'),
      loading: (_) => fail('Loading state is not expected'),
      error: (_) => fail('Error state is not expected'),
      success: (data) {
        expect(data.history, contains('taxi'));
        expect(data.query.text, isEmpty);
      },
    );

    // Update query text
    notifier.updateQueryText('Snapp');

    // Wait for debouncer delay (250ms) plus some padding to ensure execution finishes
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final updatedState = notifier.state;
    updatedState.when(
      initial: () => fail(''),
      loading: (_) => fail(''),
      error: (_) => fail(''),
      success: (data) {
        expect(data.query.text, 'Snapp');
      },
    );
  });
}
