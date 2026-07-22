import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/utils/result.dart';

void main() {
  group('Result Monad & State Tests', () {
    test('Success state resolves correctly and supports pattern matching', () {
      const result = Result.success('test_payload');

      expect(result, isA<Success<String>>());
      final Success<String> success = result as Success<String>;
      expect(success.data, equals('test_payload'));

      final patternMatched = result.when(
        success: (data) => data,
        failure: (f) => 'failure',
        loading: (p) => 'loading',
        empty: () => 'empty',
      );
      expect(patternMatched, equals('test_payload'));
    });

    test('FailureResult state resolves and returns Failure properties', () {
      const failure = ValidationFailure(
        code: 'BY_VAL_FAIL',
        message: 'Invalid input',
      );
      const result = Result<String>.failure(failure);

      expect(result, isA<FailureResult<String>>());
      final FailureResult<String> failResult = result as FailureResult<String>;
      expect(failResult.failure.code, equals('BY_VAL_FAIL'));

      final patternMatched = result.when(
        success: (data) => 'success',
        failure: (f) => f.code,
        loading: (p) => 'loading',
        empty: () => 'empty',
      );
      expect(patternMatched, equals('BY_VAL_FAIL'));
    });

    test('Loading state preserves progress metadata', () {
      const result = Result<String>.loading(progress: 0.75);

      expect(result, isA<Loading<String>>());
      final Loading<String> loading = result as Loading<String>;
      expect(loading.progress, equals(0.75));
    });

    test('Empty state matches correctly', () {
      const result = Result<String>.empty();

      expect(result, isA<Empty<String>>());
    });

    test('PartialSuccess preserves batch status metrics', () {
      const successItem = 'parsed_ok';
      const failure = ValidationFailure(code: 'err', message: 'fail');
      final result = PartialSuccess<String>(
        successfulRecords: [successItem],
        failedRecords: [MapEntry('bad_payload', failure)],
      );

      expect(result.successfulRecords, contains(successItem));
      expect(result.failedRecords.first.value.code, equals('err'));
    });

    test(
      'Guard wrapper catches generic exceptions and encapsulates cleanly',
      () async {
        final result = await Result.guard<String>(() async {
          throw Exception('File system lock failure');
        });

        expect(result, isA<FailureResult<String>>());
        final FailureResult<String> failResult =
            result as FailureResult<String>;
        expect(failResult.failure, isA<UnknownFailure>());
        expect(failResult.failure.code, equals('BY_DOM_UNKNOWN_EXCEPTION'));
        expect(failResult.failure.message, contains('File system lock'));
      },
    );
  });
}
