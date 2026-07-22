import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Dropdown Field.
/// Follows BankYar design tokens and accessibility guidelines.
class DropdownField<T> extends StatelessWidget {
  /// Constructor for DropdownField.
  const DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  /// The label displaying above or inside the field.
  final String label;

  /// The currently selected value of type [T].
  final T? value;

  /// The list of items to display in the dropdown.
  final List<DropdownMenuItem<T>> items;

  /// The callback to execute on selection change.
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      label: label,
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.m),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
      ),
    );
  }
}
