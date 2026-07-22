import 'dart:io' as io;

/// Abstraction representing the local file system.
/// Isolates low-level File I/O operations for seamless testing and mocking.
abstract class FileStorage {
  /// Writes raw text [content] to the target file [path].
  Future<void> writeString(String path, String content);

  /// Reads raw text from the file [path].
  Future<String> readString(String path);

  /// Returns true if the file [path] exists on disk.
  Future<bool> exists(String path);

  /// Deletes the file [path] from disk.
  Future<void> delete(String path);
}

/// Concrete adapter executing real File I/O on the device filesystem.
class SystemFileStorage implements FileStorage {
  /// Constructor constructing system file storage.
  const SystemFileStorage();

  @override
  Future<void> writeString(String path, String content) async {
    final file = io.File(path);
    await file.writeAsString(content);
  }

  @override
  Future<String> readString(String path) async {
    final file = io.File(path);
    return file.readAsString();
  }

  @override
  Future<bool> exists(String path) async {
    final file = io.File(path);
    return file.exists();
  }

  @override
  Future<void> delete(String path) async {
    final file = io.File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
