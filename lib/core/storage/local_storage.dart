import '../errors/exceptions.dart';
import '../logging/logger.dart';
import '../platform/file_storage.dart';

/// Reusable unified storage class for sandboxed file writes and reads.
/// Interacts via standard abstract [FileStorage] for high mockability.
class LocalStorage {
  /// Constructor injecting standard [FileStorage] client and logger.
  const LocalStorage(this._fileStorage, this._logger);

  final FileStorage _fileStorage;
  final AppLogger _logger;

  /// Writes text [content] to the specified sandboxed [filePath].
  Future<void> write(String filePath, String content) async {
    try {
      _logger.log(
        LogLevel.debug,
        LogCategories.platform,
        'BY_STORAGE_WRITE',
        'Writing content to local file.',
        metadata: {'path': filePath},
      );
      await _fileStorage.writeString(filePath, content);
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_FILE_WRITE_FAILED',
        'Failed to write content to local file.',
        metadata: {'path': filePath},
        error: e,
      );
      throw FileStorageException(
        code: 'BY_INF_FILE_WRITE_FAILED',
        message: 'Could not write to path: $filePath. Error: ${e.toString()}',
      );
    }
  }

  /// Reads text content from the specified sandboxed [filePath].
  Future<String> read(String filePath) async {
    try {
      final exists = await _fileStorage.exists(filePath);
      if (!exists) {
        throw const FileStorageException(
          code: 'BY_INF_FILE_NOT_FOUND',
          message: 'Target file not found.',
        );
      }
      return await _fileStorage.readString(filePath);
    } catch (e) {
      if (e is FileStorageException) rethrow;
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_FILE_READ_FAILED',
        'Failed to read content from local file.',
        metadata: {'path': filePath},
        error: e,
      );
      throw FileStorageException(
        code: 'BY_INF_FILE_READ_FAILED',
        message: 'Could not read from path: $filePath. Error: ${e.toString()}',
      );
    }
  }

  /// Check if the sandboxed file [filePath] exists.
  Future<bool> exists(String filePath) async {
    try {
      return await _fileStorage.exists(filePath);
    } catch (e) {
      return false;
    }
  }

  /// Deletes a file located at [filePath].
  Future<void> delete(String filePath) async {
    try {
      _logger.log(
        LogLevel.debug,
        LogCategories.platform,
        'BY_STORAGE_DELETE',
        'Deleting local file.',
        metadata: {'path': filePath},
      );
      await _fileStorage.delete(filePath);
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_INF_FILE_DELETE_FAILED',
        'Failed to delete local file.',
        metadata: {'path': filePath},
        error: e,
      );
      throw FileStorageException(
        code: 'BY_INF_FILE_DELETE_FAILED',
        message: 'Could not delete path: $filePath. Error: ${e.toString()}',
      );
    }
  }
}
