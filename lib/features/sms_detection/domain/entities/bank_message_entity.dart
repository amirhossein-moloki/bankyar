import '../../../../core/architecture/entity.dart';

/// Enum representing the processing status of a captured banking message.
enum IngestionStatus {
  /// Message parsed completely and successfully persisted.
  success,

  /// Message failed to parse but logged for manual inspection.
  failure,

  /// Message did not match any banking criteria and was filtered/ignored.
  ignored,

  /// Message was detected as a duplicate and was rejected.
  duplicate,
}

/// Domain entity representing a captured SMS message from a financial sender.
class BankMessageEntity extends Entity<String> {
  /// Constructor for a captured bank message entity.
  const BankMessageEntity({
    required String id,
    required this.rawText,
    required this.senderId,
    required this.receivedAt,
    required this.deduplicationHash,
    required this.ingestionStatus,
  }) : super(id);

  /// The raw, un-scrubbed text body of the incoming SMS message.
  final String rawText;

  /// The official sender identifier/address (e.g., 'Melli', 'Saman').
  final String senderId;

  /// The milliseconds-since-epoch epoch timestamp when the SMS was received.
  final int receivedAt;

  /// SHA-256 deduplication identifier signature of this transaction broadcast.
  final String deduplicationHash;

  /// The current pipeline state status of the message.
  final IngestionStatus ingestionStatus;

  /// Creates a copy of this entity with modified fields.
  BankMessageEntity copyWith({
    String? id,
    String? rawText,
    String? senderId,
    int? receivedAt,
    String? deduplicationHash,
    IngestionStatus? ingestionStatus,
  }) {
    return BankMessageEntity(
      id: id ?? this.id,
      rawText: rawText ?? this.rawText,
      senderId: senderId ?? this.senderId,
      receivedAt: receivedAt ?? this.receivedAt,
      deduplicationHash: deduplicationHash ?? this.deduplicationHash,
      ingestionStatus: ingestionStatus ?? this.ingestionStatus,
    );
  }
}
