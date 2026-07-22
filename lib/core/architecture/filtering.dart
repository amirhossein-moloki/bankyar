import 'package:meta/meta.dart';

/// Represents structural constraints used to filter datasets across layers.
/// Conforms to SEARCH_FILTER_SCREEN_SPECIFICATION.md and STATE_MANAGEMENT.md.
@immutable
class FilterCriteria {
  /// Constructor defining active filtering constraints.
  const FilterCriteria([this.filters = const {}]);

  /// Key-value mapping of field-specific filter parameters.
  final Map<String, dynamic> filters;

  /// Returns true if no filter parameters are active.
  bool get isEmpty => filters.isEmpty;

  /// Retrieves a specific filter criteria value if present.
  T? getValue<T>(String key) => filters[key] as T?;

  /// Creates a copy of this criteria with updated filter parameters.
  FilterCriteria copyWith(Map<String, dynamic> updatedFilters) {
    return FilterCriteria({
      ...filters,
      ...updatedFilters,
    });
  }

  /// Returns a clean copy with a specific filter key removed.
  FilterCriteria remove(String key) {
    final nextFilters = Map<String, dynamic>.from(filters)..remove(key);
    return FilterCriteria(nextFilters);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterCriteria && other.hashCode == hashCode;
  }

  @override
  int get hashCode {
    int result = 17;
    for (final entry in filters.entries) {
      result = 37 * result + entry.key.hashCode + entry.value.hashCode;
    }
    return result;
  }

  @override
  String toString() => 'FilterCriteria($filters)';
}
