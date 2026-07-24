import '../../../../core/architecture/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/entities/search_models.dart';
import '../../domain/repository/search_repository.dart';
import '../datasources/search_local_datasource.dart';

/// Concrete database-bound implementation of [SearchRepository].
class SearchRepositoryImpl extends BaseRepository implements SearchRepository {
  const SearchRepositoryImpl(this._dataSource);

  final SearchLocalDataSource _dataSource;

  @override
  Future<Result<List<ParsedTransaction>>> searchTransactions(SearchQuery query) {
    return executeSafe(() async {
      return await _dataSource.search(query);
    });
  }

  @override
  Future<Result<void>> saveSearchToHistory(String queryText) {
    return executeSafe(() async {
      await _dataSource.saveSearchQuery(queryText);
    });
  }

  @override
  Future<Result<List<String>>> getSearchHistory() {
    return executeSafe(() async {
      return await _dataSource.getSearchHistory();
    });
  }

  @override
  Future<Result<void>> clearSearchHistory() {
    return executeSafe(() async {
      await _dataSource.clearSearchHistory();
    });
  }
}
