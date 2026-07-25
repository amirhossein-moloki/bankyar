import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/security_settings.dart';
import '../repository/security_repository.dart';

/// Use case to persist modifications to active security/privacy configurations.
class UpdateSecuritySettingsUseCase implements UseCase<void, SecuritySettings> {

  /// Constructor.
  const UpdateSecuritySettingsUseCase(this._repository);
  final SecurityRepository _repository;

  @override
  AsyncResult<void> call(SecuritySettings params) {
    return _repository.updateSettings(params);
  }
}
