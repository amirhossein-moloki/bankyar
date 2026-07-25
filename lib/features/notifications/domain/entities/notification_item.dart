/// Enum defining the supported notification types.
enum NotificationType {
  /// SMS message has been intercepted and processed.
  smsDetected('sms_detected'),

  /// Financial transaction has been successfully parsed and persisted.
  transactionProcessed('transaction_processed'),

  /// Data backup file has been successfully exported.
  backupCompleted('backup_completed'),

  /// Data backup file has been successfully imported and restored.
  restoreCompleted('restore_completed'),

  /// Critical security system warning or access violation.
  securityAlerts('security_alerts'),

  /// Local biometric or PIN authentication event.
  authenticationEvents('authentication_events'),

  /// Standard system audit or lifecycle event.
  systemNotifications('system_notifications'),

  /// Non-critical system warning or action-required flag.
  warningNotifications('warning_notifications');

  /// DB string mapping constructor.
  const NotificationType(this.value);

  /// String value matching SQLite representation.
  final String value;

  /// Returns the enum value matching the DB string.
  static NotificationType fromValue(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.systemNotifications,
    );
  }
}

/// Domain entity representing an individual notification alert in BankYar.
/// Conforms to NOTIFICATION_CENTER_SCREEN_SPECIFICATION.md and sqlite database schemas.
class NotificationItem {
  /// Constructor.
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  /// Maps a relational SQLite database map back to a [NotificationItem].
  factory NotificationItem.fromSqlMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      type: NotificationType.fromValue(map['type'] as String),
      isRead: (map['is_read'] as int? ?? 0) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  /// Unique identifier of the notification.
  final String id;

  /// The high-contrast title text of the notification.
  final String title;

  /// The descriptive body text containing details or transaction parameters.
  final String body;

  /// The specific category type of the notification.
  final NotificationType type;

  /// Boolean indicating whether the user has marked this alert read.
  final bool isRead;

  /// Chronological timestamp when this notification was created.
  final DateTime createdAt;

  /// Converts this entity into a database-ready map matching the sqlite schema.
  Map<String, dynamic> toSqlMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.value,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Copies this instance with updated attributes.
  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
