import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Financial Amount Input Field.
/// Follows BankYar design tokens, form policies, and accessibility.
class AmountInputField extends StatelessWidget {
  /// Constructor for AmountInputField.
  const AmountInputField({
    required this.label,
    required this.controller,
    required this.currencySymbol,
    super.key,
    this.errorText,
    this.onChanged,
  });

  /// Label of the field.
  final String label;

  /// Text controller.
  final TextEditingController controller;

  /// Currency symbol suffix (e.g. 'ریال' or 'تومان').
  final String currencySymbol;

  /// Optional error message.
  final String? errorText;

  /// Optional callback on text changes.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      textField: true,
      label: label,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixText: currencySymbol,
          suffixStyle: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
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
