import 'package:flutter/material.dart';

/// A production-ready Material 3 App Bar.
/// Follows BankYar design tokens, navigation, and accessibility.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Constructor for CustomAppBar.
  const CustomAppBar({
    required this.title,
    super.key,
    this.showBackButton = true,
    this.actions,
    this.onBackPress,
  });

  /// The screen title text.
  final String title;

  /// Whether to display a standard back navigation arrow.
  final bool showBackButton;

  /// Optional list of trailing actions.
  final List<Widget>? actions;

  /// Optional back press callback overlay.
  final VoidCallback? onBackPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton && Navigator.of(context).canPop()
          ? Semantics(
              label: 'Back',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPress ?? () => Navigator.of(context).pop(),
              ),
            )
          : null,
      actions: actions,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
