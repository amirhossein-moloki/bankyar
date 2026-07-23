import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Checkbox Row widget.
/// Follows BankYar design tokens, RTL direction, and accessibility.
class CheckboxWidget extends StatelessWidget {
  /// Constructor for CheckboxWidget.
  const CheckboxWidget({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Label displaying next to the checkbox.
  final String label;

  /// Whether checkbox is selected.
  final bool value;

  /// Callback when selected state changes.
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      checked: value,
      label: label,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(radius.s),
        child: Container(
          height: 48.0, // Minimum accessibility touch target
          padding: EdgeInsets.symmetric(horizontal: spacing.s),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.xs),
                ),
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
