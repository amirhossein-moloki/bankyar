import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// Reusable drawer item model.
class DrawerItem {
  /// Constructor.
  const DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  /// Label of the item.
  final String title;

  /// Leading icon.
  final Widget icon;

  /// Selection callback.
  final VoidCallback onTap;
}

/// A production-ready Material 3 Navigation Slide-out Drawer.
/// Follows BankYar design tokens, accessibility, and RTL boundaries.
class CustomDrawer extends StatelessWidget {
  /// Constructor for CustomDrawer.
  const CustomDrawer({required this.items, super.key, this.header});

  /// Optional header layout block.
  final Widget? header;

  /// Navigation choices.
  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius.none),
          bottomLeft: Radius.circular(radius.none),
          topRight: Radius.circular(radius.l),
          bottomRight: Radius.circular(radius.l),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) ...[
              header!,
              Divider(color: theme.colorScheme.outline.withOpacity(0.12)),
            ],
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.m,
                  vertical: spacing.s,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    leading: item.icon,
                    title: Text(
                      item.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: item.onTap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.m),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
