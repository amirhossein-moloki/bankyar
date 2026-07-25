import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/database/database_service_impl.dart';
import 'core/di/dependency_injection.dart';
import 'core/logging/logger.dart';
import 'app.dart';

/// Helper to get or generate the cryptographically secure master key.
Future<List<int>> _getOrCreateMasterKey(FlutterSecureStorage secureStorage) async {
  const keyName = 'bankyar_db_key';
  final existingBase64 = await secureStorage.read(key: keyName);
  if (existingBase64 != null && existingBase64.isNotEmpty) {
    try {
      return base64Url.decode(existingBase64);
    } catch (_) {
      // Decode failed, fall through to regenerate
    }
  }

  final random = Random.secure();
  final bytes = List<int>.generate(32, (i) => random.nextInt(256));
  final base64String = base64Url.encode(bytes);
  await secureStorage.write(key: keyName, value: base64String);
  return bytes;
}

void main() async {
  // Ensure native and platform bindings are successfully booted
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Create robust structured logger
  final logger = AppLoggerImpl(
    isDiagnosticsEnabled: true,
    consoleOutput: true,
  );

  // 2. Instantiate and open the secure relational database service
  final databaseService = DatabaseServiceImpl(logger);

  try {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    final masterKeyBytes = await _getOrCreateMasterKey(secureStorage);
    await databaseService.openEncryptedConnection(masterKeyBytes);
  } catch (e, stack) {
    logger.log(
      LogLevel.fatal,
      LogCategories.database,
      'BY_MAIN_DB_INIT_FAILED',
      'Failed to initialize secure database on startup.',
      error: e,
      stackTrace: stack,
    );
  }

  // Run the application wrapped inside Riverpod's ProviderScope container.
  runApp(
    ProviderScope(
      overrides: [
        // Override the abstract databaseServiceProvider with our open database service
        databaseServiceProvider.overrideWithValue(databaseService),
      ],
      child: const BankYarApp(),
    ),
  );
}
