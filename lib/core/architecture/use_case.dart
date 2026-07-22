import '../utils/result_extensions.dart';

/// Base interface for all business Use Cases returning a [Result] wrapped in a Future.
/// Conforms to BankYar DI_ARCHITECTURE.md and STATE_MANAGEMENT.md specifications.
abstract class UseCase<T, Params> {
  /// Executes the business rules associated with this use case.
  AsyncResult<T> call(Params params);
}

/// Base interface for all business Use Cases returning a reactive [Stream].
abstract class StreamUseCase<T, Params> {
  /// Executes the reactive business rules stream associated with this use case.
  Stream<T> call(Params params);
}

/// Used as a placeholder parameter when a Use Case requires no inputs.
class NoParams {
  /// Constructor for parameterless use cases.
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}
