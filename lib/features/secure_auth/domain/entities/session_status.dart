/// Enum representing the local application session lifecycle state.
enum SessionStatus {
  /// The application process has booted and initialized security.
  SessionStarted,

  /// The user successfully unlocked the application via PIN or biometrics.
  SessionUnlocked,

  /// The user or system manually locked the active interface.
  SessionLocked,

  /// The active session expired automatically due to user inactivity.
  SessionExpired,

  /// The active session has been destroyed (manually logged out or data purged).
  SessionTerminated,
}
