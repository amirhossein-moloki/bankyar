import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/utils/either.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Either Monad Tests', () {
    test('Left constructs and resolves correctly', () {
      const Either<String, int> either = Left('error message');
      expect(either.isLeft, isTrue);
      expect(either.isRight, isFalse);
      expect(either.left, equals('error message'));
      expect(() => either.right, throwsStateError);

      final folded = either.fold(
        (l) => 'Fold Left: $l',
        (r) => 'Fold Right: $r',
      );
      expect(folded, equals('Fold Left: error message'));

      final mapped = either.map((r) => r * 2);
      expect(mapped, isA<Left<String, int>>());
      expect(mapped.left, equals('error message'));
    });

    test('Right constructs and resolves correctly', () {
      const Either<String, int> either = Right(42);
      expect(either.isLeft, isFalse);
      expect(either.isRight, isTrue);
      expect(either.right, equals(42));
      expect(() => either.left, throwsStateError);

      final folded = either.fold(
        (l) => 'Fold Left: $l',
        (r) => 'Fold Right: $r',
      );
      expect(folded, equals('Fold Right: 42'));

      final mapped = either.map((r) => r * 2);
      expect(mapped, isA<Right<String, int>>());
      expect(mapped.right, equals(84));

      final flatMapped = either.flatMap(
        (r) => Right<String, String>('Value: $r'),
      );
      expect(flatMapped, isA<Right<String, String>>());
      expect(flatMapped.right, equals('Value: 42'));
    });

    test('Equality and toString comparisons work', () {
      const Left<String, int> left1 = Left('error');
      const Left<String, int> left2 = Left('error');
      const Left<String, int> left3 = Left('different');
      expect(left1, equals(left2));
      expect(left1, isNot(equals(left3)));
      expect(left1.hashCode, equals(left2.hashCode));
      expect(left1.toString(), contains('Left(error)'));

      const Right<String, int> right1 = Right(10);
      const Right<String, int> right2 = Right(10);
      const Right<String, int> right3 = Right(20);
      expect(right1, equals(right2));
      expect(right1, isNot(equals(right3)));
      expect(right1.hashCode, equals(right2.hashCode));
      expect(right1.toString(), contains('Right(10)'));
    });
  });

  group('Result Extensions Tests', () {
    test('State inspection getters work correctly', () {
      const Result<int> success = Success(100);
      expect(success.isSuccess, isTrue);
      expect(success.isFailure, isFalse);
      expect(success.isLoading, isFalse);
      expect(success.isEmpty, isFalse);
      expect(success.dataOrNull, equals(100));
      expect(success.failureOrNull, isNull);

      const Result<int> failure = FailureResult(
        UnknownFailure(code: 'BY_ERR', message: 'Err'),
      );
      expect(failure.isSuccess, isFalse);
      expect(failure.isFailure, isTrue);
      expect(failure.isLoading, isFalse);
      expect(failure.isEmpty, isFalse);
      expect(failure.dataOrNull, isNull);
      expect(failure.failureOrNull, isNotNull);

      const Result<int> loading = Loading(progress: 0.5);
      expect(loading.isSuccess, isFalse);
      expect(loading.isFailure, isFalse);
      expect(loading.isLoading, isTrue);
      expect(loading.isEmpty, isFalse);

      const Result<int> empty = Empty();
      expect(empty.isSuccess, isFalse);
      expect(empty.isFailure, isFalse);
      expect(empty.isLoading, isFalse);
      expect(empty.isEmpty, isTrue);
    });

    test('Result map and flatMap work correctly', () {
      const Result<int> success = Success(5);
      final mapped = success.map((data) => 'Value: $data');
      expect(mapped, isA<Success<String>>());
      expect(mapped.dataOrNull, equals('Value: 5'));

      final flatMapped = success.flatMap((data) => Success('FlatValue: $data'));
      expect(flatMapped, isA<Success<String>>());
      expect(flatMapped.dataOrNull, equals('FlatValue: 5'));

      const Result<int> failure = FailureResult(
        UnknownFailure(code: 'BY_ERR', message: 'Err'),
      );
      final mappedFailure = failure.map((data) => 'Value: $data');
      expect(mappedFailure, isA<FailureResult<String>>());
      expect(mappedFailure.failureOrNull!.code, equals('BY_ERR'));
    });

    test('AsyncResultExtensions map and flatMap work asynchronously', () async {
      final Future<Result<int>> asyncSuccess = Future.value(const Success(10));

      final mapped = await asyncSuccess.mapAsync((data) => data * 3);
      expect(mapped, isA<Success<int>>());
      expect(mapped.dataOrNull, equals(30));

      final flatMapped = await asyncSuccess.flatMapAsync(
        (data) => Future.value(Success('Val: $data')),
      );
      expect(flatMapped, isA<Success<String>>());
      expect(flatMapped.dataOrNull, equals('Val: 10'));

      final Future<Result<int>> asyncFailure = Future.value(
        const FailureResult(UnknownFailure(code: 'BY_ERR', message: 'Err')),
      );
      final mappedFailure = await asyncFailure.mapAsync((data) => data * 3);
      expect(mappedFailure, isA<FailureResult<int>>());
    });

    test('fold and foldAsync resolve correctly', () async {
      const Result<int> success = Success(10);
      final val = success.fold(
        success: (data) => 'Success: $data',
        failure: (fail) => 'Fail: ${fail.code}',
        loading: (prog) => 'Loading: $prog',
        empty: () => 'Empty',
      );
      expect(val, equals('Success: 10'));

      final Future<Result<int>> asyncSuccess = Future.value(const Success(20));
      final valAsync = await asyncSuccess.foldAsync(
        success: (data) => 'Success: $data',
        failure: (fail) => 'Fail: ${fail.code}',
        loading: (prog) => 'Loading: $prog',
        empty: () => 'Empty',
      );
      expect(valAsync, equals('Success: 20'));
    });
  });
}
