import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../domain/entities/backup_history_item.dart';
import '../../domain/entities/backup_metadata.dart';
import '../../domain/usecases/create_backup_use_case.dart';
import '../../domain/usecases/delete_backup_use_case.dart';
import '../../domain/usecases/get_backup_history_use_case.dart';
import '../../domain/usecases/get_backup_metadata_use_case.dart';
import '../../domain/usecases/restore_backup_use_case.dart';
import '../../domain/usecases/verify_backup_file_use_case.dart';
import '../../data/di/backup_providers.dart';

/// Combined UI state for the Backup & Restore Center screen.
class BackupState {
  /// Localized database and filesystem security diagnostics.
  final BackupMetadata metadata;

  /// Cached on-device portable backups.
  final List<BackupHistoryItem> history;

  /// True when the screen is performing its initial boot load.
  final bool isLoading;

  /// True when a backup, verify, or restoration task is in-flight.
  final bool isActionLoading;

  /// Current reminder notification state.
  final bool isAutomaticReminderEnabled;

  /// Error message used for feedback popups or local inline alerts.
  final String? errorMessage;

  /// Success message used for feedback popups or local success overlays.
  final String? successMessage;

  /// Comparison row counts (local vs backup) loaded for restoration previews.
  final Map<String, int>? previewMetrics;

  /// Constructor.
  const BackupState({
    required this.metadata,
    required this.history,
    required this.isLoading,
    required this.isActionLoading,
    required this.isAutomaticReminderEnabled,
    this.errorMessage,
    this.successMessage,
    this.previewMetrics,
  });

  /// Default initial state.
  factory BackupState.initial() => BackupState(
        metadata: BackupMetadata.initial(),
        history: const [],
        isLoading: false,
        isActionLoading: false,
        isAutomaticReminderEnabled: false,
      );

  /// Helper to duplicate state with optional parameter overrides.
  BackupState copyWith({
    BackupMetadata? metadata,
    List<BackupHistoryItem>? history,
    bool? isLoading,
    bool? isActionLoading,
    bool? isAutomaticReminderEnabled,
    String? errorMessage,
    String? successMessage,
    Map<String, int>? previewMetrics,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearPreview = false,
  }) {
    return BackupState(
      metadata: metadata ?? this.metadata,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      isAutomaticReminderEnabled: isAutomaticReminderEnabled ?? this.isAutomaticReminderEnabled,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      previewMetrics: clearPreview ? null : (previewMetrics ?? this.previewMetrics),
    );
  }
}

/// StateNotifier orchestrating screen rendering and backup business rules.
class BackupNotifier extends StateNotifier<BackupState> {
  final CreateBackupUseCase _createBackupUseCase;
  final RestoreBackupUseCase _restoreBackupUseCase;
  final GetBackupHistoryUseCase _getBackupHistoryUseCase;
  final DeleteBackupUseCase _deleteBackupUseCase;
  final VerifyBackupFileUseCase _verifyBackupFileUseCase;
  final GetBackupMetadataUseCase _getBackupMetadataUseCase;
  final Ref _ref;

  /// Constructor.
  BackupNotifier({
    required CreateBackupUseCase createBackupUseCase,
    required RestoreBackupUseCase restoreBackupUseCase,
    required GetBackupHistoryUseCase getBackupHistoryUseCase,
    required DeleteBackupUseCase deleteBackupUseCase,
    required VerifyBackupFileUseCase verifyBackupFileUseCase,
    required GetBackupMetadataUseCase getBackupMetadataUseCase,
    required Ref ref,
  }) : _createBackupUseCase = createBackupUseCase,
       _restoreBackupUseCase = restoreBackupUseCase,
       _getBackupHistoryUseCase = getBackupHistoryUseCase,
       _deleteBackupUseCase = deleteBackupUseCase,
       _verifyBackupFileUseCase = verifyBackupFileUseCase,
       _getBackupMetadataUseCase = getBackupMetadataUseCase,
       _ref = ref,
       super(BackupState.initial()) {
    loadInitialData();
  }

  /// Reloads metadata, history, and scheduled reminders configuration from repositories.
  Future<void> loadInitialData() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    final repository = _ref.read(backupRepositoryProvider);
    final metadataRes = await _getBackupMetadataUseCase(const NoParams());
    final historyRes = await _getBackupHistoryUseCase(const NoParams());
    final reminderRes = await repository.isAutomaticReminderEnabled();

    if (!mounted) return;

    final metadata = metadataRes.isSuccess ? metadataRes.successOrCrash : BackupMetadata.initial();
    final history = historyRes.isSuccess ? historyRes.successOrCrash : <BackupHistoryItem>[];
    final reminder = reminderRes.isSuccess ? reminderRes.successOrCrash : false;

    state = BackupState(
      metadata: metadata,
      history: history,
      isLoading: false,
      isActionLoading: false,
      isAutomaticReminderEnabled: reminder,
    );
  }

  /// Clears any outstanding error message in the active state.
  void clearErrorMessage() {
    if (mounted) {
      state = state.copyWith(clearError: true);
    }
  }

  /// Clears any outstanding success message in the active state.
  void clearSuccessMessage() {
    if (mounted) {
      state = state.copyWith(clearSuccess: true);
    }
  }

  /// Initiates password-encrypted manual backup generation.
  Future<bool> createManualBackup(String password) async {
    if (!mounted) return false;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    final res = await _createBackupUseCase(CreateBackupParams(
      password: password,
      isManual: true,
    ));

    if (!mounted) return false;

    if (res.isSuccess) {
      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'پشتیبان‌گیری با موفقیت انجام شد.',
      );
      await loadInitialData();
      return true;
    } else {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: res.failureOrCrash.message,
      );
      return false;
    }
  }

  /// Deletes a specific portable backup.
  Future<bool> deleteBackupItem(String id) async {
    if (!mounted) return false;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    final res = await _deleteBackupUseCase(id);

    if (!mounted) return false;

    if (res.isSuccess) {
      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'فایل پشتیبان با موفقیت حذف شد.',
      );
      await loadInitialData();
      return true;
    } else {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: res.failureOrCrash.message,
      );
      return false;
    }
  }

  /// Performs a password-protected checksum and decryption validation on a file.
  Future<bool> verifyBackupItem(String id, String password) async {
    if (!mounted) return false;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    final item = state.history.firstWhere((h) => h.id == id);
    final res = await _verifyBackupFileUseCase(VerifyBackupFileParams(
      filePath: item.filePath,
      password: password,
    ));

    if (!mounted) return false;

    if (res.isSuccess) {
      final isValid = res.successOrCrash;
      state = state.copyWith(
        isActionLoading: false,
        successMessage: isValid ? 'سلامت فایل پشتیبان تأیید شد.' : 'رمز عبور اشتباه است یا فایل آسیب دیده است.',
      );

      // Local update to update the list's isHealthy state
      if (isValid) {
        final repository = _ref.read(backupRepositoryProvider);
        final history = await repository.getBackupHistory();
        if (history.isSuccess) {
          final updated = history.successOrCrash.map((h) {
            if (h.id == id) {
              return h.copyWith(isHealthy: true);
            }
            return h;
          }).toList();
          await _ref.read(localBackupDataSourceProvider).saveHistory(updated);
        }
        await loadInitialData();
      }

      return isValid;
    } else {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: res.failureOrCrash.message,
      );
      return false;
    }
  }

  /// Loads and prepares a side-by-side data comparison preview for the user before committing a restore.
  Future<bool> loadRestorePreview(List<int> bytes, String password) async {
    if (!mounted) return false;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true, clearPreview: true);

    final repository = _ref.read(backupRepositoryProvider);
    final res = await repository.previewRestoreMetrics(
      password: password,
      backupBytes: bytes,
    );

    if (!mounted) return false;

    if (res.isSuccess) {
      state = state.copyWith(
        isActionLoading: false,
        previewMetrics: res.successOrCrash,
      );
      return true;
    } else {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: res.failureOrCrash.message,
      );
      return false;
    }
  }

  /// Triggers full AES-256 database decryption and relational tables restoration.
  Future<bool> executeRestore({
    required String password,
    required List<int> bytes,
    required bool forceReplace,
  }) async {
    if (!mounted) return false;
    state = state.copyWith(isActionLoading: true, clearError: true, clearSuccess: true);

    final res = await _restoreBackupUseCase(RestoreBackupParams(
      password: password,
      backupBytes: bytes,
      forceReplace: forceReplace,
    ));

    if (!mounted) return false;

    if (res.isSuccess) {
      state = state.copyWith(
        isActionLoading: false,
        successMessage: 'اطلاعات با موفقیت بازیابی شد.',
        clearPreview: true,
      );
      await loadInitialData();
      return true;
    } else {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: res.failureOrCrash.message,
      );
      return false;
    }
  }

  /// Toggles automatic reminders on or off.
  Future<void> toggleAutomaticReminder(bool enabled) async {
    if (!mounted) return;
    final repository = _ref.read(backupRepositoryProvider);
    await repository.setAutomaticReminderEnabled(enabled);
    state = state.copyWith(isAutomaticReminderEnabled: enabled);
  }
}

/// Provider exposing the BackupNotifier state.
final backupNotifierProvider = StateNotifierProvider<BackupNotifier, BackupState>((ref) {
  final createBackup = ref.watch(createBackupUseCaseProvider);
  final restoreBackup = ref.watch(restoreBackupUseCaseProvider);
  final getHistory = ref.watch(getBackupHistoryUseCaseProvider);
  final deleteBackup = ref.watch(deleteBackupUseCaseProvider);
  final verifyBackup = ref.watch(verifyBackupFileUseCaseProvider);
  final getMetadata = ref.watch(getBackupMetadataUseCaseProvider);

  return BackupNotifier(
    createBackupUseCase: createBackup,
    restoreBackupUseCase: restoreBackup,
    getBackupHistoryUseCase: getHistory,
    deleteBackupUseCase: deleteBackup,
    verifyBackupFileUseCase: verifyBackup,
    getBackupMetadataUseCase: getMetadata,
    ref: ref,
  );
});
