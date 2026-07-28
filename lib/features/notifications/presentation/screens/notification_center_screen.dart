// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/indicators/skeleton_loader.dart';
import '../../../../core/state_management/state_wrappers.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../domain/entities/notification_item.dart';
import '../state/notification_notifier.dart';
import '../state/notification_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_details_dialog.dart';
import '../widgets/notification_dialogs.dart';

/// The central Notification Center screen displaying chronological history,
/// interactive smart filters, bulk operations, and secure diagnostics in RTL.
class NotificationCenterScreen extends ConsumerWidget {
  /// Constructor.
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(notificationNotifierProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'مرکز اعلان‌ها',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            uiState.when(
              initial: () => const SizedBox.shrink(),
              loading: (_) => const SizedBox.shrink(),
              error: (_) => const SizedBox.shrink(),
              success: (NotificationState state) {
                if (state.notifications.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (state.isBulkSelectionMode) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_outlined),
                    tooltip: 'حذف موارد انتخاب شده',
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => DeleteNotificationDialog(
                          onConfirm: () {
                            ref
                                .read(notificationNotifierProvider.notifier)
                                .deleteSelected();
                          },
                        ),
                      );
                    },
                  );
                }
                return PopupMenuButton<String>(
                  onSelected: (String val) {
                    if (val == 'mark_all_read') {
                      ref
                          .read(notificationNotifierProvider.notifier)
                          .markAllAsRead();
                    } else if (val == 'clear_all') {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => ClearAllDialog(
                          onConfirm: () {
                            ref
                                .read(notificationNotifierProvider.notifier)
                                .clearAll();
                          },
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'mark_all_read',
                      child: Text('علامت‌گذاری همه به عنوان خوانده شده'),
                    ),
                    const PopupMenuItem(
                      value: 'clear_all',
                      child: Text('پاک کردن کل تاریخچه'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ZONE A: Sticky Header and Smart Controls
              _buildStickyHeader(context, ref, uiState),

              // ZONE B: Scrollable Workspace
              Expanded(
                child: uiState.when(
                  initial: () => _buildLoadingSkeleton(context),
                  loading: (_) => _buildLoadingSkeleton(context),
                  error: (failure) =>
                      _buildErrorState(context, ref, failure.message),
                  success: (NotificationState state) {
                    final filtered = _getFilteredNotifications(state);
                    if (filtered.isEmpty) {
                      return _buildEmptyState(
                        context,
                        ref,
                        state.notifications.isNotEmpty,
                      );
                    }
                    return _buildTimelineList(context, ref, state, filtered);
                  },
                ),
              ),

              // ZONE C: Persistent Diagnostics Badge
              _buildDiagnosticsBadge(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStickyHeader(
    BuildContext context,
    WidgetRef ref,
    UiState<NotificationState> uiState,
  ) {
    final theme = Theme.of(context);

    return uiState.when(
      initial: () => const SizedBox.shrink(),
      loading: (_) => const SizedBox.shrink(),
      error: (_) => const SizedBox.shrink(),
      success: (NotificationState state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: SpacingTokens.s),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withOpacity(0.4),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Input Box
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.l,
                ),
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.4),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(RadiusTokens.m),
                    ),
                  ),
                  child: TextField(
                    onChanged: (String val) {
                      ref
                          .read(notificationNotifierProvider.notifier)
                          .setSearchQuery(val);
                    },
                    decoration: InputDecoration(
                      hintText: 'جستجوی نام بانک، مبالغ یا برچسب...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(
                          0.8,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: SpacingTokens.m,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SpacingTokens.s),

              // Categories Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.l,
                ),
                child: Row(
                  children: [
                    _buildCategoryChip(
                      ref,
                      'All',
                      'همه',
                      state.selectedCategory,
                    ),
                    _buildCategoryChip(
                      ref,
                      'sms',
                      'پیامک‌ها',
                      state.selectedCategory,
                    ),
                    _buildCategoryChip(
                      ref,
                      'tx',
                      'تراکنش‌ها',
                      state.selectedCategory,
                    ),
                    _buildCategoryChip(
                      ref,
                      'backup',
                      'پشتیبان‌گیری',
                      state.selectedCategory,
                    ),
                    _buildCategoryChip(
                      ref,
                      'security',
                      'امنیت',
                      state.selectedCategory,
                    ),
                    _buildCategoryChip(
                      ref,
                      'warning',
                      'هشدارها',
                      state.selectedCategory,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpacingTokens.s),

              // Chronological Filters Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.l,
                ),
                child: Row(
                  children: [
                    _buildTimelineChip(
                      ref,
                      'All',
                      'کل تاریخچه',
                      state.activeTimelineFilter,
                    ),
                    _buildTimelineChip(
                      ref,
                      'Unread',
                      'خوانده نشده (${state.unreadCount})',
                      state.activeTimelineFilter,
                    ),
                    _buildTimelineChip(
                      ref,
                      'Today',
                      'امروز',
                      state.activeTimelineFilter,
                    ),
                    _buildTimelineChip(
                      ref,
                      'This Week',
                      'این هفته',
                      state.activeTimelineFilter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    WidgetRef ref,
    String id,
    String label,
    String activeId,
  ) {
    final isSelected = id == activeId;
    return Padding(
      padding: const EdgeInsets.only(left: SpacingTokens.s),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool val) {
          if (val) {
            ref
                .read(notificationNotifierProvider.notifier)
                .setCategoryFilter(id);
          }
        },
      ),
    );
  }

  Widget _buildTimelineChip(
    WidgetRef ref,
    String id,
    String label,
    String activeId,
  ) {
    final isSelected = id == activeId;
    return Padding(
      padding: const EdgeInsets.only(left: SpacingTokens.s),
      child: InputChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool val) {
          ref.read(notificationNotifierProvider.notifier).setTimelineFilter(id);
        },
      ),
    );
  }

  Widget _buildTimelineList(
    BuildContext context,
    WidgetRef ref,
    NotificationState state,
    List<NotificationItem> list,
  ) {
    final todayList = <NotificationItem>[];
    final yesterdayList = <NotificationItem>[];
    final olderList = <NotificationItem>[];

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    for (final item in list) {
      if (item.createdAt.isAfter(todayStart)) {
        todayList.add(item);
      } else if (item.createdAt.isAfter(yesterdayStart)) {
        yesterdayList.add(item);
      } else {
        olderList.add(item);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        final notifier = ref.read(notificationNotifierProvider.notifier);
        notifier.clearSelection();
        await notifier.refresh();
      },
      child: ListView(
        padding: const EdgeInsets.all(SpacingTokens.l),
        children: [
          // Pinned Alert / Active System Warning Panel (Region 1)
          _buildActiveSystemWarningPanel(context, ref),

          if (todayList.isNotEmpty) ...[
            _buildTimelineHeader(context, 'امروز'),
            ...todayList.map(
              (item) => _buildCardWrapper(context, ref, state, item),
            ),
          ],
          if (yesterdayList.isNotEmpty) ...[
            const SizedBox(height: SpacingTokens.l),
            _buildTimelineHeader(context, 'دیروز'),
            ...yesterdayList.map(
              (item) => _buildCardWrapper(context, ref, state, item),
            ),
          ],
          if (olderList.isNotEmpty) ...[
            const SizedBox(height: SpacingTokens.l),
            _buildTimelineHeader(context, 'قدیمی‌تر'),
            ...olderList.map(
              (item) => _buildCardWrapper(context, ref, state, item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveSystemWarningPanel(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.errorContainer.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(RadiusTokens.m)),
        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.only(bottom: SpacingTokens.m),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.m),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: theme.colorScheme.error,
              size: 24.0,
            ),
            const SizedBox(width: SpacingTokens.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'دسترسی پیامک صادر نشده است',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xxs),
                  Text(
                    'بدون دسترسی پیامک، دریافت خودکار تراکنش‌ها متوقف گردیده است.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineHeader(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingTokens.s),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCardWrapper(
    BuildContext context,
    WidgetRef ref,
    NotificationState state,
    NotificationItem item,
  ) {
    final note = state.notesMap[item.id] ?? '';
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.s),
      child: NotificationCard(
        item: item,
        note: note,
        isSelectionMode: state.isBulkSelectionMode,
        isSelected: state.selectedIds.contains(item.id),
        onTap: () {
          _showDetailsDialog(context, ref, state, item);
        },
        onMarkAsRead: () {
          ref.read(notificationNotifierProvider.notifier).markAsRead(item.id);
        },
        onDelete: () {
          showDialog<void>(
            context: context,
            builder: (ctx) => DeleteNotificationDialog(
              onConfirm: () {
                ref
                    .read(notificationNotifierProvider.notifier)
                    .deleteNotification(item.id);
              },
            ),
          );
        },
        onToggleSelect: () {
          ref
              .read(notificationNotifierProvider.notifier)
              .toggleSelection(item.id);
        },
        onAddNote: () {
          _showInlineNoteBottomSheet(context, ref, item.id, note);
        },
        onDismissed: () {
          ref
              .read(notificationNotifierProvider.notifier)
              .deleteNotification(item.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('اعلان حذف شد'),
              action: SnackBarAction(
                label: 'بازگرداندن',
                onPressed: () {
                  ref
                      .read(notificationNotifierProvider.notifier)
                      .insertNotification(item);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDetailsDialog(
    BuildContext context,
    WidgetRef ref,
    NotificationState state,
    NotificationItem item,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => NotificationDetailsDialog(
        item: item,
        note: state.notesMap[item.id] ?? '',
        onMarkAsRead: () {
          ref.read(notificationNotifierProvider.notifier).markAsRead(item.id);
        },
        onDelete: () {
          showDialog<void>(
            context: context,
            builder: (ctx) => DeleteNotificationDialog(
              onConfirm: () {
                ref
                    .read(notificationNotifierProvider.notifier)
                    .deleteNotification(item.id);
              },
            ),
          );
        },
        onSaveNote: (String updatedNote) {
          ref
              .read(notificationNotifierProvider.notifier)
              .saveNote(item.id, updatedNote);
        },
      ),
    );
  }

  void _showInlineNoteBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String id,
    String initialNote,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.l),
        ),
      ),
      builder: (ctx) => InlineNoteBottomSheet(
        initialNote: initialNote,
        onSave: (String val) {
          ref.read(notificationNotifierProvider.notifier).saveNote(id, val);
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    bool hasAnyItems,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64.0,
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
          const SizedBox(height: SpacingTokens.l),
          Text(
            hasAnyItems ? 'نتیجه‌ای یافت نشد' : 'مرکز اعلان‌های شما خالی است',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SpacingTokens.s),
          Text(
            hasAnyItems
                ? 'لطفاً فیلتر یا عبارت جستجوی دیگری را امتحان کنید.'
                : 'پس از دریافت اولین پیامک بانکی، تراکنش‌های شما به صورت خودکار در این قسمت سازماندهی خواهند شد.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SpacingTokens.xl),
          ElevatedButton.icon(
            onPressed: () {
              ref
                  .read(notificationNotifierProvider.notifier)
                  .simulateIncomingNotification();
            },
            icon: const Icon(Icons.bolt),
            label: const Text('شبیه‌سازی دریافت پیامک'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(SpacingTokens.l),
      itemCount: 4,
      itemBuilder: (context, idx) => const Padding(
        padding: EdgeInsets.only(bottom: SpacingTokens.m),
        child: Row(
          children: [
            SkeletonLoader(
              width: 36,
              height: 36,
              borderRadius: RadiusTokens.max,
            ),
            SizedBox(width: SpacingTokens.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(width: 140, height: 16),
                  SizedBox(height: SpacingTokens.s),
                  SkeletonLoader(width: double.infinity, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48.0),
          const SizedBox(height: SpacingTokens.m),
          Text(
            'خطا در بارگذاری تاریخچه اعلان‌ها',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(error, style: theme.textTheme.bodyMedium),
          const SizedBox(height: SpacingTokens.l),
          ElevatedButton(
            onPressed: () {
              ref.read(notificationNotifierProvider.notifier).clearSelection();
            },
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticsBadge(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: SpacingTokens.s),
      color: theme.colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: SpacingTokens.s),
          Text(
            'آفلاین و امن - بدون اتصال شبکه',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  List<NotificationItem> _getFilteredNotifications(NotificationState state) {
    var items = state.notifications;

    // 1. Text Search Filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      items = items.where((item) {
        final hasNote = (state.notesMap[item.id] ?? '').toLowerCase().contains(
          query,
        );
        return item.title.toLowerCase().contains(query) ||
            item.body.toLowerCase().contains(query) ||
            hasNote;
      }).toList();
    }

    // 2. Category Filter
    if (state.selectedCategory != 'All') {
      items = items.where((item) {
        switch (state.selectedCategory) {
          case 'sms':
            return item.type == NotificationType.smsDetected;
          case 'tx':
            return item.type == NotificationType.transactionProcessed;
          case 'backup':
            return item.type == NotificationType.backupCompleted ||
                item.type == NotificationType.restoreCompleted;
          case 'security':
            return item.type == NotificationType.securityAlerts ||
                item.type == NotificationType.authenticationEvents;
          case 'warning':
            return item.type == NotificationType.warningNotifications;
          default:
            return true;
        }
      }).toList();
    }

    // 3. Timeline Criteria Filter
    if (state.activeTimelineFilter != 'All') {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = todayStart.subtract(const Duration(days: 7));

      items = items.where((item) {
        switch (state.activeTimelineFilter) {
          case 'Unread':
            return !item.isRead;
          case 'Today':
            return item.createdAt.isAfter(todayStart);
          case 'This Week':
            return item.createdAt.isAfter(weekStart);
          default:
            return true;
        }
      }).toList();
    }

    return items;
  }
}
