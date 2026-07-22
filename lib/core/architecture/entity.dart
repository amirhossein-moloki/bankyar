/// Base class for all Domain Entities.
/// Entities have a thread-safe identity ([id]) that persists across structural updates.
/// Conforms to DOMAIN_MODEL.md specifications.
abstract class Entity<Id> {
  /// Constructor defining the entity's sovereign identity.
  const Entity(this.id);

  /// The unique, persistent identifier of this entity.
  final Id id;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Entity<Id> && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$runtimeType(id: $id)';
}
