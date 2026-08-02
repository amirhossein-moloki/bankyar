import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';

/// Service responsible for querying, fetching, formatting and serializing DB tables
/// into an unencrypted, pretty-printed developer JSON.
class DeveloperExportService {
  /// Constructor.
  DeveloperExportService({
    required DatabaseService databaseService,
    required ProviderRef<DeveloperExportService> ref,
  }) : _databaseService = databaseService,
       _ref = ref;

  final DatabaseService _databaseService;
  final ProviderRef<DeveloperExportService> _ref;

  /// Fetches all records from localized tables and returns a pretty-printed UTF-8 JSON.
  Future<Result<String>> generateJsonExport() async {
    try {
      print('[EXPORT_SERVICE] generateJsonExport START');
      final dbService = _databaseService as DatabaseServiceImpl;
      if (!dbService.isOpen) {
        return const Result.failure(
          DatabaseCorruptionFailure(
            code: 'BY_EXPORT_DB_CLOSED',
            message: 'پایگاه داده باز نیست.',
          ),
        );
      }
      final db = dbService.database;

      // 1. Fetch metadata
      final generatedAt = DateTime.now().toIso8601String();
      const appVersion = '1.0.0';

      String deviceAndroidVersion = '33'; // Default fallback
      try {
        print('[EXPORT_SERVICE] fetching android info');
        final deviceInfoService = _ref.read(deviceInfoServiceProvider);
        final info = await deviceInfoService.getAndroidInfo();
        deviceAndroidVersion = info.releaseVersion;
        print('[EXPORT_SERVICE] fetched android info: $deviceAndroidVersion');
      } catch (e) {
        print('[EXPORT_SERVICE] android info fetch error: $e');
      }

      // 2. Fetch tags associated with each transaction
      print('[EXPORT_SERVICE] fetching tag relations');
      final List<Map<String, dynamic>> tagRelations = await db.rawQuery('''
        SELECT tt.transaction_id, tg.label_text
        FROM transaction_tags tt
        INNER JOIN tags tg ON tt.tag_id = tg.id
      ''');
      print('[EXPORT_SERVICE] fetched tag relations: ${tagRelations.length}');

      final Map<String, List<String>> transactionTagsMap = {};
      for (final row in tagRelations) {
        final txId = row['transaction_id'] as String;
        final label = row['label_text'] as String;
        transactionTagsMap.putIfAbsent(txId, () => []).add(label);
      }

      // 3. Fetch categories cache
      print('[EXPORT_SERVICE] fetching categoriesRaw');
      final List<Map<String, dynamic>> categoriesRaw = await db.query(
        'categories',
      );
      final Map<String, String> categoryNamesMap = {
        for (final row in categoriesRaw)
          row['id'] as String: row['name'] as String,
      };

      // 4. Fetch accounts cache
      print('[EXPORT_SERVICE] fetching accountsRaw');
      final List<Map<String, dynamic>> accountsRaw = await db.query('accounts');
      final Map<String, String> bankNamesMap = {
        for (final row in accountsRaw)
          row['id'] as String: row['name'] as String,
      };

      // 5. Query and build transaction objects exactly as specified
      print('[EXPORT_SERVICE] fetching txRows');
      final List<Map<String, dynamic>> txRows = await db.rawQuery('''
        SELECT t.*, n.note_text
        FROM transactions t
        LEFT JOIN notes n ON t.id = n.transaction_id
        ORDER BY t.timestamp DESC
      ''');
      print('[EXPORT_SERVICE] fetched txRows: ${txRows.length}');

      final List<Map<String, dynamic>> transactions = txRows.map((row) {
        final txId = row['id'] as String;
        final catId = row['category_id'] as String?;
        final accId = row['account_id'] as String?;
        return {
          'id': txId,
          'amount': row['amount'] as double,
          'currency': row['currency'] as String,
          'transaction_type': row['transaction_type'] as String,
          'merchant_name': row['raw_merchant'] as String,
          'normalized_merchant': row['normalized_merchant'] as String,
          'bank_name':
              bankNamesMap[accId] ?? row['card_identifier'] ?? 'Unknown',
          'timestamp': row['timestamp'] as int,
          'category': catId != null ? categoryNamesMap[catId] : null,
          'tags': transactionTagsMap[txId] ?? <String>[],
          'note': row['note_text'] as String?,
          'confidence_score': row['confidence_score'] as double,
          'parsing_method': row['parsing_method'] as String,
          'source_sms_id': row['source_sms_id'] as String?,
        };
      }).toList();

      // 6. Query and build bank message objects exactly as specified
      print('[EXPORT_SERVICE] fetching smsRows');
      final List<Map<String, dynamic>> smsRows = await db.query(
        'bank_messages',
      );
      final List<Map<String, dynamic>> bankMessages = smsRows.map((row) {
        final status = row['ingestion_status'] as String;
        return {
          'sms_id': row['id'] as String,
          'sender': row['sender_id'] as String,
          'raw_message': row['raw_text'] as String,
          'received_at': row['received_at'] as int,
          'parsed_successfully': status == 'success',
          'parser_version': '1.0.0',
        };
      }).toList();

      // 7. Notes
      print('[EXPORT_SERVICE] fetching notes');
      final List<Map<String, dynamic>> notes = await db.query('notes');

      // 8. Categories
      print('[EXPORT_SERVICE] fetching categories');
      final List<Map<String, dynamic>> categories = await db.query(
        'categories',
      );

      // 9. Tags
      print('[EXPORT_SERVICE] fetching tags');
      final List<Map<String, dynamic>> tags = await db.query('tags');

      // 10. Notifications
      print('[EXPORT_SERVICE] fetching notifications');
      final List<Map<String, dynamic>> notifications = await db.query(
        'notifications',
      );

      print('[EXPORT_SERVICE] build exportMap');
      // Construct overall JSON
      final exportMap = {
        'export_version': 1,
        'generated_at': generatedAt,
        'app_version': appVersion,
        'device_android_version': deviceAndroidVersion,
        'locale': 'fa',
        'transactions': transactions,
        'bank_messages': bankMessages,
        'notes': notes,
        'categories': categories,
        'tags': tags,
        'notifications': notifications,
      };

      final prettyPrintedJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(exportMap);
      print('[EXPORT_SERVICE] generateJsonExport SUCCESS');
      return Result.success(prettyPrintedJson);
    } catch (e, stack) {
      print('[EXPORT_SERVICE] generateJsonExport ERROR: $e\n$stack');
      return Result.failure(
        FileAccessFailure(
          code: 'BY_EXPORT_GENERATE_FAILED',
          message: 'Failed to generate developer export: ${e.toString()}',
        ),
      );
    }
  }
}

/// Provider exposing the DeveloperExportService.
final developerExportServiceProvider = Provider<DeveloperExportService>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return DeveloperExportService(databaseService: dbService, ref: ref);
});
