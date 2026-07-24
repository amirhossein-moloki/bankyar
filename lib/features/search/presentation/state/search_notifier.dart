import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/state_management/base_providers.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../../../core/utils/debouncer.dart';
import '../../data/di/search_dependencies.dart';
import '../../domain/entities/search_models.dart';
import '../../domain/repository/search_repository.dart';
import '../../domain/usecases/search_transactions_usecase.dart';
import 'search_state.dart';

/// Provider exposing the [SearchNotifier] view model state.
final searchViewModelProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, UiState<SearchState>>((ref) {
      final searchUseCase = ref.watch(searchTransactionsUseCaseProvider);
      final repository = ref.watch(searchRepositoryProvider);
      final logger = ref.watch(loggerProvider);
      return SearchNotifier(
        searchUseCase: searchUseCase,
        repository: repository,
        logger: logger,
      )..init();
    });

/// Riverpod StateNotifier controlling the Search & Filter workflow,
/// debounced keystroke triggers, filters, sort, and history operations.
class SearchNotifier extends BaseUiNotifier<SearchState> {
  SearchNotifier({
    required SearchTransactionsUseCase searchUseCase,
    required SearchRepository repository,
    required AppLogger logger,
  })  : _searchUseCase = searchUseCase,
        _repository = repository,
        _logger = logger,
        _debouncer = Debouncer(milliseconds: 250);

  final SearchTransactionsUseCase _searchUseCase;
  final SearchRepository _repository;
  final AppLogger _logger;
  final Debouncer _debouncer;

  /// Initializes state, loads history, and performs an initial search.
  Future<void> init() async {
    setLoading();
    final stateData = SearchState.initial();
    state = UiState.success(stateData);

    await loadHistory();
    await executeSearch();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  /// Loads search history from secure local preferences.
  Future<void> loadHistory() async {
    final currentState = _getCurrentState();
    if (currentState == null) return;

    setSuccess(currentState.copyWith(isLoadingHistory: true));

    final result = await _repository.getSearchHistory();
    result.when(
      success: (historyList) {
        final current = _getCurrentState();
        if (current != null) {
          setSuccess(
            current.copyWith(
              history: historyList,
              isLoadingHistory: false,
            ),
          );
        }
      },
      failure: (failure) {
        _logger.log(
          LogLevel.error,
          LogCategories.platform,
          'BY_SEARCH_HISTORY_LOAD_FAILED',
          'Failed to load search history list.',
          error: failure,
        );
        final current = _getCurrentState();
        if (current != null) {
          setSuccess(current.copyWith(isLoadingHistory: false));
        }
      },
      loading: (_) => null,
      empty: () {
        final current = _getCurrentState();
        if (current != null) {
          setSuccess(
            current.copyWith(
              history: [],
              isLoadingHistory: false,
            ),
          );
        }
      },
    );
  }

  /// Saves a query text to local secure history and updates the list.
  Future<void> saveToHistory(String queryText) async {
    final trimmed = queryText.trim();
    if (trimmed.isEmpty) return;

    final result = await _repository.saveSearchToHistory(trimmed);
    result.when(
      success: (_) => loadHistory(),
      failure: (f) {
        _logger.log(
          LogLevel.error,
          LogCategories.platform,
          'BY_SEARCH_HISTORY_SAVE_FAILED',
          'Failed to append search history item.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Clears the stored search history.
  Future<void> clearHistory() async {
    final result = await _repository.clearSearchHistory();
    result.when(
      success: (_) {
        final current = _getCurrentState();
        if (current != null) {
          setSuccess(current.copyWith(history: const []));
        }
      },
      failure: (f) {
        _logger.log(
          LogLevel.error,
          LogCategories.platform,
          'BY_SEARCH_HISTORY_CLEAR_FAILED',
          'Failed to erase search history list.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Updates text query and schedules a debounced execution.
  void updateQueryText(String text) {
    final current = _getCurrentState();
    if (current == null) return;

    final updatedQuery = current.query.copyWith(text: text);
    setSuccess(current.copyWith(query: updatedQuery));

    _debouncer.run(() {
      executeSearch();
      if (text.trim().isNotEmpty) {
        saveToHistory(text);
      }
    });
  }

  /// Sets the entire filters model and triggers search.
  void updateFilters(SearchFilters filters) {
    final current = _getCurrentState();
    if (current == null) return;

    final updatedQuery = current.query.copyWith(filters: filters);
    setSuccess(current.copyWith(query: updatedQuery));
    executeSearch();
  }

  /// Resets all active filters.
  void resetFilters() {
    final current = _getCurrentState();
    if (current == null) return;

    final updatedQuery = current.query.copyWith(filters: SearchFilters.empty());
    setSuccess(current.copyWith(query: updatedQuery));
    executeSearch();
  }

  /// Sets the sort field and direction and triggers search.
  void updateSort(SearchSort sort) {
    final current = _getCurrentState();
    if (current == null) return;

    final updatedQuery = current.query.copyWith(sort: sort);
    setSuccess(current.copyWith(query: updatedQuery));
    executeSearch();
  }

  /// Triggers direct on-device database queries using the active state query.
  Future<void> executeSearch() async {
    final current = _getCurrentState();
    if (current == null) return;

    _logger.log(
      LogLevel.debug,
      LogCategories.database,
      'BY_SEARCH_START',
      'Beginning transaction search queries.',
      metadata: {
        'term': current.query.text,
        'filters': current.query.filters.isAnyActive.toString(),
      },
    );

    final result = await _searchUseCase(current.query);
    result.when(
      success: (data) {
        final updatedCurrent = _getCurrentState();
        if (updatedCurrent != null) {
          setSuccess(updatedCurrent.copyWith(transactions: data));
        }
      },
      failure: (failure) {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_SEARCH_FAILED',
          'Transaction search logic encountered database error.',
          error: failure,
        );
        setError(failure);
      },
      loading: (_) => setLoading(),
      empty: () {
        final updatedCurrent = _getCurrentState();
        if (updatedCurrent != null) {
          setSuccess(updatedCurrent.copyWith(transactions: const []));
        }
      },
    );
  }

  SearchState? _getCurrentState() {
    return state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
  }
}
