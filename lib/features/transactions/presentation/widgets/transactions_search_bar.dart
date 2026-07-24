import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Search input bar for the transactions feature.
class TransactionsSearchBar extends StatelessWidget {
  /// Constructor.
  const TransactionsSearchBar({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    super.key,
  });

  /// Text controller.
  final TextEditingController controller;

  /// Placeholder hint text.
  final String hintText;

  /// Callback on query changed.
  final ValueChanged<String> onChanged;

  /// Callback on query cleared.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: SearchInputField(
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
        onClear: onClear,
      ),
    );
  }
}
