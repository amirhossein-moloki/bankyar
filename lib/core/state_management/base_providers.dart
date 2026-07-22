import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/failures.dart';
import 'state_wrappers.dart';

/// Abstract base class for all State Notifiers managing custom [UiState].
/// Standardizes loading, success, and error transition states across feature ViewModels.
abstract class BaseUiNotifier<T> extends StateNotifier<UiState<T>> {
  /// Constructor defining the default initial state.
  BaseUiNotifier() : super(const UiState.initial());

  /// Transitions the state back to initial/idle.
  void setInitial() {
    state = const UiState.initial();
  }

  /// Transitions the state to loading, optionally specifying progress rates.
  void setLoading({double? progress}) {
    state = UiState<T>.loading(progress: progress);
  }

  /// Transitions the state to success, containing the output payload [data].
  void setSuccess(T data) {
    state = UiState<T>.success(data);
  }

  /// Transitions the state to a failed state, containing the specific domain [failure].
  void setError(Failure failure) {
    state = UiState<T>.error(failure);
  }
}
