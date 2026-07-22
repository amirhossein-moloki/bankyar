import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Alert Dialog.
/// Follows BankYar design tokens, RTL action alignments, and accessibility.
class CustomDialog extends StatelessWidget {
  /// Constructor for CustomDialog.
  const CustomDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    super.key,
    this.cancelLabel,
    this.onCancel,
  });

  /// The bold title of the prompt.
  final String title;

  /// Detailed descriptive explanation.
  final String message;

  /// Label for confirm button action.
  final String confirmLabel;

  /// Callback on confirming action.
  final VoidCallback onConfirm;

  /// Optional label for cancel action.
  final String? cancelLabel;

  /// Optional callback on canceling action.
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return AlertDialog(
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(message, style: theme.textTheme.bodyMedium),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.l),
      ),
      actionsPadding: EdgeInsets.only(
        left: spacing.l,
        right: spacing.l,
        bottom: spacing.l,
      ),
      actions: [
        if (cancelLabel != null)
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(cancelLabel!),
          ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.m),
            ),
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
