import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../repository/security_repository.dart';

/// Use case to perform a permanent emergency purge of all application data, preferences, and keys.
class PurgeAllDataUseCase implements UseCase<void, NoParams> {

  /// Constructor.
  const PurgeAllDataUseCase(this._repository);
  final SecurityRepository _repository;

  @override
  AsyncResult<void> call(NoParams params) {
    return _repository.purgeAllData();
  }
}
