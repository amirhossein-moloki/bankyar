import 'package:flutter/material.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/notification_item.dart';

/// Chronological card displaying summary attributes with expand-to-action capabilities and swipe mechanics.
class NotificationCard extends StatefulWidget {
  /// Constructor.
  const NotificationCard({
    super.key,
    required this.item,
    required this.note,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
    required this.onToggleSelect,
    required this.onAddNote,
    required this.onDismissed,
  });

  /// The active notification details.
  final NotificationItem item;

  /// Existing local note associated with this notification, or empty.
  final String note;

  /// True if bulk selection checkbox mode is currently active.
  final bool isSelectionMode;

  /// True if this specific item is selected.
  final bool isSelected;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  /// Callback when user triggers marking read.
  final VoidCallback onMarkAsRead;

  /// Callback when user triggers delete action.
  final VoidCallback onDelete;

  /// Callback when user toggles checkbox selection.
  final VoidCallback onToggleSelect;

  /// Callback when user requests to write a note.
  final VoidCallback onAddNote;

  /// Callback when user successfully swipes to dismiss.
  final VoidCallback onDismissed;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final persianDate = DateFormatter.formatFriendly(widget.item.createdAt);

    // Color coordination based on notification category type
    final typeColor = _getTypeColor(context, widget.item.type);

    return Dismissible(
      key: Key('notif_dismiss_${widget.item.id}'),
      direction: widget.isSelectionMode
          ? DismissDirection.none
          : DismissDirection.startToEnd,
      onDismissed: (_) => widget.onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: const BorderRadius.all(Radius.circular(RadiusTokens.m)),
        ),
        child: Icon(
          Icons.delete_sweep_outlined,
          color: theme.colorScheme.onError,
        ),
      ),
      child: Semantics(
        label: _buildSemanticLabel(persianDate),
        container: true,
        child: InkWell(
          onTap: () {
            if (widget.isSelectionMode) {
              widget.onToggleSelect();
            } else {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              widget.onTap();
            }
          },
          onLongPress: () {
            widget.onToggleSelect();
          },
          borderRadius: const BorderRadius.all(Radius.circular(RadiusTokens.m)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(SpacingTokens.m),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.12)
                  : (widget.item.isRead
                        ? theme.colorScheme.surface
                        : theme.colorScheme.surfaceContainerHighest.withOpacity(0.35)),
              borderRadius: const BorderRadius.all(
                Radius.circular(RadiusTokens.m),
              ),
              border: Border.all(
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : (widget.item.isRead
                          ? theme.colorScheme.outlineVariant.withOpacity(0.4)
                          : theme.colorScheme.primary.withOpacity(0.2)),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (widget.isSelectionMode) ...[
                      Checkbox(
                        value: widget.isSelected,
                        onChanged: (_) => widget.onToggleSelect(),
                        activeColor: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: SpacingTokens.s),
                    ],
                    _buildTypeIcon(context, widget.item.type, typeColor),
                    const SizedBox(width: SpacingTokens.s),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: widget.item.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!widget.item.isRead) ...[
                                Container(
                                  width: 8.0,
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: SpacingTokens.s),
                              ],
                              Text(
                                _getTimeOnly(widget.item.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 11.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SpacingTokens.xxs),
                          Text(
                            widget.item.body,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: widget.item.isRead
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                              height: 1.4,
                            ),
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded
                                ? null
                                : TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.note.isNotEmpty) ...[
                  const SizedBox(height: SpacingTokens.s),
                  Row(
                    children: [
                      const SizedBox(width: 38.0), // Icon indentation offset
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingTokens.s,
                          vertical: SpacingTokens.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer
                              .withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(RadiusTokens.xs),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_note,
                              size: 14.0,
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: SpacingTokens.xxs),
                            Text(
                              widget.note,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11.0,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                // Quick Action Expanded Drawer Bottom Row
                if (_isExpanded && !widget.isSelectionMode) ...[
                  const SizedBox(height: SpacingTokens.m),
                  const Divider(),
                  const SizedBox(height: SpacingTokens.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: widget.onAddNote,
                        icon: const Icon(Icons.edit_note, size: 18.0),
                        label: const Text('یادداشت'),
                      ),
                      const SizedBox(width: SpacingTokens.s),
                      if (!widget.item.isRead) ...[
                        TextButton.icon(
                          onPressed: widget.onMarkAsRead,
                          icon: const Icon(Icons.mark_email_read, size: 18.0),
                          label: const Text('خوانده شد'),
                        ),
                        const SizedBox(width: SpacingTokens.s),
                      ],
                      TextButton.icon(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18.0),
                        label: Text(
                          'حذف',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSemanticLabel(String date) {
    final readStatus = widget.item.isRead ? 'خوانده شده' : 'خوانده نشده جدید';
    final noteStatus = widget.note.isNotEmpty
        ? 'دارای یادداشت: ${widget.note}'
        : '';
    return 'اعلان ${widget.item.title}. $readStatus. محتوا: ${widget.item.body}. دریافت شده در تاریخ $date. $noteStatus';
  }

  Widget _buildTypeIcon(
    BuildContext context,
    NotificationType type,
    Color color,
  ) {
    IconData iconData;
    switch (type) {
      case NotificationType.smsDetected:
        iconData = Icons.sms_outlined;
        break;
      case NotificationType.transactionProcessed:
        iconData = Icons.account_balance_wallet_outlined;
        break;
      case NotificationType.backupCompleted:
        iconData = Icons.backup_outlined;
        break;
      case NotificationType.restoreCompleted:
        iconData = Icons.settings_backup_restore_outlined;
        break;
      case NotificationType.securityAlerts:
        iconData = Icons.security_outlined;
        break;
      case NotificationType.authenticationEvents:
        iconData = Icons.fingerprint_outlined;
        break;
      case NotificationType.systemNotifications:
        iconData = Icons.info_outline;
        break;
      case NotificationType.warningNotifications:
        iconData = Icons.warning_amber_outlined;
        break;
    }

    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 18.0),
    );
  }

  Color _getTypeColor(BuildContext context, NotificationType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case NotificationType.smsDetected:
        return colorScheme.secondary;
      case NotificationType.transactionProcessed:
        return Colors.green;
      case NotificationType.backupCompleted:
        return Colors.blue;
      case NotificationType.restoreCompleted:
        return Colors.teal;
      case NotificationType.securityAlerts:
        return colorScheme.error;
      case NotificationType.authenticationEvents:
        return colorScheme.primary;
      case NotificationType.systemNotifications:
        return colorScheme.outline;
      case NotificationType.warningNotifications:
        return Colors.amber;
    }
  }

  String _getTimeOnly(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
