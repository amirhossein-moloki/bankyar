import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready helper to build styled Snackbars.
/// Follows BankYar design tokens and accessibility guidelines.
abstract class CustomSnackbar {
  /// Builds a standard Material 3 [SnackBar] for notification.
  static SnackBar build({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return SnackBar(
      backgroundColor: isError
          ? theme.colorScheme.error
          : theme.colorScheme.inverseSurface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
      ),
      margin: EdgeInsets.all(spacing.m),
      content: Semantics(
        liveRegion: true,
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isError
                ? theme.colorScheme.onError
                : theme.colorScheme.onInverseSurface,
          ),
        ),
      ),
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: isError
                  ? theme.colorScheme.onError
                  : theme.colorScheme.inversePrimary,
              onPressed: onAction,
            )
          : null,
    );
  }
}
