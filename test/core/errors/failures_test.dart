import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/errors/failures.dart';

void main() {
  group('Failure Hierarchy Tests', () {
    test('InfrastructureFailure preserves code, messages, and defaults', () {
      const failure = InfrastructureFailure(
        code: 'BY_INF_DB_CORRUPTED',
        message: 'The SQLCipher database file failed page integrity checks.',
      );

      expect(failure.code, equals('BY_INF_DB_CORRUPTED'));
      expect(failure.message, contains('failed page integrity'));
      expect(failure.isUserAlertRequired, isTrue);
    });

    test('SecurityFailure preserves properties', () {
      const failure = SecurityFailure(
        code: 'BY_SEC_PIN_LOCKOUT',
        message: 'PIN attempts exceeded standard lockout margins.',
      );

      expect(failure.code, equals('BY_SEC_PIN_LOCKOUT'));
      expect(failure.message, contains('attempts exceeded'));
      expect(failure.isUserAlertRequired, isTrue);
    });

    test('ValidationFailure overrides user alert default to false', () {
      const failure = ValidationFailure(
        code: 'BY_VAL_AMOUNT_INVALID',
        message: 'Monetary figure must resolve to a positive decimal.',
      );

      expect(failure.code, equals('BY_VAL_AMOUNT_INVALID'));
      expect(failure.isUserAlertRequired, isFalse);
    });

    test('ParserFailure preserves properties', () {
      const failure = ParserFailure(
        code: 'BY_PAR_RE_BACKTRACKING',
        message: 'Regex compiled successfully but backtracking was detected.',
      );

      expect(failure.code, equals('BY_PAR_RE_BACKTRACKING'));
      expect(failure.isUserAlertRequired, isTrue);
    });
  });
}
