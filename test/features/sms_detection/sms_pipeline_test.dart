import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/uuid.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/bank_message_entity.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/data/datasources/bank_message_dao.dart';
import 'package:bankyar/features/sms_detection/data/parser/sms_pipeline_engine.dart';
import 'package:bankyar/features/sms_detection/data/repositories/sms_parser_repository_impl.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

class MockBankMessageDao extends Mock implements BankMessageDao {}

class MockUuidGenerator extends Mock implements UuidGenerator {}

class MockClock extends Mock implements Clock {}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockTransaction mockTxn;
  late MockBankMessageDao mockBankMessageDao;
  late MockUuidGenerator mockUuid;
  late MockClock mockClock;
  late SmsParserRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.parser);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDbService = MockDatabaseServiceImpl();
    mockDb = MockDatabase();
    mockTxn = MockTransaction();
    mockBankMessageDao = MockBankMessageDao();
    mockUuid = MockUuidGenerator();
    mockClock = MockClock();

    when(() => mockDbService.database).thenReturn(mockDb);
    when(() => mockUuid.generateV4()).thenAnswer((_) => 'mock-id-uuid-v4');
    when(() => mockClock.now()).thenReturn(DateTime(2023, 10, 15, 12, 0, 0));

    // Mock logger.log to simply return
    when(
      () => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);

    repository = SmsParserRepositoryImpl(
      dbService: mockDbService,
      bankMessageDao: mockBankMessageDao,
      uuidGenerator: mockUuid,
      clock: mockClock,
      logger: mockLogger,
    );
  });

  group('SmsPipelineEngine Pure Processing Tests', () {
    const engine = SmsPipelineEngine();

    test('parses a valid Bank Melli transaction SMS correctly', () {
      const rawText = 'بانک ملی\nواریز مبلغ ۱۰,۰۰۰ ریال\nبه حساب *۱۲۳۴';
      final result = engine.process(
        rawText: rawText,
        senderId: 'Melli',
        receivedAt: 1697360400000,
        isDuplicate: false,
        messageId: 'msg-1',
        transactionId: 'tx-1',
      );

      expect(result.status, IngestionStatus.success);
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, 10000.0);
      expect(result.transaction!.cardIdentifier, '1234');
      expect(result.transaction!.transactionType, SmsTransactionType.credit);
    });

    test('ignores / filters spam or non-banking messages', () {
      const rawText = 'سلام، فردا ساعت ۵ جلسه است.';
      final result = engine.process(
        rawText: rawText,
        senderId: 'MyFriend',
        receivedAt: 1697360400000,
        isDuplicate: false,
        messageId: 'msg-1',
        transactionId: 'tx-1',
      );

      expect(result.status, IngestionStatus.ignored);
      expect(result.transaction, isNull);
    });

    test('handles duplicated message status cleanly', () {
      const rawText = 'بانک ملی\nواریز مبلغ ۱۰,۰۰۰ ریال\nبه حساب *۱۲۳۴';
      final result = engine.process(
        rawText: rawText,
        senderId: 'Melli',
        receivedAt: 1697360400000,
        isDuplicate: true,
        messageId: 'msg-1',
        transactionId: 'tx-1',
      );

      expect(result.status, IngestionStatus.duplicate);
      expect(result.transaction, isNull);
    });

    test('handles empty message content with failure', () {
      final result = engine.process(
        rawText: '',
        senderId: '',
        receivedAt: 1697360400000,
        isDuplicate: false,
        messageId: 'msg-1',
        transactionId: 'tx-1',
      );

      expect(result.status, IngestionStatus.failure);
      expect(result.transaction, isNull);
    });
  });

  group('SmsParserRepository Database Integration Tests', () {
    test(
      'processAndSaveSms executes relational transaction successfully on valid SMS',
      () async {
        const rawText = 'بانک ملی\nواریز مبلغ ۱۰,۰۰۰ ریال\nبه حساب *۱۲۳۴';

        // Mock db duplicate query to return empty (not duplicate)
        when(
          () => mockDb.query(
            'bank_messages',
            where: any(named: 'where'),
            whereArgs: any(named: 'whereArgs'),
            limit: 1,
          ),
        ).thenAnswer((_) async => []);

        // Mock database transaction executor supporting inferred <Null> generic type parameters
        when(() => mockDb.transaction<Null>(any())).thenAnswer((
          invocation,
        ) async {
          final Function transactionCallback =
              invocation.positionalArguments[0] as Function;

          await transactionCallback(mockTxn);
          return null;
        });

        // Mock insert on transaction
        when(
          () => mockTxn.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.processAndSaveSms(
          rawText: rawText,
          senderId: 'Melli',
          receivedAt: 1697360400000,
        );

        expect(result, isA<Success<ParsedTransaction?>>());
        final tx = (result as Success<ParsedTransaction?>).data;
        expect(tx, isNotNull);
        expect(tx!.amount, 10000.0);
        expect(tx.cardIdentifier, '1234');

        // Verify transaction database writes
        verify(
          () => mockTxn.insert(
            'bank_messages',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).called(1);
        verify(
          () => mockTxn.insert(
            'transactions',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).called(1);
      },
    );

    test('isDuplicate returns true when hash is registered in DB', () async {
      when(
        () => mockDb.query(
          'bank_messages',
          where: any(named: 'where'),
          whereArgs: any(named: 'whereArgs'),
          limit: 1,
        ),
      ).thenAnswer(
        (_) async => [
          {'id': 'msg-1'},
        ],
      );

      final result = await repository.isDuplicate('hash-test-123');
      expect(result, isA<Success<bool>>());
      expect((result as Success<bool>).data, isTrue);
    });

    test(
      'saveParsedTransaction inserts transaction record successfully',
      () async {
        const tx = ParsedTransaction(
          id: 'tx-1',
          amount: 50000.0,
          currency: 'IRR',
          transactionType: SmsTransactionType.debit,
          rawMerchant: 'Snapp',
          normalizedMerchant: 'Snapp',
          timestamp: 1697360400000,
          confidenceScore: 1.0,
          parsingMethod: 'deterministic',
          createdAt: 1697360400000,
          updatedAt: 1697360400000,
        );

        when(
          () => mockDb.insert(
            'transactions',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).thenAnswer((_) async => 1);

        final result = await repository.saveParsedTransaction(tx);
        expect(result, isA<Success<void>>());
        verify(
          () => mockDb.insert(
            'transactions',
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          ),
        ).called(1);
      },
    );
  });
}
