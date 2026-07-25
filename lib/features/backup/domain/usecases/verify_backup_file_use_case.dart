import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/backup_repository.dart';

/// Parameters for verifying backup file integrity.
class VerifyBackupFileParams {
  /// File system path to the .bankyar archive.
  final String filePath;

  /// Password to verify decryption headers.
  final String password;

  /// Constructor.
  const VerifyBackupFileParams({
    required this.filePath,
    required this.password,
  });
}

/// Use case to run standard checksum and decryption checks on a backup archive.
class VerifyBackupFileUseCase implements UseCase<bool, VerifyBackupFileParams> {
  final BackupRepository _repository;

  /// Constructor.
  VerifyBackupFileUseCase(this._repository);

  @override
  AsyncResult<bool> call(VerifyBackupFileParams params) {
    return _repository.verifyBackupFile(
      filePath: params.filePath,
      password: params.password,
    );
  }
}
