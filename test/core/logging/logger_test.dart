import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/logging/logger.dart';

void main() {
  group('AppLogger Engine & PII Scrubbing Tests', () {
    late AppLoggerImpl logger;

    setUp(() {
      logger = AppLoggerImpl(
        isDiagnosticsEnabled: true,
        consoleOutput: false, // Prevents polluting actual test runners
      );
    });

    test('sanitize redacts general monetary amounts from text inputs', () {
      final input = 'Card debited with USD 150000.50 on 2023-10-15';
      final output = logger.sanitize(input);

      expect(output, isNot(contains('150000.50')));
      expect(output, contains('[REDACTED_AMOUNT]'));
    });

    test(
      'sanitize redacts card/account digits but preserves last 4 indices',
      () {
        final input = 'Transaction completed using card 4111222233334444';
        final output = logger.sanitize(input);

        // Card must be masked
        expect(output, isNot(contains('4111222233334444')));
        expect(output, contains('************4444'));
      },
    );

    test('sanitize handles empty inputs safely', () {
      expect(logger.sanitize(''), isEmpty);
    });

    test('log respects diagnostics active switch configurations', () {
      final inactiveLogger = AppLoggerImpl(
        isDiagnosticsEnabled: false,
        consoleOutput: false,
      );

      // Should not throw or run formatting allocations when logging
      inactiveLogger.log(
        LogLevel.info,
        'DATABASE',
        'BY_INF_DB_OK',
        'Should bypass and complete silently',
      );
    });
  });
}
