/// Model representing a historical portable backup record stored on device.
/// Conforms to BACKUP_RESTORE_SCREEN_SPECIFICATION.md Component 8 specs.
class BackupHistoryItem {
  /// Unique identifier of the backup item.
  final String id;

  /// Absolute file system path to the portable backup on disk.
  final String filePath;

  /// Localized user-friendly name of the backup file.
  final String fileName;

  /// Exact date and time when this backup was constructed.
  final DateTime timestamp;

  /// True if this was manually initiated; False if automated/scheduled.
  final bool isManual;

  /// File size of the encrypted .bankyar archive in bytes.
  final int sizeBytes;

  /// Validated status based on checksum self-audit signature.
  final bool isHealthy;

  /// Database schema version at the time of export.
  final int dbVersion;

  /// Cryptographic algorithm used to protect this portable file.
  final String encryptAlgorithm;

  /// Constructor.
  const BackupHistoryItem({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.timestamp,
    required this.isManual,
    required this.sizeBytes,
    required this.isHealthy,
    required this.dbVersion,
    required this.encryptAlgorithm,
  });

  /// Maps a JSON map back to a [BackupHistoryItem].
  factory BackupHistoryItem.fromJson(Map<String, dynamic> json) {
    return BackupHistoryItem(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isManual: json['isManual'] as bool? ?? true,
      sizeBytes: json['sizeBytes'] as int? ?? 0,
      isHealthy: json['isHealthy'] as bool? ?? true,
      dbVersion: json['dbVersion'] as int? ?? 1,
      encryptAlgorithm: json['encryptAlgorithm'] as String? ?? 'AES-256-CBC',
    );
  }

  /// Converts this model to a JSON map for simple secure persistent caching.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'timestamp': timestamp.toIso8601String(),
      'isManual': isManual,
      'sizeBytes': sizeBytes,
      'isHealthy': isHealthy,
      'dbVersion': dbVersion,
      'encryptAlgorithm': encryptAlgorithm,
    };
  }

  /// Copies this instance with updated attributes.
  BackupHistoryItem copyWith({
    String? id,
    String? filePath,
    String? fileName,
    DateTime? timestamp,
    bool? isManual,
    int? sizeBytes,
    bool? isHealthy,
    int? dbVersion,
    String? encryptAlgorithm,
  }) {
    return BackupHistoryItem(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      timestamp: timestamp ?? this.timestamp,
      isManual: isManual ?? this.isManual,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      isHealthy: isHealthy ?? this.isHealthy,
      dbVersion: dbVersion ?? this.dbVersion,
      encryptAlgorithm: encryptAlgorithm ?? this.encryptAlgorithm,
    );
  }
}
