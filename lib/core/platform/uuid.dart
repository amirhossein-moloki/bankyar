import 'dart:math';

/// Abstraction representing a unique identifier generator.
/// Guarantees compile-time safety and offline v4 generation.
abstract class UuidGenerator {
  /// Generates a standard RFC 4122 compliant UUID v4 string.
  String generateV4();
}

/// Pure Dart implementation of UUID v4 generation using [Random.secure] for high entropy.
class SystemUuidGenerator implements UuidGenerator {
  /// Constructor constructing generator.
  const SystemUuidGenerator();

  @override
  String generateV4() {
    final random = Random.secure();

    String generateHex(int length) {
      final buffer = StringBuffer();
      for (var i = 0; i < length; i++) {
        buffer.write(random.nextInt(16).toRadixString(16));
      }
      return buffer.toString();
    }

    final hex8 = generateHex(8);
    final hex4_1 = generateHex(4);
    // UUID v4 format requires starting with '4' for the third block
    final hex4_2 = '4${generateHex(3)}';
    // UUID v4 format requires starting with 8, 9, a, or b for the fourth block
    final y = ['8', '9', 'a', 'b'][random.nextInt(4)];
    final hex4_3 = '$y${generateHex(3)}';
    final hex12 = generateHex(12);

    return '$hex8-$hex4_1-$hex4_2-$hex4_3-$hex12';
  }
}
