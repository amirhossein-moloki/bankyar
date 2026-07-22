import 'result.dart';
import '../errors/failures.dart';

/// Type alias standardizing asynchronous result operations in BankYar.
typedef AsyncResult<T> = Future<Result<T>>;

/// Extension providing functional and state inspection helpers on [Result].
extension ResultExtensions<T> on Result<T> {
  /// Returns true if this is a [Success] result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a [FailureResult] result.
  bool get isFailure => this is FailureResult<T>;

  /// Returns true if this is a [Loading] result.
  bool get isLoading => this is Loading<T>;

  /// Returns true if this is an [Empty] result.
  bool get isEmpty => this is Empty<T>;

  /// Returns the parsed data if successful, otherwise null.
  T? get dataOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Returns the underlying failure if failed, otherwise null.
  Failure? get failureOrNull {
    if (this is FailureResult<T>) {
      return (this as FailureResult<T>).failure;
    }
    return null;
  }

  /// Evaluates state and transforms successful result payloads.
  Result<R> map<R>(R Function(T data) fn) {
    return when(
      success: (data) => Result<R>.success(fn(data)),
      failure: (failure) => Result<R>.failure(failure),
      loading: (progress) => Result<R>.loading(progress: progress),
      empty: () => Result<R>.empty(),
    );
  }

  /// Chains and evaluates nested result operations.
  Result<R> flatMap<R>(Result<R> Function(T data) fn) {
    return when(
      success: (data) => fn(data),
      failure: (failure) => Result<R>.failure(failure),
      loading: (progress) => Result<R>.loading(progress: progress),
      empty: () => Result<R>.empty(),
    );
  }

  /// Syntactic sugar folding results down to single resolved values.
  R fold<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
    required R Function(double? progress) loading,
    required R Function() empty,
  }) {
    return when(
      success: success,
      failure: failure,
      loading: loading,
      empty: empty,
    );
  }
}

/// Extension providing async-aware pipelines on [Future] of [Result].
extension AsyncResultExtensions<T> on Future<Result<T>> {
  /// Maps success states asynchronously.
  Future<Result<R>> mapAsync<R>(R Function(T data) fn) async {
    final result = await this;
    return result.map(fn);
  }

  /// FlatMaps success states asynchronously.
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T data) fn,
  ) async {
    final result = await this;
    if (result is Success<T>) {
      return fn(result.data);
    } else if (result is FailureResult<T>) {
      return Result<R>.failure(result.failure);
    } else if (result is Loading<T>) {
      return Result<R>.loading(progress: result.progress);
    } else {
      return Result<R>.empty();
    }
  }

  /// Folds async results asynchronously.
  Future<R> foldAsync<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
    required R Function(double? progress) loading,
    required R Function() empty,
  }) async {
    final result = await this;
    return result.fold(
      success: success,
      failure: failure,
      loading: loading,
      empty: empty,
    );
  }
}
