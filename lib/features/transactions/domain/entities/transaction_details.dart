import '../../../../core/architecture/entity.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import 'transaction_category.dart';

/// Pure domain entity representing a complete enriched transaction with details.
class TransactionDetails extends Entity<String> {
  /// Constructor defining all enriched metadata.
  const TransactionDetails({
    required String transactionId,
    required this.transaction,
    this.note,
    this.category,
    required this.tags,
    this.rawSmsText,
  }) : super(transactionId);

  /// Core parsed transaction entity.
  final ParsedTransaction transaction;

  /// Custom text note added by user.
  final String? note;

  /// Category associated with this transaction.
  final TransactionCategory? category;

  /// Custom list of search tags.
  final List<String> tags;

  /// The raw un-scrubbed original SMS carrier text body if processed via SMS.
  final String? rawSmsText;

  /// Copy constructor.
  TransactionDetails copyWith({
    ParsedTransaction? transaction,
    String? note,
    TransactionCategory? category,
    List<String>? tags,
    String? rawSmsText,
  }) {
    return TransactionDetails(
      transactionId: id,
      transaction: transaction ?? this.transaction,
      note: note ?? this.note,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      rawSmsText: rawSmsText ?? this.rawSmsText,
    );
  }
}
