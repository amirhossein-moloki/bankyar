import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/backup_repository.dart';

/// Use case that deletes a specific backup from local storage and updates history metadata.
class DeleteBackupUseCase implements UseCase<void, String> {
  /// Constructor.
  DeleteBackupUseCase(this._repository);
  final BackupRepository _repository;

  @override
  AsyncResult<void> call(String params) {
    return _repository.deleteBackup(params);
  }
}
