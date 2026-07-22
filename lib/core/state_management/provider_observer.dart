import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logging/logger.dart';

/// Reusable Riverpod Provider Observer tracking dependency registration, updates, and lifecycles.
/// Connects to our central PII-scrubbed [AppLogger] to aid troubleshooting securely.
class AppProviderObserver extends ProviderObserver {
  /// Constructor injecting central diagnostic logger.
  AppProviderObserver(this._logger);

  final AppLogger _logger;

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _logger.log(
      LogLevel.trace,
      'STATE_MANAGEMENT',
      'BY_STATE_ADD',
      'Provider initialized: ${provider.name ?? provider.runtimeType}',
      metadata: {'initial_value': value.toString()},
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.log(
      LogLevel.trace,
      'STATE_MANAGEMENT',
      'BY_STATE_UPDATE',
      'Provider updated: ${provider.name ?? provider.runtimeType}',
      metadata: {
        'previous': previousValue.toString(),
        'next': newValue.toString(),
      },
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _logger.log(
      LogLevel.trace,
      'STATE_MANAGEMENT',
      'BY_STATE_DISPOSE',
      'Provider disposed: ${provider.name ?? provider.runtimeType}',
    );
  }
}
