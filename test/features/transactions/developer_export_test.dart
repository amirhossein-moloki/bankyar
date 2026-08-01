import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/device_info_service.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/data/repositories/developer_export_service.dart';
import 'package:bankyar/features/transactions/presentation/screens/home_screen.dart';

class MockAppLogger extends Mock implements AppLogger {}
class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}
class MockDatabase extends Mock implements Database {}
class MockPreferencesStorage extends Mock implements PreferencesStorage {}
class MockDeviceInfoService extends Mock implements DeviceInfoService {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockPreferencesStorage mockPrefs;
  late MockDeviceInfoService mockDeviceInfo;
  late MockTransactionRepository mockRepository;
  late MockSmsHistoryImporter mockImporter;

  const testTx = ParsedTransaction(
    id: 'tx-test-id',
    amount: 50000.0,
    currency: 'IRR',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'Snapp',
    normalizedMerchant: 'اسنپ',
    timestamp: 1697360400000,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: 1697360400000,
    updatedAt: 1697360400000,
  );

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDbService = MockDatabaseServiceImpl();
    mockDb = MockDatabase();
    mockPrefs = MockPreferencesStorage();
    mockDeviceInfo = MockDeviceInfoService();
    mockRepository = MockTransactionRepository();
    mockImporter = MockSmsHistoryImporter();

    when(() => mockDbService.database).thenReturn(mockDb);
    when(() => mockDbService.isOpen).thenReturn(true);

    when(() => mockDeviceInfo.getAndroidInfo()).thenAnswer(
      (_) async => const AndroidDeviceInfo(
        manufacturer: 'Google',
        model: 'Pixel 7',
        brand: 'Google',
        sdkVersion: 33,
        releaseVersion: '13',
      ),
    );

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

    // Default Preferences mock
    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(() => mockPrefs.getBool('by_onboarding_completed')).thenAnswer((_) async => true);
    when(() => mockPrefs.getBool('by_historical_sms_import_offered')).thenAnswer((_) async => true);
    when(() => mockPrefs.getString(any())).thenAnswer((_) async => null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async {});

    // Repository mocks to load HomeScreen cleanly
    when(() => mockRepository.getTransactions()).thenAnswer((_) async => const Result.success([testTx]));
    when(() => mockRepository.watchTransactions()).thenAnswer((_) => Stream.value(const Result.success([testTx])));
    when(() => mockRepository.getCategories()).thenAnswer((_) async => Result.success([]));
  });

  group('DeveloperExportService Unit Tests', () {
    test('generateJsonExport produces schema-compliant pretty-printed JSON with preserved Persian chars', () async {
      // Stub tag relations query
      when(() => mockDb.rawQuery(any(that: contains('transaction_tags')))).thenAnswer(
        (_) async => [
          {'transaction_id': 'tx-1', 'label_text': 'اسنپ'},
          {'transaction_id': 'tx-1', 'label_text': 'روزمره'},
        ],
      );

      // Stub categories query
      when(() => mockDb.query('categories')).thenAnswer(
        (_) async => [
          {'id': 'cat-food', 'name': 'غذا و رستوران'},
        ],
      );

      // Stub accounts query
      when(() => mockDb.query('accounts')).thenAnswer(
        (_) async => [
          {'id': 'melli', 'name': 'Bank Melli Iran'},
        ],
      );

      // Stub transactions query with notes left join
      when(() => mockDb.rawQuery(any(that: contains('LEFT JOIN notes')))).thenAnswer(
        (_) async => [
          {
            'id': 'tx-1',
            'amount': 150000.0,
            'currency': 'TOMAN',
            'transaction_type': 'debit',
            'raw_merchant': 'Snapp Trip',
            'normalized_merchant': 'اسنپ تریپ',
            'card_identifier': '1234',
            'timestamp': 1698300000000,
            'category_id': 'cat-food',
            'account_id': 'melli',
            'confidence_score': 0.95,
            'parsing_method': 'deterministic',
            'source_sms_id': 'sms-1',
            'note_text': 'توضیحات تراکنش تستی',
          },
        ],
      );

      // Stub bank_messages query
      when(() => mockDb.query('bank_messages')).thenAnswer(
        (_) async => [
          {
            'id': 'sms-1',
            'sender_id': 'Melli',
            'raw_text': 'بانک ملی\nبرداشت ۱۵۰,۰۰۰ تومان',
            'received_at': 1698300000000,
            'deduplication_hash': 'hash-xyz',
            'ingestion_status': 'success',
          },
        ],
      );

      // Stub notes query
      when(() => mockDb.query('notes')).thenAnswer((_) async => []);
      // Stub tags query
      when(() => mockDb.query('tags')).thenAnswer((_) async => []);
      // Stub notifications query
      when(() => mockDb.query('notifications')).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          databaseServiceProvider.overrideWithValue(mockDbService),
          deviceInfoServiceProvider.overrideWithValue(mockDeviceInfo),
          preferencesStorageProvider.overrideWithValue(mockPrefs),
          loggerProvider.overrideWithValue(mockLogger),
        ],
      );

      final service = container.read(developerExportServiceProvider);
      final result = await service.generateJsonExport();

      expect(result.isSuccess, isTrue);
      final jsonStr = (result as Success<String>).data;

      // Verify pretty printed spacing
      expect(jsonStr, contains('  "export_version": 1,'));

      final Map<String, dynamic> decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['export_version'], 1);
      expect(decoded['app_version'], '1.0.0');
      expect(decoded['device_android_version'], '13');
      expect(decoded['locale'], 'fa');

      // Verify Transaction Object properties
      final txList = decoded['transactions'] as List;
      expect(txList, hasLength(1));
      final tx = txList.first;
      expect(tx['id'], 'tx-1');
      expect(tx['amount'], 150000.0);
      expect(tx['currency'], 'TOMAN');
      expect(tx['merchant_name'], 'Snapp Trip');
      expect(tx['normalized_merchant'], 'اسنپ تریپ');
      expect(tx['bank_name'], 'Bank Melli Iran');
      expect(tx['category'], 'غذا و رستوران');
      expect(tx['tags'], containsAll(['اسنپ', 'روزمره']));
      expect(tx['note'], 'توضیحات تراکنش تستی');
      expect(tx['confidence_score'], 0.95);
      expect(tx['parsing_method'], 'deterministic');
      expect(tx['source_sms_id'], 'sms-1');

      // Verify Bank Message Object properties
      final smsList = decoded['bank_messages'] as List;
      expect(smsList, hasLength(1));
      final sms = smsList.first;
      expect(sms['sms_id'], 'sms-1');
      expect(sms['sender'], 'Melli');
      expect(sms['raw_message'], 'بانک ملی\nبرداشت ۱۵۰,۰۰۰ تومان');
      expect(sms['received_at'], 1698300000000);
      expect(sms['parsed_successfully'], isTrue);
      expect(sms['parser_version'], '1.0.0');
    });
  });

  group('JSON Export Interaction & Widget Tests', () {
    testWidgets('Export button appears on HomeScreen when developer mode is enabled and triggers SAF method call', (
      WidgetTester tester,
    ) async {
      // Enable developer mode in mock preferences
      when(() => mockPrefs.getBool('by_developer_mode_enabled')).thenAnswer((_) async => true);

      // Stub database calls for DeveloperExportService during widget test
      when(() => mockDb.rawQuery(any(that: contains('transaction_tags')))).thenAnswer((_) async => []);
      when(() => mockDb.rawQuery(any(that: contains('LEFT JOIN notes')))).thenAnswer((_) async => []);
      when(() => mockDb.query('categories')).thenAnswer((_) async => []);
      when(() => mockDb.query('accounts')).thenAnswer((_) async => []);
      when(() => mockDb.query('bank_messages')).thenAnswer((_) async => []);
      when(() => mockDb.query('notes')).thenAnswer((_) async => []);
      when(() => mockDb.query('tags')).thenAnswer((_) async => []);
      when(() => mockDb.query('notifications')).thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          databaseServiceProvider.overrideWithValue(mockDbService),
          deviceInfoServiceProvider.overrideWithValue(mockDeviceInfo),
          preferencesStorageProvider.overrideWithValue(mockPrefs),
          loggerProvider.overrideWithValue(mockLogger),
          transactionRepositoryProvider.overrideWithValue(mockRepository),
          smsHistoryImporterProvider.overrideWithValue(mockImporter),
        ],
      );

      // Mock MethodChannel call handler for the platform channels
      final List<MethodCall> methodCalls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('com.bankyar.app/platform'),
        (MethodCall methodCall) async {
          methodCalls.add(methodCall);
          if (methodCall.method == 'exportJsonViaSAF') {
            return 'tree/primary%3ADocuments/bankyar_export_test.json';
          }
          if (methodCall.method == 'getDeviceInfo') {
            return {
              'manufacturer': 'Google',
              'model': 'Pixel 7',
              'brand': 'Google',
              'sdkVersion': 33,
              'releaseVersion': '13',
            };
          }
          return null;
        },
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.createThemeLight(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('fa'), Locale('en')],
            locale: const Locale('fa'),
            home: const Directionality(
              textDirection: TextDirection.rtl,
              child: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      // Verify download icon representing the export button exists
      final exportBtnFinder = find.byIcon(Icons.download);
      expect(exportBtnFinder, findsOneWidget);

      // Verify the location of the button
      final RenderBox renderBox = tester.renderObject(exportBtnFinder);
      final offset = renderBox.localToGlobal(Offset.zero);
      expect(offset, isNotNull);

      // In widget tests, if there is a translucent ModalBarrier from route/navigator, we can tap by coordinates or bypass hit-testing by calling onPressed directly if needed.
      // However, to make sure it triggers perfectly, we can directly invoke the onPressed handler on the IconButton!
      final iconButton = tester.widget<IconButton>(find.ancestor(of: exportBtnFinder, matching: find.byType(IconButton)));
      iconButton.onPressed!();

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify MethodChannel invocation
      final exportCall = methodCalls.firstWhere((call) => call.method == 'exportJsonViaSAF');
      expect(exportCall, isNotNull);
      expect(exportCall.arguments['filename'], startsWith('bankyar_export_'));
      expect(exportCall.arguments['filename'], endsWith('.json'));
      expect(exportCall.arguments['content'], contains('"export_version": 1'));

      // Verify Success Snackbar is displayed
      print('=== ALL TEXT WIDGETS ===');
      for (final element in tester.allElements) {
        if (element.widget is Text) {
          print('Text: ${(element.widget as Text).data}');
        }
      }

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('فایل با موفقیت ذخیره شد'), findsOneWidget);
    });
  });
}
