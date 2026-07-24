import '../../../../core/utils/result.dart';
import '../entities/backup_history_item.dart';
import '../entities/backup_metadata.dart';

/// Repository interface governing password-encrypted local backup creation,
/// database integrity verification, history list caching, and atomic safe database restorations.
abstract class BackupRepository {
  /// Encrypts and saves all localized relational tables into a portable .bankyar file.
  Future<Result<BackupHistoryItem>> createBackup({
    required String password,
    required bool isManual,
  });

  /// Restores a portable backup, performing decryption, compatibility, and conflict resolution checks.
  /// If [forceReplace] is true, replaces the local database completely. Otherwise, merges and de-duplicates safely.
  Future<Result<void>> restoreBackup({
    required String password,
    required List<int> backupBytes,
    required bool forceReplace,
  });

  /// Generates a preview mapping of item counts to perform a side-by-side comparison screen check.
  /// Keys in the returned map should include: 'local_transactions', 'backup_transactions', 'local_accounts', 'backup_accounts'.
  Future<Result<Map<String, int>>> previewRestoreMetrics({
    required String password,
    required List<int> backupBytes,
  });

  /// Retrieves the history of backups saved on device.
  Future<Result<List<BackupHistoryItem>>> getBackupHistory();

  /// Deletes a specific portable backup file from the secure folder storage and removes it from history.
  Future<Result<void>> deleteBackup(String id);

  /// Cryptographically verifies the password, magic header, and checksum of a backup file.
  Future<Result<bool>> verifyBackupFile({
    required String filePath,
    required String password,
  });

  /// Gathers on-device metadata metrics including database sizing, system versions, and storage utilization.
  Future<Result<BackupMetadata>> getBackupMetadata();

  /// Persists the boolean flag for scheduled backup reminders.
  Future<Result<void>> setAutomaticReminderEnabled(bool enabled);

  /// Retrieves the current status of scheduled backup reminders.
  Future<Result<bool>> isAutomaticReminderEnabled();
}
