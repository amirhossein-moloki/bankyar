import '../../../../core/utils/result.dart';
import '../entities/notification_item.dart';

/// Repository interface managing local, encrypted notification history.
abstract class NotificationRepository {
  /// Fetches a chronological list of all notifications from the local database.
  Future<Result<List<NotificationItem>>> getNotifications();

  /// Exposes a real-time reactive stream of chronological notifications.
  Stream<Result<List<NotificationItem>>> getNotificationStream();

  /// Inserts a new notification into the local history.
  Future<Result<void>> insertNotification(NotificationItem notification);

  /// Marks a specific notification as read by its identifier.
  Future<Result<void>> markAsRead(String id);

  /// Marks all active notifications in the database as read.
  Future<Result<void>> markAllAsRead();

  /// Deletes an individual notification from history.
  Future<Result<void>> deleteNotification(String id);

  /// Deletes a set of notifications in a single transaction.
  Future<Result<void>> deleteNotifications(List<String> ids);

  /// Purges all notifications from the local database table.
  Future<Result<void>> clearAllNotifications();
}
