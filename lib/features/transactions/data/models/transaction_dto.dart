import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Data Transfer Object containing SQL/Relational mapping utilities for [ParsedTransaction].
class TransactionDto {
  const TransactionDto._();

  /// Converts a [ParsedTransaction] to a standard SQL database row map.
  static Map<String, dynamic> toMap(ParsedTransaction tx) {
    return {
      'id': tx.id,
      'amount': tx.amount,
      'currency': tx.currency,
      'transaction_type': tx.transactionType.name,
      'raw_merchant': tx.rawMerchant,
      'normalized_merchant': tx.normalizedMerchant,
      'card_identifier': tx.cardIdentifier,
      'timestamp': tx.timestamp,
      'category_id': tx.categoryId,
      'source_sms_id': tx.sourceSmsId,
      'account_id': tx.accountId,
      'confidence_score': tx.confidenceScore,
      'parsing_method': tx.parsingMethod,
      'created_at': tx.createdAt,
      'updated_at': tx.updatedAt,
      'version': 1,
    };
  }

  /// Re-constructs a [ParsedTransaction] from a standard SQL database row map.
  static ParsedTransaction fromMap(Map<String, dynamic> map) {
    return ParsedTransaction(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      transactionType: SmsTransactionType.values.byName(
        map['transaction_type'] as String,
      ),
      rawMerchant: map['raw_merchant'] as String,
      normalizedMerchant: map['normalized_merchant'] as String,
      cardIdentifier: map['card_identifier'] as String?,
      timestamp: map['timestamp'] as int,
      categoryId: map['category_id'] as String?,
      sourceSmsId: map['source_sms_id'] as String?,
      accountId: map['account_id'] as String?,
      confidenceScore: (map['confidence_score'] as num).toDouble(),
      parsingMethod: map['parsing_method'] as String,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }
}
