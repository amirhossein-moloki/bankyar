import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/security_settings.dart';
import '../repository/security_repository.dart';

/// Use case to retrieve the active security and privacy configuration profile.
class GetSecuritySettingsUseCase
    implements UseCase<SecuritySettings, NoParams> {

  /// Constructor.
  const GetSecuritySettingsUseCase(this._repository);
  final SecurityRepository _repository;

  @override
  AsyncResult<SecuritySettings> call(NoParams params) {
    return _repository.getSettings();
  }
}
