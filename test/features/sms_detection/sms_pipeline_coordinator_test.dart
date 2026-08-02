import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/sms_receiver_service.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/notifications/data/di/notification_providers.dart';
import 'package:bankyar/features/notifications/domain/entities/notification_item.dart';
import 'package:bankyar/features/notifications/domain/usecases/insert_notification_use_case.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/domain/usecases/process_incoming_sms_use_case.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';

class MockSmsReceiverService extends Mock implements SmsReceiverService {}
class MockProcessIncomingSmsUseCase extends Mock implements ProcessIncomingSmsUseCase {}
class MockInsertNotificationUseCase extends Mock implements InsertNotificationUseCase {}
class MockPermissionService extends Mock implements PermissionService {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSmsReceiverService mockReceiverService;
  late MockProcessIncomingSmsUseCase mockProcessUseCase;
  late MockInsertNotificationUseCase mockInsertNotificationUseCase;
  late MockPermissionService mockPermissionService;
  late MockAppLogger mockLogger;

  final smsController = StreamController<SmsMessage>.broadcast();
  final permissionController = StreamController<Map<AppPermission, PermissionStatus>>.broadcast();
  final List<MethodCall> methodChannelCalls = [];

  setUpAll(() {
    registerFallbackValue(AppPermission.smsReceive);
    registerFallbackValue(
      const ProcessIncomingSmsParams(
        rawText: '',
        senderId: '',
        receivedAt: 0,
      ),
    );
    registerFallbackValue(
      NotificationItem(
        id: '',
        title: '',
        body: '',
        type: NotificationType.systemNotifications,
        isRead: false,
        createdAt: DateTime.now(),
      ),
    );

    // Intercept MethodChannel calls
    const MethodChannel('com.bankyar.app/platform')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      methodChannelCalls.add(methodCall);
      if (methodCall.method == 'showLocalNotification') {
        return true;
      }
      return null;
    });
  });

  setUp(() {
    mockReceiverService = MockSmsReceiverService();
    mockProcessUseCase = MockProcessIncomingSmsUseCase();
    mockInsertNotificationUseCase = MockInsertNotificationUseCase();
    mockPermissionService = MockPermissionService();
    mockLogger = MockAppLogger();

    methodChannelCalls.clear();

    // Default stubbing
    when(() => mockReceiverService.startListening()).thenAnswer((_) async {});
    when(() => mockReceiverService.onMessageReceived)
        .thenAnswer((_) => smsController.stream);

    when(() => mockPermissionService.onStatusesChanged)
        .thenAnswer((_) => permissionController.stream);

    when(() => mockPermissionService.checkStatus(any()))
        .thenAnswer((_) async => PermissionStatus.granted);
  });

  test('SmsPipelineCoordinator subscribes and processes new incoming SMS correctly',
      () async {
    final container = ProviderContainer(
      overrides: [
        smsReceiverServiceProvider.overrideWithValue(mockReceiverService),
        processIncomingSmsUseCaseProvider.overrideWithValue(mockProcessUseCase),
        insertNotificationUseCaseProvider
            .overrideWithValue(mockInsertNotificationUseCase),
        permissionServiceProvider.overrideWithValue(mockPermissionService),
        loggerProvider.overrideWithValue(mockLogger),
      ],
    );

    final tx = ParsedTransaction(
      id: 'tx_123',
      amount: 150000,
      currency: 'Rial',
      transactionType: SmsTransactionType.debit,
      rawMerchant: 'Melli',
      normalizedMerchant: 'بانک ملی',
      timestamp: 1690000000000,
      createdAt: 1690000000000,
      updatedAt: 1690000000000,
      confidenceScore: 1.0,
      parsingMethod: 'template',
    );

    when(() => mockProcessUseCase.call(any()))
        .thenAnswer((_) async => Result.success(tx));

    when(() => mockInsertNotificationUseCase.call(any()))
        .thenAnswer((_) async => const Result.success(null));

    // Force coordinator initialization
    container.read(smsPipelineCoordinatorProvider);

    await Future<void>.delayed(Duration.zero);

    verify(() => mockReceiverService.startListening());

    // Emit test message
    const msg = SmsMessage(
      sender: 'Melli',
      body: 'برداشت ۱۵۰,۰۰۰ ریال',
      timestamp: 1690000000000,
    );
    smsController.add(msg);

    // Wait for async pipeline execution
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // Verify ProcessUseCase parameter matching
    verify(() => mockProcessUseCase.call(any(
          that: isA<ProcessIncomingSmsParams>()
              .having((p) => p.rawText, 'rawText', 'برداشت ۱۵۰,۰۰۰ ریال')
              .having((p) => p.senderId, 'senderId', 'Melli')
              .having((p) => p.receivedAt, 'receivedAt', 1690000000000),
        ))).called(1);

    // Verify Notification item was written to local database
    verify(() => mockInsertNotificationUseCase.call(any(
          that: isA<NotificationItem>()
              .having((n) => n.id, 'id', 'notif_tx_123')
              .having((n) => n.title, 'title', 'برداشت جدید - بانک ملی')
              .having((n) => n.type, 'type', NotificationType.transactionProcessed),
        ))).called(1);

    // Verify local OS notification was triggered via MethodChannel
    expect(methodChannelCalls, isNotEmpty);
    final notificationCall = methodChannelCalls.firstWhere(
      (c) => c.method == 'showLocalNotification',
    );
    expect(notificationCall.arguments, {
      'id': 'tx_123',
      'title': 'برداشت جدید - بانک ملی',
      'body': 'مبلغ 150000.0 ریال از حساب شما کسر/اضافه شد.',
      'transactionId': 'tx_123',
    });

    // Verify verbose logging statements are registered
    verify(() => mockLogger.log(
          LogLevel.info,
          LogCategories.parser,
          'BY_PIPELINE_SMS_RECEIVED',
          'SMS_RECEIVED',
          metadata: any(named: 'metadata'),
        )).called(1);

    verify(() => mockLogger.log(
          LogLevel.info,
          LogCategories.parser,
          'BY_PIPELINE_SMS_PARSED',
          any(),
          metadata: any(named: 'metadata'),
        )).called(1);

    verify(() => mockLogger.log(
          LogLevel.info,
          LogCategories.parser,
          'BY_PIPELINE_NOTIF_CREATED',
          any(),
        )).called(1);

    verify(() => mockLogger.log(
          LogLevel.info,
          LogCategories.parser,
          'BY_PIPELINE_UI_UPDATED',
          any(),
        )).called(1);

    container.dispose();
  });

  test('SmsPipelineCoordinator ignores non-financial and failed messages',
      () async {
    final container = ProviderContainer(
      overrides: [
        smsReceiverServiceProvider.overrideWithValue(mockReceiverService),
        processIncomingSmsUseCaseProvider.overrideWithValue(mockProcessUseCase),
        insertNotificationUseCaseProvider
            .overrideWithValue(mockInsertNotificationUseCase),
        permissionServiceProvider.overrideWithValue(mockPermissionService),
        loggerProvider.overrideWithValue(mockLogger),
      ],
    );

    // ProcessUseCase returns null representing ignored message
    when(() => mockProcessUseCase.call(any()))
        .thenAnswer((_) async => const Result.success(null));

    // Force coordinator initialization
    container.read(smsPipelineCoordinatorProvider);

    await Future<void>.delayed(Duration.zero);

    verify(() => mockReceiverService.startListening());

    // Emit standard OTP spam message
    const msg = SmsMessage(
      sender: '982000',
      body: 'کد تایید شما: ۱۲۳۴',
      timestamp: 1690000000000,
    );
    smsController.add(msg);

    await Future<void>.delayed(const Duration(milliseconds: 100));

    // ProcessUseCase is still run
    verify(() => mockProcessUseCase.call(any())).called(1);

    // No notification is created
    verifyNever(() => mockInsertNotificationUseCase.call(any()));

    // No MethodChannel local notification is shown
    expect(
      methodChannelCalls.where((c) => c.method == 'showLocalNotification'),
      isEmpty,
    );

    // Logs expected ignored event
    verify(() => mockLogger.log(
          LogLevel.info,
          LogCategories.parser,
          'BY_PIPELINE_SMS_IGNORED',
          any(),
        )).called(1);

    container.dispose();
  });
}
