import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/platform/secure_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:bankyar/features/payment_monitor/data/datasources/payment_api_client.dart';
import 'package:bankyar/features/payment_monitor/data/datasources/payment_request_dao.dart';
import 'package:bankyar/features/payment_monitor/data/models/payment_request_dto.dart';
import 'package:bankyar/features/payment_monitor/data/repositories/payment_monitor_repository_impl.dart';
import 'package:bankyar/features/payment_monitor/domain/entities/payment_monitor_config.dart';
import 'package:bankyar/features/payment_monitor/domain/entities/payment_request_log.dart';
import 'package:bankyar/features/payment_monitor/domain/entities/system_log_entry.dart';
import 'package:bankyar/features/payment_monitor/domain/repository/payment_monitor_repository.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/features/payment_monitor/presentation/screens/payment_monitor_screen.dart';
import 'package:bankyar/features/payment_monitor/presentation/state/payment_monitor_notifier.dart';
import 'package:bankyar/features/payment_monitor/data/di/payment_monitor_providers.dart';

class MockPaymentRequestDao extends Mock implements PaymentRequestDao {}

class MockPaymentApiClient extends Mock implements PaymentApiClient {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockAppLogger extends Mock implements AppLogger {}

class MockPaymentMonitorRepository extends Mock
    implements PaymentMonitorRepository {}

void main() {
  group('PaymentApiClient Unit Tests', () {
    final logger = MockAppLogger();
    final apiClient = PaymentApiClient(logger: logger);

    test('buildEndpointUrl appends /api/auto_verify.php correctly', () {
      expect(
        apiClient.buildEndpointUrl('https://example.com'),
        equals('https://example.com/api/auto_verify.php'),
      );
      expect(
        apiClient.buildEndpointUrl('example.com/'),
        equals('https://example.com/api/auto_verify.php'),
      );
      expect(
        apiClient.buildEndpointUrl('http://my-server.ir'),
        equals('http://my-server.ir/api/auto_verify.php'),
      );
    });

    test('PaymentRequestDto toApiPayload converts values correctly', () {
      const dto = PaymentRequestDto(
        id: 'req_123',
        bankName: 'Melli',
        amount: 100000.0,
        cardLastFour: '1234',
        referenceNumber: '9876543210',
        smsRaw: 'واریز 100000 ریال',
        detectedAt: 1700000000000,
        status: 'Detected',
      );

      final payload = dto.toApiPayload('secret_token');
      expect(payload['api_token'], equals('secret_token'));
      expect(payload['bank_name'], equals('Melli'));
      expect(payload['amount'], equals(100000));
      expect(payload['source_card_last_four'], equals('1234'));
      expect(payload['ref_num'], equals('9876543210'));
      expect(payload['sms_raw'], equals('واریز 100000 ریال'));
      expect(payload['timestamp'], equals(1700000000));
    });
  });

  group('PaymentMonitorConfig Unit Tests', () {
    test('maskedToken masks API token preserving last 4 digits', () {
      const config1 = PaymentMonitorConfig(apiToken: 'abcdef123456');
      expect(config1.maskedToken, equals('****************3456'));

      const config2 = PaymentMonitorConfig(apiToken: 'abcd');
      expect(config2.maskedToken, equals('****'));

      const config3 = PaymentMonitorConfig(apiToken: '');
      expect(config3.maskedToken, equals(''));
    });
  });

  group('PaymentMonitorRepositoryImpl Logic Tests', () {
    late MockPaymentRequestDao mockDao;
    late MockPaymentApiClient mockApiClient;
    late MockPreferencesStorage mockPrefs;
    late MockSecureStorage mockSecure;
    late MockAppLogger mockLogger;
    late PaymentMonitorRepositoryImpl repository;

    setUp(() {
      mockDao = MockPaymentRequestDao();
      mockApiClient = MockPaymentApiClient();
      mockPrefs = MockPreferencesStorage();
      mockSecure = MockSecureStorage();
      mockLogger = MockAppLogger();

      repository = PaymentMonitorRepositoryImpl(
        dao: mockDao,
        apiClient: mockApiClient,
        preferencesStorage: mockPrefs,
        secureStorage: mockSecure,
        logger: mockLogger,
      );

      when(
        () => mockDao.insertSystemLog(any()),
      ).thenAnswer((_) async => const Result.success(null));
    });

    test('getConfig retrieves saved config from preferences and secure storage', () async {
      when(() => mockPrefs.getString('pay_mon_domain'))
          .thenAnswer((_) async => 'https://example.com');
      when(() => mockSecure.read('pay_mon_api_token'))
          .thenAnswer((_) async => 'secret_12345');
      when(() => mockPrefs.getBool('pay_mon_auto_upload'))
          .thenAnswer((_) async => true);
      when(() => mockPrefs.getInt('pay_mon_last_test_at'))
          .thenAnswer((_) async => null);
      when(() => mockPrefs.getBool('pay_mon_last_test_success'))
          .thenAnswer((_) async => null);
      when(() => mockPrefs.getString('pay_mon_last_test_msg'))
          .thenAnswer((_) async => null);

      final configRes = await repository.getConfig();
      expect(configRes.isSuccess, isTrue);
      final config = configRes.dataOrNull!;
      expect(config.domain, equals('https://example.com'));
      expect(config.apiToken, equals('secret_12345'));
      expect(config.isAutoUploadEnabled, isTrue);
      expect(config.maskedToken, equals('****************2345'));
    });

    test('saveDomain and saveApiToken update storage', () async {
      when(() => mockPrefs.setString('pay_mon_domain', 'https://bankyar.ir'))
          .thenAnswer((_) async => true);
      when(() => mockSecure.write(key: 'pay_mon_api_token', value: 'my_token'))
          .thenAnswer((_) async => null);

      final domainRes = await repository.saveDomain('https://bankyar.ir');
      final tokenRes = await repository.saveApiToken('my_token');

      expect(domainRes.isSuccess, isTrue);
      expect(tokenRes.isSuccess, isTrue);

      verify(() => mockPrefs.setString('pay_mon_domain', 'https://bankyar.ir')).called(1);
      verify(() => mockSecure.write(key: 'pay_mon_api_token', value: 'my_token')).called(1);
    });

    test('findRequestByReferenceNumber returns entity on DAO hit', () async {
      final map = {
        'id': 'pay_1',
        'bank_name': 'Melli',
        'amount': 100000.0,
        'card_last_four': '1234',
        'reference_number': 'REF123',
        'sms_raw': 'raw sms',
        'detected_at': 1700000000000,
        'sent_at': null,
        'status': 'Success',
        'retry_count': 0,
        'api_response': 'Payment verified',
        'error_message': null,
      };

      when(() => mockDao.findRequestByReferenceNumber('REF123'))
          .thenAnswer((_) async => Result.success(map));

      final res = await repository.findRequestByReferenceNumber('REF123');
      expect(res.isSuccess, isTrue);
      final item = res.dataOrNull;
      expect(item, isNotNull);
      expect(item!.bankName, equals('Melli'));
      expect(item.status, equals(PaymentRequestStatus.success));
    });
  });

  group('PaymentMonitorScreen Widget Tests', () {
    late MockPaymentMonitorRepository mockRepo;

    setUp(() {
      mockRepo = MockPaymentMonitorRepository();

      when(() => mockRepo.getConfig()).thenAnswer(
        (_) async => const Result.success(
          PaymentMonitorConfig(
            domain: 'https://example.com',
            apiToken: 'test_token_1234',
            isAutoUploadEnabled: false,
          ),
        ),
      );

      when(() => mockRepo.getAllRequests()).thenAnswer(
        (_) async => Result.success([
          PaymentRequestLog(
            id: 'req_1',
            bankName: 'Melli',
            amount: 100000.0,
            cardLastFour: '1234',
            referenceNumber: '9876543210',
            smsRaw: 'sms raw text',
            detectedAt: DateTime.now(),
            status: PaymentRequestStatus.success,
          ),
        ]),
      );

      when(() => mockRepo.getPendingCount()).thenAnswer(
        (_) async => const Result.success(0),
      );

      when(() => mockRepo.getFailedCount()).thenAnswer(
        (_) async => const Result.success(0),
      );

      when(() => mockRepo.getSystemLogs(limit: any(named: 'limit'))).thenAnswer(
        (_) async => Result.success([
          SystemLogEntry(
            id: 'sys_1',
            timestamp: DateTime.now(),
            event: 'Bank SMS detected',
            details: 'From: Melli',
          ),
        ]),
      );
    });

    testWidgets('Renders all required sections and history card', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            paymentMonitorRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            theme: AppTheme.createThemeLight(),
            home: const PaymentMonitorScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('پایش پرداخت (Payment Monitor)'), findsOneWidget);
      expect(find.text('API Connection'), findsAtLeastNWidgets(1));
      expect(find.text('Server Domain'), findsOneWidget);
      expect(find.text('API Token'), findsOneWidget);
      expect(find.text('Test Connection'), findsOneWidget);
      expect(find.text('Automatic Payment Upload'), findsOneWidget);
      expect(find.text('Queue Status'), findsOneWidget);
      expect(find.text('Payment Request History'), findsOneWidget);
      expect(find.text('System Status'), findsOneWidget);
      expect(find.text('System Logs'), findsOneWidget);
      expect(find.text('Bank: Melli'), findsOneWidget);
      expect(find.text('Bank SMS detected'), findsOneWidget);
    });
  });
}
