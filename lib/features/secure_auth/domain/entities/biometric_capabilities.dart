/// Model representing the biometric hardware status on the active device.
class BiometricCapabilities {
  /// Whether the device has biometric scanning hardware available.
  final bool isHardwareAvailable;

  /// Whether the user has registered fingerprints or face data inside their system settings.
  final bool isEnrolled;

  /// Whether biometric fast unlock is enabled inside this application.
  final bool isEnabled;

  /// Constructor.
  const BiometricCapabilities({
    required this.isHardwareAvailable,
    required this.isEnrolled,
    required this.isEnabled,
  });

  /// Default initial capabilities.
  factory BiometricCapabilities.initial() => const BiometricCapabilities(
        isHardwareAvailable: false,
        isEnrolled: false,
        isEnabled: false,
      );
}
