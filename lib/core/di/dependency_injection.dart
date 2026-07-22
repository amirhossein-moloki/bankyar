import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database_service.dart';
import '../environment/environment.dart';
import '../logging/logger.dart';

/// Provider exposing the active application execution environment.
/// Loaded lazily from Dart defines on launch.
final environmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fromDefines();
});

/// Provider exposing the central structured, PII-scrubbing logger instance.
final loggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(environmentProvider);
  return AppLoggerImpl(
    isDiagnosticsEnabled: env.isDiagnosticsEnabled,
    consoleOutput: env.flavor != AppFlavor.test,
  );
});

/// Provider exposing native hardware secure preference storage client.
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

/// Provider contract for the encrypted local database service.
/// Overridden in production with SQLCipher implementations or fakes in tests.
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  throw UnimplementedError(
    'databaseServiceProvider must be explicitly overridden inside ProviderScope.',
  );
});
