import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../entities/search_models.dart';

/// Abstract contract for executing local advanced full-text search and filter queries.
abstract class SearchRepository {
  /// Executes search and filtering over transactional data.
  Future<Result<List<ParsedTransaction>>> searchTransactions(SearchQuery query);

  /// Saves a search query string to local history securely.
  Future<Result<void>> saveSearchToHistory(String queryText);

  /// Retrieves the list of recent search query strings.
  Future<Result<List<String>>> getSearchHistory();

  /// Clears the localized secure search history.
  Future<Result<void>> clearSearchHistory();
}
