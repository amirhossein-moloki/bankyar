import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/backup_metadata.dart';
import '../repository/backup_repository.dart';

/// Use case to retrieve the on-device system metadata, versions, and memory usage.
class GetBackupMetadataUseCase implements UseCase<BackupMetadata, NoParams> {
  final BackupRepository _repository;

  /// Constructor.
  GetBackupMetadataUseCase(this._repository);

  @override
  AsyncResult<BackupMetadata> call(NoParams params) {
    return _repository.getBackupMetadata();
  }
}
