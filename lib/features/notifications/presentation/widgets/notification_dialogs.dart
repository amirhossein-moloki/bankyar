import 'package:flutter/material.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Interactive custom dialog requesting confirmation to permanently delete a single notification.
class DeleteNotificationDialog extends StatelessWidget {
  /// Constructor.
  const DeleteNotificationDialog({super.key, required this.onConfirm});

  /// Action callback executed upon user confirmation.
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.m)),
        ),
        title: Text(
          'حذف دائم اعلان؟',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'این عملیات قابل بازگشت نیست. آیا از حذف این اعلان مطمئن هستید؟',
          style: TextStyle(height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.l,
          vertical: SpacingTokens.s,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.s)),
              ),
            ),
            child: const Text('بله، حذف شود'),
          ),
        ],
      ),
    );
  }
}

/// Interactive custom dialog requesting confirmation to clear all notifications from history.
class ClearAllDialog extends StatelessWidget {
  /// Constructor.
  const ClearAllDialog({super.key, required this.onConfirm});

  /// Action callback executed upon user confirmation.
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.m)),
        ),
        title: Text(
          'پاک کردن کل تاریخچه؟',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'با این کار تمام تاریخچه اعلان‌های دریافتی شما به طور دائمی حذف خواهد شد. یادداشت‌ها و تراکنش‌های ثبت شده در دفترچه مالی شما بدون تغییر باقی می‌مانند.',
          style: TextStyle(height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.l,
          vertical: SpacingTokens.s,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(RadiusTokens.s)),
              ),
            ),
            child: const Text('تایید و پاک‌سازی کل تاریخچه'),
          ),
        ],
      ),
    );
  }
}

/// Lightweight modal bottom sheet containing a secure, RTL text input for writing annotations.
class InlineNoteBottomSheet extends StatefulWidget {
  /// Constructor.
  const InlineNoteBottomSheet({
    super.key,
    required this.initialNote,
    required this.onSave,
  });

  /// Existing note text if editing, or empty.
  final String initialNote;

  /// Callback executing note saving with updated text.
  final ValueChanged<String> onSave;

  @override
  State<InlineNoteBottomSheet> createState() => _InlineNoteBottomSheetState();
}

class _InlineNoteBottomSheetState extends State<InlineNoteBottomSheet> {
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
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
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'متن یادداشت یا برچسب تراکنش...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(RadiusTokens.s),
                  ),
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
      ),
    );
  }
}
