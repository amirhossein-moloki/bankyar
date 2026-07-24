import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/secure_auth/domain/entities/session_model.dart';
import 'package:bankyar/features/secure_auth/domain/entities/session_status.dart';
import 'package:bankyar/features/secure_auth/domain/entities/security_settings.dart';
import 'package:bankyar/features/secure_auth/domain/entities/biometric_capabilities.dart';
import 'package:bankyar/features/secure_auth/domain/usecases/verify_biometrics_use_case.dart';
import 'package:bankyar/features/secure_auth/domain/usecases/verify_pin_use_case.dart';
import 'package:bankyar/features/secure_auth/data/repositories/security_repository_provider.dart';
import 'package:bankyar/features/secure_auth/data/repositories/local_security_repository.dart';
import 'package:bankyar/features/secure_auth/presentation/state/app_lock_coordinator.dart';

class MockVerifyPinUseCase extends Mock implements VerifyPinUseCase {}
class MockVerifyBiometricsUseCase extends Mock implements VerifyBiometricsUseCase {}
class MockLocalSecurityRepository extends Mock implements LocalSecurityRepository {}
class MockClock extends Mock implements Clock {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockVerifyPinUseCase verifyPinUseCase;
  late MockVerifyBiometricsUseCase verifyBiometricsUseCase;
  late MockLocalSecurityRepository securityRepository;
  late MockClock mockClock;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(AppLifecycleState.resumed);
    registerFallbackValue(const SessionModel(isAuthenticated: false, failedAttempts: 0));
    registerFallbackValue(SecuritySettings.initial());
    registerFallbackValue(const NoParams());
  });

  setUp(() async {
    verifyPinUseCase = MockVerifyPinUseCase();
    verifyBiometricsUseCase = MockVerifyBiometricsUseCase();
    securityRepository = MockLocalSecurityRepository();
    mockClock = MockClock();

    final nowTime = DateTime(2023, 10, 1, 12, 0, 0);
    when(() => mockClock.now()).thenReturn(nowTime);

    when(() => securityRepository.getSession()).thenAnswer((_) async => const Result.success(SessionModel(
          isAuthenticated: false,
          failedAttempts: 0,
          lockoutUntil: null,
        )));
    when(() => securityRepository.getSettings()).thenAnswer((_) async => const Result.success(SecuritySettings(
          isPinEnabled: true,
          isBiometricsEnabled: true,
          autoLockTimeout: Duration(seconds: 30),
          isPrivacyModeEnabled: false,
        )));
    when(() => securityRepository.getBiometricCapabilities()).thenAnswer((_) async => const Result.success(
          BiometricCapabilities(isHardwareAvailable: true, isEnrolled: true, isEnabled: true),
        ));
    when(() => securityRepository.saveSession(any())).thenAnswer((_) async => const Result.success(null));

    container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(mockClock),
        securityRepositoryProvider.overrideWithValue(securityRepository),
        verifyPinUseCaseProvider.overrideWithValue(verifyPinUseCase),
        verifyBiometricsUseCaseProvider.overrideWithValue(verifyBiometricsUseCase),
      ],
    );

    // Eagerly read provider to instantiate AppLockCoordinator and boot _initSession()
    container.read(appLockCoordinatorProvider);

    // Yield control to let async _initSession() complete before each test starts
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });

  tearDown(() {
    container.dispose();
  });

  group('AppLockCoordinator Tests', () {
    test('Initializes correctly with closed/unlocked status depending on PIN preference', () async {
      final state = container.read(appLockCoordinatorProvider);

      expect(state.isAppUnlocked, isFalse);
      expect(state.sessionStatus, equals(SessionStatus.SessionLocked));
    });

    test('appendDigit appends digits up to 4 and auto-verifies', () async {
      when(() => verifyPinUseCase(any())).thenAnswer((_) async => const Result.success(true));

      final coordinator = container.read(appLockCoordinatorProvider.notifier);

      await coordinator.appendDigit('1');
      expect(container.read(appLockCoordinatorProvider).currentInputPin, equals('1'));

      await coordinator.appendDigit('2');
      await coordinator.appendDigit('3');
      await coordinator.appendDigit('4');

      // Yield control to let verifyInputPin future settle
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(appLockCoordinatorProvider);
      expect(state.currentInputPin, isEmpty); // cleared on verification trigger
      expect(state.isAppUnlocked, isTrue);
      expect(state.sessionStatus, equals(SessionStatus.SessionUnlocked));
    });

    test('backspace deletes last digit cleanly', () async {
      final coordinator = container.read(appLockCoordinatorProvider.notifier);

      await coordinator.appendDigit('5');
      await coordinator.appendDigit('6');
      expect(container.read(appLockCoordinatorProvider).currentInputPin, equals('56'));

      coordinator.backspace();
      expect(container.read(appLockCoordinatorProvider).currentInputPin, equals('5'));
    });

    test('clearInput empties current PIN buffer', () async {
      final coordinator = container.read(appLockCoordinatorProvider.notifier);

      await coordinator.appendDigit('7');
      await coordinator.appendDigit('8');
      coordinator.clearInput();

      expect(container.read(appLockCoordinatorProvider).currentInputPin, isEmpty);
    });

    test('Increments fail attempts and triggers 60s doubling lockout cooldown on wrong PIN >= 3', () async {
      when(() => verifyPinUseCase(any())).thenAnswer((_) async => const Result.success(false));

      final coordinator = container.read(appLockCoordinatorProvider.notifier);

      // Attempt 1
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.read(appLockCoordinatorProvider).session.failedAttempts, equals(1));
      expect(container.read(appLockCoordinatorProvider).session.isLockedOut, isFalse);

      // Attempt 2
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.read(appLockCoordinatorProvider).session.failedAttempts, equals(2));
      expect(container.read(appLockCoordinatorProvider).session.isLockedOut, isFalse);

      // Attempt 3 -> triggers 1st block: 60s lockout
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('1');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(appLockCoordinatorProvider);
      expect(state.session.failedAttempts, equals(3));
      expect(state.session.lockoutUntil, isNotNull);
      // lockoutUntil should be 12:01:00 (now + 60s)
      expect(state.session.lockoutUntil, equals(DateTime(2023, 10, 1, 12, 1, 0)));
    });

    test('Permanent lockout is triggered after 15 failed attempts', () async {
      when(() => verifyPinUseCase(any())).thenAnswer((_) async => const Result.success(false));

      // Mock session directly with 14 attempts
      when(() => securityRepository.getSession()).thenAnswer((_) async => const Result.success(SessionModel(
            isAuthenticated: false,
            failedAttempts: 14,
            lockoutUntil: null,
          )));

      // Re-create container to reload session mock
      final customContainer = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(mockClock),
          securityRepositoryProvider.overrideWithValue(securityRepository),
          verifyPinUseCaseProvider.overrideWithValue(verifyPinUseCase),
          verifyBiometricsUseCaseProvider.overrideWithValue(verifyBiometricsUseCase),
        ],
      );

      // Yield control for initialization
      customContainer.read(appLockCoordinatorProvider);
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final coordinator = customContainer.read(appLockCoordinatorProvider.notifier);

      // 15th attempt
      await coordinator.appendDigit('9');
      await coordinator.appendDigit('9');
      await coordinator.appendDigit('9');
      await coordinator.appendDigit('9');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = customContainer.read(appLockCoordinatorProvider);
      expect(state.isPermanentLockout, isTrue);
      expect(state.errorMessage, contains('دسترسی مسدود شد'));

      customContainer.dispose();
    });

    test('authenticateBiometrics unlocks app on scan success', () async {
      when(() => verifyBiometricsUseCase(any())).thenAnswer((_) async => const Result.success(true));

      final coordinator = container.read(appLockCoordinatorProvider.notifier);
      final success = await coordinator.authenticateBiometrics();

      expect(success, isTrue);
      final state = container.read(appLockCoordinatorProvider);
      expect(state.isAppUnlocked, isTrue);
      expect(state.sessionStatus, equals(SessionStatus.SessionUnlocked));
    });

    test('12-Word seed recovery resets PIN protection and unlocks session', () async {
      final coordinator = container.read(appLockCoordinatorProvider.notifier);
      when(() => securityRepository.updateSettings(any())).thenAnswer((_) async => const Result.success(null));

      final words = List.generate(12, (index) => 'word$index');
      final success = await coordinator.recoverWithSeedWords(words);

      expect(success, isTrue);
      final state = container.read(appLockCoordinatorProvider);
      expect(state.isAppUnlocked, isTrue);
      expect(state.sessionStatus, equals(SessionStatus.SessionUnlocked));
      expect(state.session.failedAttempts, equals(0));
    });

    test('Auto Lock Timeout triggers locking when background elapsed duration exceeds settings', () async {
      final coordinator = container.read(appLockCoordinatorProvider.notifier);

      // 1. Mock app starting as unlocked
      when(() => verifyPinUseCase(any())).thenAnswer((_) async => const Result.success(true));
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('2');
      await coordinator.appendDigit('3');
      await coordinator.appendDigit('4');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.read(appLockCoordinatorProvider).isAppUnlocked, isTrue);

      // 2. Suspend app to background (paused)
      // Timestamp: 12:00:00
      await coordinator.handleLifecycleTransition(AppLifecycleState.paused);

      // 3. Move time forward by 45 seconds (exceeding the 30s autoLockTimeout)
      final futureTime = DateTime(2023, 10, 1, 12, 0, 45);
      when(() => mockClock.now()).thenReturn(futureTime);

      // Mock session storage return on resume
      when(() => securityRepository.getSession()).thenAnswer((_) async => Result.success(SessionModel(
            isAuthenticated: true,
            failedAttempts: 0,
            lockoutUntil: null,
            lastActivity: DateTime(2023, 10, 1, 12, 0, 0),
          )));

      // 4. Resume app to foreground (resumed)
      await coordinator.handleLifecycleTransition(AppLifecycleState.resumed);

      final state = container.read(appLockCoordinatorProvider);
      expect(state.isAppUnlocked, isFalse);
      expect(state.sessionStatus, equals(SessionStatus.SessionExpired));
    });

    test('Auto Lock Timeout does NOT trigger lock when elapsed background duration is within timeout', () async {
      final coordinator = container.read(appLockCoordinatorProvider.notifier);

      // 1. Unlock app
      when(() => verifyPinUseCase(any())).thenAnswer((_) async => const Result.success(true));
      await coordinator.appendDigit('1');
      await coordinator.appendDigit('2');
      await coordinator.appendDigit('3');
      await coordinator.appendDigit('4');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(container.read(appLockCoordinatorProvider).isAppUnlocked, isTrue);

      // 2. Suspend app (paused)
      await coordinator.handleLifecycleTransition(AppLifecycleState.paused);

      // 3. Move time forward by 15 seconds (within the 30s autoLockTimeout)
      final futureTime = DateTime(2023, 10, 1, 12, 0, 15);
      when(() => mockClock.now()).thenReturn(futureTime);

      when(() => securityRepository.getSession()).thenAnswer((_) async => Result.success(SessionModel(
            isAuthenticated: true,
            failedAttempts: 0,
            lockoutUntil: null,
            lastActivity: DateTime(2023, 10, 1, 12, 0, 0),
          )));

      // 4. Resume app (resumed)
      await coordinator.handleLifecycleTransition(AppLifecycleState.resumed);

      final state = container.read(appLockCoordinatorProvider);
      expect(state.isAppUnlocked, isTrue);
    });
  });
}
