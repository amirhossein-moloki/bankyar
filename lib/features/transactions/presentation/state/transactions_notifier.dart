import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/platform/sms_history_importer.dart';
import '../../../../core/state_management/base_providers.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/presentation/state/sms_detection_providers.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/repository/transaction_repository.dart';
import '../state/home_notifier.dart';
import 'transactions_state.dart';

/// Provider exposing list of system categories.
final categoriesListProvider =
    FutureProvider.autoDispose<List<TransactionCategory>>((ref) async {
      final repo = ref.watch(transactionRepositoryProvider);
      final result = await repo.getCategories();
      return result.when(
        success: (list) => list,
        failure: (f) => <TransactionCategory>[],
        loading: (_) => <TransactionCategory>[],
        empty: () => <TransactionCategory>[],
      );
    });

/// Provider exposing the [TransactionsNotifier] view model state.
final transactionsViewModelProvider =
    StateNotifierProvider.autoDispose<
      TransactionsNotifier,
      UiState<TransactionsState>
    >((ref) {
      final repository = ref.watch(transactionRepositoryProvider);
      final logger = ref.watch(loggerProvider);
      final importer = ref.watch(smsHistoryImporterProvider);
      return TransactionsNotifier(
        repository: repository,
        logger: logger,
        importer: importer,
      )..loadInitial();
    });

/// Riverpod StateNotifier controlling the Transactions Screen ledger operations,
/// pagination, searching, sorting, filters, and grouping.
class TransactionsNotifier extends BaseUiNotifier<TransactionsState> {
  /// Constructor.
  TransactionsNotifier({
    required TransactionRepository repository,
    required AppLogger logger,
    required SmsHistoryImporter importer,
  }) : _repository = repository,
       _logger = logger,
       _importer = importer;

  final TransactionRepository _repository;
  final AppLogger _logger;
  final SmsHistoryImporter _importer;

  /// Resets and loads the first page of transactions.
  Future<void> loadInitial() async {
    final currentState = state.when(
      initial: () => TransactionsState.initial(),
      loading: (_) => TransactionsState.initial(),
      error: (_) => TransactionsState.initial(),
      success: (d) => d,
    );

    setLoading();

    final result = await _repository.getTransactionsPaged(
      limit: currentState.limit,
      offset: 0,
      bankFilter: currentState.bankFilter,
      categoryId: currentState.categoryId,
      typeFilter: currentState.typeFilter,
      searchQuery: currentState.searchQuery,
      sortBy: currentState.sortBy,
      descending: currentState.descending,
    );

    result.when(
      success: (data) {
        setSuccess(
          currentState.copyWith(
            transactions: data,
            offset: data.length,
            hasMore: data.length >= currentState.limit,
            isLoadingMore: false,
          ),
        );
      },
      failure: (f) {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_LOAD_INITIAL_FAILED',
          'Failed to load initial transactions.',
          error: f,
        );
        setError(f);
      },
      loading: (_) => setLoading(),
      empty: () {
        setSuccess(
          currentState.copyWith(
            transactions: [],
            offset: 0,
            hasMore: false,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Loads the next page of transactions and appends them.
  Future<void> loadNextPage() async {
    final currentState = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );

    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    setSuccess(currentState.copyWith(isLoadingMore: true));

    final result = await _repository.getTransactionsPaged(
      limit: currentState.limit,
      offset: currentState.offset,
      bankFilter: currentState.bankFilter,
      categoryId: currentState.categoryId,
      typeFilter: currentState.typeFilter,
      searchQuery: currentState.searchQuery,
      sortBy: currentState.sortBy,
      descending: currentState.descending,
    );

    result.when(
      success: (data) {
        final List<dynamic> updatedList = [
          ...currentState.transactions,
          ...data,
        ];
        setSuccess(
          currentState.copyWith(
            transactions: updatedList.cast(),
            offset: currentState.offset + data.length,
            hasMore: data.length >= currentState.limit,
            isLoadingMore: false,
          ),
        );
      },
      failure: (f) {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_LOAD_MORE_FAILED',
          'Failed to load more transactions page.',
          error: f,
        );
        setSuccess(currentState.copyWith(isLoadingMore: false));
      },
      loading: (_) => null,
      empty: () {
        setSuccess(currentState.copyWith(hasMore: false, isLoadingMore: false));
      },
    );
  }

  /// Triggers full SMS inbox check and reloads initial dataset.
  Future<void> refresh() async {
    _logger.log(
      LogLevel.info,
      LogCategories.parser,
      'BY_TX_PULL_TO_REFRESH',
      'User pulled to refresh transactions.',
    );
    try {
      await _importer.performIncrementalSync();
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.parser,
        'BY_TX_REFRESH_IMPORT_ERROR',
        'Failed sync check during transaction list refresh.',
        error: e,
        stackTrace: stack,
      );
    }
    await loadInitial();
  }

  /// Updates search text query and refreshes.
  void setSearchQuery(String query) {
    _updateStateAndReload((s) => s.copyWith(searchQuery: query));
  }

  /// Updates bank filter option and refreshes.
  void setBankFilter(String bank) {
    _updateStateAndReload((s) => s.copyWith(bankFilter: bank));
  }

  /// Updates category filter option and refreshes.
  void setCategoryFilter(String? categoryId) {
    _updateStateAndReload((s) => s.copyWith(categoryId: () => categoryId));
  }

  /// Updates transaction type filter option and refreshes.
  void setTypeFilter(String type) {
    _updateStateAndReload((s) => s.copyWith(typeFilter: type));
  }

  /// Updates sort criteria and refreshes.
  void setSortBy(String field, bool descending) {
    _updateStateAndReload(
      (s) => s.copyWith(sortBy: field, descending: descending),
    );
  }

  /// Sets the display grouping.
  void setGroupBy(String group) {
    final currentState = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
    if (currentState != null) {
      setSuccess(currentState.copyWith(groupBy: group));
    }
  }

  void _updateStateAndReload(
    TransactionsState Function(TransactionsState) updater,
  ) {
    final currentState = state.when(
      initial: () => TransactionsState.initial(),
      loading: (_) => TransactionsState.initial(),
      error: (_) => TransactionsState.initial(),
      success: (d) => d,
    );
    final newState = updater(currentState);
    state = UiState.success(newState);
    loadInitial();
  }
}
