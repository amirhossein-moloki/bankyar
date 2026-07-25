/// Represents dynamic state and security diagnostics of the offline backup vault.
/// Conforms to BACKUP_RESTORE_SCREEN_SPECIFICATION.md Component definitions.
class BackupMetadata {
  /// Constructor.
  const BackupMetadata({
    this.lastBackupTime,
    required this.databaseVersion,
    required this.encryptionAlgorithm,
    required this.databaseSizeBytes,
    required this.backupSizeBytes,
    required this.healthPercentage,
    required this.deviceFreeSpaceBytes,
    required this.deviceTotalSpaceBytes,
  });

  /// Factory constructor to generate baseline initial state.
  factory BackupMetadata.initial() {
    return const BackupMetadata(
      lastBackupTime: null,
      databaseVersion: 1,
      encryptionAlgorithm: 'AES-256-CBC',
      databaseSizeBytes: 0,
      backupSizeBytes: 0,
      healthPercentage: 100,
      deviceFreeSpaceBytes: 10 * 1024 * 1024 * 1024, // 10 GB
      deviceTotalSpaceBytes: 16 * 1024 * 1024 * 1024, // 16 GB
    );
  }

  /// Exact timestamp of the last successful backup.
  final DateTime? lastBackupTime;

  /// Schema version of the localized database file.
  final int databaseVersion;

  /// Cryptographic standard used to lock backups.
  final String encryptionAlgorithm;

  /// Raw byte size of the active on-device sqlite database.
  final int databaseSizeBytes;

  /// Compressed/encrypted byte size of the latest backup file.
  final int backupSizeBytes;

  /// Unified health and integrity score (0-100) of database and backups.
  final int healthPercentage;

  /// Remaining storage space available on the physical device.
  final int deviceFreeSpaceBytes;

  /// Total storage capacity of the physical device.
  final int deviceTotalSpaceBytes;

  /// Calculates the free storage percentage (0 to 100).
  double get freeSpacePercentage {
    if (deviceTotalSpaceBytes == 0) return 0.0;
    return (deviceFreeSpaceBytes / deviceTotalSpaceBytes) * 100.0;
  }

  /// Returns a copy with updated fields.
  BackupMetadata copyWith({
    DateTime? lastBackupTime,
    int? databaseVersion,
    String? encryptionAlgorithm,
    int? databaseSizeBytes,
    int? backupSizeBytes,
    int? healthPercentage,
    int? deviceFreeSpaceBytes,
    int? deviceTotalSpaceBytes,
  }) {
    return BackupMetadata(
      lastBackupTime: lastBackupTime ?? this.lastBackupTime,
      databaseVersion: databaseVersion ?? this.databaseVersion,
      encryptionAlgorithm: encryptionAlgorithm ?? this.encryptionAlgorithm,
      databaseSizeBytes: databaseSizeBytes ?? this.databaseSizeBytes,
      backupSizeBytes: backupSizeBytes ?? this.backupSizeBytes,
      healthPercentage: healthPercentage ?? this.healthPercentage,
      deviceFreeSpaceBytes: deviceFreeSpaceBytes ?? this.deviceFreeSpaceBytes,
      deviceTotalSpaceBytes:
          deviceTotalSpaceBytes ?? this.deviceTotalSpaceBytes,
    );
  }
}
