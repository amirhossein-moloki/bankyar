import 'sms_classification.dart';
import '../../features/sms_detection/domain/entities/parsed_transaction.dart';

/// Represents a flexible template for matching and parsing banking SMS formats.
class BankSmsTemplate {
  const BankSmsTemplate({
    required this.id,
    required this.pattern,
    required this.classification,
    required this.direction,
    this.amountPattern,
    this.balancePattern,
    this.cardPattern,
    this.refPattern,
    this.merchantPattern,
  });

  /// Unique template ID.
  final String id;

  /// RegExp or fuzzy match pattern to identify if this template matches the SMS text.
  final RegExp pattern;

  /// Classification category of this template.
  final SmsClassification classification;

  /// Default transaction direction (Credit/Debit/Unknown).
  final SmsTransactionType direction;

  /// Optional specialized regex to extract the amount from matched texts.
  final RegExp? amountPattern;

  /// Optional specialized regex to extract the balance.
  final RegExp? balancePattern;

  /// Optional specialized regex to extract card or account identifier.
  final RegExp? cardPattern;

  /// Optional specialized regex to extract reference or tracking code.
  final RegExp? refPattern;

  /// Optional specialized regex to extract merchant name.
  final RegExp? merchantPattern;
}
