import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../entities/transaction_details.dart';
import '../repository/transaction_repository.dart';

/// Use case to fetch full enriched transaction details.
class GetTransactionDetailsUseCase
    extends UseCase<Result<TransactionDetails>, String> {
  /// Constructor.
  GetTransactionDetailsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<TransactionDetails>> call(String params) {
    return _repository.getTransactionDetails(params);
  }
}
