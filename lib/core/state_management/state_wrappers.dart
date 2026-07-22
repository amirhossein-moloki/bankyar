import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import '../errors/failures.dart';
import '../utils/result.dart';

/// Standardized, lightweight UI state wrapper modeled after Riverpod's [AsyncValue].
/// Tailored specifically for high-density finance dashboards and tracking progress rates.
@immutable
abstract class UiState<T> {
  const UiState();

  /// Creates a [UiInitial] state representation.
  const factory UiState.initial() = UiInitial<T>;

  /// Creates a [UiLoading] state representation, optionally tracking progress values.
  const factory UiState.loading({double? progress}) = UiLoading<T>;

  /// Creates a [UiSuccess] state representation containing the payload [data].
  const factory UiState.success(T data) = UiSuccess<T>;

  /// Creates a [UiError] state representation containing a domain [failure].
  const factory UiState.error(Failure failure) = UiError<T>;

  /// Map state representations to UI components cleanly.
  R when<R>({
    required R Function() initial,
    required R Function(double? progress) loading,
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    if (this is UiInitial<T>) return initial();
    if (this is UiLoading<T>) return loading((this as UiLoading<T>).progress);
    if (this is UiSuccess<T>) return success((this as UiSuccess<T>).data);
    if (this is UiError<T>) return error((this as UiError<T>).failure);
    throw StateError('Unexpected UiState type: $runtimeType');
  }
}

class UiInitial<T> extends UiState<T> {
  const UiInitial() : super();
}

class UiLoading<T> extends UiState<T> {
  const UiLoading({this.progress}) : super();
  final double? progress;
}

class UiSuccess<T> extends UiState<T> {
  const UiSuccess(this.data) : super();
  final T data;
}

class UiError<T> extends UiState<T> {
  const UiError(this.failure) : super();
  final Failure failure;
}

/// Extension mapping domain [Result] patterns directly to Riverpod's native [AsyncValue].
extension ResultToAsyncValue<T> on Result<T> {
  /// Converts a standard business [Result] to a reactive [AsyncValue].
  AsyncValue<T> toAsyncValue() {
    return when(
      success: (data) => AsyncValue.data(data),
      failure: (failure) => AsyncValue.error(failure, StackTrace.current),
      loading: (progress) => const AsyncValue.loading(),
      empty: () => const AsyncValue.loading(),
    );
  }
}
