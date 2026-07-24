import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../repository/transaction_repository.dart';

/// Params class for updating/deleting transaction note.
class UpdateNoteParams {
  /// Constructor.
  const UpdateNoteParams({required this.transactionId, required this.noteText});

  /// ID of target transaction.
  final String transactionId;

  /// Note text. If empty or null, note is deleted.
  final String? noteText;
}

/// Use case to save/update/delete a transaction's user note.
class UpdateTransactionNoteUseCase
    extends UseCase<Result<void>, UpdateNoteParams> {
  /// Constructor.
  UpdateTransactionNoteUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(UpdateNoteParams params) {
    final noteText = params.noteText;
    if (noteText == null || noteText.trim().isEmpty) {
      return _repository.deleteNote(params.transactionId);
    }
    return _repository.saveNote(params.transactionId, noteText.trim());
  }
}
