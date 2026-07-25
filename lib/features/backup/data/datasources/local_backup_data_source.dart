import 'dart:convert';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/platform/file_storage.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../domain/entities/backup_history_item.dart';

/// Abstract contract governing on-device backup file I/O operations and metadata caching.
abstract class LocalBackupDataSource {
  /// Writes encrypted backup bytes to a target path on disk.
  Future<void> writeBackupFile(String filePath, List<int> backupBytes);

  /// Reads encrypted backup bytes from a path on disk.
  Future<List<int>> readBackupFile(String filePath);

  /// Deletes a backup file from disk.
  Future<void> deleteBackupFile(String filePath);

  /// Checks if a backup file exists on disk.
  Future<bool> backupFileExists(String filePath);

  /// Persists the history list of backups as a JSON cache.
  Future<void> saveHistory(List<BackupHistoryItem> history);

  /// Retrieves the cached history list of backups.
  Future<List<BackupHistoryItem>> loadHistory();

  /// Persists the automatic backup reminders toggle.
  Future<void> setReminderEnabled(bool enabled);

  /// Retrieves the automatic backup reminders toggle.
  Future<bool> getReminderEnabled();
}

/// Concrete production-ready implementation of [LocalBackupDataSource]
/// utilizing secure [FileStorage] and [PreferencesStorage].
class LocalBackupDataSourceImpl implements LocalBackupDataSource {
  final FileStorage _fileStorage;
  final PreferencesStorage _preferencesStorage;
  final AppLogger _logger;

  /// Key for storing backup history in PreferencesStorage
  static const String _historyKey = 'by_backup_history_list';

  /// Key for storing the reminder preference in PreferencesStorage
  static const String _reminderKey = 'by_backup_reminder_enabled';

  /// Constructor.
  LocalBackupDataSourceImpl({
    required FileStorage fileStorage,
    required PreferencesStorage preferencesStorage,
    required AppLogger logger,
  }) : _fileStorage = fileStorage,
       _preferencesStorage = preferencesStorage,
       _logger = logger;

  @override
  Future<void> writeBackupFile(String filePath, List<int> backupBytes) async {
    try {
      final base64String = base64Encode(backupBytes);
      await _fileStorage.writeString(filePath, base64String);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.backup,
        'BY_BACKUP_FILE_WRITE_FAILED',
        'Failed to write portable backup archive to path.',
        metadata: {'path': filePath},
        error: e,
        stackTrace: stack,
      );
      throw SecureStorageException(
        code: 'BY_BACKUP_FILE_WRITE_FAILED',
        message: 'Could not save backup file: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<int>> readBackupFile(String filePath) async {
    try {
      final exists = await _fileStorage.exists(filePath);
      if (!exists) {
        throw SecureStorageException(
          code: 'BY_BACKUP_FILE_NOT_FOUND',
          message: 'The file at $filePath does not exist.',
        );
      }
      final base64String = await _fileStorage.readString(filePath);
      return base64Decode(base64String.trim());
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.backup,
        'BY_BACKUP_FILE_READ_FAILED',
        'Failed to read portable backup archive from path.',
        metadata: {'path': filePath},
        error: e,
        stackTrace: stack,
      );
      throw SecureStorageException(
        code: 'BY_BACKUP_FILE_READ_FAILED',
        message: 'Could not load backup file: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteBackupFile(String filePath) async {
    try {
      await _fileStorage.delete(filePath);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.backup,
        'BY_BACKUP_FILE_DELETE_FAILED',
        'Failed to delete portable backup file from path.',
        metadata: {'path': filePath},
        error: e,
        stackTrace: stack,
      );
      throw SecureStorageException(
        code: 'BY_BACKUP_FILE_DELETE_FAILED',
        message: 'Could not delete backup file: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> backupFileExists(String filePath) async {
    return _fileStorage.exists(filePath);
  }

  @override
  Future<void> saveHistory(List<BackupHistoryItem> history) async {
    try {
      final listMaps = history.map((item) => item.toJson()).toList();
      final jsonStr = jsonEncode(listMaps);
      await _preferencesStorage.setString(_historyKey, jsonStr);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.backup,
        'BY_BACKUP_SAVE_HISTORY_FAILED',
        'Failed to cache backup history list metadata.',
        error: e,
        stackTrace: stack,
      );
    }
  }

  @override
  Future<List<BackupHistoryItem>> loadHistory() async {
    try {
      final jsonStr = await _preferencesStorage.getString(_historyKey);
      if (jsonStr == null || jsonStr.isEmpty) {
        return [];
      }
      final List<dynamic> listRaw = jsonDecode(jsonStr) as List<dynamic>;
      return listRaw
          .map(
            (item) => BackupHistoryItem.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.backup,
        'BY_BACKUP_LOAD_HISTORY_FAILED',
        'Failed to retrieve backup history cache.',
        error: e,
        stackTrace: stack,
      );
      return [];
    }
  }

  @override
  Future<void> setReminderEnabled(bool enabled) async {
    try {
      await _preferencesStorage.setBool(_reminderKey, enabled);
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.backup,
        'BY_BACKUP_SET_REMINDER_FAILED',
        'Failed to update reminder settings.',
      );
    }
  }

  @override
  Future<bool> getReminderEnabled() async {
    try {
      return await _preferencesStorage.getBool(_reminderKey) ?? false;
    } catch (e) {
      return false;
    }
  }
}
