import 'package:meta/meta.dart';

/// Supported sorting orders.
enum SortDirection {
  /// Sort in ascending alphabetical or chronological order.
  ascending,

  /// Sort in descending order (newest first or highest values first).
  descending,
}

/// Represents sorting parameters to order data listings.
/// Conforms to SEARCH_FILTER_SCREEN_SPECIFICATION.md specifications.
@immutable
class SortCriteria {
  /// Constructor defining active sorting field and direction.
  const SortCriteria({
    required this.field,
    this.direction = SortDirection.descending,
  });

  /// The target table column or entity property to sort by.
  final String field;

  /// The sort direction (ascending or descending).
  final SortDirection direction;

  /// Returns true if sorting direction is descending.
  bool get isDescending => direction == SortDirection.descending;

  /// Creates a copy of this sorting criteria with updated parameters.
  SortCriteria copyWith({String? field, SortDirection? direction}) {
    return SortCriteria(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SortCriteria &&
        other.field == field &&
        other.direction == direction;
  }

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;

  @override
  String toString() =>
      'SortCriteria(field: $field, direction: ${direction.name})';
}
