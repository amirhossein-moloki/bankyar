import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/notification_repository.dart';

/// Parameters for marking notifications as read.
class MarkReadParams {
  /// Constructor.
  const MarkReadParams({this.id});

  /// The unique identifier of a notification, or null to mark all as read.
  final String? id;
}

/// Use case to mark a specific notification or all notifications as read.
class MarkNotificationReadUseCase implements UseCase<void, MarkReadParams> {
  /// Constructor.
  const MarkNotificationReadUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  AsyncResult<void> call(MarkReadParams params) {
    final id = params.id;
    if (id != null) {
      return _repository.markAsRead(id);
    } else {
      return _repository.markAllAsRead();
    }
  }
}
