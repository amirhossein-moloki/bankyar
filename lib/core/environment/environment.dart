import 'package:meta/meta.dart';

/// The active application build flavor.
enum AppFlavor {
  /// Local engineering development environment
  dev,

  /// Local or CI test automation execution
  test,

  /// Manual or automated Quality Assurance checks
  qa,

  /// Internal alpha distribution tracks
  internal,

  /// Public beta pre-release distribution
  beta,

  /// Production-ready consumer release
  prod,

  /// Enterprise-customized corporate distribution
  enterprise,
}

/// Strongly-typed compile-time and runtime environment configuration.
/// Conforms to BankYar CONFIGURATION_ARCHITECTURE.md specifications.
@immutable
class AppEnvironment {
  /// Constructor constructing complete [AppEnvironment] variables.
  const AppEnvironment({
    required this.flavor,
    required this.buildId,
    required this.isDiagnosticsEnabled,
    required this.isScreenshotProtectionEnabled,
    required this.maxLogSizeMb,
    required this.regexTimeoutMs,
    required this.isBiometricLockEnabled,
    required this.isExperimentalFeatureActive,
  });

  /// Factory constructor to load configurations from Dart compile-time defines.
  factory AppEnvironment.fromDefines() {
    const flavorStr = String.fromEnvironment(
      'BY_APP_FLAVOR',
      defaultValue: 'dev',
    );
    final flavor = AppFlavor.values.firstWhere(
      (e) => e.name == flavorStr,
      orElse: () => AppFlavor.dev,
    );

    const buildId = String.fromEnvironment(
      'BY_BUILD_ID',
      defaultValue: 'local_debug',
    );
    const isDiagnostics = bool.fromEnvironment(
      'BY_DIAGNOSTICS_ENABLED',
      defaultValue: true,
    );
    const isScreenshotProtection = bool.fromEnvironment(
      'BY_SCREENSHOT_PROTECTION',
      defaultValue: true,
    );
    const maxLogSize = int.fromEnvironment(
      'BY_VAR_MAX_LOG_SIZE_MB',
      defaultValue: 2,
    );
    const regexTimeout = int.fromEnvironment(
      'BY_VAR_REGEX_TIMEOUT_MS',
      defaultValue: 100,
    );

    // Default flags depend on target build flavor
    final isProdOrBeta = flavor == AppFlavor.prod || flavor == AppFlavor.beta;

    return AppEnvironment(
      flavor: flavor,
      buildId: buildId,
      isDiagnosticsEnabled: isDiagnostics,
      isScreenshotProtectionEnabled: isScreenshotProtection,
      maxLogSizeMb: maxLogSize,
      regexTimeoutMs: regexTimeout,
      isBiometricLockEnabled: isProdOrBeta,
      isExperimentalFeatureActive: !isProdOrBeta,
    );
  }

  /// Active execution flavor of this build
  final AppFlavor flavor;

  /// Unique compilation build run identifier
  final String buildId;

  /// Compile-time switch to preserve or strip diagnostic logs
  final bool isDiagnosticsEnabled;

  /// Window secure flags configuration toggle
  final bool isScreenshotProtectionEnabled;

  /// Max log storage page limit (default 2MB)
  final int maxLogSizeMb;

  /// Hard timeout threshold for regular expression matching
  final int regexTimeoutMs;

  /// Whether biometric locks are strictly required
  final bool isBiometricLockEnabled;

  /// Toggles experimental feature visibilities
  final bool isExperimentalFeatureActive;

  /// Compares environments for equality.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppEnvironment &&
          runtimeType == other.runtimeType &&
          flavor == other.flavor &&
          buildId == other.buildId &&
          isDiagnosticsEnabled == other.isDiagnosticsEnabled &&
          isScreenshotProtectionEnabled ==
              other.isScreenshotProtectionEnabled &&
          maxLogSizeMb == other.maxLogSizeMb &&
          regexTimeoutMs == other.regexTimeoutMs &&
          isBiometricLockEnabled == other.isBiometricLockEnabled &&
          isExperimentalFeatureActive == other.isExperimentalFeatureActive;

  /// Generates hash value for current configs.
  @override
  int get hashCode =>
      flavor.hashCode ^
      buildId.hashCode ^
      isDiagnosticsEnabled.hashCode ^
      isScreenshotProtectionEnabled.hashCode ^
      maxLogSizeMb.hashCode ^
      regexTimeoutMs.hashCode ^
      isBiometricLockEnabled.hashCode ^
      isExperimentalFeatureActive.hashCode;

  /// String descriptor of active environment.
  @override
  String toString() {
    return 'AppEnvironment(flavor: $flavor, buildId: $buildId, diagnostics: $isDiagnosticsEnabled)';
  }
}
