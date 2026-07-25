import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/platform/clock.dart';
import '../../../../core/platform/uuid.dart';
import '../../../../core/state_management/base_providers.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/architecture/use_case.dart' as clean_uc;
import '../../data/di/notification_providers.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/usecases/delete_notification_use_case.dart';
import '../../domain/usecases/get_notification_stream_use_case.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/insert_notification_use_case.dart';
import '../../domain/usecases/mark_notification_read_use_case.dart';
import 'notification_state.dart';

/// Central StateNotifier/ViewModel governing the entire Notification Center business rules.
class NotificationNotifier extends BaseUiNotifier<NotificationState> {
  /// Constructor.
  NotificationNotifier({
    required GetNotificationsUseCase getNotifications,
    required GetNotificationStreamUseCase getNotificationStream,
    required MarkNotificationReadUseCase markNotificationRead,
    required DeleteNotificationUseCase deleteNotification,
    required InsertNotificationUseCase insertNotification,
    required PreferencesStorage preferencesStorage,
    required Clock clock,
    required UuidGenerator uuidGenerator,
  }) : _getNotifications = getNotifications,
       _getNotificationStream = getNotificationStream,
       _markNotificationRead = markNotificationRead,
       _deleteNotification = deleteNotification,
       _insertNotification = insertNotification,
       _preferencesStorage = preferencesStorage,
       _clock = clock,
       _uuidGenerator = uuidGenerator {
    _initStream();
  }

  final GetNotificationsUseCase _getNotifications;
  final GetNotificationStreamUseCase _getNotificationStream;
  final MarkNotificationReadUseCase _markNotificationRead;
  final DeleteNotificationUseCase _deleteNotification;
  final InsertNotificationUseCase _insertNotification;
  final PreferencesStorage _preferencesStorage;
  final Clock _clock;
  final UuidGenerator _uuidGenerator;

  StreamSubscription<Result<List<NotificationItem>>>? _streamSubscription;

  static const String _notesStorageKey = 'by_notification_notes';

  void _initStream() {
    setLoading();
    _loadNotesAndSubscribe();
  }

  Future<void> _loadNotesAndSubscribe() async {
    final notes = await _loadNotesFromStorage();
    _streamSubscription = _getNotificationStream(const clean_uc.NoParams())
        .listen(
          (Result<List<NotificationItem>> result) {
            result.when(
              success: (List<NotificationItem> list) {
                final currentState = state;
                if (currentState is UiSuccess<NotificationState>) {
                  setSuccess(
                    currentState.data.copyWith(
                      notifications: list,
                      notesMap: notes,
                    ),
                  );
                } else {
                  setSuccess(
                    NotificationState.initial().copyWith(
                      notifications: list,
                      notesMap: notes,
                    ),
                  );
                }
              },
              failure: (failure) => setError(failure),
              loading: (_) => setLoading(),
              empty: () => setSuccess(
                NotificationState.initial().copyWith(notesMap: notes),
              ),
            );
          },
          onError: (Object err) {
            _fallbackFetch();
          },
        );
  }

  Future<void> _fallbackFetch() async {
    final res = await _getNotifications(const clean_uc.NoParams());
    res.when(
      success: (List<NotificationItem> list) async {
        final notes = await _loadNotesFromStorage();
        setSuccess(
          NotificationState.initial().copyWith(
            notifications: list,
            notesMap: notes,
          ),
        );
      },
      failure: (failure) => setError(failure),
      loading: (_) => setLoading(),
      empty: () => setSuccess(NotificationState.initial()),
    );
  }

  Future<Map<String, String>> _loadNotesFromStorage() async {
    try {
      final jsonStr = await _preferencesStorage.getString(_notesStorageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = json.decode(jsonStr) as Map<String, dynamic>;
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
    } catch (_) {
      // Return empty on error
    }
    return {};
  }

  Future<void> _saveNotesToStorage(Map<String, String> notes) async {
    try {
      final jsonStr = json.encode(notes);
      await _preferencesStorage.setString(_notesStorageKey, jsonStr);
    } catch (_) {}
  }

  /// Sets the active search text input query.
  void setSearchQuery(String query) {
    state.when(
      initial: () {},
      loading: (_) {},
      error: (_) {},
      success: (NotificationState data) {
        setSuccess(data.copyWith(searchQuery: query));
      },
    );
  }

  /// Sets the active smart category filter choice chip.
  void setCategoryFilter(String category) {
    state.when(
      initial: () {},
      loading: (_) {},
      error: (_) {},
      success: (NotificationState data) {
        setSuccess(data.copyWith(selectedCategory: category));
      },
    );
  }

  /// Sets the active chronological timeline filter choice chip.
  void setTimelineFilter(String filter) {
    state.when(
      initial: () {},
      loading: (_) {},
      error: (_) {},
      success: (NotificationState data) {
        setSuccess(data.copyWith(activeTimelineFilter: filter));
      },
    );
  }

  /// Toggles individual selection checkbox status for bulk edits.
  void toggleSelection(String id) {
    state.when(
      initial: () {},
      loading: (_) {},
      error: (_) {},
      success: (NotificationState data) {
        final updated = Set<String>.from(data.selectedIds);
        if (updated.contains(id)) {
          updated.remove(id);
        } else {
          updated.add(id);
        }
        setSuccess(
          data.copyWith(
            selectedIds: updated,
            isBulkSelectionMode: updated.isNotEmpty,
          ),
        );
      },
    );
  }

  /// Deselects all active items and exits bulk mode.
  void clearSelection() {
    state.when(
      initial: () {},
      loading: (_) {},
      error: (_) {},
      success: (NotificationState data) {
        setSuccess(data.copyWith(selectedIds: {}, isBulkSelectionMode: false));
      },
    );
  }

  /// Marks an individual notification read.
  Future<void> markAsRead(String id) async {
    await _markNotificationRead(MarkReadParams(id: id));
  }

  /// Marks all active notifications as read in database.
  Future<void> markAllAsRead() async {
    await _markNotificationRead(const MarkReadParams());
  }

  /// Inserts a notification directly into the local history.
  Future<void> insertNotification(NotificationItem notification) async {
    await _insertNotification(notification);
  }

  /// Deletes an individual notification card from database history.
  Future<void> deleteNotification(String id) async {
    await _deleteNotification(DeleteNotificationParams(id: id));
  }

  /// Deletes all currently selected notification items.
  Future<void> deleteSelected() async {
    await state.when(
      initial: () async {},
      loading: (_) async {},
      error: (_) async {},
      success: (NotificationState data) async {
        if (data.selectedIds.isNotEmpty) {
          final ids = data.selectedIds.toList();
          await _deleteNotification(DeleteNotificationParams(ids: ids));
          setSuccess(
            data.copyWith(selectedIds: {}, isBulkSelectionMode: false),
          );
        }
      },
    );
  }

  /// Permanently purges entire local history database table.
  Future<void> clearAll() async {
    await _deleteNotification(const DeleteNotificationParams(clearAll: true));
  }

  /// Adds or updates a local text annotation tag on an individual notification.
  Future<void> saveNote(String id, String noteText) async {
    await state.when(
      initial: () async {},
      loading: (_) async {},
      error: (_) async {},
      success: (NotificationState data) async {
        final updatedNotes = Map<String, String>.from(data.notesMap);
        if (noteText.trim().isEmpty) {
          updatedNotes.remove(id);
        } else {
          updatedNotes[id] = noteText;
        }
        await _saveNotesToStorage(updatedNotes);
        setSuccess(data.copyWith(notesMap: updatedNotes));
      },
    );
  }

  /// Deletes annotation text from an individual notification.
  Future<void> deleteNote(String id) async {
    await saveNote(id, '');
  }

  /// Simulates dynamic incoming banking and system notifications for demonstration.
  Future<void> simulateIncomingNotification() async {
    final simulations = [
      NotificationItem(
        id: _uuidGenerator.generateV4(),
        title: 'واریز وجه موفق',
        body: 'مبلغ ۱۰,۰۰۰,۰۰۰ ریال از بانک ملی ایران به حساب شما واریز شد.',
        type: NotificationType.transactionProcessed,
        isRead: false,
        createdAt: _clock.now(),
      ),
      NotificationItem(
        id: _uuidGenerator.generateV4(),
        title: 'برداشت وجه موفق',
        body: 'مبلغ ۲,۵۰۰,۰۰۰ ریال خرید فروشگاهی از حساب صادرات شما کسر گردید.',
        type: NotificationType.transactionProcessed,
        isRead: false,
        createdAt: _clock.now().subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: _uuidGenerator.generateV4(),
        title: 'هشدار امنیتی سیستم',
        body: 'یک تلاش ناموفق برای ورود به قفل برنامه با اثرانگشت شناسایی شد.',
        type: NotificationType.securityAlerts,
        isRead: false,
        createdAt: _clock.now().subtract(const Duration(hours: 4)),
      ),
      NotificationItem(
        id: _uuidGenerator.generateV4(),
        title: 'پشتیبان‌گیری ناموفق',
        body:
            'فضای ذخیره‌سازی محلی دستگاه پر است. پشتیبان‌گیری خودکار لغو گردید.',
        type: NotificationType.backupCompleted,
        isRead: false,
        createdAt: _clock.now().subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        id: _uuidGenerator.generateV4(),
        title: 'دسترسی پیامک صادر نشده است',
        body:
            'مجوز سیستمی پیامک غیرفعال است. لطفاً آن را جهت دریافت هوشمند فعال کنید.',
        type: NotificationType.warningNotifications,
        isRead: false,
        createdAt: _clock.now().subtract(const Duration(days: 2)),
      ),
    ];

    // Pick one at random and insert
    final index = _clock.now().millisecondsSinceEpoch % simulations.length;
    final item = simulations[index];
    await _insertNotification(item);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

/// Provider exposing NotificationNotifier tied auto-disposably.
final notificationNotifierProvider =
    StateNotifierProvider.autoDispose<
      NotificationNotifier,
      UiState<NotificationState>
    >((ref) {
      final getNotifications = ref.watch(getNotificationsUseCaseProvider);
      final getNotificationStream = ref.watch(
        getNotificationStreamUseCaseProvider,
      );
      final markNotificationRead = ref.watch(
        markNotificationReadUseCaseProvider,
      );
      final deleteNotification = ref.watch(deleteNotificationUseCaseProvider);
      final insertNotification = ref.watch(insertNotificationUseCaseProvider);
      final preferencesStorage = ref.watch(preferencesStorageProvider);
      final clock = ref.watch(clockProvider);
      final uuidGenerator = ref.watch(uuidGeneratorProvider);

      return NotificationNotifier(
        getNotifications: getNotifications,
        getNotificationStream: getNotificationStream,
        markNotificationRead: markNotificationRead,
        deleteNotification: deleteNotification,
        insertNotification: insertNotification,
        preferencesStorage: preferencesStorage,
        clock: clock,
        uuidGenerator: uuidGenerator,
      );
    });
