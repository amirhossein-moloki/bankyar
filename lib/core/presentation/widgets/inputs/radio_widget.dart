import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Radio Row widget.
/// Follows BankYar design tokens, RTL layout, and accessibility.
class RadioWidget<T> extends StatelessWidget {
  /// Constructor for RadioWidget.
  const RadioWidget({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  /// Label next to the radio circle.
  final String label;

  /// The unique value of this radio option.
  final T value;

  /// The active group value.
  final T? groupValue;

  /// Callback when selected.
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    final isSelected = value == groupValue;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(radius.s),
        child: Container(
          height: 48.0, // Minimum accessibility touch target
          padding: EdgeInsets.symmetric(horizontal: spacing.s),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.xs),
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
