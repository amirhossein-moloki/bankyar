import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction representing secure preferences or hardware-bound keychain storages.
/// Conforms to DI_ARCHITECTURE.md and SECURITY_ARCHITECTURE.md specifications.
abstract class SecureStorage {
  /// Reads a decrypted value from secure storage.
  Future<String?> read(String key);

  /// Writes an encrypted key-value pair to secure storage.
  Future<void> write({required String key, required String value});

  /// Deletes a value from secure storage.
  Future<void> delete(String key);

  /// Erases all keys and values from secure storage.
  Future<void> deleteAll();
}

/// Concrete adapter wrapping native [FlutterSecureStorage] configurations safely.
class SystemSecureStorage implements SecureStorage {
  /// Constructor injecting standard secure storage client.
  const SystemSecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
