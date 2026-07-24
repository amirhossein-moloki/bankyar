import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/state_management/base_providers.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../domain/entities/time_range.dart';
import '../../domain/usecases/get_analytics_use_case.dart';
import '../../data/di/analytics_dependencies.dart';
import 'analytics_state.dart';

/// Provider exposing the [AnalyticsNotifier] view model as a reactive state holder.
final analyticsViewModelProvider =
    StateNotifierProvider.autoDispose<AnalyticsNotifier, UiState<AnalyticsState>>((ref) {
      final getAnalyticsUseCase = ref.watch(getAnalyticsUseCaseProvider);
      final logger = ref.watch(loggerProvider);
      return AnalyticsNotifier(
        getAnalyticsUseCase: getAnalyticsUseCase,
        logger: logger,
      );
    });

/// Riverpod StateNotifier controlling the Statistics & Analytics screen, range shifting,
/// card details recalculations, and reactive visual charts reloading.
class AnalyticsNotifier extends BaseUiNotifier<AnalyticsState> {
  /// Constructor immediately triggering data load.
  AnalyticsNotifier({
    required GetAnalyticsUseCase getAnalyticsUseCase,
    required AppLogger logger,
  }) : _getAnalyticsUseCase = getAnalyticsUseCase,
       _logger = logger {
    _state = AnalyticsState.initial();
    loadAnalytics();
  }

  final GetAnalyticsUseCase _getAnalyticsUseCase;
  final AppLogger _logger;
  late AnalyticsState _state;

  /// Loads/Reloads analytics based on current filters and time window parameters.
  Future<void> loadAnalytics() async {
    setLoading();
    _logger.log(
      LogLevel.debug,
      LogCategories.database,
      'BY_STAT_RELOAD',
      'Executing analytics database pull...',
    );

    final result = await _getAnalyticsUseCase(
      GetAnalyticsParams(
        startDate: _state.timeRange.startDate,
        endDate: _state.timeRange.endDate,
        bankFilter: _state.selectedBankFilter,
      ),
    );

    result.when(
      success: (summary) {
        _state = _state.copyWith(summary: summary);
        setSuccess(_state);
      },
      failure: (failure) {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_STAT_RELOAD_FAILED',
          'Database aggregation failed.',
          error: failure,
        );
        setError(failure);
      },
      loading: (_) => setLoading(),
      empty: () {
        _state = _state.copyWith(summary: null);
        setSuccess(_state);
      },
    );
  }

  /// Change report timeframe preset (e.g. Daily, Weekly, Monthly, All Time).
  void selectTimeRangePreset(TimeRangePreset preset) {
    final now = DateTime.now();
    final newRange = TimeRange.fromPreset(preset, now);
    _state = _state.copyWith(timeRange: newRange);
    loadAnalytics();
  }

  /// Shift current timeframe window forward chronologically (e.g. next month).
  void shiftForward() {
    final currentRange = _state.timeRange;
    final Duration diff = currentRange.endDate.difference(currentRange.startDate);

    final shiftDuration = Duration(milliseconds: diff.inMilliseconds + 1);

    final start = currentRange.startDate.add(shiftDuration);
    final end = currentRange.endDate.add(shiftDuration);

    _state = _state.copyWith(
      timeRange: TimeRange(
        currentRange.value,
        startDate: start,
        endDate: end,
      ),
    );
    loadAnalytics();
  }

  /// Shift current timeframe window backward chronologically (e.g. previous month).
  void shiftBackward() {
    final currentRange = _state.timeRange;
    final Duration diff = currentRange.endDate.difference(currentRange.startDate);

    final shiftDuration = Duration(milliseconds: diff.inMilliseconds + 1);

    final start = currentRange.startDate.subtract(shiftDuration);
    final end = currentRange.endDate.subtract(shiftDuration);

    _state = _state.copyWith(
      timeRange: TimeRange(
        currentRange.value,
        startDate: start,
        endDate: end,
      ),
    );
    loadAnalytics();
  }

  /// Apply card/account filter chip.
  void selectBankFilter(String bankFilter) {
    _state = _state.copyWith(selectedBankFilter: bankFilter);
    loadAnalytics();
  }

  /// Swaps visual graph tab selection.
  void selectChartTab(int index) {
    _state = _state.copyWith(activeChartTabIndex: index);
    setSuccess(_state);
  }
}
