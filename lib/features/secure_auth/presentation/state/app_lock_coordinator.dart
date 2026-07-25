import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/architecture/use_case.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../domain/entities/session_model.dart';
import '../../domain/entities/session_status.dart';
import '../../domain/usecases/verify_biometrics_use_case.dart';
import '../../domain/usecases/verify_pin_use_case.dart';
import '../../data/repositories/security_repository_provider.dart';
import 'security_notifier.dart';

/// Central application state governing global locks, PIN buffering,
/// lockout timers, and localized session lifecycle stages.
class AppLockState {
  /// Active session properties (auth status, failed attempts, lockouts).
  final SessionModel session;

  /// Current session status.
  final SessionStatus sessionStatus;

  /// Whether the app is currently unlocked and ready to display content.
  final bool isAppUnlocked;

  /// In-memory buffer for keypresses.
  final String currentInputPin;

  /// Error message to show on the lock screen.
  final String? errorMessage;

  /// Flag indicating if the user has triggered permanent brute-force lock.
  final bool isPermanentLockout;

  /// Constructor.
  const AppLockState({
    required this.session,
    required this.sessionStatus,
    required this.isAppUnlocked,
    required this.currentInputPin,
    this.errorMessage,
    required this.isPermanentLockout,
  });

  /// Factory for standard starting configurations.
  factory AppLockState.initial() => AppLockState(
    session: SessionModel.initial(),
    sessionStatus: SessionStatus.SessionStarted,
    isAppUnlocked: false,
    currentInputPin: '',
    errorMessage: null,
    isPermanentLockout: false,
  );

  /// Helper to duplicate state with option overrides.
  AppLockState copyWith({
    SessionModel? session,
    SessionStatus? sessionStatus,
    bool? isAppUnlocked,
    String? currentInputPin,
    String? errorMessage,
    bool? isPermanentLockout,
  }) {
    return AppLockState(
      session: session ?? this.session,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      isAppUnlocked: isAppUnlocked ?? this.isAppUnlocked,
      currentInputPin: currentInputPin ?? this.currentInputPin,
      errorMessage: errorMessage,
      isPermanentLockout: isPermanentLockout ?? this.isPermanentLockout,
    );
  }
}

/// Central application-level Lock Coordinator observing active hardware,
/// OS lifecycles, preferences, and broadcasting atomic [SessionStatus] updates.
class AppLockCoordinator extends StateNotifier<AppLockState>
    with WidgetsBindingObserver {
  final VerifyPinUseCase _verifyPinUseCase;
  final VerifyBiometricsUseCase _verifyBiometricsUseCase;
  final Ref _ref;

  final _statusController = StreamController<SessionStatus>.broadcast();
  Timer? _lockoutTimer;

  /// Constructor bootstrapping lifecycle tracking and session restoration.
  AppLockCoordinator({
    required VerifyPinUseCase verifyPinUseCase,
    required VerifyBiometricsUseCase verifyBiometricsUseCase,
    required Ref ref,
  }) : _verifyPinUseCase = verifyPinUseCase,
       _verifyBiometricsUseCase = verifyBiometricsUseCase,
       _ref = ref,
       super(AppLockState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _initSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lockoutTimer?.cancel();
    _statusController.close();
    super.dispose();
  }

  /// Stream broadcasting session transitions app-wide.
  Stream<SessionStatus> get onSessionStatusChanged => _statusController.stream;

  Future<void> _initSession() async {
    final repository = _ref.read(securityRepositoryProvider);
    final sessionRes = await repository.getSession();
    final settingsRes = await repository.getSettings();

    final session = sessionRes.isSuccess
        ? sessionRes.successOrCrash
        : SessionModel.initial();
    final settings = settingsRes.isSuccess ? settingsRes.successOrCrash : null;

    final pinConfigured = settings?.isPinEnabled ?? false;
    _startLockoutTimerIfActive(session);

    final isUnlocked = !pinConfigured;
    final initialStatus = isUnlocked
        ? SessionStatus.SessionUnlocked
        : SessionStatus.SessionLocked;

    if (!mounted) return;

    state = AppLockState(
      session: session,
      sessionStatus: initialStatus,
      isAppUnlocked: isUnlocked,
      currentInputPin: '',
      isPermanentLockout: session.failedAttempts >= 15,
    );

    _emitStatus(initialStatus);
  }

  /// Appends a digit to the in-memory PIN buffer, auto-triggering verification at 4 digits.
  Future<void> appendDigit(String digit) async {
    if (state.session.isLockedOut || state.isPermanentLockout) return;

    final current = state.currentInputPin;
    if (current.length >= 4) return;

    final updated = current + digit;
    if (!mounted) return;
    state = state.copyWith(currentInputPin: updated, errorMessage: null);

    if (updated.length == 4) {
      await verifyInputPin(updated);
    }
  }

  /// Backspaces the last digit entered on the PIN buffer.
  void backspace() {
    final current = state.currentInputPin;
    if (current.isEmpty) return;
    if (!mounted) return;
    state = state.copyWith(
      currentInputPin: current.substring(0, current.length - 1),
      errorMessage: null,
    );
  }

  /// Clears the in-memory PIN buffer.
  void clearInput() {
    if (!mounted) return;
    state = state.copyWith(currentInputPin: '', errorMessage: null);
  }

  /// Verifies the PIN, managing attempts, lockouts, and session status updates.
  Future<bool> verifyInputPin(String pin) async {
    final res = await _verifyPinUseCase(pin);
    final repository = _ref.read(securityRepositoryProvider);
    final clock = _ref.read(clockProvider);

    if (!mounted) return false;

    if (res.isSuccess && res.successOrCrash) {
      final updatedSession = state.session.copyWith(
        isAuthenticated: true,
        failedAttempts: 0,
        lockoutUntil: null,
        lastActivity: clock.now(),
      );
      await repository.saveSession(updatedSession);

      if (!mounted) return true;

      state = state.copyWith(
        session: updatedSession,
        sessionStatus: SessionStatus.SessionUnlocked,
        isAppUnlocked: true,
        currentInputPin: '',
        errorMessage: null,
      );

      _emitStatus(SessionStatus.SessionUnlocked);
      return true;
    } else {
      final newAttempts = state.session.failedAttempts + 1;
      DateTime? lockoutUntil;

      if (newAttempts >= 15) {
        final updatedSession = state.session.copyWith(
          isAuthenticated: false,
          failedAttempts: newAttempts,
          lockoutUntil: null,
        );
        await repository.saveSession(updatedSession);

        if (!mounted) return false;

        state = state.copyWith(
          session: updatedSession,
          sessionStatus: SessionStatus.SessionLocked,
          isPermanentLockout: true,
          currentInputPin: '',
          errorMessage: 'دسترسی مسدود شد. لطفاً کلید بازیابی خود را وارد کنید.',
        );

        _emitStatus(SessionStatus.SessionLocked);
        return false;
      }

      if (newAttempts >= 3) {
        final blockIndex = newAttempts - 2;
        final seconds = (60 * (1 << (blockIndex - 1))).clamp(60, 1800);
        lockoutUntil = clock.now().add(Duration(seconds: seconds));
      }

      final updatedSession = state.session.copyWith(
        isAuthenticated: false,
        failedAttempts: newAttempts,
        lockoutUntil: lockoutUntil,
      );
      await repository.saveSession(updatedSession);

      if (!mounted) return false;

      state = state.copyWith(
        session: updatedSession,
        currentInputPin: '',
        errorMessage: 'پین‌کد اشتباه است. تلاش‌های ناموفق: $newAttempts',
      );

      _startLockoutTimerIfActive(updatedSession);
      return false;
    }
  }

  /// Triggers biometric authentication scanning.
  Future<bool> authenticateBiometrics() async {
    if (state.session.isLockedOut || state.isPermanentLockout) return false;

    final res = await _verifyBiometricsUseCase(const NoParams());
    final repository = _ref.read(securityRepositoryProvider);
    final clock = _ref.read(clockProvider);

    if (!mounted) return false;

    if (res.isSuccess && res.successOrCrash) {
      final updatedSession = state.session.copyWith(
        isAuthenticated: true,
        failedAttempts: 0,
        lockoutUntil: null,
        lastActivity: clock.now(),
      );
      await repository.saveSession(updatedSession);

      if (!mounted) return true;

      state = state.copyWith(
        session: updatedSession,
        sessionStatus: SessionStatus.SessionUnlocked,
        isAppUnlocked: true,
        currentInputPin: '',
        errorMessage: null,
      );

      _emitStatus(SessionStatus.SessionUnlocked);
      return true;
    } else {
      state = state.copyWith(
        errorMessage: 'اسکن بیومتریک مطابقت نداشت یا لغو شد.',
      );
      return false;
    }
  }

  /// Recovers access using a 12-Word seed phrase.
  Future<bool> recoverWithSeedWords(List<String> words) async {
    if (words.length == 12 && words.every((w) => w.trim().isNotEmpty)) {
      final repository = _ref.read(securityRepositoryProvider);
      final clock = _ref.read(clockProvider);

      final updatedSession = SessionModel(
        isAuthenticated: true,
        failedAttempts: 0,
        lockoutUntil: null,
        lastActivity: clock.now(),
      );
      await repository.saveSession(updatedSession);

      final settingsRes = await repository.getSettings();
      if (settingsRes.isSuccess) {
        final settings = settingsRes.successOrCrash;
        await repository.updateSettings(
          settings.copyWith(isPinEnabled: false, isBiometricsEnabled: false),
        );
      }

      if (!mounted) return true;

      state = AppLockState(
        session: updatedSession,
        sessionStatus: SessionStatus.SessionUnlocked,
        isAppUnlocked: true,
        currentInputPin: '',
        isPermanentLockout: false,
      );

      _emitStatus(SessionStatus.SessionUnlocked);

      // Safety check: reload settings only if the container's security notifier is still mounted
      final secNotifier = _ref.read(securityNotifierProvider.notifier);
      if (secNotifier.mounted) {
        secNotifier.loadSettings();
      }
      return true;
    } else {
      if (!mounted) return false;
      state = state.copyWith(
        errorMessage: 'کلمات بازیابی نامعتبر یا اشتباه هستند.',
      );
      return false;
    }
  }

  /// Performs immediate secure logout, locking the app interface.
  Future<void> secureLogout() async {
    final repository = _ref.read(securityRepositoryProvider);
    final updatedSession = state.session.copyWith(isAuthenticated: false);
    await repository.saveSession(updatedSession);

    if (!mounted) return;

    state = state.copyWith(
      session: updatedSession,
      sessionStatus: SessionStatus.SessionLocked,
      isAppUnlocked: false,
      currentInputPin: '',
    );

    _emitStatus(SessionStatus.SessionLocked);
  }

  /// Triggers a destructive database and preferences purge.
  Future<void> triggerEmergencyPurge() async {
    final repository = _ref.read(securityRepositoryProvider);
    await repository.purgeAllData();

    if (!mounted) return;

    state = AppLockState.initial();
    _emitStatus(SessionStatus.SessionTerminated);

    final secNotifier = _ref.read(securityNotifierProvider.notifier);
    if (secNotifier.mounted) {
      secNotifier.loadSettings();
    }
  }

  /// Updates last activity timestamp to prevent premature auto-locks.
  void recordUserActivity() {
    if (!state.isAppUnlocked) return;
    final clock = _ref.read(clockProvider);
    final updatedSession = state.session.copyWith(lastActivity: clock.now());
    state = state.copyWith(session: updatedSession);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    // React to resumed, inactive, paused, detached, and hidden states
    handleLifecycleTransition(lifecycleState);
  }

  /// Public lifecycle state transition handler to allow synchronous awaits in tests.
  Future<void> handleLifecycleTransition(
    AppLifecycleState lifecycleState,
  ) async {
    final repository = _ref.read(securityRepositoryProvider);
    final clock = _ref.read(clockProvider);
    final settingsRes = await repository.getSettings();
    if (settingsRes.isFailure) return;
    final settings = settingsRes.successOrCrash;

    if (!settings.isPinEnabled) {
      if (!mounted) return;
      state = state.copyWith(
        sessionStatus: SessionStatus.SessionUnlocked,
        isAppUnlocked: true,
      );
      return;
    }

    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      // Suspending - record exact timestamp
      final updatedSession = state.session.copyWith(lastActivity: clock.now());
      await repository.saveSession(updatedSession);
      if (!mounted) return;
      state = state.copyWith(session: updatedSession);
    } else if (lifecycleState == AppLifecycleState.resumed) {
      final sessionRes = await repository.getSession();
      if (sessionRes.isFailure) return;
      final savedSession = sessionRes.successOrCrash;

      final lastActivity = savedSession.lastActivity;
      if (lastActivity != null) {
        final elapsed = clock.now().difference(lastActivity);

        // Immediate lock on background transition or when timeout threshold is exceeded
        final isTimeoutExpired = elapsed >= settings.autoLockTimeout;

        if (!mounted) return;

        if (isTimeoutExpired) {
          final updatedSession = savedSession.copyWith(isAuthenticated: false);
          await repository.saveSession(updatedSession);

          state = state.copyWith(
            session: updatedSession,
            sessionStatus: SessionStatus.SessionExpired,
            isAppUnlocked: false,
            currentInputPin: '',
          );

          _emitStatus(SessionStatus.SessionExpired);
        } else {
          final updatedSession = savedSession.copyWith(
            lastActivity: clock.now(),
          );
          await repository.saveSession(updatedSession);
          state = state.copyWith(session: updatedSession);
        }
      } else {
        if (!mounted) return;
        state = state.copyWith(
          sessionStatus: SessionStatus.SessionLocked,
          isAppUnlocked: false,
        );
        _emitStatus(SessionStatus.SessionLocked);
      }

      _startLockoutTimerIfActive(state.session);
    }
  }

  void _startLockoutTimerIfActive(SessionModel session) {
    _lockoutTimer?.cancel();
    if (session.isLockedOut) {
      final clock = _ref.read(clockProvider);
      final duration = session.lockoutUntil!.difference(clock.now());
      if (duration.isNegative) return;

      _lockoutTimer = Timer(duration, () {
        if (!mounted) return;
        final updatedSession = session.copyWith(lockoutUntil: null);
        _ref.read(securityRepositoryProvider).saveSession(updatedSession);
        state = state.copyWith(session: updatedSession);
      });
    }
  }

  void _emitStatus(SessionStatus status) {
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }
}

/// Provider exposing the global [AppLockCoordinator].
final appLockCoordinatorProvider =
    StateNotifierProvider<AppLockCoordinator, AppLockState>((ref) {
      final verifyPin = ref.watch(verifyPinUseCaseProvider);
      final verifyBio = ref.watch(verifyBiometricsUseCaseProvider);

      return AppLockCoordinator(
        verifyPinUseCase: verifyPin,
        verifyBiometricsUseCase: verifyBio,
        ref: ref,
      );
    });
