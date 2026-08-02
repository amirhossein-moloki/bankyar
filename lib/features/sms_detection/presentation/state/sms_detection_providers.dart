import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/platform/sms_history_importer.dart';
import '../../../../core/platform/sms_receiver_service.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/platform/permission.dart';
import '../../../notifications/domain/entities/notification_item.dart';
import '../../../notifications/domain/usecases/insert_notification_use_case.dart';
import '../../../notifications/data/di/notification_providers.dart';
import '../../../secure_auth/presentation/state/permission_notifier.dart';
import '../../data/datasources/bank_message_dao.dart';
import '../../data/repositories/sms_parser_repository_impl.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/repository/sms_parser_repository.dart';
import '../../domain/usecases/process_incoming_sms_use_case.dart';

/// Provider exposing the localized Relational [BankMessageDao].
final bankMessageDaoProvider = Provider<BankMessageDao>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final logger = ref.watch(loggerProvider);
  return BankMessageDao(dbService, logger);
});

/// Provider exposing the core pipeline [SmsParserRepository] implementation.
final smsParserRepositoryProvider = Provider<SmsParserRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final bankMessageDao = ref.watch(bankMessageDaoProvider);
  final uuidGenerator = ref.watch(uuidGeneratorProvider);
  final clock = ref.watch(clockProvider);
  final logger = ref.watch(loggerProvider);

  return SmsParserRepositoryImpl(
    dbService: dbService,
    bankMessageDao: bankMessageDao,
    uuidGenerator: uuidGenerator,
    clock: clock,
    logger: logger,
  );
});

/// Coordination service that binds incoming system SMS messages to the parsing,
/// transactional storage, notification logging, and reactive UI refresh pipeline.
class SmsPipelineCoordinator {
  /// Constructor.
  SmsPipelineCoordinator({
    required SmsReceiverService receiverService,
    required ProcessIncomingSmsUseCase processUseCase,
    required InsertNotificationUseCase insertNotificationUseCase,
    required PermissionService permissionService,
    required AppLogger logger,
    required Ref ref,
  }) : _receiverService = receiverService,
       _processUseCase = processUseCase,
       _insertNotificationUseCase = insertNotificationUseCase,
       _permissionService = permissionService,
       _logger = logger,
       _ref = ref {
    _init();
  }

  final SmsReceiverService _receiverService;
  final ProcessIncomingSmsUseCase _processUseCase;
  final InsertNotificationUseCase _insertNotificationUseCase;
  final PermissionService _permissionService;
  final AppLogger _logger;
  final Ref _ref;

  StreamSubscription<SmsMessage>? _subscription;
  static const _platform = MethodChannel('com.bankyar.app/platform');

  void _init() {
    _startListening();

    _ref.listen(permissionNotifierProvider, (previous, next) {
      final prevSms = previous?.isSmsReceiveGranted ?? false;
      final nextSms = next.isSmsReceiveGranted;
      if (!prevSms && nextSms) {
        _startListening();
      }
    });
  }

  void _startListening() async {
    try {
      await _receiverService.startListening();
      await _subscription?.cancel();
      _subscription = _receiverService.onMessageReceived.listen((message) {
        _handleIncomingSms(message);
      });
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PIPELINE_COORD_START_ERR',
        'Failed to start SMS receiver subscription',
        error: e,
      );
    }
  }

  void _handleIncomingSms(SmsMessage message) async {
    final receivedTime = DateTime.fromMillisecondsSinceEpoch(message.timestamp);
    _logger.log(
      LogLevel.info,
      LogCategories.parser,
      'BY_PIPELINE_SMS_RECEIVED',
      'SMS_RECEIVED',
      metadata: {
        'Received Time': receivedTime.toIso8601String(),
        'Sender': message.sender,
        'SMS ID': message.timestamp.toString(),
        'Pipeline Started': 'true',
      },
    );

    final params = ProcessIncomingSmsParams(
      rawText: message.body,
      senderId: message.sender,
      receivedAt: message.timestamp,
    );

    final result = await _processUseCase(params);

    result.when(
      success: (ParsedTransaction? tx) async {
        if (tx != null) {
          _logger.log(
            LogLevel.info,
            LogCategories.parser,
            'BY_PIPELINE_SMS_PARSED',
            'SMS parsed and transaction processed successfully.',
            metadata: {
              'Matched Bank': tx.normalizedMerchant,
              'Parser Used': tx.parsingMethod,
              'Inserted Into Database': 'true',
            },
          );

          // Create Notification Center item
          final notification = NotificationItem(
            id: 'notif_${tx.id}',
            title: tx.transactionType == SmsTransactionType.credit
                ? 'واریز جدید - ${tx.normalizedMerchant}'
                : 'برداشت جدید - ${tx.normalizedMerchant}',
            body: 'مبلغ ${tx.amount} ریال از حساب شما کسر/اضافه شد.',
            type: NotificationType.transactionProcessed,
            isRead: false,
            createdAt: DateTime.now(),
          );

          await _insertNotificationUseCase(notification);
          _logger.log(
            LogLevel.info,
            LogCategories.parser,
            'BY_PIPELINE_NOTIF_CREATED',
            'Notification Created: true',
          );

          // Trigger local OS notification
          try {
            await _platform.invokeMethod('showLocalNotification', {
              'id': tx.id,
              'title': notification.title,
              'body': notification.body,
              'transactionId': tx.id,
            });
          } catch (e) {
            _logger.log(
              LogLevel.error,
              LogCategories.platform,
              'BY_PIPELINE_OS_NOTIF_ERR',
              'Failed to show local OS notification.',
              error: e,
            );
          }

          _logger.log(
            LogLevel.info,
            LogCategories.parser,
            'BY_PIPELINE_UI_UPDATED',
            'UI Updated: true',
          );
        } else {
          _logger.log(
            LogLevel.info,
            LogCategories.parser,
            'BY_PIPELINE_SMS_IGNORED',
            'SMS message did not yield a valid transaction (ignored or invalid).',
          );
        }
      },
      failure: (failure) {
        _logger.log(
          LogLevel.error,
          LogCategories.parser,
          'BY_PIPELINE_SMS_FAILED',
          'Pipeline failed parsing incoming SMS.',
          metadata: {
            'Failure Reason': failure.message,
          },
        );
      },
      loading: (_) {},
      empty: () {},
    );
  }

  /// Disposes of listeners.
  void dispose() {
    _subscription?.cancel();
  }
}

/// Provider exposing the [SmsPipelineCoordinator] globally as a singleton.
final smsPipelineCoordinatorProvider = Provider<SmsPipelineCoordinator>((ref) {
  final receiverService = ref.watch(smsReceiverServiceProvider);
  final processUseCase = ref.watch(processIncomingSmsUseCaseProvider);
  final insertNotificationUseCase = ref.watch(insertNotificationUseCaseProvider);
  final permissionService = ref.watch(permissionServiceProvider);
  final logger = ref.watch(loggerProvider);

  final coordinator = SmsPipelineCoordinator(
    receiverService: receiverService,
    processUseCase: processUseCase,
    insertNotificationUseCase: insertNotificationUseCase,
    permissionService: permissionService,
    logger: logger,
    ref: ref,
  );

  ref.onDispose(() {
    coordinator.dispose();
  });

  return coordinator;
});

/// Provider exposing the stateless, single-action [ProcessIncomingSmsUseCase].
final processIncomingSmsUseCaseProvider = Provider<ProcessIncomingSmsUseCase>((
  ref,
) {
  final repository = ref.watch(smsParserRepositoryProvider);
  return ProcessIncomingSmsUseCase(repository);
});

/// Provider exposing the historical SMS inbox synchronization service.
final smsHistoryImporterProvider = Provider<SmsHistoryImporter>((ref) {
  final permissionService = ref.watch(permissionServiceProvider);
  final preferencesStorage = ref.watch(preferencesStorageProvider);
  final processUseCase = ref.watch(processIncomingSmsUseCaseProvider);
  final logger = ref.watch(loggerProvider);

  return AndroidSmsHistoryImporter(
    permissionService: permissionService,
    preferencesStorage: preferencesStorage,
    processUseCase: processUseCase,
    logger: logger,
  );
});
