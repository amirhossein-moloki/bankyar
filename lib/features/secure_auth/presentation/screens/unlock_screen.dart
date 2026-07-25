// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../state/app_lock_coordinator.dart';
import '../widgets/pin_keypad.dart';

/// Central screen representing the application's secure gate, preventing unauthorized
/// access and displaying lockout states, dynamic timer tickers, or seed-phrase recovery forms.
class UnlockScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  bool _isRecoveryMode = false;
  final List<TextEditingController> _wordControllers = List.generate(
    12,
    (_) => TextEditingController(),
  );
  Timer? _countdownTicker;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _startCountdownCheck();
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    for (final controller in _wordControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startCountdownCheck() {
    _countdownTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final session = ref.read(appLockCoordinatorProvider).session;
      if (session.isLockedOut) {
        setState(() {
          _secondsLeft = session.lockoutUntil!
              .difference(DateTime.now())
              .inSeconds;
        });
      } else {
        setState(() {
          _secondsLeft = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(appLockCoordinatorProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;

    return Scaffold(
      appBar: CustomAppBar(
        title: _isRecoveryMode ? 'بازیابی رمز عبور' : 'قفل‌گشایی بانک‌یار',
        showBackButton: _isRecoveryMode,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isRecoveryMode
              ? _buildRecoveryLayout(spacing, radius, theme)
              : _buildStandardUnlockLayout(authState, spacing, radius, theme),
        ),
      ),
    );
  }

  Widget _buildStandardUnlockLayout(
    AppLockState authState,
    SpacingExtension spacing,
    RadiusExtension radius,
    ThemeData theme,
  ) {
    final isLockedOut = authState.session.isLockedOut || _secondsLeft > 0;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: spacing.xl),
          Icon(
            Icons.lock_person_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: spacing.m),
          Text(
            isLockedOut
                ? 'امکان ورود موقتاً مسدود است'
                : 'کد عبور ۴ رقمی خود را وارد کنید',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLockedOut
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: spacing.s),
          if (authState.errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.m),
              child: Text(
                authState.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(height: spacing.l),
          if (isLockedOut)
            _buildLockoutTimerCard(spacing, radius, theme)
          else
            _buildPinDots(authState.currentInputPin, spacing, theme),
          SizedBox(height: spacing.xl),
          if (!isLockedOut)
            PinKeypad(
              onDigitTap: (digit) => ref
                  .read(appLockCoordinatorProvider.notifier)
                  .appendDigit(digit),
              onBackspaceTap: () =>
                  ref.read(appLockCoordinatorProvider.notifier).backspace(),
              leftAccessory: IconButton(
                icon: Icon(
                  Icons.fingerprint_outlined,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () async {
                  final success = await ref
                      .read(appLockCoordinatorProvider.notifier)
                      .authenticateBiometrics();
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('برنامه با موفقیت قفل‌گشایی شد'),
                      ),
                    );
                  }
                },
              ),
              rightAccessory: TextButton(
                onPressed: () {
                  setState(() {
                    _isRecoveryMode = true;
                  });
                },
                child: const Text(
                  'فراموشی؟',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          SizedBox(height: spacing.xl),
        ],
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

  Widget _buildLockoutTimerCard(
    SpacingExtension spacing,
    RadiusExtension radius,
    ThemeData theme,
  ) {
    return Card(
      margin: EdgeInsets.all(spacing.m),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.error, width: 1.5),
      ),
      elevation: 0,
      color: theme.colorScheme.errorContainer.withOpacity(0.12),
      child: Padding(
        padding: EdgeInsets.all(spacing.l),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_disabled_outlined,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: spacing.s),
                Text(
                  'تلاش بیش از حد ناموفق',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.s),
            Text(
              'به دلیل ملاحظات امنیتی، تا پایان ثانیه‌شمار امکان ورود وجود ندارد:',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: spacing.m),
            Text(
              '$_secondsLeft ثانیه',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryLayout(
    SpacingExtension spacing,
    RadiusExtension radius,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.m),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: spacing.s),
                Text(
                  'بازیابی با کلمات پشتیبان',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  'لطفاً کلمات پشتیبان ۱۲گانه خود را با دقت و به ترتیب وارد کنید تا رمز عبور شما بازنشانی شود.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: spacing.m),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.2,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return TextInputField(
                controller: _wordControllers[index],
                label: 'کلمه ${index + 1}',
              );
            }, childCount: 12),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: spacing.l),
                PrimaryButton(
                  label: 'بررسی و تایید کلمات بازیابی',
                  onPressed: () async {
                    final words = _wordControllers
                        .map((c) => c.text.trim())
                        .toList();
                    final success = await ref
                        .read(appLockCoordinatorProvider.notifier)
                        .recoverWithSeedWords(words);

                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'اعتبارسنجی کلمات با موفقیت انجام شد. پین‌کد غیرفعال شد.',
                          ),
                        ),
                      );
                      setState(() {
                        _isRecoveryMode = false;
                      });
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'کلمات پشتیبان مطابقت ندارند یا نامعتبر هستند.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: spacing.s),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isRecoveryMode = false;
                    });
                  },
                  child: const Text('بازگشت به قفل صفحه'),
                ),
                SizedBox(height: spacing.m),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
