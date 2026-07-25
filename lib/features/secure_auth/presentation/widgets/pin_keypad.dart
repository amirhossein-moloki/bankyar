import 'package:flutter/material.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Highly accessible, Material Design 3 compliant PIN entry keypad supporting
/// native RTL mirrored layouts, semantic screen-reader labels, and custom accessory actions.
class PinKeypad extends StatelessWidget {

  /// Constructor.
  const PinKeypad({
    super.key,
    required this.onDigitTap,
    required this.onBackspaceTap,
    this.leftAccessory,
    this.rightAccessory,
  });
  /// Callback when a numeric digit is tapped.
  final ValueChanged<String> onDigitTap;

  /// Callback when the backspace button is tapped.
  final VoidCallback onBackspaceTap;

  /// Optional widget for the bottom-left accessory slot (e.g. biometric scanner icon).
  final Widget? leftAccessory;

  /// Optional widget for the bottom-right accessory slot (e.g. confirm action).
  final Widget? rightAccessory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    // Numbers mapped from right to left in RTL, or normal order.
    // Standard phone dial layout grid.
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Directionality(
      textDirection: TextDirection
          .rtl, // Enforce RTL direction for consistent keypad layout
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: spacing.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...rows.map(
              (row) => Padding(
                padding: EdgeInsets.only(bottom: spacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row
                      .map(
                        (digit) => _KeypadButton(
                          label: digit,
                          onTap: () => onDigitTap(digit),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                leftAccessory ?? const SizedBox(width: 72, height: 72),
                _KeypadButton(label: '0', onTap: () => onDigitTap('0')),
                rightAccessory ??
                    _KeypadIconButton(
                      icon: Icons.backspace_outlined,
                      onTap: onBackspaceTap,
                      semanticLabel: 'پاک کردن رقم قبل',
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {

  const _KeypadButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'رقم $label',
      button: true,
      child: SizedBox(
        width: 72,
        height: 72,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            label,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _KeypadIconButton extends StatelessWidget {

  const _KeypadIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: semanticLabel,
      button: true,
      child: SizedBox(
        width: 72,
        height: 72,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              size: 26,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
