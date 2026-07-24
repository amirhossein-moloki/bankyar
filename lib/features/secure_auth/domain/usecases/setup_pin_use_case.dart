import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/security_repository.dart';

/// Use case to securely configure a new unlock PIN.
class SetupPinUseCase implements UseCase<void, String> {
  final SecurityRepository _repository;

  /// Constructor.
  const SetupPinUseCase(this._repository);

  @override
  AsyncResult<void> call(String params) {
    return _repository.savePin(params);
  }
}
