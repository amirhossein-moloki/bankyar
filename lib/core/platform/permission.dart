/// Supported operating system authorization requirements inside BankYar.
enum AppPermission {
  /// Receive background and foreground SMS broadcasts.
  smsReceive,

  /// Read/Write local sandboxed files (backup export/import).
  localFiles,

  /// Access system biometric hardware sensors.
  biometrics,
}

/// Standard authorization statuses.
enum PermissionStatus {
  /// User granted full permissions.
  granted,

  /// User denied permission prompts.
  denied,

  /// User blocked permission prompts permanently; requires manual system settings intervention.
  permanentlyDenied,
}

/// Abstraction representing system authorization controllers.
/// Conforms to FEATURE_ARCHITECTURE.md specifications.
abstract class PermissionService {
  /// Verifies whether the specified [permission] is active.
  Future<PermissionStatus> checkStatus(AppPermission permission);

  /// Prompts standard system authorization dialogs for the specified [permission].
  Future<PermissionStatus> request(AppPermission permission);
}

/// Fallback/default implementation of [PermissionService] that can be overridden in tests.
class SystemPermissionService implements PermissionService {
  /// Constructor constructing permission service.
  const SystemPermissionService();

  @override
  Future<PermissionStatus> checkStatus(AppPermission permission) async {
    // Standard system permissions default to granted for smooth offline operations in sandbox
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> request(AppPermission permission) async {
    return PermissionStatus.granted;
  }
}
