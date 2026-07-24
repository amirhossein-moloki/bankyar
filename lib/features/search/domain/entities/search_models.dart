import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Represents the sorting options for search results.
enum SearchSortField {
  date,
  amount,
  alphabetical,
  bank,
  category,
}

/// Model encapsulating all filter configurations.
class SearchFilters {
  const SearchFilters({
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.transactionType = 'All', // 'All', 'Credit', 'Debit'
    this.bank,
    this.categoryId,
    this.tags = const [],
    this.hasNote,
  });

  /// The start date for transaction timestamp filter.
  final DateTime? startDate;

  /// The end date for transaction timestamp filter.
  final DateTime? endDate;

  /// The minimum amount limit.
  final double? minAmount;

  /// The maximum amount limit.
  final double? maxAmount;

  /// The type filter (Credit, Debit, All).
  final String transactionType;

  /// Selected bank filter.
  final String? bank;

  /// Associated category ID filter.
  final String? categoryId;

  /// List of tag labels.
  final List<String> tags;

  /// Filter by presence of note text.
  final bool? hasNote;

  /// Factory for initial empty/default filters.
  factory SearchFilters.empty() => const SearchFilters();

  /// Determines if any custom filter is active.
  bool get isAnyActive {
    return startDate != null ||
        endDate != null ||
        minAmount != null ||
        maxAmount != null ||
        transactionType != 'All' ||
        (bank != null && bank != 'All' && bank!.isNotEmpty) ||
        categoryId != null ||
        tags.isNotEmpty ||
        hasNote != null;
  }

  /// Copy constructor.
  SearchFilters copyWith({
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    double? Function()? minAmount,
    double? Function()? maxAmount,
    String? transactionType,
    String? Function()? bank,
    String? Function()? categoryId,
    List<String>? tags,
    bool? Function()? hasNote,
  }) {
    return SearchFilters(
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      minAmount: minAmount != null ? minAmount() : this.minAmount,
      maxAmount: maxAmount != null ? maxAmount() : this.maxAmount,
      transactionType: transactionType ?? this.transactionType,
      bank: bank != null ? bank() : this.bank,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      tags: tags ?? this.tags,
      hasNote: hasNote != null ? hasNote() : this.hasNote,
    );
  }
}

/// Model for the sort configuration.
class SearchSort {
  const SearchSort({
    this.field = SearchSortField.date,
    this.descending = true,
  });

  final SearchSortField field;
  final bool descending;

  SearchSort copyWith({
    SearchSortField? field,
    bool? descending,
  }) {
    return SearchSort(
      field: field ?? this.field,
      descending: descending ?? this.descending,
    );
  }
}

/// Consolidated query model passing text, filters, and sorting.
class SearchQuery {
  const SearchQuery({
    required this.text,
    required this.filters,
    required this.sort,
  });

  /// The raw text search query.
  final String text;

  /// The filters configuration.
  final SearchFilters filters;

  /// The sort configuration.
  final SearchSort sort;

  /// Creates a blank query representation.
  factory SearchQuery.empty() {
    return SearchQuery(
      text: '',
      filters: SearchFilters.empty(),
      sort: const SearchSort(),
    );
  }

  SearchQuery copyWith({
    String? text,
    SearchFilters? filters,
    SearchSort? sort,
  }) {
    return SearchQuery(
      text: text ?? this.text,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
    );
  }
}
