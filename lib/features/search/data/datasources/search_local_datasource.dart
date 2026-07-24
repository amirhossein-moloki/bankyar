import 'dart:convert';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/entities/search_models.dart';
import '../../../transactions/data/models/transaction_dto.dart';

/// Contract for search-related local database and preferences storage operations.
abstract class SearchLocalDataSource {
  /// Queries database for transactions matching advanced parameters.
  Future<List<ParsedTransaction>> search(SearchQuery query);

  /// Stores a query string locally for search history.
  Future<void> saveSearchQuery(String queryText);

  /// Retrieves the history list of search queries.
  Future<List<String>> getSearchHistory();

  /// Clears search history.
  Future<void> clearSearchHistory();
}

/// Concrete SQLite and Preferences implementation of [SearchLocalDataSource].
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  SearchLocalDataSourceImpl({
    required DatabaseServiceImpl dbService,
    required PreferencesStorage preferencesStorage,
    required AppLogger logger,
  })  : _dbService = dbService,
        _preferences = preferencesStorage,
        _logger = logger;

  final DatabaseServiceImpl _dbService;
  final PreferencesStorage _preferences;
  final AppLogger _logger;

  static const String _historyKey = 'by_search_history';
  static const int _maxHistoryItems = 10;

  @override
  Future<List<ParsedTransaction>> search(SearchQuery query) async {
    final db = _dbService.database;

    final List<String> whereClauses = [];
    final List<dynamic> whereArgs = [];

    // Apply filters first
    final filters = query.filters;

    // 1. Date Range
    if (filters.startDate != null) {
      whereClauses.add('t.timestamp >= ?');
      whereArgs.add(filters.startDate!.millisecondsSinceEpoch);
    }
    if (filters.endDate != null) {
      whereClauses.add('t.timestamp <= ?');
      whereArgs.add(filters.endDate!.millisecondsSinceEpoch);
    }

    // 2. Amount Range
    if (filters.minAmount != null) {
      whereClauses.add('t.amount >= ?');
      whereArgs.add(filters.minAmount);
    }
    if (filters.maxAmount != null) {
      whereClauses.add('t.amount <= ?');
      whereArgs.add(filters.maxAmount);
    }

    // 3. Transaction Type
    if (filters.transactionType != 'All') {
      whereClauses.add('t.transaction_type = ?');
      whereArgs.add(filters.transactionType.toLowerCase());
    }

    // 4. Bank
    if (filters.bank != null && filters.bank != 'All' && filters.bank!.isNotEmpty) {
      whereClauses.add(
        '(t.card_identifier = ? OR t.normalized_merchant LIKE ? OR t.raw_merchant LIKE ?)',
      );
      whereArgs.add(filters.bank);
      whereArgs.add('%${filters.bank}%');
      whereArgs.add('%${filters.bank}%');
    }

    // 5. Category ID
    if (filters.categoryId != null) {
      whereClauses.add('t.category_id = ?');
      whereArgs.add(filters.categoryId);
    }

    // 6. Has Note
    if (filters.hasNote != null) {
      if (filters.hasNote!) {
        whereClauses.add('(n.note_text IS NOT NULL AND n.note_text != "")');
      } else {
        whereClauses.add('(n.note_text IS NULL OR n.note_text = "")');
      }
    }

    // 7. Tags
    if (filters.tags.isNotEmpty) {
      final placeholders = List.filled(filters.tags.length, '?').join(', ');
      whereClauses.add(
        't.id IN (SELECT tt.transaction_id FROM transaction_tags tt INNER JOIN tags tg ON tt.tag_id = tg.id WHERE tg.label_text IN ($placeholders))',
      );
      whereArgs.addAll(filters.tags);
    }

    // 8. Text Search (Matches Merchant, Note, Bank Name, Card identifier, Category Name, Tags, and SMS Text)
    if (query.text.trim().isNotEmpty) {
      final textQuery = query.text.trim();
      final textParam = '%$textQuery%';

      // We use standard LIKE clauses combined with FTS5 table references for high confidence matches.
      // Since FTS5 index contains merchant_name, note_text, and tag_labels, we can query it:
      final String ftsClause = 't.id IN (SELECT transaction_id FROM fts_transactions_search WHERE fts_transactions_search MATCH ?)';

      whereClauses.add(
        '($ftsClause OR t.normalized_merchant LIKE ? OR t.raw_merchant LIKE ? OR n.note_text LIKE ? OR c.name LIKE ? OR bm.raw_text LIKE ? OR t.card_identifier LIKE ?)',
      );
      whereArgs.add('$textQuery*'); // FTS prefix search syntax
      whereArgs.add(textParam); // Merchant normalized
      whereArgs.add(textParam); // Merchant raw
      whereArgs.add(textParam); // Note text
      whereArgs.add(textParam); // Category Name
      whereArgs.add(textParam); // SMS raw text
      whereArgs.add(textParam); // Card identifier
    }

    final String whereSection = whereClauses.isNotEmpty
        ? 'WHERE ${whereClauses.join(' AND ')}'
        : '';

    // Apply Sorting
    String orderBy;
    switch (query.sort.field) {
      case SearchSortField.amount:
        orderBy = 't.amount';
        break;
      case SearchSortField.alphabetical:
        orderBy = 't.normalized_merchant';
        break;
      case SearchSortField.bank:
        orderBy = 't.card_identifier';
        break;
      case SearchSortField.category:
        orderBy = 'c.name';
        break;
      case SearchSortField.date:
      default:
        orderBy = 't.timestamp';
        break;
    }

    final String direction = query.sort.descending ? 'DESC' : 'ASC';

    final String sql = '''
      SELECT DISTINCT t.* FROM transactions t
      LEFT JOIN notes n ON t.id = n.transaction_id
      LEFT JOIN categories c ON t.category_id = c.id
      LEFT JOIN bank_messages bm ON t.source_sms_id = bm.id
      $whereSection
      ORDER BY $orderBy $direction
    ''';

    _logger.log(
      LogLevel.debug,
      LogCategories.database,
      'BY_SEARCH_DB_QUERY',
      'Executing advanced transaction search SQL query.',
      metadata: {'sql': sql, 'args': whereArgs.toString()},
    );

    final results = await db.rawQuery(sql, whereArgs);
    return results.map(TransactionDto.fromMap).toList();
  }

  @override
  Future<void> saveSearchQuery(String queryText) async {
    final trimmed = queryText.trim();
    if (trimmed.isEmpty) return;

    final history = await getSearchHistory();
    final updated = List<String>.from(history)..remove(trimmed);
    updated.insert(0, trimmed);

    if (updated.length > _maxHistoryItems) {
      updated.removeLast();
    }

    final jsonStr = jsonEncode(updated);
    await _preferences.setString(_historyKey, jsonStr);
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final jsonStr = await _preferences.getString(_historyKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> clearSearchHistory() async {
    await _preferences.delete(_historyKey);
  }
}
