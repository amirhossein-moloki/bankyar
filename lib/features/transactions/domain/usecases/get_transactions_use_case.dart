import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../repository/transaction_repository.dart';

/// Use case to watch chronological transaction feeds reactively.
class GetTransactionsUseCase
    extends StreamUseCase<Result<List<ParsedTransaction>>, NoParams> {
  /// Constructor injecting standard [TransactionRepository].
  GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Result<List<ParsedTransaction>>> call(NoParams params) {
    return _repository.watchTransactions();
  }
}
