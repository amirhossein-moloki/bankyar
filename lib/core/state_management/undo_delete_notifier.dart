import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/sms_detection/domain/entities/parsed_transaction.dart';
import '../../features/transactions/domain/repository/transaction_repository.dart';
import '../../features/transactions/presentation/state/home_notifier.dart';
import '../di/dependency_injection.dart';
import '../logging/logger.dart';

/// Holds the in-memory pending deletions state for safe undo actions.
class UndoDeleteState {
  /// Constructor.
  const UndoDeleteState({
    this.pendingTransactionIds = const {},
    this.pendingNoteTransactionIds = const {},
    this.pendingDeletedNotes = const {},
  });

  /// Transaction IDs that are temporarily deleted and hidden from the UI.
  final Set<String> pendingTransactionIds;

  /// Transaction IDs whose notes are temporarily deleted and hidden from the UI.
  final Set<String> pendingNoteTransactionIds;

  /// Keeps a copy of notes being deleted (transactionId -> noteText) to restore if Undo is clicked.
  final Map<String, String> pendingDeletedNotes;

  /// Factory for clean copy-with modifications.
  UndoDeleteState copyWith({
    Set<String>? pendingTransactionIds,
    Set<String>? pendingNoteTransactionIds,
    Map<String, String>? pendingDeletedNotes,
  }) {
    return UndoDeleteState(
      pendingTransactionIds:
          pendingTransactionIds ?? this.pendingTransactionIds,
      pendingNoteTransactionIds:
          pendingNoteTransactionIds ?? this.pendingNoteTransactionIds,
      pendingDeletedNotes: pendingDeletedNotes ?? this.pendingDeletedNotes,
    );
  }
}

/// Global StateNotifier managing deferred deletions and safe undo actions with exact Persian translations.
class UndoDeleteNotifier extends StateNotifier<UndoDeleteState> {
  /// Constructor.
  UndoDeleteNotifier({
    required TransactionRepository transactionRepository,
    required AppLogger logger,
  }) : _transactionRepository = transactionRepository,
       _logger = logger,
       super(const UndoDeleteState());

  final TransactionRepository _transactionRepository;
  final AppLogger _logger;

  Timer? _activeTimer;
  String? _activeUndoType; // 'transaction' or 'note'
  List<String> _activeIds = [];

  /// Forces any current pending deletion to be immediately completed/committed.
  /// Used to ensure rapid sequential deletions don't interfere and that "only one Undo snackbar is visible at a time".
  void cancelActiveUndoAndCommit() {
    if (_activeTimer != null) {
      _activeTimer!.cancel();
      _activeTimer = null;
      _commitDeletion();
    }
  }

  void _commitDeletion() async {
    final type = _activeUndoType;
    final ids = List<String>.from(_activeIds);
    _activeUndoType = null;
    _activeIds.clear();

    if (type == 'transaction') {
      try {
        await _transactionRepository.deleteTransactions(ids);
        _logger.log(
          LogLevel.info,
          LogCategories.database,
          'BY_UNDO_DELETE_COMMIT_TX',
          'Permanently deleted transactions from DB.',
          metadata: {'ids': ids},
        );
      } catch (e, stack) {
        _logger.log(
          LogLevel.error,
          LogCategories.database,
          'BY_UNDO_DELETE_COMMIT_TX_FAILED',
          'Failed permanent delete of transactions.',
          error: e,
          stackTrace: stack,
        );
      }
    } else if (type == 'note') {
      for (final txId in ids) {
        try {
          await _transactionRepository.deleteNote(txId);
          _logger.log(
            LogLevel.info,
            LogCategories.database,
            'BY_UNDO_DELETE_COMMIT_NOTE',
            'Permanently deleted notes from DB.',
            metadata: {'transactionId': txId},
          );
        } catch (e, stack) {
          _logger.log(
            LogLevel.error,
            LogCategories.database,
            'BY_UNDO_DELETE_COMMIT_NOTE_FAILED',
            'Failed permanent delete of notes.',
            error: e,
            stackTrace: stack,
          );
        }
      }
    }

    // Safely remove the committed IDs from pending state
    state = state.copyWith(
      pendingTransactionIds: state.pendingTransactionIds.difference(
        ids.toSet(),
      ),
      pendingNoteTransactionIds: state.pendingNoteTransactionIds.difference(
        ids.toSet(),
      ),
      pendingDeletedNotes: Map<String, String>.from(state.pendingDeletedNotes)
        ..removeWhere((k, v) => ids.contains(k)),
    );
  }

  /// Registers a transaction deletion, hides it immediately, and schedules the 5s timer.
  void deleteTransaction(
    BuildContext context,
    ParsedTransaction tx,
    VoidCallback onRefreshes,
  ) {
    cancelActiveUndoAndCommit();

    final txId = tx.id;
    _activeUndoType = 'transaction';
    _activeIds = [txId];

    state = state.copyWith(
      pendingTransactionIds: {...state.pendingTransactionIds, txId},
    );

    // Refresh UI list and summary states instantly
    onRefreshes();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text(
              'تراکنش حذف شد.',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
            action: SnackBarAction(
              label: 'بازگردانی',
              textColor: Colors.amber,
              onPressed: () {
                // Cancel timer & restore!
                _activeTimer?.cancel();
                _activeTimer = null;
                _activeUndoType = null;
                _activeIds.clear();

                state = state.copyWith(
                  pendingTransactionIds: state.pendingTransactionIds.difference(
                    {txId},
                  ),
                );

                onRefreshes();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        )
        .closed
        .then((reason) {
          if (reason != SnackBarClosedReason.action &&
              _activeUndoType == 'transaction' &&
              _activeIds.contains(txId)) {
            _commitDeletion();
          }
        });

    _activeTimer = Timer(const Duration(seconds: 5), () {
      _commitDeletion();
    });
  }

  /// Registers multiple transaction deletions (batch delete), hides them immediately, and schedules the 5s timer.
  void deleteTransactions(
    BuildContext context,
    List<String> txIds,
    VoidCallback onRefreshes,
  ) {
    cancelActiveUndoAndCommit();

    _activeUndoType = 'transaction';
    _activeIds = List<String>.from(txIds);

    state = state.copyWith(
      pendingTransactionIds: {...state.pendingTransactionIds, ...txIds},
    );

    onRefreshes();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text(
              'تراکنش‌ها حذف شدند.',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
            action: SnackBarAction(
              label: 'بازگردانی',
              textColor: Colors.amber,
              onPressed: () {
                _activeTimer?.cancel();
                _activeTimer = null;
                _activeUndoType = null;
                _activeIds.clear();

                state = state.copyWith(
                  pendingTransactionIds: state.pendingTransactionIds.difference(
                    txIds.toSet(),
                  ),
                );

                onRefreshes();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        )
        .closed
        .then((reason) {
          if (reason != SnackBarClosedReason.action &&
              _activeUndoType == 'transaction' &&
              _activeIds.isNotEmpty) {
            _commitDeletion();
          }
        });

    _activeTimer = Timer(const Duration(seconds: 5), () {
      _commitDeletion();
    });
  }

  /// Registers a note deletion, hides it immediately, and schedules the 5s timer.
  void deleteNote(
    BuildContext context,
    String transactionId,
    String currentNoteText,
    VoidCallback onRefreshes,
  ) {
    cancelActiveUndoAndCommit();

    _activeUndoType = 'note';
    _activeIds = [transactionId];

    state = state.copyWith(
      pendingNoteTransactionIds: {
        ...state.pendingNoteTransactionIds,
        transactionId,
      },
      pendingDeletedNotes: {
        ...state.pendingDeletedNotes,
        transactionId: currentNoteText,
      },
    );

    onRefreshes();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text(
              'یادداشت حذف شد.',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
            action: SnackBarAction(
              label: 'بازگردانی',
              textColor: Colors.amber,
              onPressed: () {
                _activeTimer?.cancel();
                _activeTimer = null;
                _activeUndoType = null;
                _activeIds.clear();

                state = state.copyWith(
                  pendingNoteTransactionIds: state.pendingNoteTransactionIds
                      .difference({transactionId}),
                  pendingDeletedNotes: Map<String, String>.from(
                    state.pendingDeletedNotes,
                  )..remove(transactionId),
                );

                onRefreshes();
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        )
        .closed
        .then((reason) {
          if (reason != SnackBarClosedReason.action &&
              _activeUndoType == 'note' &&
              _activeIds.contains(transactionId)) {
            _commitDeletion();
          }
        });

    _activeTimer = Timer(const Duration(seconds: 5), () {
      _commitDeletion();
    });
  }

  @override
  void dispose() {
    _activeTimer?.cancel();
    super.dispose();
  }
}

/// Provider exposing the central `UndoDeleteNotifier` state.
final undoDeleteProvider =
    StateNotifierProvider<UndoDeleteNotifier, UndoDeleteState>((ref) {
      final repo = ref.watch(transactionRepositoryProvider);
      final logger = ref.watch(loggerProvider);
      return UndoDeleteNotifier(transactionRepository: repo, logger: logger);
    });
