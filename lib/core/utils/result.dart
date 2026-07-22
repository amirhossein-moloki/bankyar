import '../errors/failures.dart';

/// Standard, type-safe representation of asynchronous or business operation results.
/// Conforms to BankYar ERROR_HANDLING_ARCHITECTURE.md specifications.
abstract class Result<T> {
  const Result();

  /// Utility constructor for executing a closure safely and wrapping its return in [Result].
  static Future<Result<T>> guard<T>(Future<T> Function() computation) async {
    try {
      final data = await computation();
      return Result.success(data);
    } on Exception catch (e) {
      return Result.failure(
        UnknownFailure(code: 'BY_DOM_UNKNOWN_EXCEPTION', message: e.toString()),
      );
    }
  }

  /// Construct a [Success] result.
  const factory Result.success(T data) = Success<T>;

  /// Construct a [FailureResult] result.
  const factory Result.failure(Failure failure) = FailureResult<T>;

  /// Construct a [Loading] result.
  const factory Result.loading({double? progress}) = Loading<T>;

  /// Construct an [Empty] result.
  const factory Result.empty() = Empty<T>;

  /// Pattern matching utility for resolving result states cleanly.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
    required R Function(double? progress) loading,
    required R Function() empty,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is FailureResult<T>) {
      return failure((this as FailureResult<T>).failure);
    } else if (this is Loading<T>) {
      return loading((this as Loading<T>).progress);
    } else if (this is Empty<T>) {
      return empty();
    }
    throw StateError('Unexpected Result subtype: $runtimeType');
  }
}

/// Represents a successful operation delivering typed data [T].
class Success<T> extends Result<T> {
  /// Constructor for a successful operation result.
  const Success(this.data) : super();

  /// The processed output payload
  final T data;
}

/// Represents a failed operation holding domain-specific [Failure].
class FailureResult<T> extends Result<T> {
  /// Constructor for a failed operation result.
  const FailureResult(this.failure) : super();

  /// The mapped failure object
  final Failure failure;
}

/// Represents a transient loading state, optionally tracking loading progress.
class Loading<T> extends Result<T> {
  /// Constructor for a loading/processing result.
  const Loading({this.progress}) : super();

  /// The optional progress percentage from 0.0 to 1.0
  final double? progress;
}

/// Represents a successful operation that returned zero records.
class Empty<T> extends Result<T> {
  /// Constructor for an empty result.
  const Empty() : super();
}

/// Represents batch transactions with mixed success and failure states.
class PartialSuccess<T> extends Result<List<T>> {
  /// Constructor for partial success batch operations.
  const PartialSuccess({
    required this.successfulRecords,
    required this.failedRecords,
  }) : super();

  /// List of records processed successfully
  final List<T> successfulRecords;

  /// List of records that failed alongside their corresponding Failure
  final List<MapEntry<dynamic, Failure>> failedRecords;
}
