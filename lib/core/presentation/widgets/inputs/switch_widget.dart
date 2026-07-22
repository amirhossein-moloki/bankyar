import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';
import '../../../theme/spacing_tokens.dart';

/// A production-ready Material 3 Switch Row widget.
/// Follows BankYar design tokens, RTL layout, and accessibility.
class SwitchWidget extends StatelessWidget {
  /// Constructor for SwitchWidget.
  const SwitchWidget({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Descriptive label next to the switch toggle.
  final String label;

  /// Active status of switch.
  final bool value;

  /// Callback when switched.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      button: true,
      selected: value,
      label: label,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(radius.s),
        child: Container(
          height: 48.0, // Minimum accessibility touch target
          padding: EdgeInsets.symmetric(horizontal: spacing.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
