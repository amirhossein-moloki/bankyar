import '../../../../core/database/database_service.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/permission.dart';
import '../../../../core/platform/secure_storage.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../domain/entities/biometric_capabilities.dart';
import '../../domain/entities/security_settings.dart';
import '../../domain/entities/session_model.dart';
import '../../domain/repository/security_repository.dart';
import '../models/security_hash_helper.dart';

/// Concrete implementation of [SecurityRepository] managing persistence
/// in secure storage and preferences storage, providing simulated biometrics.
class LocalSecurityRepository implements SecurityRepository {
  /// Constructor.
  LocalSecurityRepository({
    required SecureStorage secureStorage,
    required PreferencesStorage preferencesStorage,
    required DatabaseService databaseService,
    required PermissionService permissionService,
  }) : _secureStorage = secureStorage,
       _preferencesStorage = preferencesStorage,
       _databaseService = databaseService,
       _permissionService = permissionService;
  final SecureStorage _secureStorage;
  final PreferencesStorage _preferencesStorage;
  final DatabaseService _databaseService;
  final PermissionService _permissionService;

  /// Control flag to simulate biometric authentication outcomes during testing.
  bool simulateBiometricsSuccess = true;

  /// Control flag to simulate biometric availability during testing.
  bool simulateBiometricsHardwareAvailable = true;

  static const String _pinHashKey = 'by_sec_pin_hash';
  static const String _pinSaltKey = 'by_sec_pin_salt';

  static const String _prefPinEnabled = 'by_sec_pin_enabled';
  static const String _prefBiometricsEnabled = 'by_sec_biometrics_enabled';
  static const String _prefAutoLockTimeout = 'by_sec_auto_lock_timeout';
  static const String _prefPrivacyModeEnabled = 'by_sec_privacy_mode_enabled';

  static const String _prefSessionAuth = 'by_sec_session_auth';
  static const String _prefSessionFailedAttempts =
      'by_sec_session_failed_attempts';
  static const String _prefSessionLockoutUntil = 'by_sec_session_lockout_until';

  @override
  Future<Result<bool>> isPinConfigured() async {
    try {
      final hash = await _secureStorage.read(_pinHashKey);
      return Result.success(hash != null && hash.isNotEmpty);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_STORAGE_ERROR',
          message: 'Could not read PIN status from secure storage.',
        ),
      );
    }
  }

  @override
  Future<Result<void>> savePin(String pin) async {
    try {
      final salt = SecurityHashHelper.generateSalt();
      final hash = SecurityHashHelper.hashPin(pin, salt);

      await _secureStorage.write(key: _pinHashKey, value: hash);
      await _secureStorage.write(key: _pinSaltKey, value: salt);

      // Automatically enable PIN protection flag
      await _preferencesStorage.setBool(_prefPinEnabled, true);

      return const Result.success(null);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_STORAGE_ERROR',
          message: 'Could not write PIN configuration to secure storage.',
        ),
      );
    }
  }

  @override
  Future<Result<bool>> verifyPin(String pin) async {
    try {
      final hash = await _secureStorage.read(_pinHashKey);
      final salt = await _secureStorage.read(_pinSaltKey);

      if (hash == null || salt == null) {
        return const Result.success(false);
      }

      final computedHash = SecurityHashHelper.hashPin(pin, salt);
      return Result.success(computedHash == hash);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_VERIFICATION_ERROR',
          message: 'Could not execute secure PIN cryptographic matching.',
        ),
      );
    }
  }

  @override
  Future<Result<void>> changePin({
    required String oldPin,
    required String newPin,
  }) async {
    try {
      final verification = await verifyPin(oldPin);
      if (verification.isFailure) {
        return Result.failure(verification.failureOrCrash);
      }

      if (!verification.successOrCrash) {
        return const Result.failure(
          SecurityFailure(
            code: 'BY_SEC_PIN_MISMATCH',
            message: 'The old PIN entered is incorrect.',
          ),
        );
      }

      return savePin(newPin);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_CHANGE_ERROR',
          message: 'Could not complete secure PIN rollover operation.',
        ),
      );
    }
  }

  @override
  Future<Result<SecuritySettings>> getSettings() async {
    try {
      final pinEnabled =
          await _preferencesStorage.getBool(_prefPinEnabled) ?? false;
      final bioEnabled =
          await _preferencesStorage.getBool(_prefBiometricsEnabled) ?? false;
      final timeoutSecs =
          await _preferencesStorage.getInt(_prefAutoLockTimeout) ?? 60;
      final privacyEnabled =
          await _preferencesStorage.getBool(_prefPrivacyModeEnabled) ?? false;

      return Result.success(
        SecuritySettings(
          isPinEnabled: pinEnabled,
          isBiometricsEnabled: bioEnabled,
          autoLockTimeout: Duration(seconds: timeoutSecs),
          isPrivacyModeEnabled: privacyEnabled,
        ),
      );
    } catch (e) {
      return Result.success(SecuritySettings.initial());
    }
  }

  @override
  Future<Result<void>> updateSettings(SecuritySettings settings) async {
    try {
      await _preferencesStorage.setBool(_prefPinEnabled, settings.isPinEnabled);
      await _preferencesStorage.setBool(
        _prefBiometricsEnabled,
        settings.isBiometricsEnabled,
      );
      await _preferencesStorage.setInt(
        _prefAutoLockTimeout,
        settings.autoLockTimeout.inSeconds,
      );
      await _preferencesStorage.setBool(
        _prefPrivacyModeEnabled,
        settings.isPrivacyModeEnabled,
      );

      // Align balance privacy masking key used in transactions feature
      await _preferencesStorage.setBool(
        'by_balance_obscured',
        settings.isPrivacyModeEnabled,
      );

      return const Result.success(null);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_UPDATE_SETTINGS_ERROR',
          message: 'Could not persist active security preferences.',
        ),
      );
    }
  }

  @override
  Future<Result<BiometricCapabilities>> getBiometricCapabilities() async {
    try {
      final status = await _permissionService.checkStatus(
        AppPermission.biometrics,
      );
      final isHardwareAvailable = simulateBiometricsHardwareAvailable;
      final isEnrolled = status == PermissionStatus.granted;
      final isEnabled =
          await _preferencesStorage.getBool(_prefBiometricsEnabled) ?? false;

      return Result.success(
        BiometricCapabilities(
          isHardwareAvailable: isHardwareAvailable,
          isEnrolled: isEnrolled,
          isEnabled: isEnabled,
        ),
      );
    } catch (e) {
      return Result.success(BiometricCapabilities.initial());
    }
  }

  @override
  Future<Result<bool>> authenticateBiometrics() async {
    try {
      final capsRes = await getBiometricCapabilities();
      if (capsRes.isFailure) return Result.failure(capsRes.failureOrCrash);
      final caps = capsRes.successOrCrash;

      if (!caps.isHardwareAvailable || !caps.isEnrolled) {
        return const Result.failure(
          SecurityFailure(
            code: 'BY_SEC_BIOMETRICS_UNAVAILABLE',
            message:
                'Biometric scan hardware is not ready or configured on the device.',
          ),
        );
      }

      // Simulate authentication scanning outcome
      if (simulateBiometricsSuccess) {
        return const Result.success(true);
      } else {
        return const Result.failure(BiometricMismatchFailure());
      }
    } catch (e) {
      return const Result.failure(BiometricMismatchFailure());
    }
  }

  @override
  Future<Result<SessionModel>> getSession() async {
    try {
      final auth = await _preferencesStorage.getBool(_prefSessionAuth) ?? false;
      final failed =
          await _preferencesStorage.getInt(_prefSessionFailedAttempts) ?? 0;
      final lockoutStr = await _preferencesStorage.getString(
        _prefSessionLockoutUntil,
      );

      DateTime? lockoutUntil;
      if (lockoutStr != null && lockoutStr.isNotEmpty) {
        lockoutUntil = DateTime.tryParse(lockoutStr);
      }

      return Result.success(
        SessionModel(
          isAuthenticated: auth,
          lastActivity:
              DateTime.now(), // Dynamic last activity representing active boot check
          failedAttempts: failed,
          lockoutUntil: lockoutUntil,
        ),
      );
    } catch (e) {
      return Result.success(SessionModel.initial());
    }
  }

  @override
  Future<Result<void>> saveSession(SessionModel session) async {
    try {
      await _preferencesStorage.setBool(
        _prefSessionAuth,
        session.isAuthenticated,
      );
      await _preferencesStorage.setInt(
        _prefSessionFailedAttempts,
        session.failedAttempts,
      );
      if (session.lockoutUntil != null) {
        await _preferencesStorage.setString(
          _prefSessionLockoutUntil,
          session.lockoutUntil!.toIso8601String(),
        );
      } else {
        await _preferencesStorage.setString(_prefSessionLockoutUntil, '');
      }
      return const Result.success(null);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_SESSION_SAVE_ERROR',
          message: 'Could not write active session properties.',
        ),
      );
    }
  }

  @override
  Future<Result<void>> purgeAllData() async {
    try {
      // 1. Clear database sandboxing
      await _databaseService.wipeLocalSandboxData();
      await _databaseService.closeConnection();

      // 2. Erase secure keys
      await _secureStorage.deleteAll();

      // 3. Purge PreferencesStorage entirely
      await _preferencesStorage.clear();

      return const Result.success(null);
    } catch (e) {
      return const Result.failure(
        SecurityFailure(
          code: 'BY_SEC_PURGE_ERROR',
          message:
              'Could not execute defensive zeroization of application storage.',
        ),
      );
    }
  }
}
