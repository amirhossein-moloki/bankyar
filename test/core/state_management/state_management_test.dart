import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/state_management/base_providers.dart';
import 'package:bankyar/core/state_management/provider_observer.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogger extends Mock implements AppLogger {}

class MyUiNotifier extends BaseUiNotifier<int> {
  void triggerSuccess(int value) => setSuccess(value);
  void triggerLoading({double? progress}) => setLoading(progress: progress);
  void triggerError(Failure failure) => setError(failure);
  void triggerInitial() => setInitial();
}

void main() {
  group('UiState Union and Conversions Tests', () {
    test('UiState maps patterns correctly', () {
      const UiState<int> state = UiState.initial();
      final mapped = state.when(
        initial: () => 'Initial',
        loading: (prog) => 'Loading: $prog',
        success: (data) => 'Success: $data',
        error: (fail) => 'Error: ${fail.code}',
      );
      expect(mapped, equals('Initial'));

      final UiState<int> loading = const UiState.loading(progress: 0.75);
      expect(
        loading.when(
          initial: () => 'Initial',
          loading: (prog) => 'Loading: $prog',
          success: (data) => 'Success: $data',
          error: (fail) => 'Error: ${fail.code}',
        ),
        equals('Loading: 0.75'),
      );

      final UiState<int> success = const UiState.success(123);
      expect(
        success.when(
          initial: () => 'Initial',
          loading: (prog) => 'Loading: $prog',
          success: (data) => 'Success: $data',
          error: (fail) => 'Error: ${fail.code}',
        ),
        equals('Success: 123'),
      );

      final UiState<int> error = const UiState.error(UnknownFailure(code: 'BY_ERR', message: 'Fail'));
      expect(
        error.when(
          initial: () => 'Initial',
          loading: (prog) => 'Loading: $prog',
          success: (data) => 'Success: $data',
          error: (fail) => 'Error: ${fail.code}',
        ),
        equals('Error: BY_ERR'),
      );
    });

    test('ResultToAsyncValue extension converts successfully', () {
      const Result<int> resSuccess = Success(42);
      final asyncSuccess = resSuccess.toAsyncValue();
      expect(asyncSuccess.asData!.value, equals(42));

      const Result<int> resFail = FailureResult(UnknownFailure(code: 'BY_ERR', message: 'Err'));
      final asyncFail = resFail.toAsyncValue();
      expect(asyncFail.hasError, isTrue);
      expect((asyncFail.error as Failure).code, equals('BY_ERR'));
    });
  });

  group('BaseUiNotifier State Transition Tests', () {
    test('BaseUiNotifier transitions through states correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifierProvider = StateNotifierProvider<MyUiNotifier, UiState<int>>((ref) {
        return MyUiNotifier();
      });

      expect(container.read(notifierProvider), isA<UiInitial<int>>());

      container.read(notifierProvider.notifier).triggerLoading(progress: 0.5);
      expect(container.read(notifierProvider), isA<UiLoading<int>>());
      expect((container.read(notifierProvider) as UiLoading<int>).progress, equals(0.5));

      container.read(notifierProvider.notifier).triggerSuccess(99);
      expect(container.read(notifierProvider), isA<UiSuccess<int>>());
      expect((container.read(notifierProvider) as UiSuccess<int>).data, equals(99));

      container.read(notifierProvider.notifier).triggerError(const UnknownFailure(code: 'BY_FAIL', message: 'Fail'));
      expect(container.read(notifierProvider), isA<UiError<int>>());
      expect((container.read(notifierProvider) as UiError<int>).failure.code, equals('BY_FAIL'));

      container.read(notifierProvider.notifier).triggerInitial();
      expect(container.read(notifierProvider), isA<UiInitial<int>>());
    });
  });

  group('AppProviderObserver Lifecycle Tracking Tests', () {
    test('AppProviderObserver writes diagnostics correctly on add, update, and dispose', () {
      final mockLogger = MockLogger();
      final observer = AppProviderObserver(mockLogger);

      registerFallbackValue(LogLevel.trace);

      when(() => mockLogger.log(
            any(),
            any(),
            any(),
            any(),
            metadata: any(named: 'metadata'),
            error: any(named: 'error'),
            stackTrace: any(named: 'stackTrace'),
          )).thenAnswer((_) {});

      final container = ProviderContainer(observers: [observer]);

      final dummyProvider = StateProvider<String>((ref) => 'initial-value');

      // 1. Trigger didAddProvider
      final val1 = container.read(dummyProvider);
      expect(val1, equals('initial-value'));

      // 2. Trigger didUpdateProvider
      container.read(dummyProvider.notifier).state = 'updated-value';
      final val2 = container.read(dummyProvider);
      expect(val2, equals('updated-value'));

      // 3. Trigger didDisposeProvider
      container.dispose();

      // Verify that all 3 lifecycle logging calls were invoked with trace level and taxonomy codes
      verify(() => mockLogger.log(
            LogLevel.trace,
            'STATE_MANAGEMENT',
            'BY_STATE_ADD',
            any(),
            metadata: any(named: 'metadata'),
          )).called(1);

      verify(() => mockLogger.log(
            LogLevel.trace,
            'STATE_MANAGEMENT',
            'BY_STATE_UPDATE',
            any(),
            metadata: any(named: 'metadata'),
          )).called(1);

      verify(() => mockLogger.log(
            LogLevel.trace,
            'STATE_MANAGEMENT',
            'BY_STATE_DISPOSE',
            any(),
          )).called(1);
    });
  });
}
