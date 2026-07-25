import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/backup_history_item.dart';
import '../repository/backup_repository.dart';

/// Use case that fetches the list of historical backups cached on device.
class GetBackupHistoryUseCase
    implements UseCase<List<BackupHistoryItem>, NoParams> {
  /// Constructor.
  GetBackupHistoryUseCase(this._repository);
  final BackupRepository _repository;

  @override
  AsyncResult<List<BackupHistoryItem>> call(NoParams params) {
    return _repository.getBackupHistory();
  }
}
