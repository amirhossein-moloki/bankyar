import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../../../core/architecture/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/bank_message_entity.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/transaction_details.dart';
import '../../domain/repository/transaction_repository.dart';
import '../datasources/transaction_dao.dart';
import '../models/category_dto.dart';

/// Concrete database-bound implementation of [TransactionRepository].
/// Handles ledger transaction querying, listening, and modification safely.
class TransactionRepositoryImpl extends BaseRepository
    implements TransactionRepository {
  /// Constructor injecting standard [TransactionDao].
  const TransactionRepositoryImpl(this._transactionDao);

  final TransactionDao _transactionDao;

  @override
  Stream<Result<List<ParsedTransaction>>> watchTransactions() {
    return pipeSafeStream(
      _transactionDao.getChronologicalStream().map((r) {
        if (r is FailureResult<List<ParsedTransaction>>) {
          throw r.failure;
        }
        return (r as Success<List<ParsedTransaction>>).data;
      }),
    );
  }

  @override
  Future<Result<List<ParsedTransaction>>> getTransactions() {
    return executeSafe(() async {
      final result = await _transactionDao.getChronologicalList();
      if (result is FailureResult<List<ParsedTransaction>>) {
        throw result.failure;
      }
      return (result as Success<List<ParsedTransaction>>).data;
    });
  }

  @override
  Future<Result<void>> saveTransaction(ParsedTransaction transaction) {
    return executeSafe(() async {
      final result = await _transactionDao.insert(transaction);
      if (result is FailureResult<void>) {
        throw result.failure;
      }
    });
  }

  @override
  Future<Result<void>> deleteTransaction(String id) {
    return executeSafe(() async {
      final result = await _transactionDao.delete(id);
      if (result is FailureResult<void>) {
        throw result.failure;
      }
    });
  }

  @override
  Future<Result<List<ParsedTransaction>>> getTransactionsPaged({
    required int limit,
    required int offset,
    String? bankFilter,
    String? categoryId,
    String? typeFilter,
    String? searchQuery,
    String? sortBy,
    bool descending = true,
  }) {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;

      final List<String> whereClauses = [];
      final List<dynamic> whereArgs = [];

      if (bankFilter != null && bankFilter != 'All' && bankFilter.isNotEmpty) {
        whereClauses.add(
          '(card_identifier = ? OR normalized_merchant LIKE ? OR raw_merchant LIKE ?)',
        );
        whereArgs.add(bankFilter);
        whereArgs.add('%$bankFilter%');
        whereArgs.add('%$bankFilter%');
      }

      if (categoryId != null && categoryId.isNotEmpty) {
        whereClauses.add('category_id = ?');
        whereArgs.add(categoryId);
      }

      if (typeFilter != null && typeFilter != 'All' && typeFilter.isNotEmpty) {
        whereClauses.add('transaction_type = ?');
        whereArgs.add(typeFilter.toLowerCase());
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        whereClauses.add('(normalized_merchant LIKE ? OR raw_merchant LIKE ?)');
        final queryPattern = '%${searchQuery.trim()}%';
        whereArgs.add(queryPattern);
        whereArgs.add(queryPattern);
      }

      final String whereSection = whereClauses.isNotEmpty
          ? 'WHERE ${whereClauses.join(' AND ')}'
          : '';

      String orderByColumn = 'timestamp';
      if (sortBy == 'amount') {
        orderByColumn = 'amount';
      } else if (sortBy == 'confidence') {
        orderByColumn = 'confidence_score';
      }

      final String direction = descending ? 'DESC' : 'ASC';

      final queryStr =
          '''
        SELECT * FROM transactions
        $whereSection
        ORDER BY $orderByColumn $direction
        LIMIT ? OFFSET ?
      ''';

      whereArgs.add(limit);
      whereArgs.add(offset);

      final results = await db.rawQuery(queryStr, whereArgs);
      final list = results.map((row) => _transactionDao.fromMap(row)).toList();
      return list;
    });
  }

  @override
  Future<Result<TransactionDetails>> getTransactionDetails(String id) {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;

      // 1. Fetch transaction
      final txResult = await _transactionDao.findById(id);
      if (txResult is FailureResult<ParsedTransaction?>) {
        throw txResult.failure;
      }
      final transaction = (txResult as Success<ParsedTransaction?>).data;
      if (transaction == null) {
        throw DatabaseCorruptionFailure(
          code: 'BY_TX_NOT_FOUND',
          message: 'Transaction with ID $id was not found in database.',
        );
      }

      // 2. Fetch note
      final noteResults = await db.query(
        'notes',
        columns: ['note_text'],
        where: 'transaction_id = ?',
        whereArgs: [id],
        limit: 1,
      );
      final note = noteResults.isNotEmpty
          ? noteResults.first['note_text'] as String
          : null;

      // 3. Fetch category
      TransactionCategory? category;
      if (transaction.categoryId != null) {
        final catResults = await db.query(
          'categories',
          where: 'id = ?',
          whereArgs: [transaction.categoryId],
          limit: 1,
        );
        if (catResults.isNotEmpty) {
          category = CategoryDto.fromMap(catResults.first);
        }
      }

      // 4. Fetch tags
      final tagResults = await db.rawQuery(
        '''
        SELECT t.label_text FROM tags t
        INNER JOIN transaction_tags tt ON t.id = tt.tag_id
        WHERE tt.transaction_id = ?
      ''',
        [id],
      );
      final tags = tagResults.map((r) => r['label_text'] as String).toList();

      // 5. Fetch raw SMS text if available
      String? rawSmsText;
      if (transaction.sourceSmsId != null) {
        final smsResults = await db.query(
          'bank_messages',
          columns: ['raw_text'],
          where: 'id = ?',
          whereArgs: [transaction.sourceSmsId],
          limit: 1,
        );
        if (smsResults.isNotEmpty) {
          rawSmsText = smsResults.first['raw_text'] as String;
        }
      }

      return TransactionDetails(
        transactionId: id,
        transaction: transaction,
        note: note,
        category: category,
        tags: tags,
        rawSmsText: rawSmsText,
      );
    });
  }

  @override
  Future<Result<void>> saveNote(String transactionId, String text) {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;
      final noteId = 'note_$transactionId';
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await db.insert('notes', {
        'id': noteId,
        'transaction_id': transactionId,
        'note_text': text,
        'edited_at': timestamp,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  @override
  Future<Result<void>> deleteNote(String transactionId) {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;
      await db.delete(
        'notes',
        where: 'transaction_id = ?',
        whereArgs: [transactionId],
      );
    });
  }

  @override
  Future<Result<void>> assignCategory(
    String transactionId,
    String? categoryId,
  ) {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;
      await db.update(
        'transactions',
        {'category_id': categoryId},
        where: 'id = ?',
        whereArgs: [transactionId],
      );
    });
  }

  @override
  Future<Result<void>> assignTags(String transactionId, List<String> tags) {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;

      await db.transaction((txn) async {
        // 1. Clear existing relations
        await txn.delete(
          'transaction_tags',
          where: 'transaction_id = ?',
          whereArgs: [transactionId],
        );

        // 2. Insert new tags & relations
        for (final tagLabel in tags) {
          final trimmed = tagLabel.trim();
          if (trimmed.isEmpty) continue;

          // Check if tag exists
          final existing = await txn.query(
            'tags',
            columns: ['id'],
            where: 'label_text = ?',
            whereArgs: [trimmed],
            limit: 1,
          );

          String tagId;
          if (existing.isEmpty) {
            tagId =
                'tag_${trimmed.hashCode}_${DateTime.now().microsecondsSinceEpoch}';
            await txn.insert('tags', {
              'id': tagId,
              'label_text': trimmed,
              'created_at': DateTime.now().millisecondsSinceEpoch,
            });
          } else {
            tagId = existing.first['id'] as String;
          }

          // Insert relationship
          await txn.insert('transaction_tags', {
            'transaction_id': transactionId,
            'tag_id': tagId,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      });
    });
  }

  @override
  Future<Result<List<TransactionCategory>>> getCategories() {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;

      // Seed categories if empty
      await _seedCategoriesIfEmpty(db);

      final results = await db.query('categories');
      return results.map((row) => CategoryDto.fromMap(row)).toList();
    });
  }

  @override
  Future<Result<List<String>>> getTags() {
    return executeSafe(() async {
      final db = _transactionDao.dbService.database;
      final results = await db.query('tags', columns: ['label_text']);
      return results.map((row) => row['label_text'] as String).toList();
    });
  }

  Future<void> _seedCategoriesIfEmpty(Database db) async {
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM categories',
    );
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count == 0) {
      final defaultCategories = [
        {
          'id': 'cat-food',
          'name': 'غذا و رستوران',
          'color_hex': '#FF9800',
          'is_system_defined': 1,
        },
        {
          'id': 'cat-transport',
          'name': 'حمل و نقل',
          'color_hex': '#2196F3',
          'is_system_defined': 1,
        },
        {
          'id': 'cat-bills',
          'name': 'قبوض و خدمات',
          'color_hex': '#9C27B0',
          'is_system_defined': 1,
        },
        {
          'id': 'cat-shopping',
          'name': 'خرید',
          'color_hex': '#E91E63',
          'is_system_defined': 1,
        },
        {
          'id': 'cat-salary',
          'name': 'حقوق و درآمد',
          'color_hex': '#4CAF50',
          'is_system_defined': 1,
        },
        {
          'id': 'cat-medical',
          'name': 'سلامت و درمان',
          'color_hex': '#F44336',
          'is_system_defined': 1,
        },
        {
          'id': 'cat-misc',
          'name': 'متفرقه',
          'color_hex': '#9E9E9E',
          'is_system_defined': 1,
        },
      ];

      final batch = db.batch();
      for (final cat in defaultCategories) {
        batch.insert(
          'categories',
          cat,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true);
    }
  }
}
