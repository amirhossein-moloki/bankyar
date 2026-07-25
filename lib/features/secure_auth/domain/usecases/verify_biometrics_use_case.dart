import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/security_repository.dart';

/// Use case to trigger device hardware-bound biometric scans.
class VerifyBiometricsUseCase implements UseCase<bool, NoParams> {

  /// Constructor.
  const VerifyBiometricsUseCase(this._repository);
  final SecurityRepository _repository;

  @override
  AsyncResult<bool> call(NoParams params) {
    return _repository.authenticateBiometrics();
  }
}
