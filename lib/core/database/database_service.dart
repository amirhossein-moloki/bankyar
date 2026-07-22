import '../utils/result.dart';

/// Database table schemas and entity mapping contracts.
abstract class DatabaseService {
  /// Establish a secure encrypted connection pool.
  /// Decrypted via raw master key bytes.
  Future<Result<void>> openEncryptedConnection(List<int> masterKeyBytes);

  /// Close the active connection pool and securely zeroize memory fields.
  Future<Result<void>> closeConnection();

  /// Programmatically verify the integrity signature of database file pages.
  Future<Result<bool>> verifyDatabaseIntegrity();

  /// Clear all stored data (transaction tables, categories, SMS logs).
  Future<Result<void>> wipeLocalSandboxData();
}

/// Abstract contract governing localized Relational Data Access Objects (DAOs).
abstract class BaseDao<T> {
  /// Insert records into relational pages.
  Future<Result<void>> insert(T entity);

  /// Find records by unique string identifiers.
  Future<Result<T?>> findById(String id);

  /// Fetch chronological streams of relational records.
  Stream<Result<List<T>>> getChronologicalStream();

  /// Soft or hard delete records by identifiers.
  Future<Result<void>> delete(String id);
}
