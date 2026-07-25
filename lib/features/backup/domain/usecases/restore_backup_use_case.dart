import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/backup_repository.dart';

/// Parameters for restoring a backup.
class RestoreBackupParams {
  /// Constructor.
  const RestoreBackupParams({
    required this.password,
    required this.backupBytes,
    required this.forceReplace,
  });

  /// The password used to decrypt the portable backup archive.
  final String password;

  /// The raw encrypted bytes of the portable backup archive.
  final List<int> backupBytes;

  /// Whether to replace local records entirely or perform intelligent deduplication.
  final bool forceReplace;
}

/// Use case that orchestrates database decryption and restoration inside safe boundaries.
class RestoreBackupUseCase implements UseCase<void, RestoreBackupParams> {
  /// Constructor.
  RestoreBackupUseCase(this._repository);
  final BackupRepository _repository;

  @override
  AsyncResult<void> call(RestoreBackupParams params) {
    return _repository.restoreBackup(
      password: params.password,
      backupBytes: params.backupBytes,
      forceReplace: params.forceReplace,
    );
  }
}
