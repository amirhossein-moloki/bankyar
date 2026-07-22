import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Bottom Sheet template.
/// Follows BankYar design tokens, accessibility boundaries, and drag dismiss haptics.
class CustomBottomSheet extends StatelessWidget {
  /// Constructor for CustomBottomSheet.
  const CustomBottomSheet({required this.child, super.key, this.title});

  /// Custom layout list or column child to display inside the sheet.
  final Widget child;

  /// Optional title of bottom sheet.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.l),
          topRight: Radius.circular(radius.l),
        ),
      ),
      padding: EdgeInsets.only(
        left: spacing.l,
        right: spacing.l,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacing.l,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: spacing.s),
          // Drag handle indicator
          Center(
            child: Container(
              width: 32.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(radius.max),
              ),
            ),
          ),
          SizedBox(height: spacing.m),
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.m),
          ],
          child,
        ],
      ),
    );
  }
}
