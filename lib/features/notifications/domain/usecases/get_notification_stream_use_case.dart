import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result.dart';
import '../entities/notification_item.dart';
import '../repository/notification_repository.dart';

/// Use case to stream chronological list changes of notifications.
class GetNotificationStreamUseCase
    implements StreamUseCase<Result<List<NotificationItem>>, NoParams> {
  /// Constructor.
  const GetNotificationStreamUseCase(this._repository);

  final NotificationRepository _repository;

  @override
  Stream<Result<List<NotificationItem>>> call(NoParams params) {
    return _repository.getNotificationStream();
  }
}
