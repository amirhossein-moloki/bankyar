import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/architecture/use_case.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/platform/sms_history_importer.dart';
import '../../../../core/state_management/base_providers.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../../sms_detection/presentation/state/sms_detection_providers.dart';
import '../../data/datasources/transaction_dao.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repository/transaction_repository.dart';
import '../../domain/usecases/get_transactions_use_case.dart';
import 'home_state.dart';

/// Provider exposing the relational [TransactionDao].
final transactionDaoProvider = Provider<TransactionDao>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final logger = ref.watch(loggerProvider);
  return TransactionDao(dbService, logger);
});

/// Provider exposing the abstract [TransactionRepository] interface.
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return TransactionRepositoryImpl(dao);
});

/// Provider exposing the [GetTransactionsUseCase] business action.
final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCase(repository);
});

/// Provider exposing the [HomeNotifier] view model as a reactive state holder.
final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeNotifier, UiState<HomeState>>((ref) {
      final useCase = ref.watch(getTransactionsUseCaseProvider);
      final logger = ref.watch(loggerProvider);
      return HomeNotifier(
        getTransactionsUseCase: useCase,
        logger: logger,
        ref: ref,
      );
    });

/// Riverpod StateNotifier controlling the Home Dashboard operations, aggregations,
/// visibility masking, bank filter queries, and chronological feed streams.
class HomeNotifier extends BaseUiNotifier<HomeState> {
  /// Constructor starting stream listening on boot.
  HomeNotifier({
    required GetTransactionsUseCase getTransactionsUseCase,
    required AppLogger logger,
    required Ref ref,
  }) : _getTransactionsUseCase = getTransactionsUseCase,
       _logger = logger,
       _ref = ref {
    _loadVisibilityAndSubscribe();
  }

  final GetTransactionsUseCase _getTransactionsUseCase;
  final AppLogger _logger;
  final Ref _ref;
  StreamSubscription<Result<List<ParsedTransaction>>>? _subscription;
  List<ParsedTransaction> _rawTransactions = [];
  bool _isObscured = false;
  String _selectedBankFilter = 'All';

  static const String _balanceObscuredPrefKey = 'by_balance_obscured';

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadVisibilityAndSubscribe() async {
    try {
      final prefs = _ref.read(preferencesStorageProvider);
      final obscured = await prefs.getBool(_balanceObscuredPrefKey);
      _isObscured = obscured ?? false;
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_HOME_LOAD_VISIBILITY_FAILED',
        'Could not load saved balance visibility.',
        error: e,
      );
    }
    _subscribeToTransactions();
  }

  void _subscribeToTransactions() {
    setLoading();
    _subscription?.cancel();
    _subscription = _getTransactionsUseCase(const NoParams()).listen(
      (result) {
        result.when(
          success: (transactions) {
            _rawTransactions = transactions;
            _recomputeAndPublish();
          },
          failure: (failure) {
            _logger.log(
              LogLevel.error,
              LogCategories.database,
              'BY_HOME_SUBSCRIBE_FAILED',
              'Failed to read ledger streams.',
              error: failure,
            );
            setError(failure);
          },
          loading: (_) => setLoading(),
          empty: () => _publishEmpty(),
        );
      },
      onError: (err, stack) {
        final failure = DatabaseCorruptionFailure(
          code: 'BY_HOME_STREAM_EXCEPTION',
          message: 'Stream encountered unhandled error: ${err.toString()}',
        );
        setError(failure);
      },
    );
  }

  /// Triggers a pull-to-refresh reload, forcing historical SMS ingestion checks.
  Future<void> refresh() async {
    _logger.log(
      LogLevel.info,
      LogCategories.parser,
      'BY_HOME_PULL_TO_REFRESH',
      'User pulled to refresh. Rescanning SMS history.',
    );
    try {
      final importer = _ref.read(smsHistoryImporterProvider);
      await importer.performIncrementalSync();
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.parser,
        'BY_HOME_REFRESH_IMPORT_ERROR',
        'Failed to import historical SMS during refresh.',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Toggles sensitive cash value masking and shoulder-surfing protection overlays.
  void toggleVisibility() {
    _isObscured = !_isObscured;
    _recomputeAndPublish();

    _ref
        .read(preferencesStorageProvider)
        .setBool(_balanceObscuredPrefKey, _isObscured)
        .catchError((Object e) {
          _logger.log(
            LogLevel.error,
            LogCategories.platform,
            'BY_HOME_SAVE_VISIBILITY_FAILED',
            'Failed to save balance visibility.',
            error: e,
          );
        });
  }

  /// Filters the chronological list by matching bank/institution names.
  void selectBankFilter(String bankFilter) {
    _selectedBankFilter = bankFilter;
    _recomputeAndPublish();
  }

  void _publishEmpty() {
    setSuccess(HomeState.empty());
  }

  void _recomputeAndPublish() {
    double total = 0.0;
    double income = 0.0;
    double expense = 0.0;

    for (final tx in _rawTransactions) {
      final amt = tx.amount;
      if (tx.transactionType == SmsTransactionType.credit) {
        income += amt;
        total += amt;
      } else if (tx.transactionType == SmsTransactionType.debit) {
        expense += amt;
        total -= amt;
      }
    }

    final filtered = _rawTransactions.where((tx) {
      if (_selectedBankFilter == 'All') return true;
      final source = tx.sourceSmsId != null ? tx.rawMerchant : '';
      return tx.normalizedMerchant.toLowerCase().contains(
            _selectedBankFilter.toLowerCase(),
          ) ||
          source.toLowerCase().contains(_selectedBankFilter.toLowerCase()) ||
          (tx.cardIdentifier != null &&
              tx.cardIdentifier!.contains(_selectedBankFilter));
    }).toList();

    setSuccess(
      HomeState(
        transactions: filtered,
        totalBalance: total,
        monthlyIncome: income,
        monthlyExpense: expense,
        isObscured: _isObscured,
        selectedBankFilter: _selectedBankFilter,
      ),
    );
  }
}
