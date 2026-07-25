import '../../domain/entities/analytics_models.dart';
import '../../domain/entities/time_range.dart';

/// Presentation state for the Statistics & Analytics Dashboard.
class AnalyticsState {
  /// Factory creating initial state parameters.
  factory AnalyticsState.initial() {
    final now = DateTime.now();
    return AnalyticsState(
      timeRange: TimeRange.fromPreset(TimeRangePreset.thisMonth, now),
      selectedBankFilter: 'All',
      activeChartTabIndex: 0,
      summary: AnalyticsSummary.empty(),
    );
  }

  /// Constructor.
  const AnalyticsState({
    required this.timeRange,
    required this.selectedBankFilter,
    required this.activeChartTabIndex,
    required this.summary,
  });

  /// Selected report range.
  final TimeRange timeRange;

  /// Selected bank/card suffix filter.
  final String selectedBankFilter;

  /// Active chart segment toggle (0 = Daily, 1 = Weekly, 2 = Monthly, 3 = Expense Category, 4 = Bank Dist).
  final int activeChartTabIndex;

  /// Aggregated report data.
  final AnalyticsSummary summary;

  /// Copy constructor.
  AnalyticsState copyWith({
    TimeRange? timeRange,
    String? selectedBankFilter,
    int? activeChartTabIndex,
    AnalyticsSummary? summary,
  }) {
    return AnalyticsState(
      timeRange: timeRange ?? this.timeRange,
      selectedBankFilter: selectedBankFilter ?? this.selectedBankFilter,
      activeChartTabIndex: activeChartTabIndex ?? this.activeChartTabIndex,
      summary: summary ?? this.summary,
    );
  }
}
