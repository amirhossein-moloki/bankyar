import 'dart:async';
import 'package:flutter/services.dart';
import '../logging/logger.dart';
import 'permission.dart';

/// Data class representing an incoming system SMS broadcast.
class SmsMessage {
  /// Constructor defining message contents.
  const SmsMessage({
    required this.sender,
    required this.body,
    required this.timestamp,
  });

  /// The originating phone number or textual Sender ID of the SMS.
  final String sender;

  /// Raw textual body of the message.
  final String body;

  /// Operating system millisecond epoch timestamp.
  final int timestamp;
}

/// Abstraction managing incoming financial SMS streams with permission checks and security safeguards.
abstract class SmsReceiverService {
  /// Stream of validated incoming SMS messages.
  Stream<SmsMessage> get onMessageReceived;

  /// Programmatically starts real-time SMS broadcast interception.
  Future<void> startListening();

  /// Programmatically stops active live listeners.
  Future<void> stopListening();
}

/// Concrete Android implementation of [SmsReceiverService] binding to native EventChannels.
class AndroidSmsReceiverService implements SmsReceiverService {
  /// Constructor injecting services and channels.
  AndroidSmsReceiverService({
    required PermissionService permissionService,
    required AppLogger logger,
    EventChannel? eventChannel,
  }) : _permissionService = permissionService,
       _logger = logger,
       _eventChannel =
           eventChannel ?? const EventChannel('com.bankyar.app/sms_events');

  final PermissionService _permissionService;
  final AppLogger _logger;
  final EventChannel _eventChannel;

  final StreamController<SmsMessage> _controller =
      StreamController<SmsMessage>.broadcast();
  StreamSubscription<dynamic>? _subscription;

  @override
  Stream<SmsMessage> get onMessageReceived => _controller.stream;

  @override
  Future<void> startListening() async {
    _logger.log(
      LogLevel.info,
      LogCategories.platform,
      'BY_PLAT_SMS_LISTEN_START',
      'Initiating live SMS receiver stream subscription.',
    );

    // Verify SMS permission is granted before starting stream listeners
    final status = await _permissionService.checkStatus(
      AppPermission.smsReceive,
    );
    if (status != PermissionStatus.granted) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PLAT_SMS_LISTEN_DENIED',
        'Cannot initiate SMS receiver: Permission smsReceive is denied.',
      );
      return;
    }

    await _subscription?.cancel();
    _subscription = _eventChannel.receiveBroadcastStream().listen(
      (data) {
        _handleIncomingData(data);
      },
      onError: (err) {
        _logger.log(
          LogLevel.error,
          LogCategories.platform,
          'BY_PLAT_SMS_LISTEN_ERROR',
          'Error intercepted in live SMS EventChannel: $err',
        );
      },
    );
  }

  @override
  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _logger.log(
      LogLevel.info,
      LogCategories.platform,
      'BY_PLAT_SMS_LISTEN_STOP',
      'Stopped live SMS receiver stream.',
    );
  }

  void _handleIncomingData(dynamic data) {
    if (data is Map<dynamic, dynamic>) {
      final sender = (data['sender'] as String?) ?? '';
      final body = (data['body'] as String?) ?? '';
      final timestamp =
          (data['timestamp'] as int?) ?? DateTime.now().millisecondsSinceEpoch;

      // Security Check 1: SMS Source validation
      if (!_validateSmsSource(sender, body)) {
        _logger.log(
          LogLevel.debug,
          LogCategories.platform,
          'BY_PLAT_SMS_VALIDATION_IGNORED',
          'Ignored non-financial or suspicious SMS source: $sender',
        );
        return;
      }

      final sms = SmsMessage(sender: sender, body: body, timestamp: timestamp);
      _controller.add(sms);
    }
  }

  /// Validates that the SMS sender or content represents a genuine banking or financial notification.
  /// Prevents processing of standard OTPs, personal messages, or suspicious texts.
  bool _validateSmsSource(String sender, String body) {
    if (sender.isEmpty || body.isEmpty) return false;

    final senderLower = sender.toLowerCase();

    // Ignore personal or promotional cellular numbers if they don't look like short codes or textual masks
    final isCellularNumber =
        RegExp(r'^\+?989\d{9}$').hasMatch(senderLower) ||
        RegExp(r'^09\d{9}$').hasMatch(senderLower);

    // If it's a typical mobile phone number, it's highly likely spam or personal chat, unless it contains distinct financial markers
    if (isCellularNumber) {
      final hasFinancialKeywords =
          body.contains('بانک') ||
          body.contains('واریز') ||
          body.contains('برداشت') ||
          body.contains('حساب') ||
          body.contains('کارت') ||
          body.contains('مانده');
      return hasFinancialKeywords;
    }

    // Standard shortcodes or alphabetical Sender IDs (e.g., "Melli", "Mellat", "982000...") are acceptable
    return true;
  }

  /// Standard disposal of controllers.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
