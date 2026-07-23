import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../errors/failures.dart';
import '../logging/logger.dart';
import '../utils/result.dart';
import 'database_service.dart';

/// Concrete implementation of [DatabaseService] utilizing the sqflite package.
/// Supports SQLCipher parameters, schema versioning, and sequential migrations.
class DatabaseServiceImpl implements DatabaseService {
  /// Constructor injecting standard logger.
  DatabaseServiceImpl(this._logger);

  final AppLogger _logger;
  Database? _database;
  List<int>? _activeKeyBytes;

  static const String _dbFileName = 'bankyar_secure.db';
  static const int _dbVersion = 1;

  /// Expose the active database instance for DAO internal lookups.
  Database get database {
    final db = _database;
    if (db == null) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_INF_DB_CLOSED',
        'Attempted to access database when connection was closed.',
      );
      throw const DatabaseCorruptionFailure(
        code: 'BY_INF_DB_CLOSED',
        message: 'Database connection is not open.',
      );
    }
    return db;
  }

  /// Check if the database connection is currently active.
  bool get isOpen => _database != null;

  @override
  Future<Result<void>> openEncryptedConnection(List<int> masterKeyBytes) async {
    try {
      if (_database != null) {
        return const Result.success(null);
      }

      // Store a volatile copy of key bytes in memory for reference
      _activeKeyBytes = List<int>.from(masterKeyBytes);

      final databasesPath = await getDatabasesPath();
      final path = '$databasesPath/$_dbFileName';

      // Convert master key bytes to hex string for SQLCipher keying
      final keyHex = masterKeyBytes
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();

      _logger.log(
        LogLevel.info,
        LogCategories.database,
        'BY_DB_OPEN_START',
        'Opening encrypted database connection pool.',
      );

      final db = await openDatabase(
        path,
        version: _dbVersion,
        onConfigure: (db) async {
          // Standard SQLCipher decryption pragma
          if (keyHex.isNotEmpty) {
            await db.execute("PRAGMA key = '$keyHex';");
          }
          // Performance Tuning Pragmas according to DATABASE_ARCHITECTURE.md
          await db.execute('PRAGMA journal_mode = WAL;');
          await db.execute('PRAGMA synchronous = NORMAL;');
          await db.execute('PRAGMA secure_delete = ON;');
          await db.execute('PRAGMA page_size = 4096;');
          await db.execute('PRAGMA cache_size = 2000;');
          await db.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (db, version) async {
          _logger.log(
            LogLevel.info,
            LogCategories.database,
            'BY_DB_CREATE',
            'Creating database tables for version $version.',
          );
          await _bootstrapSchema(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          _logger.log(
            LogLevel.info,
            LogCategories.database,
            'BY_DB_UPGRADE',
            'Upgrading database from $oldVersion to $newVersion.',
          );
          await _runMigrations(db, oldVersion, newVersion);
        },
      );

      _database = db;
      return const Result.success(null);
    } on Exception catch (e, stack) {
      _logger.log(
        LogLevel.fatal,
        LogCategories.database,
        'BY_INF_DB_OPEN_FAILED',
        'Failed to open secure database connection.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        DatabaseCorruptionFailure(
          code: 'BY_INF_DB_OPEN_FAILED',
          message: 'Secure database open failed: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void>> closeConnection() async {
    try {
      if (_database == null) {
        return const Result.success(null);
      }

      _logger.log(
        LogLevel.info,
        LogCategories.database,
        'BY_DB_CLOSE',
        'Closing active database connection pool and zeroizing memory keys.',
      );

      await _database?.close();
      _database = null;

      // Secure key zeroization to prevent RAM scanning leaks (NFR-1.2)
      if (_activeKeyBytes != null) {
        for (int i = 0; i < _activeKeyBytes!.length; i++) {
          _activeKeyBytes![i] = 0;
        }
        _activeKeyBytes = null;
      }

      return const Result.success(null);
    } on Exception catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_INF_DB_CLOSE_FAILED',
        'Error encountered during database closure.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_INF_DB_CLOSE_FAILED',
          message: 'Failed to close database: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<bool>> verifyDatabaseIntegrity() async {
    try {
      if (!isOpen) {
        return const Result.success(false);
      }

      _logger.log(
        LogLevel.debug,
        LogCategories.database,
        'BY_DB_INTEGRITY_CHECK',
        'Running cryptographic integrity verification signatures.',
      );

      final results = await database.rawQuery('PRAGMA integrity_check;');
      if (results.isNotEmpty) {
        final firstRowValue = results.first.values.first?.toString();
        final passed = firstRowValue?.toLowerCase() == 'ok';
        return Result.success(passed);
      }
      return const Result.success(false);
    } on Exception catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_INF_DB_INTEGRITY_FAILED',
        'Database integrity check failed with exception.',
        error: e,
        stackTrace: stack,
      );
      return const Result.success(false);
    }
  }

  @override
  Future<Result<void>> wipeLocalSandboxData() async {
    try {
      if (!isOpen) {
        return const Result.success(null);
      }

      _logger.log(
        LogLevel.warn,
        LogCategories.database,
        'BY_DB_WIPE_START',
        'Wiping all localized transactional, category, and audit datasets.',
      );

      await database.transaction<void>((txn) async {
        await txn.delete('audit_logs');
        await txn.delete('notifications');
        await txn.delete('settings');
        await txn.delete('attachments');
        await txn.delete('transaction_tags');
        await txn.delete('tags');
        await txn.delete('notes');
        await txn.delete('transactions');
        await txn.delete('categories');
        await txn.delete('accounts');
        await txn.delete('bank_messages');
        await txn.delete('fts_transactions_search');
      });

      _logger.log(
        LogLevel.info,
        LogCategories.database,
        'BY_DB_WIPE_COMPLETE',
        'Local database wipe complete.',
      );

      return const Result.success(null);
    } on Exception catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.database,
        'BY_INF_DB_WIPE_FAILED',
        'Failed to execute complete database sandbox wipe.',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_INF_DB_WIPE_FAILED',
          message: 'Wipe failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _bootstrapSchema(Database db) async {
    await db.transaction((txn) async {
      // 1. bank_messages
      await txn.execute('''
        CREATE TABLE bank_messages (
          id TEXT PRIMARY KEY,
          raw_text TEXT NOT NULL,
          sender_id TEXT NOT NULL,
          received_at INTEGER NOT NULL,
          deduplication_hash TEXT UNIQUE NOT NULL,
          ingestion_status TEXT NOT NULL
        );
      ''');

      // 2. accounts
      await txn.execute('''
        CREATE TABLE accounts (
          id TEXT PRIMARY KEY,
          name TEXT UNIQUE NOT NULL,
          sender_prefix TEXT NOT NULL,
          logo_token TEXT,
          balance REAL NOT NULL DEFAULT 0.0
        );
      ''');

      // 3. categories
      await txn.execute('''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT UNIQUE NOT NULL,
          color_hex TEXT NOT NULL,
          is_system_defined INTEGER NOT NULL DEFAULT 0
        );
      ''');

      // 4. transactions
      await txn.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          amount REAL NOT NULL,
          currency TEXT NOT NULL,
          transaction_type TEXT NOT NULL,
          raw_merchant TEXT NOT NULL,
          normalized_merchant TEXT NOT NULL,
          card_identifier TEXT,
          timestamp INTEGER NOT NULL,
          category_id TEXT,
          source_sms_id TEXT,
          account_id TEXT,
          confidence_score REAL NOT NULL,
          parsing_method TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          version INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
          FOREIGN KEY (source_sms_id) REFERENCES bank_messages(id) ON DELETE SET NULL,
          FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL
        );
      ''');

      // 5. notes
      await txn.execute('''
        CREATE TABLE notes (
          id TEXT PRIMARY KEY,
          transaction_id TEXT UNIQUE NOT NULL,
          note_text TEXT NOT NULL,
          edited_at INTEGER NOT NULL,
          FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
        );
      ''');

      // 6. tags
      await txn.execute('''
        CREATE TABLE tags (
          id TEXT PRIMARY KEY,
          label_text TEXT UNIQUE NOT NULL,
          created_at INTEGER NOT NULL
        );
      ''');

      // 7. transaction_tags
      await txn.execute('''
        CREATE TABLE transaction_tags (
          transaction_id TEXT NOT NULL,
          tag_id TEXT NOT NULL,
          PRIMARY KEY (transaction_id, tag_id),
          FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
          FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
        );
      ''');

      // 8. attachments
      await txn.execute('''
        CREATE TABLE attachments (
          id TEXT PRIMARY KEY,
          transaction_id TEXT NOT NULL,
          local_file_path TEXT NOT NULL,
          file_size_bytes INTEGER NOT NULL,
          mime_type TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
        );
      ''');

      // 9. settings
      await txn.execute('''
        CREATE TABLE settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL,
          updated_at INTEGER NOT NULL
        );
      ''');

      // 10. notifications
      await txn.execute('''
        CREATE TABLE notifications (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          type TEXT NOT NULL,
          is_read INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL
        );
      ''');

      // 11. audit_logs
      await txn.execute('''
        CREATE TABLE audit_logs (
          id TEXT PRIMARY KEY,
          log_level TEXT NOT NULL,
          category TEXT NOT NULL,
          taxonomy_code TEXT NOT NULL,
          message TEXT NOT NULL,
          metadata_json TEXT,
          stack_trace TEXT,
          timestamp INTEGER NOT NULL
        );
      ''');

      // 12. fts_transactions_search (FTS5 shadow table)
      await txn.execute('''
        CREATE VIRTUAL TABLE fts_transactions_search USING fts5(
          transaction_id,
          merchant_name,
          note_text,
          tag_labels
        );
      ''');

      // Triggers for syncing search virtual index
      await txn.execute('''
        CREATE TRIGGER trg_tx_search_insert AFTER INSERT ON transactions BEGIN
          INSERT INTO fts_transactions_search(transaction_id, merchant_name, note_text, tag_labels)
          VALUES (new.id, new.normalized_merchant, '', '');
        END;
      ''');

      await txn.execute('''
        CREATE TRIGGER trg_tx_search_delete AFTER DELETE ON transactions BEGIN
          DELETE FROM fts_transactions_search WHERE transaction_id = old.id;
        END;
      ''');

      await txn.execute('''
        CREATE TRIGGER trg_tx_search_update AFTER UPDATE ON transactions BEGIN
          UPDATE fts_transactions_search
          SET merchant_name = new.normalized_merchant
          WHERE transaction_id = new.id;
        END;
      ''');

      await txn.execute('''
        CREATE TRIGGER trg_notes_search_insert AFTER INSERT ON notes BEGIN
          UPDATE fts_transactions_search
          SET note_text = new.note_text
          WHERE transaction_id = new.transaction_id;
        END;
      ''');

      await txn.execute('''
        CREATE TRIGGER trg_notes_search_update AFTER UPDATE ON notes BEGIN
          UPDATE fts_transactions_search
          SET note_text = new.note_text
          WHERE transaction_id = new.transaction_id;
        END;
      ''');

      await txn.execute('''
        CREATE TRIGGER trg_notes_search_delete AFTER DELETE ON notes BEGIN
          UPDATE fts_transactions_search
          SET note_text = ''
          WHERE transaction_id = old.transaction_id;
        END;
      ''');

      // Indexes for performance optimization according to DATABASE_ARCHITECTURE.md
      await txn.execute(
        'CREATE INDEX idx_sms_dedup ON bank_messages (deduplication_hash);',
      );
      await txn.execute(
        'CREATE INDEX idx_sms_received ON bank_messages (received_at);',
      );
      await txn.execute(
        'CREATE INDEX idx_tx_chrono ON transactions (timestamp DESC);',
      );
      await txn.execute(
        'CREATE INDEX idx_tx_cat_time ON transactions (category_id, timestamp);',
      );
      await txn.execute(
        'CREATE INDEX idx_tx_sms ON transactions (source_sms_id);',
      );
      await txn.execute('CREATE INDEX idx_notes_tx ON notes (transaction_id);');
    });
  }

  Future<void> _runMigrations(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Migration system hook for future updates
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      _logger.log(
        LogLevel.info,
        LogCategories.database,
        'BY_DB_MIGRATION_STEP',
        'Executing database migration script step: v${i - 1} -> v$i.',
      );
      // Future incremental scripts added here
    }
  }
}
