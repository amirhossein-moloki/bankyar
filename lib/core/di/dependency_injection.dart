import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database_service.dart';
import '../environment/environment.dart';
import '../logging/logger.dart';
import '../platform/clock.dart';
import '../platform/uuid.dart';
import '../platform/platform.dart';
import '../platform/connectivity.dart';
import '../platform/secure_storage.dart';
import '../platform/file_storage.dart';
import '../platform/permission.dart';
import '../platform/app_lifecycle_service.dart';
import '../platform/device_info_service.dart';
import '../platform/sms_receiver_service.dart';
import '../platform/background_service_manager.dart';
import '../platform/work_scheduling_service.dart';
import '../storage/preferences_storage.dart';

/// Provider exposing the active application execution environment.
/// Loaded lazily from Dart defines on launch.
final environmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fromDefines();
});

/// Provider exposing the system clock abstraction.
final clockProvider = Provider<Clock>((ref) {
  return const SystemClock();
});

/// Provider exposing the RFC-compliant UUID v4 generator.
final uuidGeneratorProvider = Provider<UuidGenerator>((ref) {
  return const SystemUuidGenerator();
});

/// Provider exposing the platform environment service.
final platformServiceProvider = Provider<PlatformService>((ref) {
  return const SystemPlatformService();
});

/// Provider exposing the network connectivity service.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return const SystemConnectivityService();
});

/// Provider exposing the secure storage manager adapter.
final secureStorageServiceProvider = Provider<SecureStorage>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SystemSecureStorage(secureStorage);
});

/// Provider exposing the local file storage manager.
final fileStorageProvider = Provider<FileStorage>((ref) {
  return const SystemFileStorage();
});

/// Provider exposing system permissions authorization service.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return SystemPermissionService();
});

/// Provider exposing application lifecycle state transitions.
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  return SystemAppLifecycleService();
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

/// Provider exposing the secure PreferencesStorage manager.
final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final logger = ref.watch(loggerProvider);
  return PreferencesStorage(secureStorage, logger);
});

/// Provider exposing the native hardware DeviceInfoService.
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return AndroidDeviceInfoService();
});

/// Provider exposing the secure, real-time incoming SmsReceiverService.
final smsReceiverServiceProvider = Provider<SmsReceiverService>((ref) {
  final permissionService = ref.watch(permissionServiceProvider);
  final logger = ref.watch(loggerProvider);
  return AndroidSmsReceiverService(
    permissionService: permissionService,
    logger: logger,
  );
});

/// Provider exposing the BackgroundServiceManager to control foreground syncing daemons.
final backgroundServiceManagerProvider = Provider<BackgroundServiceManager>((ref) {
  final logger = ref.watch(loggerProvider);
  return AndroidBackgroundServiceManager(logger: logger);
});

/// Provider exposing the WorkSchedulingService to orchestrate background tasks using WorkManager.
final workSchedulingServiceProvider = Provider<WorkSchedulingService>((ref) {
  final logger = ref.watch(loggerProvider);
  return AndroidWorkSchedulingService(logger: logger);
});
