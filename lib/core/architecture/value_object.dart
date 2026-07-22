import 'package:meta/meta.dart';

/// Base class for all business Domain Value Objects.
/// Value Objects are defined by their attributes rather than a persistent identity.
/// Conforms to DOMAIN_MODEL.md specifications.
@immutable
abstract class ValueObject<T> {
  /// Constructor enforcing immutability.
  const ValueObject(this.value);

  /// The wrapped underlying raw value.
  final T value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$runtimeType($value)';
}
