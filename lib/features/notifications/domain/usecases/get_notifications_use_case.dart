import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/notification_item.dart';
import '../repository/notification_repository.dart';

/// Use case to fetch a chronological list of notifications.
class GetNotificationsUseCase
    implements UseCase<List<NotificationItem>, NoParams> {
  /// Constructor.
  const GetNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  AsyncResult<List<NotificationItem>> call(NoParams params) {
    return _repository.getNotifications();
  }
}
