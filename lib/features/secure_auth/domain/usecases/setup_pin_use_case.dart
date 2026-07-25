import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/security_repository.dart';

/// Use case to securely configure a new unlock PIN.
class SetupPinUseCase implements UseCase<void, String> {
  /// Constructor.
  const SetupPinUseCase(this._repository);
  final SecurityRepository _repository;

  @override
  AsyncResult<void> call(String params) {
    return _repository.savePin(params);
  }
}
