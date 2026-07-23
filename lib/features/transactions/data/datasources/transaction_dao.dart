import '../../../../core/database/sqlite_base_dao.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../models/transaction_dto.dart';

/// Relational Data Access Object mapping [ParsedTransaction] to SQLite pages.
class TransactionDao extends SqliteBaseDao<ParsedTransaction> {
  /// Constructor injecting DB Service and standard logger.
  TransactionDao(super.dbService, super.logger);

  @override
  String get tableName => 'transactions';

  @override
  String get chronologicalColumn => 'timestamp';

  @override
  Map<String, dynamic> toMap(ParsedTransaction entity) {
    return TransactionDto.toMap(entity);
  }

  @override
  ParsedTransaction fromMap(Map<String, dynamic> map) {
    return TransactionDto.fromMap(map);
  }
}
