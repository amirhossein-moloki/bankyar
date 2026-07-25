import '../../domain/entities/notification_item.dart';

/// State model for managing Notification Center filters, query, and selections.
class NotificationState {
  /// Constructor.
  const NotificationState({
    required this.notifications,
    required this.searchQuery,
    required this.selectedCategory,
    required this.activeTimelineFilter,
    required this.selectedIds,
    required this.isBulkSelectionMode,
    required this.notesMap,
  });

  /// Factory constructor representing initial default state.
  factory NotificationState.initial() {
    return const NotificationState(
      notifications: [],
      searchQuery: '',
      selectedCategory:
          'All', // 'All', 'Income', 'Expenses', 'System', 'Security' etc.
      activeTimelineFilter:
          'All', // 'All', 'Unread', 'Today', 'This Week', 'Pinned'
      selectedIds: {},
      isBulkSelectionMode: false,
      notesMap: {},
    );
  }

  /// Original chronological notification list fetched from database.
  final List<NotificationItem> notifications;

  /// Current text search filter input.
  final String searchQuery;

  /// Active smart category filter (e.g., 'All', 'Deposit', 'Withdrawal', 'System', 'Security').
  final String selectedCategory;

  /// Active timeline/criteria filter (e.g., 'All', 'Unread', 'Today', 'This Week', 'Pinned').
  final String activeTimelineFilter;

  /// Currently selected notification IDs in bulk edit mode.
  final Set<String> selectedIds;

  /// Flag indicating whether multi-select checkbox mode is active.
  final bool isBulkSelectionMode;

  /// Lightweight mapping of local inline annotations [notificationId -> noteText]
  /// backed by PreferencesStorage persistence for absolute offline safety.
  final Map<String, String> notesMap;

  /// Helper to get the total number of unread notifications.
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// Copies this state with updated parameters.
  NotificationState copyWith({
    List<NotificationItem>? notifications,
    String? searchQuery,
    String? selectedCategory,
    String? activeTimelineFilter,
    Set<String>? selectedIds,
    bool? isBulkSelectionMode,
    Map<String, String>? notesMap,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      activeTimelineFilter: activeTimelineFilter ?? this.activeTimelineFilter,
      selectedIds: selectedIds ?? this.selectedIds,
      isBulkSelectionMode: isBulkSelectionMode ?? this.isBulkSelectionMode,
      notesMap: notesMap ?? this.notesMap,
    );
  }
}
