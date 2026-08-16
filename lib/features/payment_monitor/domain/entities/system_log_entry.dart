/// Represents a system event log entry in the Payment Monitor log viewer.
class SystemLogEntry {
  /// Constructor.
  const SystemLogEntry({
    required this.id,
    required this.timestamp,
    required this.event,
    this.details,
  });

  /// Unique log entry identifier.
  final String id;

  /// System event timestamp.
  final DateTime timestamp;

  /// System event title/summary (e.g. Bank SMS detected, API request sent).
  final String event;

  /// Optional event details or response metadata.
  final String? details;
}
