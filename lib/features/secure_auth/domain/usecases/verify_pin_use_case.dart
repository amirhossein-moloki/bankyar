import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/security_repository.dart';

/// Use case to verify whether an input PIN matches the stored credential.
class VerifyPinUseCase implements UseCase<bool, String> {
  final SecurityRepository _repository;

  /// Constructor.
  const VerifyPinUseCase(this._repository);

  @override
  AsyncResult<bool> call(String params) {
    return _repository.verifyPin(params);
  }
}
