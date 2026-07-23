import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/device_info_service.dart';
import 'package:bankyar/core/platform/sms_receiver_service.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/platform/background_service_manager.dart';
import 'package:bankyar/core/platform/work_scheduling_service.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/domain/usecases/process_incoming_sms_use_case.dart';

// Mocks
class MockAppLogger extends Mock implements AppLogger {}
class MockPermissionService extends Mock implements PermissionService {}
class MockPreferencesStorage extends Mock implements PreferencesStorage {}
class MockProcessIncomingSmsUseCase extends Mock implements ProcessIncomingSmsUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAppLogger mockLogger;
  late MockPermissionService mockPermissionService;
  late MockPreferencesStorage mockPreferencesStorage;
  late MockProcessIncomingSmsUseCase mockProcessUseCase;

  const MethodChannel channel = MethodChannel('com.bankyar.app/platform');

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(const ProcessIncomingSmsParams(
      rawText: '',
      senderId: '',
      receivedAt: 0,
    ));
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockPermissionService = MockPermissionService();
    mockPreferencesStorage = MockPreferencesStorage();
    mockProcessUseCase = MockProcessIncomingSmsUseCase();

    // Setup default logger mock behavior
    when(() => mockLogger.log(
      any(),
      any(),
      any(),
      any(),
      metadata: any(named: 'metadata'),
      error: any(named: 'error'),
      stackTrace: any(named: 'stackTrace'),
    )).thenReturn(null);
  });

  tearDown(() {
    // Clear MethodChannel mock handlers
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('SystemPermissionService state & stream tests', () {
    test('Check default permission statuses are granted', () async {
      final service = SystemPermissionService();
      final status = await service.checkStatus(AppPermission.smsRead);
      expect(status, PermissionStatus.granted);
      service.dispose();
    });

    test('Status observer stream broadcasts correct updates', () async {
      final service = SystemPermissionService();

      final statusesFuture = service.onStatusesChanged.first;
      service.setMockStatus(AppPermission.smsRead, PermissionStatus.denied);

      final statuses = await statusesFuture;
      expect(statuses[AppPermission.smsRead], PermissionStatus.denied);
      service.dispose();
    });

    test('request permission returns immediately if already granted', () async {
      final service = SystemPermissionService();
      final status = await service.request(AppPermission.smsRead);
      expect(status, PermissionStatus.granted);
      service.dispose();
    });

    test('request permission transitions successfully', () async {
      final service = SystemPermissionService();
      service.setMockStatus(AppPermission.smsRead, PermissionStatus.denied);

      final status = await service.request(AppPermission.smsRead);
      expect(status, PermissionStatus.granted);
      service.dispose();
    });

    test('request permission stays permanentlyDenied', () async {
      final service = SystemPermissionService();
      service.setMockStatus(AppPermission.smsRead, PermissionStatus.permanentlyDenied);

      final status = await service.request(AppPermission.smsRead);
      expect(status, PermissionStatus.permanentlyDenied);
      service.dispose();
    });

    test('openSettings executes without exception', () async {
      final service = SystemPermissionService();
      await expectLater(service.openSettings(), completes);
      service.dispose();
    });
  });

  group('AndroidDeviceInfoService Tests', () {
    test('getAndroidInfo queries platform and parses correctly', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'getDeviceInfo') {
          return {
            'manufacturer': 'Xiaomi',
            'model': 'Redmi Note 10',
            'brand': 'POCO',
            'sdkVersion': 31,
            'releaseVersion': '12',
          };
        }
        return null;
      });

      final service = AndroidDeviceInfoService();
      final info = await service.getAndroidInfo();

      expect(info.manufacturer, 'Xiaomi');
      expect(info.model, 'Redmi Note 10');
      expect(info.brand, 'POCO');
      expect(info.sdkVersion, 31);
      expect(info.releaseVersion, '12');
    });

    test('getAndroidInfo falls back gracefully on error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        throw PlatformException(code: 'ERROR');
      });

      final service = AndroidDeviceInfoService();
      final info = await service.getAndroidInfo();

      expect(info.manufacturer, 'Google');
      expect(info.model, 'Pixel');
    });

    test('Troubleshooting guidelines returned correctly by brand', () {
      final service = AndroidDeviceInfoService();

      expect(
        service.getManufacturerTroubleshootingGuide('Xiaomi'),
        contains('شیائومی'),
      );
      expect(
        service.getManufacturerTroubleshootingGuide('Huawei'),
        contains('هوآوی'),
      );
      expect(
        service.getManufacturerTroubleshootingGuide('Samsung'),
        contains('سامسونگ'),
      );
      expect(
        service.getManufacturerTroubleshootingGuide('Google'),
        contains('بهینه‌سازی باتری'),
      );

      expect(
        service.getManufacturerSettingsIntent('Xiaomi'),
        isNotNull,
      );
      expect(
        service.getManufacturerSettingsIntent('Huawei'),
        isNotNull,
      );
      expect(
        service.getManufacturerSettingsIntent('Google'),
        isNull,
      );
    });
  });

  group('AndroidSmsReceiverService Tests', () {
    const smsChannel = EventChannel('com.bankyar.app/sms_events');

    test('Cannot start listening if permission is denied', () async {
      when(() => mockPermissionService.checkStatus(AppPermission.smsReceive))
          .thenAnswer((_) async => PermissionStatus.denied);

      final service = AndroidSmsReceiverService(
        permissionService: mockPermissionService,
        logger: mockLogger,
      );

      await service.startListening();

      verify(() => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      )).called(2); // First start attempt, second log for denied error
    });

    test('Listen captures and validates SMS broadcasts correctly', () async {
      when(() => mockPermissionService.checkStatus(AppPermission.smsReceive))
          .thenAnswer((_) async => PermissionStatus.granted);

      final controller = StreamController<dynamic>();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(smsChannel, MockSmsStreamHandler(controller.stream));

      final service = AndroidSmsReceiverService(
        permissionService: mockPermissionService,
        logger: mockLogger,
      );

      await service.startListening();

      final listFuture = service.onMessageReceived.take(2).toList();

      // Emit genuine financial shortcode SMS
      controller.add({
        'sender': 'Melli',
        'body': 'واریز ۵,۰۰۰ ریال',
        'timestamp': 1697360400000,
      });

      // Emit normal cellular number with financial keyword (genuine source verification)
      controller.add({
        'sender': '09123456789',
        'body': 'بانک صادرات: تراکنش انجام شد',
        'timestamp': 1697360500000,
      });

      // Emit cellular without financial keyword (spam/personal - ignored)
      controller.add({
        'sender': '09123456789',
        'body': 'کجایی؟ فردا میای؟',
        'timestamp': 1697360600000,
      });

      final list = await listFuture;
      expect(list.length, 2);
      expect(list[0].sender, 'Melli');
      expect(list[1].sender, '09123456789');

      await service.stopListening();
      await controller.close();
    });
  });

  group('AndroidSmsHistoryImporter Tests', () {
    test('Returns 0 and logs error if smsRead permission is denied', () async {
      when(() => mockPermissionService.checkStatus(AppPermission.smsRead))
          .thenAnswer((_) async => PermissionStatus.denied);

      final importer = AndroidSmsHistoryImporter(
        permissionService: mockPermissionService,
        preferencesStorage: mockPreferencesStorage,
        processUseCase: mockProcessUseCase,
        logger: mockLogger,
      );

      final count = await importer.synchronizeInbox(forceSinceTimestamp: 1697360400000);
      expect(count, 0);
      verify(() => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      )).called(2);
    });

    test('Queries historical SMS inbox and processes new messages cleanly', () async {
      when(() => mockPermissionService.checkStatus(AppPermission.smsRead))
          .thenAnswer((_) async => PermissionStatus.granted);

      when(() => mockPreferencesStorage.setInt(any(), any()))
          .thenAnswer((_) async => {});

      when(() => mockProcessUseCase.call(any()))
          .thenAnswer((_) async => const Result.success(ParsedTransaction(
                id: 'tx-1',
                amount: 1000.0,
                currency: 'IRR',
                transactionType: SmsTransactionType.credit,
                rawMerchant: 'Melli',
                normalizedMerchant: 'Melli',
                confidenceScore: 1.0,
                parsingMethod: 'deterministic',
                createdAt: 1697360400000,
                updatedAt: 1697360400000,
                timestamp: 1697360400000,
              )));

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'queryHistoricalSms') {
          return [
            {
              'sender': 'Melli',
              'body': 'واریز ۱,۰۰۰ ریال',
              'timestamp': 1697360400000,
            }
          ];
        }
        return null;
      });

      final importer = AndroidSmsHistoryImporter(
        permissionService: mockPermissionService,
        preferencesStorage: mockPreferencesStorage,
        processUseCase: mockProcessUseCase,
        logger: mockLogger,
      );

      final count = await importer.synchronizeInbox(forceSinceTimestamp: 1697360300000);
      expect(count, 1);

      verify(() => mockProcessUseCase.call(any())).called(1);
      verify(() => mockPreferencesStorage.setInt(
            'bankyar.sms_history.last_sync_timestamp',
            1697360400001,
          )).called(1);
    });

    test('performIncrementalSync fetches correct state and runs correctly', () async {
      when(() => mockPermissionService.checkStatus(AppPermission.smsRead))
          .thenAnswer((_) async => PermissionStatus.granted);

      when(() => mockPreferencesStorage.getInt('bankyar.sms_history.last_sync_timestamp'))
          .thenAnswer((_) async => 1697360400000);

      when(() => mockPreferencesStorage.setInt(any(), any()))
          .thenAnswer((_) async => {});

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return []; // No new messages
      });

      final importer = AndroidSmsHistoryImporter(
        permissionService: mockPermissionService,
        preferencesStorage: mockPreferencesStorage,
        processUseCase: mockProcessUseCase,
        logger: mockLogger,
      );

      final count = await importer.performIncrementalSync();
      expect(count, 0);
    });

    test('performIncrementalSync falls back to 3 days ago if key is null', () async {
      when(() => mockPermissionService.checkStatus(AppPermission.smsRead))
          .thenAnswer((_) async => PermissionStatus.granted);

      when(() => mockPreferencesStorage.getInt('bankyar.sms_history.last_sync_timestamp'))
          .thenAnswer((_) async => null);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        return [];
      });

      final importer = AndroidSmsHistoryImporter(
        permissionService: mockPermissionService,
        preferencesStorage: mockPreferencesStorage,
        processUseCase: mockProcessUseCase,
        logger: mockLogger,
      );

      final count = await importer.performIncrementalSync();
      expect(count, 0);
    });
  });

  group('AndroidBackgroundServiceManager Tests', () {
    test('startService executes MethodChannel and updates status', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'startBackgroundService') {
          return true;
        }
        return null;
      });

      final manager = AndroidBackgroundServiceManager(logger: mockLogger);
      expect(await manager.isServiceRunning(), isFalse);

      final started = await manager.startService();
      expect(started, isTrue);
      expect(await manager.isServiceRunning(), isTrue);
    });

    test('stopService executes MethodChannel and updates status', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'startBackgroundService' || call.method == 'stopBackgroundService') {
          return true;
        }
        return null;
      });

      final manager = AndroidBackgroundServiceManager(logger: mockLogger);
      await manager.startService();
      expect(await manager.isServiceRunning(), isTrue);

      final stopped = await manager.stopService();
      expect(stopped, isTrue);
      expect(await manager.isServiceRunning(), isFalse);
    });

    test('ensureResilience restarts background service if stopped', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'startBackgroundService') {
          return true;
        }
        return null;
      });

      final manager = AndroidBackgroundServiceManager(logger: mockLogger);
      expect(await manager.isServiceRunning(), isFalse);

      await manager.ensureResilience();
      expect(await manager.isServiceRunning(), isTrue);
    });
  });

  group('AndroidWorkSchedulingService Tests', () {
    test('schedulePeriodicSync passes arguments to platform and returns success', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'scheduleWork') {
          expect(call.arguments['taskName'], 'SyncTask');
          expect(call.arguments['intervalMinutes'], 15);
          expect(call.arguments['requiresCharging'], isFalse);
          expect(call.arguments['backoffPolicy'], 'exponential');
          return true;
        }
        return null;
      });

      final service = AndroidWorkSchedulingService(logger: mockLogger);
      final success = await service.schedulePeriodicSync(
        taskName: 'SyncTask',
        interval: const Duration(minutes: 15),
        constraints: const WorkConstraints(),
        backoffPolicy: WorkBackoffPolicy.exponential,
        backoffDelay: const Duration(seconds: 30),
      );

      expect(success, isTrue);
    });

    test('cancelAllTasks cancels active tasks and returns success', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'cancelAllTasks') {
          return true;
        }
        return null;
      });

      final service = AndroidWorkSchedulingService(logger: mockLogger);
      final success = await service.cancelAllTasks();
      expect(success, isTrue);
    });
  });
}

class MockSmsStreamHandler extends MockStreamHandler {
  MockSmsStreamHandler(this.stream);
  final Stream<dynamic> stream;
  StreamSubscription<dynamic>? _subscription;

  @override
  void onListen(dynamic arguments, MockStreamHandlerEventSink events) {
    _subscription = stream.listen(
      (data) => events.success(data),
      onError: (Object err) => events.error(code: 'ERROR', message: err.toString()),
      onDone: () => events.endOfStream(),
    );
  }

  @override
  void onCancel(dynamic arguments) {
    _subscription?.cancel();
  }
}
