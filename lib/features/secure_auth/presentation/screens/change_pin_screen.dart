import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../../../core/presentation/widgets/navigation/custom_app_bar.dart';
import '../../data/repositories/security_repository_provider.dart';
import '../state/security_notifier.dart';
import '../widgets/pin_keypad.dart';

/// Screen guiding the user through changing their existing security PIN.
class ChangePinScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  int _step = 1; // 1: Old PIN, 2: New PIN, 3: Confirm New PIN
  String _newPin = '';
  String _buffer = '';
  String? _errorMessage;

  void _onDigit(String digit) async {
    if (_buffer.length >= 4) return;
    setState(() {
      _buffer += digit;
      _errorMessage = null;
    });

    if (_buffer.length == 4) {
      if (_step == 1) {
        // Step 1: Verify old PIN
        final repo = ref.read(securityRepositoryProvider);
        final verifyRes = await repo.verifyPin(_buffer);

        if (verifyRes.isSuccess && verifyRes.successOrCrash) {
          setState(() {
            _buffer = '';
            _step = 2;
          });
        } else {
          setState(() {
            _buffer = '';
            _errorMessage = 'پین‌کد فعلی وارد شده نادرست است.';
          });
        }
      } else if (_step == 2) {
        // Step 2: Save new PIN temporarily
        setState(() {
          _newPin = _buffer;
          _buffer = '';
          _step = 3;
        });
      } else if (_step == 3) {
        // Step 3: Match and save new PIN
        if (_buffer == _newPin) {
          final success = await ref
              .read(securityNotifierProvider.notifier)
              .setupPin(_newPin);

          if (success && mounted) {
            _showSuccessDialog();
          } else if (mounted) {
            setState(() {
              _buffer = '';
              _errorMessage = 'خطایی در به‌روزرسانی پین‌کد رخ داد.';
            });
          }
        } else {
          setState(() {
            _buffer = '';
            _errorMessage = 'پین‌کد جدید تکرار شده مطابقت ندارد.';
          });
        }
      }
    }
  }

  void _onBackspace() {
    if (_buffer.isEmpty) return;
    setState(() {
      _buffer = _buffer.substring(0, _buffer.length - 1);
    });
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;
    final spacing = theme.extension<SpacingExtension>()!;

    showDialog<void>(
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
              const Text('پین‌کد تغییر یافت'),
            ],
          ),
          content: const Text(
            'کد عبور ۴ رقمی جدید شما با موفقیت به صورت رمزنگاری شده به‌روزرسانی و ذخیره شد.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // ChangePinScreen
              },
              child: const Text('تایید و بازگشت'),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeadlineText() {
    switch (_step) {
      case 1:
        return 'رمز عبور فعلی خود را وارد کنید';
      case 2:
        return 'رمز عبور جدید را وارد کنید';
      case 3:
        return 'رمز عبور جدید را تکرار کنید';
      default:
        return '';
    }
  }

  String _getSubtitleText() {
    switch (_step) {
      case 1:
        return 'جهت تایید هویت، نیاز است رمز عبور فعلی خود را وارد کنید.';
      case 2:
        return 'یک کد عبور ۴ رقمی جدید و ایمن انتخاب کنید.';
      case 3:
        return 'لطفاً رمز عبور جدید را مجدداً تکرار کنید.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Scaffold(
      appBar: const CustomAppBar(title: 'تغییر پین‌کد امنیتی'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing.xl),
            Icon(
              Icons.lock_reset_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: spacing.m),
            Text(
              _getHeadlineText(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            Text(
              _getSubtitleText(),
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
            _buildPinDots(_buffer, spacing, theme),
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
