import 'package:meta/meta.dart';
import '../errors/failure_mapper.dart';
import '../utils/result.dart';
import 'repository.dart';

/// Reusable abstract repository base class.
/// Safely wraps infrastructure and database calls, mapping exceptions to Domain Failures.
abstract class BaseRepository implements Repository {
  /// Constructor constructing base repository.
  const BaseRepository();

  /// Executes an asynchronous query block safely, mapping any caught exceptions
  /// or errors into standard, type-safe [Result] failures using [FailureMapper].
  @protected
  Future<Result<R>> executeSafe<R>(Future<R> Function() action) async {
    try {
      final result = await action();
      return Result.success(result);
    } catch (e, stack) {
      final failure = FailureMapper.map(e, stack);
      return Result.failure(failure);
    }
  }

  /// Pipes a reactive data stream safely, catching upstream exceptions
  /// and mapping them to domain-specific failures inside [Result] models.
  @protected
  Stream<Result<R>> pipeSafeStream<R>(Stream<R> stream) async* {
    try {
      await for (final data in stream) {
        yield Result.success(data);
      }
    } catch (e, stack) {
      final failure = FailureMapper.map(e, stack);
      yield Result.failure(failure);
    }
  }
}
