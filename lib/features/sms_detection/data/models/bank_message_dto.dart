import '../../domain/entities/bank_message_entity.dart';

/// Data Transfer Object containing JSON/Relational mapping utilities for [BankMessageEntity].
class BankMessageDto {
  const BankMessageDto._();

  /// Converts a [BankMessageEntity] to a standard SQL database row map.
  static Map<String, dynamic> toMap(BankMessageEntity entity) {
    return {
      'id': entity.id,
      'raw_text': entity.rawText,
      'sender_id': entity.senderId,
      'received_at': entity.receivedAt,
      'deduplication_hash': entity.deduplicationHash,
      'ingestion_status': entity.ingestionStatus.name,
    };
  }

  /// Re-constructs a [BankMessageEntity] from a standard SQL database row map.
  static BankMessageEntity fromMap(Map<String, dynamic> map) {
    return BankMessageEntity(
      id: map['id'] as String,
      rawText: map['raw_text'] as String,
      senderId: map['sender_id'] as String,
      receivedAt: map['received_at'] as int,
      deduplicationHash: map['deduplication_hash'] as String,
      ingestionStatus: IngestionStatus.values.byName(
        map['ingestion_status'] as String,
      ),
    );
  }
}
