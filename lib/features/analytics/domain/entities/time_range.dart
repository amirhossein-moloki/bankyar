import '../../../../core/architecture/value_object.dart';

/// Predefined chronological time window filters.
enum TimeRangePreset {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  thisYear,
  allTime,
  custom,
}

/// Domain Value Object encapsulating start and end date bounds for reporting.
class TimeRange extends ValueObject<TimeRangePreset> {
  /// Constructor defining concrete chronological bounds.
  const TimeRange(
    super.value, {
    required this.startDate,
    required this.endDate,
  });

  /// The start boundary of the report window.
  final DateTime startDate;

  /// The end boundary of the report window.
  final DateTime endDate;

  /// Helper factory to generate predefined ranges based on a given time anchor.
  factory TimeRange.fromPreset(TimeRangePreset preset, DateTime anchor) {
    switch (preset) {
      case TimeRangePreset.today:
        final start = DateTime(anchor.year, anchor.month, anchor.day);
        final end = DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
          23,
          59,
          59,
          999,
        );
        return TimeRange(preset, startDate: start, endDate: end);

      case TimeRangePreset.yesterday:
        final yesterday = anchor.subtract(const Duration(days: 1));
        final start = DateTime(yesterday.year, yesterday.month, yesterday.day);
        final end = DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          23,
          59,
          59,
          999,
        );
        return TimeRange(preset, startDate: start, endDate: end);

      case TimeRangePreset.thisWeek:
        int daysToSubtract = (anchor.weekday - DateTime.saturday) % 7;
        final startOfWeek = anchor.subtract(Duration(days: daysToSubtract));
        final start = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        final end = DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
          23,
          59,
          59,
          999,
        );
        return TimeRange(preset, startDate: start, endDate: end);

      case TimeRangePreset.thisMonth:
        final start = DateTime(anchor.year, anchor.month, 1);
        final end = DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
          23,
          59,
          59,
          999,
        );
        return TimeRange(preset, startDate: start, endDate: end);

      case TimeRangePreset.thisYear:
        final start = DateTime(anchor.year, 1, 1);
        final end = DateTime(
          anchor.year,
          anchor.month,
          anchor.day,
          23,
          59,
          59,
          999,
        );
        return TimeRange(preset, startDate: start, endDate: end);

      case TimeRangePreset.allTime:
        final start = DateTime(2000, 1, 1);
        final end = DateTime(2100, 12, 31, 23, 59, 59, 999);
        return TimeRange(preset, startDate: start, endDate: end);

      case TimeRangePreset.custom:
        throw ArgumentError(
          'Custom TimeRangePreset requires explicit startDate and endDate.',
        );
    }
  }

  /// Check if a specific timestamp falls inside this time range.
  bool contains(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate);
  }
}
