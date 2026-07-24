import '../../../../core/utils/result.dart';
import '../entities/analytics_models.dart';

/// Contract governing analytical calculations and aggregates.
/// Executed completely offline, mapping relational schemas to business objects.
abstract class StatisticsRepository {
  /// Fetch a complete aggregate analytics summary for the selected period.
  Future<Result<AnalyticsSummary>> getStatistics({
    required DateTime startDate,
    required DateTime endDate,
    String? bankFilter,
  });
}
