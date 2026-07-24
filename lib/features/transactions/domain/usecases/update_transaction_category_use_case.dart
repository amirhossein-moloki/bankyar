import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../repository/transaction_repository.dart';

/// Params class for updating category.
class UpdateCategoryParams {
  /// Constructor.
  const UpdateCategoryParams({required this.transactionId, this.categoryId});

  /// ID of target transaction.
  final String transactionId;

  /// ID of category to assign. Null to unassign.
  final String? categoryId;
}

/// Use case to assign/update a transaction's category.
class UpdateTransactionCategoryUseCase
    extends UseCase<Result<void>, UpdateCategoryParams> {
  /// Constructor.
  UpdateTransactionCategoryUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(UpdateCategoryParams params) {
    return _repository.assignCategory(params.transactionId, params.categoryId);
  }
}
