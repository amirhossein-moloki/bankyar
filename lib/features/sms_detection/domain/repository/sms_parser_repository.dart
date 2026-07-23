import '../../../../core/utils/result.dart';
import '../entities/bank_message_entity.dart';
import '../entities/parsed_transaction.dart';

/// Abstract domain contract governing SMS message interception, ingestion,
/// modular processing, and secure transaction ledger saving.
abstract class SmsParserRepository {
  /// Core pipeline entrypoint: accepts a raw incoming SMS payload,
  /// parses metadata, verifies signatures, checks for duplication,
  /// determines categories, and persists structured logs to encrypted tables.
  ///
  /// Returns a [ParsedTransaction] if a valid financial message is parsed,
  /// or `null` if the message is filtered, ignored, or detected as a duplicate.
  Future<Result<ParsedTransaction?>> processAndSaveSms({
    required String rawText,
    required String senderId,
    required int receivedAt,
  });

  /// Cryptographic signature lookup: check if this SHA-256 deduplication
  /// signature hash is already stored in the relational `bank_messages` table.
  Future<Result<bool>> isDuplicate(String deduplicationHash);

  /// Direct save of an audited [BankMessageEntity] record to disk.
  Future<Result<void>> saveBankMessage(BankMessageEntity message);

  /// Find a captured banking message by its unique identifier.
  Future<Result<BankMessageEntity?>> getBankMessageById(String id);

  /// Direct save of an extracted [ParsedTransaction] record to the ledger.
  Future<Result<void>> saveParsedTransaction(ParsedTransaction transaction);
}
