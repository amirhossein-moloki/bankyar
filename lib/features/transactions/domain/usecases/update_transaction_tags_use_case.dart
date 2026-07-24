import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../repository/transaction_repository.dart';

/// Params class for updating tags.
class UpdateTagsParams {
  /// Constructor.
  const UpdateTagsParams({required this.transactionId, required this.tags});

  /// ID of target transaction.
  final String transactionId;

  /// Full list of active tags to assign.
  final List<String> tags;
}

/// Use case to update/assign tags to a transaction.
class UpdateTransactionTagsUseCase
    extends UseCase<Result<void>, UpdateTagsParams> {
  /// Constructor.
  UpdateTransactionTagsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(UpdateTagsParams params) {
    return _repository.assignTags(params.transactionId, params.tags);
  }
}
