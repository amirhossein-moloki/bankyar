import '../../../../core/utils/result.dart';
import '../entities/biometric_capabilities.dart';
import '../entities/security_settings.dart';
import '../entities/session_model.dart';

/// Repository interface governing local security configuration,
/// PIN authentication, biometrics, auto-lock policies, and emergency purges.
abstract class SecurityRepository {
  /// Check if the user has already configured an unlock PIN.
  Future<Result<bool>> isPinConfigured();

  /// Securely set a new unlock PIN.
  Future<Result<void>> savePin(String pin);

  /// Verify if the given [pin] matches the stored PIN.
  Future<Result<bool>> verifyPin(String pin);

  /// Modify the active PIN after confirming credentials.
  Future<Result<void>> changePin({required String oldPin, required String newPin});

  /// Retrieve overall application security and privacy configurations.
  Future<Result<SecuritySettings>> getSettings();

  /// Update active security and privacy configurations.
  Future<Result<void>> updateSettings(SecuritySettings settings);

  /// Retrieve the biometric scanning capabilities of the active device.
  Future<Result<BiometricCapabilities>> getBiometricCapabilities();

  /// Perform secure hardware-based biometric authentication.
  Future<Result<bool>> authenticateBiometrics();

  /// Retrieve the current active session state metadata.
  Future<Result<SessionModel>> getSession();

  /// Persist/update the active session state metadata.
  Future<Result<void>> saveSession(SessionModel session);

  /// Complete destructive purge of database and settings under emergency lockout scenarios.
  Future<Result<void>> purgeAllData();
}
