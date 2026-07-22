/// Immutable model representing a paginated chunk of records.
/// Conforms to STATE_MANAGEMENT.md Keyset Seek Pagination guidelines.
class PaginatedList<T> {
  /// Constructor for creating a paginated chunk of data.
  const PaginatedList({
    required this.items,
    this.nextPageAnchor,
    this.hasMore = false,
  });

  /// The list of items in the current page chunk.
  final List<T> items;

  /// The seek cursor anchor for pulling the next page.
  /// Uses primary timestamp and unique sequence keys for $O(1)$seek pagination.
  final Object? nextPageAnchor;

  /// Returns true if more pages are available on disk.
  final bool hasMore;

  /// Converts the list items to another type [R] preserving pagination metrics.
  PaginatedList<R> map<R>(R Function(T item) transform) {
    return PaginatedList<R>(
      items: items.map(transform).toList(),
      nextPageAnchor: nextPageAnchor,
      hasMore: hasMore,
    );
  }
}

/// Parameters defining traditional limit-offset pagination.
class OffsetPaginationParams {
  /// Constructor for offset parameters.
  const OffsetPaginationParams({
    required this.limit,
    required this.offset,
  });

  /// The maximum number of records to return.
  final int limit;

  /// The number of records to skip.
  final int offset;
}

/// Parameters defining constant-time keyset seek pagination.
class KeysetPaginationParams {
  /// Constructor for keyset parameters.
  const KeysetPaginationParams({
    required this.limit,
    this.anchorValue,
    this.anchorId,
  });

  /// The maximum number of records to return.
  final int limit;

  /// The sorting column value of the last-seen anchor record (e.g., DateTime).
  final Object? anchorValue;

  /// The unique sequence key of the last-seen anchor record (e.g., String uuid).
  final String? anchorId;
}
