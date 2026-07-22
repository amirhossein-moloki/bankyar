import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready Material 3 Search Input Field.
/// Follows BankYar design tokens and accessibility guidelines.
class SearchInputField extends StatefulWidget {
  /// Constructor for SearchInputField.
  const SearchInputField({
    required this.controller,
    required this.hintText,
    super.key,
    this.onChanged,
    this.onClear,
  });

  /// Text controller.
  final TextEditingController controller;

  /// The search placeholder hint.
  final String hintText;

  /// Optional callback on query change.
  final ValueChanged<String>? onChanged;

  /// Optional callback on clearing search text.
  final VoidCallback? onClear;

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      label: widget.hintText,
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyLarge,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    if (widget.onClear != null) widget.onClear!();
                    if (widget.onChanged != null) widget.onChanged!('');
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.xl),
            borderSide: BorderSide.none,
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
