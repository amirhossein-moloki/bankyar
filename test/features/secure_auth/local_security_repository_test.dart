import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/database/database_service.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/secure_storage.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:bankyar/features/secure_auth/domain/entities/security_settings.dart';
import 'package:bankyar/features/secure_auth/domain/entities/session_model.dart';
import 'package:bankyar/features/secure_auth/data/models/security_hash_helper.dart';
import 'package:bankyar/features/secure_auth/data/repositories/local_security_repository.dart';

class MockSecureStorage extends Mock implements SecureStorage {}
class MockPreferencesStorage extends Mock implements PreferencesStorage {}
class MockDatabaseService extends Mock implements DatabaseService {}
class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockSecureStorage secureStorage;
  late MockPreferencesStorage preferencesStorage;
  late MockDatabaseService databaseService;
  late MockPermissionService permissionService;
  late LocalSecurityRepository repository;

  setUp(() {
    secureStorage = MockSecureStorage();
    preferencesStorage = MockPreferencesStorage();
    databaseService = MockDatabaseService();
    permissionService = MockPermissionService();

    repository = LocalSecurityRepository(
      secureStorage: secureStorage,
      preferencesStorage: preferencesStorage,
      databaseService: databaseService,
      permissionService: permissionService,
    );
  });

  group('LocalSecurityRepository Tests', () {
    test('isPinConfigured returns true when hash is stored', () async {
      when(() => secureStorage.read('by_sec_pin_hash'))
          .thenAnswer((_) async => 'some_stored_hash');

      final result = await repository.isPinConfigured();

      expect(result.isSuccess, isTrue);
      expect(result.successOrCrash, isTrue);
    });

    test('isPinConfigured returns false when hash is not stored', () async {
      when(() => secureStorage.read('by_sec_pin_hash'))
          .thenAnswer((_) async => null);

      final result = await repository.isPinConfigured();

      expect(result.isSuccess, isTrue);
      expect(result.successOrCrash, isFalse);
    });

    test('savePin saves hashed pin and salt to secure storage and sets pin enabled preference', () async {
      when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => {});
      when(() => preferencesStorage.setBool('by_sec_pin_enabled', true))
          .thenAnswer((_) async => true);

      final result = await repository.savePin('1234');

      expect(result.isSuccess, isTrue);
      verify(() => secureStorage.write(key: 'by_sec_pin_hash', value: any(named: 'value'))).called(1);
      verify(() => secureStorage.write(key: 'by_sec_pin_salt', value: any(named: 'value'))).called(1);
      verify(() => preferencesStorage.setBool('by_sec_pin_enabled', true)).called(1);
    });

    test('verifyPin returns true on correct matching hash', () async {
      const salt = 'salt123';
      final expectedHash = SecurityHashHelper.hashPin('1234', salt);
      when(() => secureStorage.read('by_sec_pin_salt')).thenAnswer((_) async => salt);
      when(() => secureStorage.read('by_sec_pin_hash')).thenAnswer((_) async => expectedHash);

      final result = await repository.verifyPin('1234');

      expect(result.isSuccess, isTrue);
      expect(result.successOrCrash, isTrue);
    });

    test('changePin checks old PIN, saves new PIN on success', () async {
      const salt = 'salt123';
      final expectedHash = SecurityHashHelper.hashPin('1234', salt);
      when(() => secureStorage.read('by_sec_pin_salt')).thenAnswer((_) async => salt);
      when(() => secureStorage.read('by_sec_pin_hash')).thenAnswer((_) async => expectedHash);

      when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => {});
      when(() => preferencesStorage.setBool('by_sec_pin_enabled', true))
          .thenAnswer((_) async => true);

      final result = await repository.changePin(oldPin: '1234', newPin: '5678');

      expect(result.isSuccess, isTrue);
    });

    test('changePin returns failure on wrong old PIN', () async {
      when(() => secureStorage.read('by_sec_pin_salt')).thenAnswer((_) async => 'salt123');
      when(() => secureStorage.read('by_sec_pin_hash')).thenAnswer((_) async => 'some_wrong_hash');

      final result = await repository.changePin(oldPin: '1234', newPin: '5678');

      expect(result.isFailure, isTrue);
    });

    test('getSettings retrieves correct settings', () async {
      when(() => preferencesStorage.getBool('by_sec_pin_enabled')).thenAnswer((_) async => true);
      when(() => preferencesStorage.getBool('by_sec_biometrics_enabled')).thenAnswer((_) async => false);
      when(() => preferencesStorage.getInt('by_sec_auto_lock_timeout')).thenAnswer((_) async => 30);
      when(() => preferencesStorage.getBool('by_sec_privacy_mode_enabled')).thenAnswer((_) async => true);

      final result = await repository.getSettings();

      expect(result.isSuccess, isTrue);
      final settings = result.successOrCrash;
      expect(settings.isPinEnabled, isTrue);
      expect(settings.isBiometricsEnabled, isFalse);
      expect(settings.autoLockTimeout.inSeconds, equals(30));
      expect(settings.isPrivacyModeEnabled, isTrue);
    });

    test('updateSettings writes to PreferencesStorage and updates by_balance_obscured', () async {
      when(() => preferencesStorage.setBool('by_sec_pin_enabled', true)).thenAnswer((_) async => true);
      when(() => preferencesStorage.setBool('by_sec_biometrics_enabled', true)).thenAnswer((_) async => true);
      when(() => preferencesStorage.setInt('by_sec_auto_lock_timeout', 60)).thenAnswer((_) async => true);
      when(() => preferencesStorage.setBool('by_sec_privacy_mode_enabled', true)).thenAnswer((_) async => true);
      when(() => preferencesStorage.setBool('by_balance_obscured', true)).thenAnswer((_) async => true);

      final result = await repository.updateSettings(const SecuritySettings(
        isPinEnabled: true,
        isBiometricsEnabled: true,
        autoLockTimeout: Duration(seconds: 60),
        isPrivacyModeEnabled: true,
      ));

      expect(result.isSuccess, isTrue);
      verify(() => preferencesStorage.setBool('by_sec_pin_enabled', true)).called(1);
      verify(() => preferencesStorage.setBool('by_balance_obscured', true)).called(1);
    });

    test('getBiometricCapabilities returns correct hardware availability and enrollment status', () async {
      when(() => permissionService.checkStatus(AppPermission.biometrics))
          .thenAnswer((_) async => PermissionStatus.granted);
      when(() => preferencesStorage.getBool('by_sec_biometrics_enabled'))
          .thenAnswer((_) async => true);

      final result = await repository.getBiometricCapabilities();

      expect(result.isSuccess, isTrue);
      final caps = result.successOrCrash;
      expect(caps.isHardwareAvailable, isTrue);
      expect(caps.isEnrolled, isTrue);
      expect(caps.isEnabled, isTrue);
    });

    test('authenticateBiometrics returns true when simulation succeeds', () async {
      when(() => permissionService.checkStatus(AppPermission.biometrics))
          .thenAnswer((_) async => PermissionStatus.granted);
      when(() => preferencesStorage.getBool('by_sec_biometrics_enabled'))
          .thenAnswer((_) async => true);

      repository.simulateBiometricsSuccess = true;
      final result = await repository.authenticateBiometrics();

      expect(result.isSuccess, isTrue);
    });

    test('authenticateBiometrics returns failure when simulation fails', () async {
      when(() => permissionService.checkStatus(AppPermission.biometrics))
          .thenAnswer((_) async => PermissionStatus.granted);
      when(() => preferencesStorage.getBool('by_sec_biometrics_enabled'))
          .thenAnswer((_) async => true);

      repository.simulateBiometricsSuccess = false;
      final result = await repository.authenticateBiometrics();

      expect(result.isFailure, isTrue);
      expect(result.failureOrCrash, isA<BiometricMismatchFailure>());
    });

    test('getSession loads correct SessionModel', () async {
      when(() => preferencesStorage.getBool('by_sec_session_auth')).thenAnswer((_) async => true);
      when(() => preferencesStorage.getInt('by_sec_session_failed_attempts')).thenAnswer((_) async => 2);
      when(() => preferencesStorage.getString('by_sec_session_lockout_until')).thenAnswer((_) async => null);

      final result = await repository.getSession();

      expect(result.isSuccess, isTrue);
      final session = result.successOrCrash;
      expect(session.isAuthenticated, isTrue);
      expect(session.failedAttempts, equals(2));
      expect(session.isLockedOut, isFalse);
    });

    test('saveSession writes current session properties', () async {
      when(() => preferencesStorage.setBool('by_sec_session_auth', true)).thenAnswer((_) async => true);
      when(() => preferencesStorage.setInt('by_sec_session_failed_attempts', 0)).thenAnswer((_) async => true);
      when(() => preferencesStorage.setString('by_sec_session_lockout_until', any())).thenAnswer((_) async => true);

      final result = await repository.saveSession(const SessionModel(
        isAuthenticated: true,
        failedAttempts: 0,
        lockoutUntil: null,
      ));

      expect(result.isSuccess, isTrue);
      verify(() => preferencesStorage.setBool('by_sec_session_auth', true)).called(1);
      verify(() => preferencesStorage.setInt('by_sec_session_failed_attempts', 0)).called(1);
    });

    test('purgeAllData wipes local database, secure storage and preferences', () async {
      when(() => databaseService.wipeLocalSandboxData()).thenAnswer((_) async => const Result.success(null));
      when(() => databaseService.closeConnection()).thenAnswer((_) async => const Result.success(null));
      when(() => secureStorage.deleteAll()).thenAnswer((_) async => {});
      when(() => preferencesStorage.clear()).thenAnswer((_) async => true);

      final result = await repository.purgeAllData();

      expect(result.isSuccess, isTrue);
      verify(() => databaseService.wipeLocalSandboxData()).called(1);
      verify(() => databaseService.closeConnection()).called(1);
      verify(() => secureStorage.deleteAll()).called(1);
      verify(() => preferencesStorage.clear()).called(1);
    });
  });
}
