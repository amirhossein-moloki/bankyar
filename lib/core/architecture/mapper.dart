/// Interface for mapping representations across architecture boundaries.
/// Typically maps between database models (DTOs) and domain Entities.
abstract class Mapper<I, O> {
  /// Maps an input object of type [I] to an output object of type [O].
  O map(I input);
}

/// Interface for mapping representations bidirectional across boundaries.
abstract class BidirectionalMapper<I, O> implements Mapper<I, O> {
  /// Maps an output object back to its input representation.
  I mapBack(O output);
}
