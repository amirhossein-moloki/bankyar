import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Filter/Choice Chip.
/// Follows BankYar design tokens, RTL layouts, and accessibility.
class CustomChip extends StatelessWidget {
  /// Constructor for CustomChip.
  const CustomChip({
    required this.label,
    super.key,
    this.isSelected = false,
    this.onSelected,
    this.leading,
    this.onDeleted,
  });

  /// The text label inside the chip.
  final String label;

  /// Selected status flag.
  final bool isSelected;

  /// Selection toggle callback.
  final ValueChanged<bool>? onSelected;

  /// Optional leading icon widget.
  final Widget? leading;

  /// Optional trailing delete button action.
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      avatar: leading,
      onDeleted: onDeleted,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.s),
      ),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
