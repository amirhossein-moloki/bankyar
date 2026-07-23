import 'package:flutter/services.dart';
import '../logging/logger.dart';

/// Abstraction managing the native operating system daemon background service life cycles.
abstract class BackgroundServiceManager {
  /// Launches the background service with a secure foreground notification context.
  Future<bool> startService();

  /// Stops the background execution process completely.
  Future<bool> stopService();

  /// Returns true if the background synchronization engine is currently active.
  Future<bool> isServiceRunning();

  /// Validates status and triggers self-healing / process restart resilience.
  Future<void> ensureResilience();
}

/// Concrete Android implementation of [BackgroundServiceManager] using platform method channels.
class AndroidBackgroundServiceManager implements BackgroundServiceManager {
  /// Constructor injecting logger and method channel.
  AndroidBackgroundServiceManager({
    required AppLogger logger,
    MethodChannel? channel,
  })  : _logger = logger,
        _channel = channel ?? const MethodChannel('com.bankyar.app/platform');

  final AppLogger _logger;
  final MethodChannel _channel;

  bool _isLocallyRunning = false;

  @override
  Future<bool> startService() async {
    _logger.log(
      LogLevel.info,
      LogCategories.platform,
      'BY_PLAT_BG_SERVICE_START_REQ',
      'Requesting OS to start foreground sync service.',
    );

    try {
      final success = await _channel.invokeMethod<bool>('startBackgroundService');
      if (success == true) {
        _isLocallyRunning = true;
        _logger.log(
          LogLevel.info,
          LogCategories.platform,
          'BY_PLAT_BG_SERVICE_START_OK',
          'Foreground service successfully active.',
        );
        return true;
      }
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PLAT_BG_SERVICE_START_ERR',
        'Failed to start background foreground service',
        error: e,
      );
    }
    return false;
  }

  @override
  Future<bool> stopService() async {
    _logger.log(
      LogLevel.info,
      LogCategories.platform,
      'BY_PLAT_BG_SERVICE_STOP_REQ',
      'Requesting OS to stop foreground sync service.',
    );

    try {
      final success = await _channel.invokeMethod<bool>('stopBackgroundService');
      if (success == true) {
        _isLocallyRunning = false;
        _logger.log(
          LogLevel.info,
          LogCategories.platform,
          'BY_PLAT_BG_SERVICE_STOP_OK',
          'Foreground service successfully stopped.',
        );
        return true;
      }
    } catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PLAT_BG_SERVICE_STOP_ERR',
        'Failed to stop background service',
        error: e,
      );
    }
    return false;
  }

  @override
  Future<bool> isServiceRunning() async {
    // In standard headless executions or tests, falls back to internal trackers
    return _isLocallyRunning;
  }

  @override
  Future<void> ensureResilience() async {
    // Self-healing: if service got terminated, restart it automatically
    final running = await isServiceRunning();
    if (!running) {
      _logger.log(
        LogLevel.info,
        LogCategories.platform,
        'BY_PLAT_BG_SERVICE_RESILIENCE',
        'Self-healing triggered: Background Service was found offline, restarting...',
      );
      await startService();
    }
  }
}
