import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/notification_item.dart';
import '../repository/notification_repository.dart';

/// Use case to insert a new notification into history.
class InsertNotificationUseCase implements UseCase<void, NotificationItem> {
  /// Constructor.
  const InsertNotificationUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  AsyncResult<void> call(NotificationItem params) {
    return _repository.insertNotification(params);
  }
}
