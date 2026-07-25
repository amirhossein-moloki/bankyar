import 'dart:async';
import '../../../../core/architecture/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repository/notification_repository.dart';
import '../datasources/notification_dao.dart';

/// Concrete implementation of [NotificationRepository] managing SQLCipher state interactions.
class NotificationRepositoryImpl extends BaseRepository
    implements NotificationRepository {
  /// Constructor.
  const NotificationRepositoryImpl(this._dao);

  final NotificationDao _dao;

  @override
  Future<Result<List<NotificationItem>>> getNotifications() {
    return executeSafe(() async {
      final res = await _dao.getChronologicalList();
      return res.successOrCrash;
    });
  }

  @override
  Stream<Result<List<NotificationItem>>> getNotificationStream() {
    return pipeSafeStream(
      _dao.getChronologicalStream().map((res) {
        return res.successOrCrash;
      }),
    );
  }

  @override
  Future<Result<void>> insertNotification(NotificationItem notification) {
    return executeSafe(() => _dao.insert(notification));
  }

  @override
  Future<Result<void>> markAsRead(String id) {
    return executeSafe(() async {
      final foundRes = await _dao.findById(id);
      final found = foundRes.successOrCrash;
      if (found != null) {
        await _dao.insert(found.copyWith(isRead: true));
      }
    });
  }

  @override
  Future<Result<void>> markAllAsRead() {
    return executeSafe(() async {
      final listRes = await _dao.getChronologicalList();
      final list = listRes.successOrCrash;
      final unreadItems = list.where((item) => !item.isRead).toList();
      if (unreadItems.isNotEmpty) {
        final readItems = unreadItems
            .map((item) => item.copyWith(isRead: true))
            .toList();
        await _dao.insertAll(readItems);
      }
    });
  }

  @override
  Future<Result<void>> deleteNotification(String id) {
    return executeSafe(() => _dao.delete(id));
  }

  @override
  Future<Result<void>> deleteNotifications(List<String> ids) {
    return executeSafe(() async {
      await _dao.runInTransaction((txn) async {
        for (final id in ids) {
          await txn.delete(
            _dao.tableName,
            where: '${_dao.idColumn} = ?',
            whereArgs: [id],
          );
        }
      });
    });
  }

  @override
  Future<Result<void>> clearAllNotifications() {
    return executeSafe(() async {
      await _dao.runInTransaction((txn) async {
        await txn.delete(_dao.tableName);
      });
    });
  }
}
