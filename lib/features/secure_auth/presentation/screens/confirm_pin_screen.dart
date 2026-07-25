import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/presentation/widgets/navigation/custom_app_bar.dart';
import '../state/security_notifier.dart';
import '../widgets/pin_keypad.dart';

/// Screen guiding the user to retype and confirm their proposed PIN code, completing setup.
class ConfirmPinScreen extends ConsumerStatefulWidget {

  /// Constructor.
  const ConfirmPinScreen({super.key, required this.proposedPin});
  /// Proposed PIN code to match against.
  final String proposedPin;

  @override
  ConsumerState<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  String _confirmBuffer = '';
  String? _errorMessage;

  void _onDigit(String digit) async {
    if (_confirmBuffer.length >= 4) return;
    setState(() {
      _confirmBuffer += digit;
      _errorMessage = null;
    });

    if (_confirmBuffer.length == 4) {
      if (_confirmBuffer == widget.proposedPin) {
        // Matches! Setup PIN in SecurityNotifier
        final success = await ref
            .read(securityNotifierProvider.notifier)
            .setupPin(_confirmBuffer);

        if (success && mounted) {
          _showSetupSuccessDialog();
        } else if (mounted) {
          setState(() {
            _confirmBuffer = '';
            _errorMessage = 'خطایی در ثبت محلی پین‌کد رخ داد.';
          });
        }
      } else {
        // Mismatch!
        setState(() {
          _confirmBuffer = '';
          _errorMessage = 'پین‌کد تکرار شده مطابقت ندارد. مجدداً تلاش کنید.';
        });
      }
    }
  }

  void _onBackspace() {
    if (_confirmBuffer.isEmpty) return;
    setState(() {
      _confirmBuffer = _confirmBuffer.substring(0, _confirmBuffer.length - 1);
    });
  }

  void _showSetupSuccessDialog() {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;
    final spacing = theme.extension<SpacingExtension>()!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.l),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.s),
              const Text('پین‌کد فعال شد'),
            ],
          ),
          content: const Text(
            'کد عبور ۴ رقمی شما با موفقیت به صورت رمزنگاری شده ذخیره شد. از این پس برای ورود به برنامه به این کد نیاز دارید.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Pop dialog and pop back twice to return to settings
                Navigator.pop(context); // dialog
                Navigator.pop(context); // ConfirmPinScreen
                Navigator.pop(context); // CreatePinScreen
              },
              child: const Text('تایید و بازگشت'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Scaffold(
      appBar: const CustomAppBar(title: 'تأیید پین‌کد امنیتی'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing.xl),
            Icon(
              Icons.verified_user_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: spacing.m),
            Text(
              'تأیید پین‌کد',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            Text(
              'لطفاً پین‌کد خود را مجدداً وارد کنید تا از صحت آن اطمینان حاصل شود.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: spacing.s),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: spacing.xl),
            _buildPinDots(_confirmBuffer, spacing, theme),
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
