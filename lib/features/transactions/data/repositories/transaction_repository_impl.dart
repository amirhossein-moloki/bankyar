import '../../../../core/architecture/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/repository/transaction_repository.dart';
import '../datasources/transaction_dao.dart';

/// Concrete database-bound implementation of [TransactionRepository].
/// Handles ledger transaction querying, listening, and modification safely.
class TransactionRepositoryImpl extends BaseRepository
    implements TransactionRepository {
  /// Constructor injecting standard [TransactionDao].
  const TransactionRepositoryImpl(this._transactionDao);

  final TransactionDao _transactionDao;

  @override
  Stream<Result<List<ParsedTransaction>>> watchTransactions() {
    return pipeSafeStream(
      _transactionDao.getChronologicalStream().map((r) {
        if (r is FailureResult<List<ParsedTransaction>>) {
          throw r.failure;
        }
        return (r as Success<List<ParsedTransaction>>).data;
      }),
    );
  }

  @override
  Future<Result<List<ParsedTransaction>>> getTransactions() {
    return executeSafe(() async {
      final result = await _transactionDao.getChronologicalList();
      if (result is FailureResult<List<ParsedTransaction>>) {
        throw result.failure;
      }
      return (result as Success<List<ParsedTransaction>>).data;
    });
  }

  @override
  Future<Result<void>> saveTransaction(ParsedTransaction transaction) {
    return executeSafe(() async {
      final result = await _transactionDao.insert(transaction);
      if (result is FailureResult<void>) {
        throw result.failure;
      }
    });
  }

  @override
  Future<Result<void>> deleteTransaction(String id) {
    return executeSafe(() async {
      final result = await _transactionDao.delete(id);
      if (result is FailureResult<void>) {
        throw result.failure;
      }
    });
  }
}
