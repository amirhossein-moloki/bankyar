import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/security_repository.dart';

/// Parameter wrapper for modifying existing PIN values.
class ChangePinParams {
  /// User's current PIN.
  final String oldPin;

  /// User's proposed new PIN.
  final String newPin;

  /// Constructor.
  const ChangePinParams({required this.oldPin, required this.newPin});
}

/// Use case to safely modify the active PIN after validating the current credentials.
class ChangePinUseCase implements UseCase<void, ChangePinParams> {
  final SecurityRepository _repository;

  /// Constructor.
  const ChangePinUseCase(this._repository);

  @override
  AsyncResult<void> call(ChangePinParams params) {
    return _repository.changePin(oldPin: params.oldPin, newPin: params.newPin);
  }
}
