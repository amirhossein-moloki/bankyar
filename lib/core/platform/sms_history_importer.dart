import 'package:flutter/services.dart';
import '../../features/sms_detection/domain/usecases/process_incoming_sms_use_case.dart';
import '../logging/logger.dart';
import '../storage/preferences_storage.dart';
import 'permission.dart';
import 'sms_receiver_service.dart';

/// Abstraction managing historical banking SMS ingestion and incremental synchronization.
abstract class SmsHistoryImporter {
  /// Queries the system SMS database securely and runs incoming SMS processing use case.
  /// Returns count of successfully parsed new financial transactions.
  Future<int> synchronizeInbox({required int forceSinceTimestamp});

  /// Incremental sync wrapper: automatically tracks last sync time using local preference storages.
  Future<int> performIncrementalSync();
}

/// Concrete Android implementation of [SmsHistoryImporter] querying standard native SMS content providers.
class AndroidSmsHistoryImporter implements SmsHistoryImporter {
  /// Constructor injecting dependencies.
  AndroidSmsHistoryImporter({
    required PermissionService permissionService,
    required PreferencesStorage preferencesStorage,
    required ProcessIncomingSmsUseCase processUseCase,
    required AppLogger logger,
    MethodChannel? channel,
  })  : _permissionService = permissionService,
        _preferencesStorage = preferencesStorage,
        _processUseCase = processUseCase,
        _logger = logger,
        _channel = channel ?? const MethodChannel('com.bankyar.app/platform');

  final PermissionService _permissionService;
  final PreferencesStorage _preferencesStorage;
  final ProcessIncomingSmsUseCase _processUseCase;
  final AppLogger _logger;
  final MethodChannel _channel;

  static const _lastSyncKey = 'bankyar.sms_history.last_sync_timestamp';

  @override
  Future<int> synchronizeInbox({required int forceSinceTimestamp}) async {
    _logger.log(
      LogLevel.info,
      LogCategories.platform,
      'BY_PLAT_SMS_SYNC_START',
      'Initiating inbox synchronization since timestamp: $forceSinceTimestamp',
    );

    // Secure Permission Check
    final status = await _permissionService.checkStatus(AppPermission.smsRead);
    if (status != PermissionStatus.granted) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PLAT_SMS_SYNC_DENIED',
        'Cannot synchronize inbox: smsRead permission is not granted.',
      );
      return 0;
    }

    try {
      final List<dynamic>? rawMessages = await _channel.invokeMethod<List<dynamic>>(
        'queryHistoricalSms',
        {'since': forceSinceTimestamp},
      );

      if (rawMessages == null || rawMessages.isEmpty) {
        _logger.log(
          LogLevel.info,
          LogCategories.platform,
          'BY_PLAT_SMS_SYNC_EMPTY',
          'Inbox sync complete: 0 messages found.',
        );
        return 0;
      }

      int processedCount = 0;
      int maxTimestamp = forceSinceTimestamp;

      for (final raw in rawMessages) {
        if (raw is Map<dynamic, dynamic>) {
          final sender = (raw['sender'] as String?) ?? '';
          final body = (raw['body'] as String?) ?? '';
          final timestamp = (raw['timestamp'] as int?) ?? 0;

          if (timestamp > maxTimestamp) {
            maxTimestamp = timestamp;
          }

          // Ingest message through Clean Architecture use case pipeline
          final result = await _processUseCase.call(
            ProcessIncomingSmsParams(
              rawText: body,
              senderId: sender,
              receivedAt: timestamp,
            ),
          );

          result.when(
            success: (transaction) {
              if (transaction != null) {
                processedCount++;
              }
            },
            failure: (failure) {
              _logger.log(
                LogLevel.error,
                LogCategories.platform,
                'BY_PLAT_SMS_SYNC_ERROR',
                'Sms sync pipeline encountered failure: ${failure.message}',
              );
            },
            loading: (_) {},
            empty: () {},
          );
        }
      }

      // Secure incremental sync state updates
      await _preferencesStorage.setInt(_lastSyncKey, maxTimestamp + 1);

      _logger.log(
        LogLevel.info,
        LogCategories.platform,
        'BY_PLAT_SMS_SYNC_COMPLETE',
        'Inbox synchronization completed. Found ${rawMessages.length} messages, successfully ingested $processedCount.',
      );

      return processedCount;
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PLAT_SMS_SYNC_EXCEPTION',
        'Exception occurred during historical SMS sync',
        error: e,
        stackTrace: stack,
      );
      return 0;
    }
  }

  @override
  Future<int> performIncrementalSync() async {
    final lastSyncVal = await _preferencesStorage.getInt(_lastSyncKey);
    // Default fallback starting point is 3 days ago if no historical logs exist
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3)).millisecondsSinceEpoch;
    final startingTimestamp = lastSyncVal ?? threeDaysAgo;

    return synchronizeInbox(forceSinceTimestamp: startingTimestamp);
  }
}
