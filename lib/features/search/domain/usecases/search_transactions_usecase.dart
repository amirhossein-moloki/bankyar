import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../entities/search_models.dart';
import '../repository/search_repository.dart';

/// Use case that runs advanced searching and filtering on the ledger dataset.
class SearchTransactionsUseCase implements UseCase<List<ParsedTransaction>, SearchQuery> {
  const SearchTransactionsUseCase(this._repository);

  final SearchRepository _repository;

  @override
  Future<Result<List<ParsedTransaction>>> call(SearchQuery params) {
    return _repository.searchTransactions(params);
  }
}
