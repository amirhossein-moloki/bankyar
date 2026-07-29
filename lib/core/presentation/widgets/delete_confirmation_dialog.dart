import 'package:flutter/material.dart';

/// Reusable production-grade Material Design 3 Delete Confirmation Dialog.
/// Fully RTL compliant and accessible, prevents accidental double taps.
class DeleteConfirmationDialog extends StatefulWidget {
  /// Constructor.
  const DeleteConfirmationDialog({
    required this.onConfirm,
    this.title = 'حذف اطلاعات',
    this.message =
        'آیا از حذف این مورد اطمینان دارید؟ این عملیات قابل بازگردانی نخواهد بود.',
    super.key,
  });

  /// Triggered once when the delete action is confirmed.
  final VoidCallback onConfirm;

  /// Optional custom title, defaults to 'حذف اطلاعات'.
  final String title;

  /// Optional custom message, defaults to the standard warning.
  final String message;

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          widget.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(widget.message, style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: const Text('لغو'),
          ),
          TextButton(
            onPressed: _isProcessing
                ? null
                : () {
                    setState(() {
                      _isProcessing = true;
                    });
                    Navigator.pop(context);
                    widget.onConfirm();
                  },
            child: Text(
              'حذف',
              style: TextStyle(
                color: _isProcessing
                    ? theme.colorScheme.error.withOpacity(0.5)
                    : theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
