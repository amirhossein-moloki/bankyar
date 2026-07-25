/// Model representing overall security configuration parameters.
class SecuritySettings {

  /// Constructor.
  const SecuritySettings({
    required this.isPinEnabled,
    required this.isBiometricsEnabled,
    required this.autoLockTimeout,
    required this.isPrivacyModeEnabled,
  });

  /// Factory for standard default secure configurations.
  factory SecuritySettings.initial() => const SecuritySettings(
    isPinEnabled: false,
    isBiometricsEnabled: false,
    autoLockTimeout: Duration(minutes: 1),
    isPrivacyModeEnabled: false,
  );
  /// Whether local PIN authentication is required to unlock the application.
  final bool isPinEnabled;

  /// Whether biometric fast-unlock has been granted and configured.
  final bool isBiometricsEnabled;

  /// Inactivity timeout duration before triggering auto-lock.
  final Duration autoLockTimeout;

  /// Whether privacy mode is enabled (obscures monetary balances and card numbers).
  final bool isPrivacyModeEnabled;

  /// Helper to create a copy of the settings with modified fields.
  SecuritySettings copyWith({
    bool? isPinEnabled,
    bool? isBiometricsEnabled,
    Duration? autoLockTimeout,
    bool? isPrivacyModeEnabled,
  }) {
    return SecuritySettings(
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      isPrivacyModeEnabled: isPrivacyModeEnabled ?? this.isPrivacyModeEnabled,
    );
  }
}
