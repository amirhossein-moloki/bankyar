import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../domain/entities/biometric_capabilities.dart';
import '../../domain/entities/security_settings.dart';
import '../../domain/usecases/get_security_settings_use_case.dart';
import '../../domain/usecases/setup_pin_use_case.dart';
import '../../domain/usecases/update_security_settings_use_case.dart';
import '../../data/repositories/security_repository_provider.dart';

/// Combined state representing the user's security configuration profile.
class SecurityState {
  /// Constructor.
  const SecurityState({
    required this.settings,
    required this.biometricCapabilities,
    required this.isLoading,
  });

  /// Default initial state.
  factory SecurityState.initial() => SecurityState(
    settings: SecuritySettings.initial(),
    biometricCapabilities: BiometricCapabilities.initial(),
    isLoading: false,
  );

  /// The active security and privacy configuration options.
  final SecuritySettings settings;

  /// Hardware-bound biometric capabilities of the executing device.
  final BiometricCapabilities biometricCapabilities;

  /// Flag indicating if security operations are undergoing async load.
  final bool isLoading;

  /// Helper to duplicate state with option overrides.
  SecurityState copyWith({
    SecuritySettings? settings,
    BiometricCapabilities? biometricCapabilities,
    bool? isLoading,
  }) {
    return SecurityState(
      settings: settings ?? this.settings,
      biometricCapabilities:
          biometricCapabilities ?? this.biometricCapabilities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// StateNotifier orchestrating preferences updates, biometrics checks, and settings toggle actions.
class SecurityNotifier extends StateNotifier<SecurityState> {
  /// Constructor initiating automatic profile loading.
  SecurityNotifier({
    required SetupPinUseCase setupPinUseCase,
    required GetSecuritySettingsUseCase getSecuritySettingsUseCase,
    required UpdateSecuritySettingsUseCase updateSecuritySettingsUseCase,
    required Ref ref,
  }) : _setupPinUseCase = setupPinUseCase,
       _getSecuritySettingsUseCase = getSecuritySettingsUseCase,
       _updateSecuritySettingsUseCase = updateSecuritySettingsUseCase,
       _ref = ref,
       super(SecurityState.initial()) {
    loadSettings();
  }
  final SetupPinUseCase _setupPinUseCase;
  final GetSecuritySettingsUseCase _getSecuritySettingsUseCase;
  final UpdateSecuritySettingsUseCase _updateSecuritySettingsUseCase;
  final Ref _ref;

  /// Retrieves current on-device preferences and capabilities.
  Future<void> loadSettings() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true);
    final settingsRes = await _getSecuritySettingsUseCase(const NoParams());
    final repository = _ref.read(securityRepositoryProvider);
    final bioCapsRes = await repository.getBiometricCapabilities();

    if (!mounted) return;

    final settings = settingsRes.isSuccess
        ? settingsRes.successOrCrash
        : SecuritySettings.initial();
    final bioCaps = bioCapsRes.isSuccess
        ? bioCapsRes.successOrCrash
        : BiometricCapabilities.initial();

    state = SecurityState(
      settings: settings,
      biometricCapabilities: bioCaps,
      isLoading: false,
    );
  }

  /// Sets up or updates the user PIN credential securely.
  Future<bool> setupPin(String pin) async {
    if (!mounted) return false;
    state = state.copyWith(isLoading: true);
    final res = await _setupPinUseCase(pin);
    if (res.isSuccess) {
      final updatedSettings = state.settings.copyWith(isPinEnabled: true);
      await _updateSecuritySettingsUseCase(updatedSettings);
      await loadSettings();
      return true;
    }
    if (mounted) {
      state = state.copyWith(isLoading: false);
    }
    return false;
  }

  /// Toggles whether local PIN protection should be active.
  Future<void> togglePinEnabled(bool enabled, {String? pin}) async {
    if (enabled && pin != null) {
      await setupPin(pin);
    } else if (!enabled) {
      if (!mounted) return;
      state = state.copyWith(isLoading: true);
      final updatedSettings = state.settings.copyWith(
        isPinEnabled: false,
        isBiometricsEnabled:
            false, // Biometrics must be disabled if PIN is disabled
      );
      await _updateSecuritySettingsUseCase(updatedSettings);
      await loadSettings();
    }
  }

  /// Toggles local biometric scan authorization settings.
  Future<bool> toggleBiometricsEnabled(bool enabled) async {
    if (!mounted) return false;
    state = state.copyWith(isLoading: true);
    final updatedSettings = state.settings.copyWith(
      isBiometricsEnabled: enabled,
    );
    final res = await _updateSecuritySettingsUseCase(updatedSettings);

    if (res.isSuccess) {
      await loadSettings();
      return true;
    }
    if (mounted) {
      state = state.copyWith(isLoading: false);
    }
    return false;
  }

  /// Updates inactivity duration threshold for app locking.
  Future<void> updateAutoLockTimeout(Duration timeout) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true);
    final updatedSettings = state.settings.copyWith(autoLockTimeout: timeout);
    await _updateSecuritySettingsUseCase(updatedSettings);
    await loadSettings();
  }

  /// Toggles overall screen privacy mask settings (blur switcher, obscure cards).
  Future<void> togglePrivacyModeEnabled(bool enabled) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true);
    final updatedSettings = state.settings.copyWith(
      isPrivacyModeEnabled: enabled,
    );
    await _updateSecuritySettingsUseCase(updatedSettings);
    await loadSettings();
  }
}

/// Provider exposing the [SecurityNotifier] view model state.
final securityNotifierProvider =
    StateNotifierProvider<SecurityNotifier, SecurityState>((ref) {
      final setupPin = ref.watch(setupPinUseCaseProvider);
      final getSettings = ref.watch(getSecuritySettingsUseCaseProvider);
      final updateSettings = ref.watch(updateSecuritySettingsUseCaseProvider);

      return SecurityNotifier(
        setupPinUseCase: setupPin,
        getSecuritySettingsUseCase: getSettings,
        updateSecuritySettingsUseCase: updateSettings,
        ref: ref,
      );
    });
