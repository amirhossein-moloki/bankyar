import '../../../../core/architecture/entity.dart';

/// Enum representing the transaction directional flow.
enum SmsTransactionType {
  /// Money flowing into the account (e.g., credit, deposit, refund).
  credit,

  /// Money flowing out of the account (e.g., debit, purchase, transfer).
  debit,

  /// Directional flow is unknown or ambiguous.
  unknown,
}

/// Domain entity representing a transaction extracted from an SMS message.
class ParsedTransaction extends Entity<String> {
  /// Constructor defining a fully structured transaction entity extracted from SMS.
  const ParsedTransaction({
    required String id,
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.rawMerchant,
    required this.normalizedMerchant,
    this.cardIdentifier,
    required this.timestamp,
    this.categoryId,
    this.sourceSmsId,
    this.accountId,
    required this.confidenceScore,
    required this.parsingMethod,
    required this.createdAt,
    required this.updatedAt,
    this.balance,
    this.referenceNumber,
  }) : super(id);

  /// The processed decimal transaction amount.
  final double amount;

  /// Currency code of the transaction (e.g. 'IRR', 'Rial', 'Toman').
  final String currency;

  /// Direction of the fund flow (Debit/Credit).
  final SmsTransactionType transactionType;

  /// The raw un-sanitized merchant string extracted from the text.
  final String rawMerchant;

  /// The clean, normalized merchant label for search indexing and categorization.
  final String normalizedMerchant;

  /// Suffix digits or masks identifier of the card/account involved (e.g. '1234').
  final String? cardIdentifier;

  /// The exact epoch timestamp in milliseconds when the transaction occurred.
  final int timestamp;

  /// Associated category unique identifier.
  final String? categoryId;

  /// Reference link back to the source bank SMS entry.
  final String? sourceSmsId;

  /// Associated user bank account identifier.
  final String? accountId;

  /// Pipeline accuracy confidence evaluation score between 0.0 and 1.0.
  final double confidenceScore;

  /// The method used to parse this entry (e.g., 'deterministic', 'heuristic').
  final String parsingMethod;

  /// Timestamp in milliseconds indicating when this record was appended locally.
  final int createdAt;

  /// Timestamp in milliseconds indicating the last modification event.
  final int updatedAt;

  /// Resulting account balance post-transaction, if available.
  final double? balance;

  /// Tracking code or payment reference number extracted from text, if available.
  final String? referenceNumber;

  /// Creates a copy of this transaction with modified fields.
  ParsedTransaction copyWith({
    String? id,
    double? amount,
    String? currency,
    SmsTransactionType? transactionType,
    String? rawMerchant,
    String? normalizedMerchant,
    String? cardIdentifier,
    int? timestamp,
    String? categoryId,
    String? sourceSmsId,
    String? accountId,
    double? confidenceScore,
    String? parsingMethod,
    int? createdAt,
    int? updatedAt,
    double? balance,
    String? referenceNumber,
  }) {
    return ParsedTransaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      transactionType: transactionType ?? this.transactionType,
      rawMerchant: rawMerchant ?? this.rawMerchant,
      normalizedMerchant: normalizedMerchant ?? this.normalizedMerchant,
      cardIdentifier: cardIdentifier ?? this.cardIdentifier,
      timestamp: timestamp ?? this.timestamp,
      categoryId: categoryId ?? this.categoryId,
      sourceSmsId: sourceSmsId ?? this.sourceSmsId,
      accountId: accountId ?? this.accountId,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      parsingMethod: parsingMethod ?? this.parsingMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      balance: balance ?? this.balance,
      referenceNumber: referenceNumber ?? this.referenceNumber,
    );
  }
}
