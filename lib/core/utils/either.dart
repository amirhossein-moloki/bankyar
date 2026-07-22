import 'package:meta/meta.dart';

/// A standard, generic representation of a value of one of two possible types.
/// By convention, [Left] represents a failure or error value, and [Right] represents a success value.
@immutable
abstract class Either<L, R> {
  const Either();

  /// Returns true if this is an instance of [Left].
  bool get isLeft;

  /// Returns true if this is an instance of [Right].
  bool get isRight;

  /// Returns the Left value, or throws if this is a Right.
  L get left => when(
    onLeft: (l) => l,
    onRight: (_) => throw StateError('Called left on a Right Either'),
  );

  /// Returns the Right value, or throws if this is a Left.
  R get right => when(
    onLeft: (_) => throw StateError('Called right on a Left Either'),
    onRight: (r) => r,
  );

  /// Pattern matching on [Either].
  T when<T>({
    required T Function(L left) onLeft,
    required T Function(R right) onRight,
  });

  /// Applies [fnL] if this is a [Left], or [fnR] if this is a [Right].
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return when(onLeft: fnL, onRight: fnR);
  }

  /// Maps the right value of this [Either] to a new type.
  Either<L, R2> map<R2>(R2 Function(R right) fn) {
    return fold((l) => Left<L, R2>(l), (r) => Right<L, R2>(fn(r)));
  }

  /// Chains another [Either] operation.
  Either<L, R2> flatMap<R2>(Either<L, R2> Function(R right) fn) {
    return fold((l) => Left<L, R2>(l), (r) => fn(r));
  }
}

/// Represents the Left (conventionally Failure) side of an [Either].
class Left<L, R> extends Either<L, R> {
  const Left(this.value);

  final L value;

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  T when<T>({
    required T Function(L left) onLeft,
    required T Function(R right) onRight,
  }) {
    return onLeft(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Left<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// Represents the Right (conventionally Success) side of an [Either].
class Right<L, R> extends Either<L, R> {
  const Right(this.value);

  final R value;

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  T when<T>({
    required T Function(L left) onLeft,
    required T Function(R right) onRight,
  }) {
    return onRight(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Right<L, R> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
