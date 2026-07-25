import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/analytics_models.dart';
import '../repository/statistics_repository.dart';

/// Params class specifying date range bounds and optional card filter.
class GetAnalyticsParams {
  /// Constructor defining query scope.
  const GetAnalyticsParams({
    required this.startDate,
    required this.endDate,
    this.bankFilter,
  });

  /// The start boundary of the report window.
  final DateTime startDate;

  /// The end boundary of the report window.
  final DateTime endDate;

  /// Optional bank account or card identifier filter.
  final String? bankFilter;
}

/// Central business Use Case executing database aggregations for financial reports.
class GetAnalyticsUseCase
    extends UseCase<AnalyticsSummary, GetAnalyticsParams> {
  /// Constructor injecting standard interface contract.
  GetAnalyticsUseCase(this._repository);

  final StatisticsRepository _repository;

  @override
  AsyncResult<AnalyticsSummary> call(GetAnalyticsParams params) {
    return _repository.getStatistics(
      startDate: params.startDate,
      endDate: params.endDate,
      bankFilter: params.bankFilter,
    );
  }
}
