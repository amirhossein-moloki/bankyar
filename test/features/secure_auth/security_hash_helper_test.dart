import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/features/secure_auth/data/models/security_hash_helper.dart';

void main() {
  group('SecurityHashHelper Tests', () {
    test('generateSalt returns valid non-empty base64url string', () {
      final salt1 = SecurityHashHelper.generateSalt();
      final salt2 = SecurityHashHelper.generateSalt();

      expect(salt1, isNotEmpty);
      expect(salt2, isNotEmpty);
      expect(salt1, isNot(equals(salt2))); // verify uniqueness
    });

    test(
      'hashPin returns deterministic sha256 hex string of correct length',
      () {
        const pin = '1234';
        final salt = SecurityHashHelper.generateSalt();

        final hash1 = SecurityHashHelper.hashPin(pin, salt);
        final hash2 = SecurityHashHelper.hashPin(pin, salt);

        expect(hash1, isNotEmpty);
        expect(hash1.length, equals(64)); // 32 bytes hex = 64 chars
        expect(hash1, equals(hash2)); // deterministic matching
      },
    );

    test(
      'hashPin returns different values for different PINs with same salt',
      () {
        const pin1 = '1234';
        const pin2 = '5678';
        final salt = SecurityHashHelper.generateSalt();

        final hash1 = SecurityHashHelper.hashPin(pin1, salt);
        final hash2 = SecurityHashHelper.hashPin(pin2, salt);

        expect(hash1, isNot(equals(hash2)));
      },
    );
  });
}
