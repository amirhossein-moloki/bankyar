import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../entities/transaction_category.dart';
import '../entities/transaction_details.dart';

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

  /// Fetches a paginated, filtered, and sorted list of transactions.
  Future<Result<List<ParsedTransaction>>> getTransactionsPaged({
    required int limit,
    required int offset,
    String? bankFilter,
    String? categoryId,
    String? typeFilter,
    String? searchQuery,
    String? sortBy,
    bool descending = true,
  });

  /// Retrieves full enriched transaction details.
  Future<Result<TransactionDetails>> getTransactionDetails(String id);

  /// Saves or updates a transaction's user text note.
  Future<Result<void>> saveNote(String transactionId, String text);

  /// Deletes a transaction's text note.
  Future<Result<void>> deleteNote(String transactionId);

  /// Assigns an existing category to a transaction.
  Future<Result<void>> assignCategory(String transactionId, String? categoryId);

  /// Replaces the tags assigned to a transaction.
  Future<Result<void>> assignTags(String transactionId, List<String> tags);

  /// Lists all available categories in the system.
  Future<Result<List<TransactionCategory>>> getCategories();

  /// Lists all tags present in the system.
  Future<Result<List<String>>> getTags();
}
