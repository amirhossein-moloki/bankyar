/// Model representing the local application authentication session state.
class SessionModel {

  /// Constructor.
  const SessionModel({
    required this.isAuthenticated,
    this.lastActivity,
    required this.failedAttempts,
    this.lockoutUntil,
  });

  /// Factory for a clean, default session.
  factory SessionModel.initial() => const SessionModel(
    isAuthenticated: false,
    lastActivity: null,
    failedAttempts: 0,
    lockoutUntil: null,
  );
  /// Whether the user has successfully unlocked the application during this run.
  final bool isAuthenticated;

  /// Timestamp of the last user interaction / lifecycle activity.
  final DateTime? lastActivity;

  /// Counter of consecutive failed PIN entry attempts.
  final int failedAttempts;

  /// Timestamp until which the keyboard input is temporarily locked out.
  final DateTime? lockoutUntil;

  /// Helper indicating if the user is currently under a brute-force cooldown lockout.
  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return lockoutUntil!.isAfter(DateTime.now());
  }

  /// Copies the session with optional override parameters.
  SessionModel copyWith({
    bool? isAuthenticated,
    DateTime? lastActivity,
    int? failedAttempts,
    DateTime? lockoutUntil,
  }) {
    return SessionModel(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      lastActivity: lastActivity ?? this.lastActivity,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
    );
  }
}
