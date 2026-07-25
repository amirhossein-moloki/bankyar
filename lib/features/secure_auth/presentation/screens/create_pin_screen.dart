import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/presentation/widgets/navigation/custom_app_bar.dart';
import '../widgets/pin_keypad.dart';
import 'confirm_pin_screen.dart';

/// Screen guiding the user to enter their proposed 4-digit PIN for the first time.
class CreatePinScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String _pinBuffer = '';

  void _onDigit(String digit) {
    if (_pinBuffer.length >= 4) return;
    setState(() {
      _pinBuffer += digit;
    });

    if (_pinBuffer.length == 4) {
      final pin = _pinBuffer;
      setState(() {
        _pinBuffer = '';
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPinScreen(proposedPin: pin),
        ),
      );
    }
  }

  void _onBackspace() {
    if (_pinBuffer.isEmpty) return;
    setState(() {
      _pinBuffer = _pinBuffer.substring(0, _pinBuffer.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Scaffold(
      appBar: const CustomAppBar(title: 'ایجاد پین‌کد امنیتی'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing.xl),
            Icon(
              Icons.password_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: spacing.m),
            Text(
              'کد عبور ۴ رقمی جدیدی وارد کنید',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            Text(
              'این کد عبور برای قفل‌گشایی‌های بعدی برنامه به صورت محلی استفاده می‌شود.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: spacing.xl),
            _buildPinDots(_pinBuffer, spacing, theme),
            const Spacer(),
            PinKeypad(onDigitTap: _onDigit, onBackspaceTap: _onBackspace),
            SizedBox(height: spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots(String pin, SpacingExtension spacing, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < pin.length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(horizontal: spacing.xs),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            border: Border.all(color: theme.colorScheme.primary, width: 1.5),
          ),
        );
      }),
    );
  }
}
