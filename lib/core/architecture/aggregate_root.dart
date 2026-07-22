import 'entity.dart';

/// Base class for all Aggregate Roots.
/// An Aggregate Root is the primary entry point to a cluster of associated entities and value objects.
/// Conforms to DOMAIN_MODEL.md specifications.
abstract class AggregateRoot<Id> extends Entity<Id> {
  /// Constructor defining the Aggregate Root's unique identifier.
  const AggregateRoot(super.id);

  // Note: Since BankYar encourages immutability, state transitions are handled
  // by copyWith patterns. This base class is ready to support domain events tracking
  // if future synchronization features require transactional event logging.
}
