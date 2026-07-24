import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/repository/backup_repository.dart';
import '../../domain/usecases/create_backup_use_case.dart';
import '../../domain/usecases/delete_backup_use_case.dart';
import '../../domain/usecases/get_backup_history_use_case.dart';
import '../../domain/usecases/get_backup_metadata_use_case.dart';
import '../../domain/usecases/restore_backup_use_case.dart';
import '../../domain/usecases/verify_backup_file_use_case.dart';
import '../datasources/local_backup_data_source.dart';
import '../repositories/backup_repository_impl.dart';

/// Provider exposing the local backup data source.
final localBackupDataSourceProvider = Provider<LocalBackupDataSource>((ref) {
  final fileStorage = ref.watch(fileStorageProvider);
  final preferencesStorage = ref.watch(preferencesStorageProvider);
  final logger = ref.watch(loggerProvider);
  return LocalBackupDataSourceImpl(
    fileStorage: fileStorage,
    preferencesStorage: preferencesStorage,
    logger: logger,
  );
});

/// Provider exposing the BackupRepository interface.
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final localBackupDataSource = ref.watch(localBackupDataSourceProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  final backupPortability = ref.watch(backupPortabilityProvider);
  final clock = ref.watch(clockProvider);
  final uuidGenerator = ref.watch(uuidGeneratorProvider);
  final logger = ref.watch(loggerProvider);
  return BackupRepositoryImpl(
    localBackupDataSource: localBackupDataSource,
    databaseService: databaseService,
    backupPortability: backupPortability,
    clock: clock,
    uuidGenerator: uuidGenerator,
    logger: logger,
  );
});

/// Provider exposing CreateBackupUseCase.
final createBackupUseCaseProvider = Provider<CreateBackupUseCase>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  return CreateBackupUseCase(repository);
});

/// Provider exposing RestoreBackupUseCase.
final restoreBackupUseCaseProvider = Provider<RestoreBackupUseCase>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  return RestoreBackupUseCase(repository);
});

/// Provider exposing GetBackupHistoryUseCase.
final getBackupHistoryUseCaseProvider = Provider<GetBackupHistoryUseCase>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  return GetBackupHistoryUseCase(repository);
});

/// Provider exposing DeleteBackupUseCase.
final deleteBackupUseCaseProvider = Provider<DeleteBackupUseCase>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  return DeleteBackupUseCase(repository);
});

/// Provider exposing VerifyBackupFileUseCase.
final verifyBackupFileUseCaseProvider = Provider<VerifyBackupFileUseCase>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  return VerifyBackupFileUseCase(repository);
});

/// Provider exposing GetBackupMetadataUseCase.
final getBackupMetadataUseCaseProvider = Provider<GetBackupMetadataUseCase>((ref) {
  final repository = ref.watch(backupRepositoryProvider);
  return GetBackupMetadataUseCase(repository);
});
