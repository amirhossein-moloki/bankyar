import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/search/domain/entities/search_models.dart';
import 'package:bankyar/features/search/domain/repository/search_repository.dart';
import 'package:bankyar/features/search/domain/usecases/search_transactions_usecase.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepository;
  late SearchTransactionsUseCase useCase;

  setUpAll(() {
    registerFallbackValue(SearchQuery.empty());
  });

  setUp(() {
    mockRepository = MockSearchRepository();
    useCase = SearchTransactionsUseCase(mockRepository);
  });

  const tx1 = ParsedTransaction(
    id: 'tx-1',
    amount: 15000.0,
    currency: 'IRR',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'Snapp',
    normalizedMerchant: 'Snapp',
    timestamp: 1697360400000,
    confidenceScore: 0.95,
    parsingMethod: 'deterministic',
    createdAt: 1697360400000,
    updatedAt: 1697360400000,
  );

  test('SearchTransactionsUseCase invokes searchTransactions on repository with correct params', () async {
    final query = SearchQuery(
      text: 'Snapp',
      filters: SearchFilters.empty(),
      sort: const SearchSort(),
    );

    when(() => mockRepository.searchTransactions(any()))
        .thenAnswer((_) async => const Result.success([tx1]));

    final result = await useCase(query);

    expect(result, isA<Success<List<ParsedTransaction>>>());
    final list = (result as Success<List<ParsedTransaction>>).data;
    expect(list.length, 1);
    expect(list.first.id, 'tx-1');

    verify(() => mockRepository.searchTransactions(query)).called(1);
  });
}
