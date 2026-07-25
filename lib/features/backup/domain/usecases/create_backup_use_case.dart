import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/backup_history_item.dart';
import '../repository/backup_repository.dart';

/// Parameters for creating a manual or automatic backup.
class CreateBackupParams {
  /// The user's encryption password.
  final String password;

  /// Whether the backup is manually initiated.
  final bool isManual;

  /// Constructor.
  const CreateBackupParams({required this.password, required this.isManual});
}

/// Executes database serialization and AES-256 encryption backup generation.
class CreateBackupUseCase
    implements UseCase<BackupHistoryItem, CreateBackupParams> {
  final BackupRepository _repository;

  /// Constructor.
  CreateBackupUseCase(this._repository);

  @override
  AsyncResult<BackupHistoryItem> call(CreateBackupParams params) {
    return _repository.createBackup(
      password: params.password,
      isManual: params.isManual,
    );
  }
}
