import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/environment/environment.dart';

void main() {
  group('AppEnvironment Configuration Tests', () {
    test('Environment constructs successfully with expected variables', () {
      const env = AppEnvironment(
        flavor: AppFlavor.dev,
        buildId: 'test_build_123',
        isDiagnosticsEnabled: true,
        isScreenshotProtectionEnabled: false,
        maxLogSizeMb: 5,
        regexTimeoutMs: 200,
        isBiometricLockEnabled: false,
        isExperimentalFeatureActive: true,
      );

      expect(env.flavor, equals(AppFlavor.dev));
      expect(env.buildId, equals('test_build_123'));
      expect(env.isDiagnosticsEnabled, isTrue);
      expect(env.isScreenshotProtectionEnabled, isFalse);
      expect(env.maxLogSizeMb, equals(5));
      expect(env.regexTimeoutMs, equals(200));
      expect(env.isBiometricLockEnabled, isFalse);
      expect(env.isExperimentalFeatureActive, isTrue);
    });

    test('Environment supports equality checks and hashCode comparisons', () {
      const env1 = AppEnvironment(
        flavor: AppFlavor.qa,
        buildId: 'same_build',
        isDiagnosticsEnabled: true,
        isScreenshotProtectionEnabled: true,
        maxLogSizeMb: 2,
        regexTimeoutMs: 100,
        isBiometricLockEnabled: true,
        isExperimentalFeatureActive: false,
      );

      const env2 = AppEnvironment(
        flavor: AppFlavor.qa,
        buildId: 'same_build',
        isDiagnosticsEnabled: true,
        isScreenshotProtectionEnabled: true,
        maxLogSizeMb: 2,
        regexTimeoutMs: 100,
        isBiometricLockEnabled: true,
        isExperimentalFeatureActive: false,
      );

      expect(env1, equals(env2));
      expect(env1.hashCode, equals(env2.hashCode));
    });

    test(
      'fromDefines generates deterministic default fallback environments',
      () {
        final env = AppEnvironment.fromDefines();

        // In testing contexts, standard fallbacks must resolve to dev
        expect(env.flavor, equals(AppFlavor.dev));
        expect(env.buildId, equals('local_debug'));
        expect(env.isDiagnosticsEnabled, isTrue);
        expect(env.isScreenshotProtectionEnabled, isTrue);
        expect(env.maxLogSizeMb, equals(2));
        expect(env.regexTimeoutMs, equals(100));
      },
    );
  });
}
