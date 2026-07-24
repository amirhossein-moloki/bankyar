import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/entities/search_models.dart';

/// State representation for the Search & Filter feature.
class SearchState {
  const SearchState({
    required this.query,
    required this.transactions,
    required this.history,
    required this.isLoadingHistory,
  });

  /// Factory for the initial state of search.
  factory SearchState.initial() {
    return SearchState(
      query: SearchQuery.empty(),
      transactions: const [],
      history: const [],
      isLoadingHistory: false,
    );
  }

  /// The active consolidated search query model.
  final SearchQuery query;

  /// List of matched and filtered transaction entities.
  final List<ParsedTransaction> transactions;

  /// Recent search strings loaded from secure preferences.
  final List<String> history;

  /// Loading status of the historical search queries.
  final bool isLoadingHistory;

  /// Copy constructor.
  SearchState copyWith({
    SearchQuery? query,
    List<ParsedTransaction>? transactions,
    List<String>? history,
    bool? isLoadingHistory,
  }) {
    return SearchState(
      query: query ?? this.query,
      transactions: transactions ?? this.transactions,
      history: history ?? this.history,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
    );
  }
}
