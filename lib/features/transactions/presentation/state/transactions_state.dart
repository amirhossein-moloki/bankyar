import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// State object managing filtering, pagination, sorting, search, and grouping of transactions.
class TransactionsState {
  /// Constructor defining all defaults.
  const TransactionsState({
    required this.transactions,
    required this.offset,
    required this.limit,
    required this.hasMore,
    required this.searchQuery,
    required this.bankFilter,
    this.categoryId,
    required this.typeFilter,
    required this.groupBy,
    required this.sortBy,
    required this.descending,
    required this.isLoadingMore,
  });

  /// Factory constructor for initial empty state.
  factory TransactionsState.initial() {
    return const TransactionsState(
      transactions: [],
      offset: 0,
      limit: 20,
      hasMore: true,
      searchQuery: '',
      bankFilter: 'All',
      categoryId: null,
      typeFilter: 'All',
      groupBy: 'Day',
      sortBy: 'Date',
      descending: true,
      isLoadingMore: false,
    );
  }

  /// List of loaded transaction entities.
  final List<ParsedTransaction> transactions;

  /// Current offset for database pagination.
  final int offset;

  /// Items per page limit.
  final int limit;

  /// Indicates if there are more transactions to load in the database.
  final bool hasMore;

  /// Current search input query.
  final String searchQuery;

  /// Selected bank filter text.
  final String bankFilter;

  /// Associated category filter ID.
  final String? categoryId;

  /// Selected transaction type filter ('All', 'Credit', 'Debit').
  final String typeFilter;

  /// Transaction grouping type ('None', 'Day', 'Week', 'Month').
  final String groupBy;

  /// Transaction sorting field ('Date', 'Amount', 'Confidence').
  final String sortBy;

  /// Indicates chronological direction.
  final bool descending;

  /// Spinner state for lazy list pagination.
  final bool isLoadingMore;

  /// Copy constructor.
  TransactionsState copyWith({
    List<ParsedTransaction>? transactions,
    int? offset,
    int? limit,
    bool? hasMore,
    String? searchQuery,
    String? bankFilter,
    String? Function()? categoryId,
    String? typeFilter,
    String? groupBy,
    String? sortBy,
    bool? descending,
    bool? isLoadingMore,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      bankFilter: bankFilter ?? this.bankFilter,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      typeFilter: typeFilter ?? this.typeFilter,
      groupBy: groupBy ?? this.groupBy,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
