import '../errors/exceptions.dart';
import '../logging/logger.dart';
import '../platform/secure_storage.dart';

/// Reusable storage wrapper for reading and writing encrypted key-value settings.
/// Uses standard [SecureStorage] and wraps all operations with structured logs.
class PreferencesStorage {
  /// Constructor injecting standard [SecureStorage] client and logger.
  const PreferencesStorage(this._secureStorage, this._logger);

  final SecureStorage _secureStorage;
  final AppLogger _logger;

  /// Saves a string preference securely.
  Future<void> setString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_PREF_WRITE_FAILED',
        'Failed to write preference key.',
        metadata: {'key': key},
        error: e,
      );
      throw SecureStorageException(
        code: 'BY_INF_PREF_WRITE_FAILED',
        message: 'Could not write preference: $key. Error: ${e.toString()}',
      );
    }
  }

  /// Reads a string preference securely.
  Future<String?> getString(String key) async {
    try {
      return await _secureStorage.read(key);
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_PREF_READ_FAILED',
        'Failed to read preference key.',
        metadata: {'key': key},
        error: e,
      );
      throw SecureStorageException(
        code: 'BY_INF_PREF_READ_FAILED',
        message: 'Could not read preference: $key. Error: ${e.toString()}',
      );
    }
  }

  /// Saves a boolean preference securely.
  Future<void> setBool(String key, bool value) async {
    await setString(key, value.toString());
  }

  /// Reads a boolean preference securely.
  Future<bool?> getBool(String key) async {
    final str = await getString(key);
    if (str == null) return null;
    return str.toLowerCase() == 'true';
  }

  /// Saves an integer preference securely.
  Future<void> setInt(String key, int value) async {
    await setString(key, value.toString());
  }

  /// Reads an integer preference securely.
  Future<int?> getInt(String key) async {
    final str = await getString(key);
    if (str == null) return null;
    return int.tryParse(str);
  }

  /// Deletes a specific preference key.
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key);
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_PREF_DELETE_FAILED',
        'Failed to delete preference key.',
        metadata: {'key': key},
        error: e,
      );
      throw SecureStorageException(
        code: 'BY_INF_PREF_DELETE_FAILED',
        message: 'Could not delete preference: $key. Error: ${e.toString()}',
      );
    }
  }

  /// Deletes all preferences stored in secure preferences.
  Future<void> clear() async {
    try {
      _logger.log(
        LogLevel.warn,
        LogCategories.platform,
        'BY_PREF_CLEAR',
        'Clearing all secure preference keys.',
      );
      await _secureStorage.deleteAll();
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_PREF_CLEAR_FAILED',
        'Failed to clear secure preference keys.',
        error: e,
      );
      throw SecureStorageException(
        code: 'BY_INF_PREF_CLEAR_FAILED',
        message: 'Could not clear preferences. Error: ${e.toString()}',
      );
    }
  }
}
