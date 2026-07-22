import 'package:flutter/material.dart';

/// A production-ready Material 3 Divider wrapper.
/// Follows BankYar design tokens and accessibility guidelines.
class CustomDivider extends StatelessWidget {
  /// Constructor for CustomDivider.
  const CustomDivider({super.key, this.indent = 0.0, this.endIndent = 0.0});

  /// The leading offset padding.
  final double indent;

  /// The trailing offset padding.
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Separator',
      child: Divider(
        height: 1.0,
        thickness: 1.0,
        indent: indent,
        endIndent: endIndent,
        color: theme.colorScheme.outline.withOpacity(0.12),
      ),
    );
  }
}
