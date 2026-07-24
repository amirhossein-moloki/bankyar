import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/state_management/base_providers.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/transaction_details.dart';
import '../../domain/repository/transaction_repository.dart';
import '../state/home_notifier.dart';

/// Provider exposing the [TransactionDetailsNotifier] for a given transaction ID.
final transactionDetailsViewModelProvider = StateNotifierProvider.family
    .autoDispose<
      TransactionDetailsNotifier,
      UiState<TransactionDetails>,
      String
    >((ref, transactionId) {
      final repository = ref.watch(transactionRepositoryProvider);
      final logger = ref.watch(loggerProvider);
      return TransactionDetailsNotifier(
        transactionId: transactionId,
        repository: repository,
        logger: logger,
      )..loadDetails();
    });

/// Riverpod StateNotifier controlling the Transaction Details Screen actions, notes CRUD,
/// and categorization/tag edits.
class TransactionDetailsNotifier extends BaseUiNotifier<TransactionDetails> {
  /// Constructor.
  TransactionDetailsNotifier({
    required this.transactionId,
    required TransactionRepository repository,
    required AppLogger logger,
  }) : _repository = repository,
       _logger = logger;

  /// Target transaction unique identifier.
  final String transactionId;

  final TransactionRepository _repository;
  final AppLogger _logger;

  /// Loads full enriched transaction details from database.
  Future<void> loadDetails() async {
    setLoading();
    final result = await _repository.getTransactionDetails(transactionId);
    result.when(
      success: (details) {
        setSuccess(details);
      },
      failure: (f) {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_LOAD_DETAILS_FAILED',
          'Failed to load transaction details.',
          metadata: {'id': transactionId},
          error: f,
        );
        setError(f);
      },
      loading: (_) => setLoading(),
      empty: () => setError(
        const DatabaseCorruptionFailure(
          code: 'BY_TX_NOT_FOUND',
          message: 'The requested transaction was not found.',
        ),
      ),
    );
  }

  /// Verifies/Confirms a heuristic parsed transaction, promoting confidence score.
  Future<void> verifyTransaction() async {
    final currentDetails = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
    if (currentDetails == null) return;

    final updatedTx = currentDetails.transaction.copyWith(
      confidenceScore: 1.0,
      parsingMethod: 'verified',
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final saveResult = await _repository.saveTransaction(updatedTx);
    await saveResult.when(
      success: (_) async {
        await loadDetails();
      },
      failure: (f) async {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_VERIFY_FAILED',
          'Failed to verify transaction.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Saves or updates the transaction notes text.
  Future<void> saveNote(String text) async {
    final currentDetails = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
    if (currentDetails == null) return;

    final result = await _repository.saveNote(transactionId, text);
    await result.when(
      success: (_) async {
        await loadDetails();
      },
      failure: (f) async {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_SAVE_NOTE_FAILED',
          'Failed to save transaction note.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Deletes the transaction user note.
  Future<void> deleteNote() async {
    final currentDetails = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
    if (currentDetails == null) return;

    final result = await _repository.deleteNote(transactionId);
    await result.when(
      success: (_) async {
        await loadDetails();
      },
      failure: (f) async {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_DELETE_NOTE_FAILED',
          'Failed to delete note.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Assigns a category ID to the transaction.
  Future<void> assignCategory(String? categoryId) async {
    final currentDetails = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
    if (currentDetails == null) return;

    final result = await _repository.assignCategory(transactionId, categoryId);
    await result.when(
      success: (_) async {
        await loadDetails();
      },
      failure: (f) async {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_ASSIGN_CATEGORY_FAILED',
          'Failed to assign category.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Assigns a new set of tag labels to the transaction.
  Future<void> assignTags(List<String> tags) async {
    final currentDetails = state.when(
      initial: () => null,
      loading: (_) => null,
      error: (_) => null,
      success: (d) => d,
    );
    if (currentDetails == null) return;

    final result = await _repository.assignTags(transactionId, tags);
    await result.when(
      success: (_) async {
        await loadDetails();
      },
      failure: (f) async {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_TX_ASSIGN_TAGS_FAILED',
          'Failed to assign tags.',
          error: f,
        );
      },
      loading: (_) => null,
      empty: () => null,
    );
  }

  /// Permanently deletes this transaction record.
  Future<Result<void>> deleteTransaction() async {
    return _repository.deleteTransaction(transactionId);
  }
}
