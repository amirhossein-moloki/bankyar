import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Abstract contract for Transaction Ledger operations and updates.
abstract class TransactionRepository {
  /// Watches the chronological stream of all parsed transactions.
  Stream<Result<List<ParsedTransaction>>> watchTransactions();

  /// Fetches a static chronological list of all parsed transactions.
  Future<Result<List<ParsedTransaction>>> getTransactions();

  /// Direct transaction ledger write.
  Future<Result<void>> saveTransaction(ParsedTransaction transaction);

  /// Direct transaction ledger record deletion.
  Future<Result<void>> deleteTransaction(String id);
}
