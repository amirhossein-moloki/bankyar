import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 List Tile.
/// Follows BankYar design tokens, RTL layouts, and accessibility.
class CustomListTile extends StatelessWidget {
  /// Constructor for CustomListTile.
  const CustomListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  /// The main prominent label text.
  final String title;

  /// Optional secondary supporting text.
  final String? subtitle;

  /// Optional widget displayed at the start (e.g. icon or avatar).
  final Widget? leading;

  /// Optional widget displayed at the end (e.g. toggle switch or arrow).
  final Widget? trailing;

  /// Optional item tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      label: subtitle != null ? '$title: $subtitle' : title,
      child: ListTile(
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.m),
        ),
      ),
    );
  }
}
