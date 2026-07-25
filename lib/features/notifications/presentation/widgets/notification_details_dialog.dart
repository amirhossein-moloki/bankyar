// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/notification_item.dart';

/// Screen-modal dialog showing complete text and metadata fields for an individual notification.
class NotificationDetailsDialog extends StatelessWidget {
  /// Constructor.
  const NotificationDetailsDialog({
    super.key,
    required this.item,
    required this.note,
    required this.onMarkAsRead,
    required this.onDelete,
    required this.onSaveNote,
  });

  /// The active notification item.
  final NotificationItem item;

  /// Existing local note associated with this item, or empty.
  final String note;

  /// Trigger callback to mark this item read.
  final VoidCallback onMarkAsRead;

  /// Trigger callback to delete this item.
  final VoidCallback onDelete;

  /// Trigger callback to update the local note text.
  final ValueChanged<String> onSaveNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final persianDate = DateFormatter.formatFriendly(item.createdAt);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.m)),
        ),
        title: Row(
          children: [
            _buildTypeIcon(context, item.type),
            const SizedBox(width: SpacingTokens.s),
            Expanded(
              child: Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.body,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: SpacingTokens.l),
              const Divider(),
              const SizedBox(height: SpacingTokens.s),
              _buildMetadataRow('تاریخ دریافت', persianDate, theme),
              const SizedBox(height: SpacingTokens.xs),
              _buildMetadataRow('نوع اعلان', _getTypeLabel(item.type), theme),
              if (note.isNotEmpty) ...[
                const SizedBox(height: SpacingTokens.m),
                Container(
                  padding: const EdgeInsets.all(SpacingTokens.s),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.15),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(RadiusTokens.s),
                    ),
                    border: Border.all(
                      color: theme.colorScheme.primaryContainer.withOpacity(
                        0.3,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'یادداشت شما:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.xxs),
                      Text(note, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.all(SpacingTokens.m),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'حذف',
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_note_outlined),
            tooltip: 'یادداشت',
            onPressed: () {
              Navigator.of(context).pop();
              _showAddNoteSheet(context);
            },
          ),
          if (!item.isRead)
            IconButton(
              icon: const Icon(Icons.mark_email_read_outlined),
              tooltip: 'خوانده شد',
              onPressed: () {
                Navigator.of(context).pop();
                onMarkAsRead();
              },
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeIcon(BuildContext context, NotificationType type) {
    final colorScheme = Theme.of(context).colorScheme;
    IconData iconData;
    Color color;

    switch (type) {
      case NotificationType.smsDetected:
        iconData = Icons.sms_outlined;
        color = colorScheme.secondary;
        break;
      case NotificationType.transactionProcessed:
        iconData = Icons.account_balance_wallet_outlined;
        color = Colors.green;
        break;
      case NotificationType.backupCompleted:
        iconData = Icons.backup_outlined;
        color = Colors.blue;
        break;
      case NotificationType.restoreCompleted:
        iconData = Icons.settings_backup_restore_outlined;
        color = Colors.teal;
        break;
      case NotificationType.securityAlerts:
        iconData = Icons.security_outlined;
        color = colorScheme.error;
        break;
      case NotificationType.authenticationEvents:
        iconData = Icons.fingerprint_outlined;
        color = colorScheme.primary;
        break;
      case NotificationType.systemNotifications:
        iconData = Icons.info_outline;
        color = colorScheme.outline;
        break;
      case NotificationType.warningNotifications:
        iconData = Icons.warning_amber_outlined;
        color = Colors.amber;
    }

    return Container(
      padding: const EdgeInsets.all(SpacingTokens.s),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 20.0),
    );
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.smsDetected:
        return 'پیامک دریافتی';
      case NotificationType.transactionProcessed:
        return 'تراکنش بانکی';
      case NotificationType.backupCompleted:
        return 'پشتیبان‌گیری';
      case NotificationType.restoreCompleted:
        return 'بازیابی داده';
      case NotificationType.securityAlerts:
        return 'امنیت سیستم';
      case NotificationType.authenticationEvents:
        return 'قفل و احراز هویت';
      case NotificationType.systemNotifications:
        return 'سیستم';
      case NotificationType.warningNotifications:
        return 'هشدار';
    }
  }

  void _showAddNoteSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RadiusTokens.l),
        ),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: _InlineBottomSheetContent(
            initialNote: note,
            onSave: onSaveNote,
          ),
        );
      },
    );
  }
}

class _InlineBottomSheetContent extends StatefulWidget {
  const _InlineBottomSheetContent({
    required this.initialNote,
    required this.onSave,
  });

  final String initialNote;
  final ValueChanged<String> onSave;

  @override
  State<_InlineBottomSheetContent> createState() =>
      _InlineBottomSheetContentState();
}

class _InlineBottomSheetContentState extends State<_InlineBottomSheetContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: SpacingTokens.l,
        right: SpacingTokens.l,
        top: SpacingTokens.l,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'افزودن یادداشت',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpacingTokens.m),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'متن یادداشت شما...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.s)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: SpacingTokens.m,
                vertical: SpacingTokens.s,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: SpacingTokens.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('انصراف'),
              ),
              const SizedBox(width: SpacingTokens.s),
              ElevatedButton(
                onPressed: () {
                  widget.onSave(_controller.text);
                  Navigator.of(context).pop();
                },
                child: const Text('ثبت یادداشت'),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.l),
        ],
      ),
    );
  }
}
