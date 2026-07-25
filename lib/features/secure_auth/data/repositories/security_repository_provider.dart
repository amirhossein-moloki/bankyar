import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/repository/security_repository.dart';
import '../../domain/usecases/change_pin_use_case.dart';
import '../../domain/usecases/get_security_settings_use_case.dart';
import '../../domain/usecases/purge_all_data_use_case.dart';
import '../../domain/usecases/setup_pin_use_case.dart';
import '../../domain/usecases/update_security_settings_use_case.dart';
import '../../domain/usecases/verify_biometrics_use_case.dart';
import '../../domain/usecases/verify_pin_use_case.dart';
import 'local_security_repository.dart';

/// Provider exposing the concrete [LocalSecurityRepository] instance.
final securityRepositoryProvider = Provider<LocalSecurityRepository>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final preferencesStorage = ref.watch(preferencesStorageProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  final permissionService = ref.watch(permissionServiceProvider);

  return LocalSecurityRepository(
    secureStorage: secureStorage,
    preferencesStorage: preferencesStorage,
    databaseService: databaseService,
    permissionService: permissionService,
  );
});

/// Use case provider for PIN setup.
final setupPinUseCaseProvider = Provider<SetupPinUseCase>((ref) {
  final repository = ref.watch(securityRepositoryProvider);
  return SetupPinUseCase(repository);
});

/// Use case provider for PIN verification.
final verifyPinUseCaseProvider = Provider<VerifyPinUseCase>((ref) {
  final repository = ref.watch(securityRepositoryProvider);
  return VerifyPinUseCase(repository);
});

/// Use case provider for PIN changing.
final changePinUseCaseProvider = Provider<ChangePinUseCase>((ref) {
  final repository = ref.watch(securityRepositoryProvider);
  return ChangePinUseCase(repository);
});

/// Use case provider for biometric verification.
final verifyBiometricsUseCaseProvider = Provider<VerifyBiometricsUseCase>((
  ref,
) {
  final repository = ref.watch(securityRepositoryProvider);
  return VerifyBiometricsUseCase(repository);
});

/// Use case provider for retrieving security configurations.
final getSecuritySettingsUseCaseProvider = Provider<GetSecuritySettingsUseCase>(
  (ref) {
    final repository = ref.watch(securityRepositoryProvider);
    return GetSecuritySettingsUseCase(repository);
  },
);

/// Use case provider for saving security configurations.
final updateSecuritySettingsUseCaseProvider =
    Provider<UpdateSecuritySettingsUseCase>((ref) {
      final repository = ref.watch(securityRepositoryProvider);
      return UpdateSecuritySettingsUseCase(repository);
    });

/// Use case provider for emergency application data erasure.
final purgeAllDataUseCaseProvider = Provider<PurgeAllDataUseCase>((ref) {
  final repository = ref.watch(securityRepositoryProvider);
  return PurgeAllDataUseCase(repository);
});
