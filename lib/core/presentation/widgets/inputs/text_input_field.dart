import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Outlined Text Field.
/// Follows BankYar design tokens and form guidelines.
class TextInputField extends StatelessWidget {
  /// Constructor for TextInputField.
  const TextInputField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  /// Label of the field.
  final String label;

  /// Text controller.
  final TextEditingController controller;

  /// Optional hint text.
  final String? hintText;

  /// Optional error message.
  final String? errorText;

  /// Obscure text flag (useful for password/credentials).
  final bool obscureText;

  /// Keyboard layout type.
  final TextInputType keyboardType;

  /// Optional widget displayed at the start.
  final Widget? prefixIcon;

  /// Optional widget displayed at the end.
  final Widget? suffixIcon;

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
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
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
