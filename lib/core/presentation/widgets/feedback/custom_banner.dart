import 'package:flutter/material.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Inline Alert Banner.
/// Follows BankYar design tokens, accessibility, and RTL constraints.
class CustomBanner extends StatelessWidget {
  /// Constructor for CustomBanner.
  const CustomBanner({
    required this.message,
    required this.actions,
    super.key,
    this.icon,
    this.backgroundColor,
  });

  /// Main message text.
  final String message;

  /// Actions list (usually TextButtons).
  final List<Widget> actions;

  /// Optional leading icon.
  final Widget? icon;

  /// Custom background overlay.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Semantics(
      container: true,
      liveRegion: true,
      child: MaterialBanner(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        leading: icon,
        actions: actions,
        backgroundColor:
            backgroundColor ?? theme.colorScheme.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        dividerColor: theme.colorScheme.outline.withOpacity(0.12),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.l,
          vertical: spacing.s,
        ),
      ),
    );
  }
}
