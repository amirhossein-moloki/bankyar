import '../../../../core/database/sqlite_base_dao.dart';
import '../../domain/entities/bank_message_entity.dart';
import '../models/bank_message_dto.dart';

/// Relational relational Data Access Object mapping [BankMessageEntity] to SQLite page pages.
class BankMessageDao extends SqliteBaseDao<BankMessageEntity> {
  /// Constructor injecting DB Service and standard logger.
  BankMessageDao(super.dbService, super.logger);

  @override
  String get tableName => 'bank_messages';

  @override
  String get chronologicalColumn => 'received_at';

  @override
  Map<String, dynamic> toMap(BankMessageEntity entity) {
    return BankMessageDto.toMap(entity);
  }

  @override
  BankMessageEntity fromMap(Map<String, dynamic> map) {
    return BankMessageDto.fromMap(map);
  }
}
