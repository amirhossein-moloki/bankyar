import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/notification_repository.dart';

/// Parameters for deleting notifications.
class DeleteNotificationParams {
  /// Constructor.
  const DeleteNotificationParams({this.id, this.ids, this.clearAll = false});

  /// Single notification ID to delete.
  final String? id;

  /// List of multiple notification IDs to delete.
  final List<String>? ids;

  /// Flag indicating whether to clear all notifications.
  final bool clearAll;
}

/// Use case to delete a specific, multiple, or all notifications from history.
class DeleteNotificationUseCase
    implements UseCase<void, DeleteNotificationParams> {
  /// Constructor.
  const DeleteNotificationUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  AsyncResult<void> call(DeleteNotificationParams params) {
    if (params.clearAll) {
      return _repository.clearAllNotifications();
    } else if (params.ids != null && params.ids!.isNotEmpty) {
      return _repository.deleteNotifications(params.ids!);
    } else if (params.id != null) {
      return _repository.deleteNotification(params.id!);
    }
    return Future.value(const Result.success(null));
  }
}
