import '../../../../core/database/sqlite_base_dao.dart';
import '../../domain/entities/notification_item.dart';

/// Relational Data Access Object mapping [NotificationItem] to SQLite notifications table.
class NotificationDao extends SqliteBaseDao<NotificationItem> {
  /// Constructor injecting database service and standard logger.
  NotificationDao(super.dbService, super.logger);

  @override
  String get tableName => 'notifications';

  @override
  String get chronologicalColumn => 'created_at';

  @override
  Map<String, dynamic> toMap(NotificationItem entity) {
    return entity.toSqlMap();
  }

  @override
  NotificationItem fromMap(Map<String, dynamic> map) {
    return NotificationItem.fromSqlMap(map);
  }
}
