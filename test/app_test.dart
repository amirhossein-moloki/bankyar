import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/app.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/usecases/get_transactions_use_case.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockDatabase extends Mock implements Database {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDbService = MockDatabaseServiceImpl();
    mockDb = MockDatabase();
    mockPrefs = MockPreferencesStorage();
    mockImporter = MockSmsHistoryImporter();
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();

    when(() => mockDbService.database).thenReturn(mockDb);

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

    // Default mock behavior for secure storage preferences
    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => null);
    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) async => 0);

    // Return empty transactions list on startup stream
    when(() => mockGetTransactionsUseCase(any())).thenAnswer(
      (_) => Stream.value(const Result.success(<ParsedTransaction>[])),
    );
  });

  group('BankYarApp Bootstrapping Smoke Tests', () {
    testWidgets('App renders placeholder elements successfully', (
      tester,
    ) async {
      // Build our app and trigger a frame with appropriate provider overrides.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            getTransactionsUseCaseProvider.overrideWithValue(
              mockGetTransactionsUseCase,
            ),
          ],
          child: const BankYarApp(),
        ),
      );

      // Verify that the router's initial home dashboard route starts loaded
      await tester.pumpAndSettle();

      expect(find.text('سلام، سهراب عزیز'), findsOneWidget);
    });
  });
}
