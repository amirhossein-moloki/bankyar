// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/platform/permission.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../secure_auth/presentation/state/security_notifier.dart';
import '../../../secure_auth/presentation/widgets/pin_keypad.dart';

/// Comprehensive, production-grade 12-screen Onboarding & Permission Experience system.
/// Adheres strictly to ONBOARDING_PERMISSION_SCREEN_SPECIFICATION.md and Material Design 3.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => OnboardingScreenState();
}

/// Public state class of [OnboardingScreen] to facilitate clean advanced testing of wizard steps.
class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentPage = 0;
  Timer? _splashTimer;

  // Step 3 state
  bool _isPrivacyAccepted = false;

  // Step 6 & 7 state
  PermissionStatus _smsStatus = PermissionStatus.denied;
  PermissionStatus _notifStatus = PermissionStatus.denied;

  // Step 10 PIN state
  String _pinBuffer = '';
  String _confirmBuffer = '';
  int _pinStep = 1; // 1: Enter proposed PIN, 2: Confirm PIN
  String? _pinError;

  // Step 11 Database preparation checklist state
  final List<String> _checklistSteps = [
    'ایجاد کلید رمزنگاری سخت‌افزاری Keystore...',
    'ساخت و پایدارسازی جداول پایگاه داده SQLCipher...',
    'ایجاد نمای جستجوی سریع متنی FTS4...',
    'راه‌اندازی موتور تحلیل آفلاین پیامک‌ها...',
    'صندوقچه امن شما با موفقیت آماده شد!',
  ];
  int _checklistActiveStep = 0;
  Timer? _dbPrepTimer;

  /// Expose the current step page index.
  int get currentPage => _currentPage;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
    _handlePageTransitions();
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _dbPrepTimer?.cancel();
    super.dispose();
  }

  void _checkInitialPermissions() async {
    final permService = ref.read(permissionServiceProvider);
    final sms = await permService.checkStatus(AppPermission.smsRead);
    final checkedNotif = await permService.checkStatus(
      AppPermission.notifications,
    );
    if (mounted) {
      setState(() {
        _smsStatus = sms;
        _notifStatus = checkedNotif;
      });
    }
  }

  void _handlePageTransitions() {
    // If we are on Step 0 (Splash), auto progress to Step 1 after 2 seconds
    if (_currentPage == 0) {
      _splashTimer = Timer(const Duration(seconds: 2), () {
        if (mounted && _currentPage == 0) {
          nextPage();
        }
      });
    }
  }

  /// Instantly jump to a specific page slide. Helpful for deterministic testing.
  void jumpToPage(int page) {
    setState(() {
      _currentPage = page;
    });
    _handlePageTransitions();
  }

  /// Advance to the next page.
  void nextPage() {
    if (_currentPage < 11) {
      setState(() {
        _currentPage++;
      });
    }
  }

  /// Return to the previous page.
  void prevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  /// Skip the education steps straight to PIN configuration setup.
  void skipOnboarding() {
    setState(() {
      _currentPage = 10;
    });
  }

  Future<void> _requestSmsPermission() async {
    final permService = ref.read(permissionServiceProvider);
    final result = await permService.request(AppPermission.smsRead);
    if (mounted) {
      setState(() {
        _smsStatus = result;
      });
      if (result == PermissionStatus.granted) {
        nextPage();
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    final permService = ref.read(permissionServiceProvider);
    final result = await permService.request(AppPermission.notifications);
    if (mounted) {
      setState(() {
        _notifStatus = result;
      });
      nextPage();
    }
  }

  void _onPinDigit(String digit) async {
    if (_pinStep == 1) {
      if (_pinBuffer.length >= 4) return;
      setState(() {
        _pinBuffer += digit;
      });
      if (_pinBuffer.length == 4) {
        setState(() {
          _pinStep = 2;
        });
      }
    } else {
      if (_confirmBuffer.length >= 4) return;
      setState(() {
        _confirmBuffer += digit;
        _pinError = null;
      });
      if (_confirmBuffer.length == 4) {
        if (_confirmBuffer == _pinBuffer) {
          // Setup PIN in notifier
          final success = await ref
              .read(securityNotifierProvider.notifier)
              .setupPin(_confirmBuffer);
          if (success && mounted) {
            nextPage();
            _startDbPreparationSimulator();
          } else if (mounted) {
            setState(() {
              _confirmBuffer = '';
              _pinBuffer = '';
              _pinStep = 1;
              _pinError = 'خطایی در ثبت امن پین‌کد رخ داد.';
            });
          }
        } else {
          setState(() {
            _confirmBuffer = '';
            _pinError = 'کدهای عبور وارد شده مطابقت ندارند. از اول تکرار کنید.';
            _pinBuffer = '';
            _pinStep = 1;
          });
        }
      }
    }
  }

  void _onPinBackspace() {
    if (_pinStep == 1) {
      if (_pinBuffer.isEmpty) return;
      setState(() {
        _pinBuffer = _pinBuffer.substring(0, _pinBuffer.length - 1);
      });
    } else {
      if (_confirmBuffer.isEmpty) return;
      setState(() {
        _confirmBuffer = _confirmBuffer.substring(0, _confirmBuffer.length - 1);
      });
    }
  }

  void _startDbPreparationSimulator() {
    _checklistActiveStep = 0;
    _dbPrepTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          if (_checklistActiveStep < _checklistSteps.length - 1) {
            _checklistActiveStep++;
          } else {
            _dbPrepTimer?.cancel();
          }
        });
      }
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = ref.read(preferencesStorageProvider);
    await prefs.setBool('by_onboarding_completed', true);
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return WillPopScope(
      onWillPop: () async {
        if (_currentPage > 0) {
          prevPage();
          return false;
        }
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Zone A: Segmented progress & Header Controls
                if (_currentPage > 0) _buildZoneA(theme, spacing),

                // Zone B: Central Content Workspace (Scrollable/PageView)
                Expanded(
                  child: IndexedStack(
                    index: _currentPage,
                    children: [
                      _buildSplashSlide(theme, spacing),
                      _buildWelcomeSlide(theme, spacing),
                      _buildCoreBenefitsSlide(theme, spacing),
                      _buildPrivacyCommitmentSlide(theme, spacing),
                      _buildOfflineExplanationSlide(theme, spacing),
                      _buildSmsProcessingExplanationSlide(theme, spacing),
                      _buildWhySmsPermissionSlide(theme, spacing),
                      _buildNotificationBenefitsSlide(theme, spacing),
                      _buildSecurityOverviewSlide(theme, spacing),
                      _buildFeatureHighlightsSlide(theme, spacing),
                      _buildPinSetupSlide(theme, spacing),
                      _buildPermissionPreparationSlide(theme, spacing),
                    ],
                  ),
                ),

                // Zone C: Persistent Privacy trust seal
                if (_currentPage > 0 && _currentPage < 10)
                  _buildPrivacyTrustSeal(theme, spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoneA(ThemeData theme, SpacingExtension spacing) {
    // Don't show header controls on splash, PIN configuration or database compilation slides
    final isSkipAvailable =
        _currentPage > 1 &&
        _currentPage != 3 && // Privacy terms mandatory
        _currentPage != 6 && // SMS permission mandatory
        _currentPage < 10;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
      child: Column(
        children: [
          // Segmented progress indicator
          Row(
            children: List.generate(11, (index) {
              final isCompleted = index < _currentPage;
              final isActive = index == _currentPage - 1;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: spacing.xxs),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : (isActive
                              ? theme.colorScheme.primary.withOpacity(0.5)
                              : theme.colorScheme.outlineVariant),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: spacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: prevPage,
              ),
              if (isSkipAvailable)
                TextButton(
                  onPressed: skipOnboarding,
                  child: const Text(
                    'رد شدن',
                    style: TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTrustSeal(ThemeData theme, SpacingExtension spacing) {
    final semanticColors = theme.extension<SemanticColorExtension>()!;
    return Padding(
      padding: EdgeInsets.all(spacing.m),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.m,
          vertical: spacing.xs,
        ),
        decoration: BoxDecoration(
          color: semanticColors.success.withOpacity(0.08),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: semanticColors.success.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 14,
              color: semanticColors.success,
            ),
            SizedBox(width: spacing.xs),
            Text(
              'کاملاً آفلاین و رمزگذاری‌شده',
              style: theme.textTheme.labelSmall?.copyWith(
                color: semanticColors.success,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SLIDE BUILDERS ---

  Widget _buildSplashSlide(ThemeData theme, SpacingExtension spacing) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_person_outlined,
            size: 96,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: spacing.l),
          Text(
            'بانک‌یار',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontFamily: 'Vazirmatn',
            ),
          ),
          SizedBox(height: spacing.s),
          Text(
            'صندوقچه شخصی مالی کاملاً آفلاین',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'Vazirmatn',
            ),
          ),
          SizedBox(height: spacing.giant),
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSlide(ThemeData theme, SpacingExtension spacing) {
    return _buildSlideSkeleton(
      title: 'به بانک‌یار خوش آمدید',
      subtitle:
          'پلتفرم هوشمند مدیریت و پایش پیامک‌های بانکی بدون نیاز به اینترنت و اشتراک‌گذاری داده‌ها.',
      illustration: Icons.account_balance_wallet_outlined,
      theme: theme,
      spacing: spacing,
      bottomAction: PrimaryButton(
        label: 'شروع راه‌اندازی امن',
        onPressed: nextPage,
      ),
    );
  }

  Widget _buildCoreBenefitsSlide(ThemeData theme, SpacingExtension spacing) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'ارزش‌های محوری صندوق مالی',
      subtitle: 'سه رکن اساسی که امنیت و شفافیت مالی شما را تضمین می‌کنند.',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildBenefitCard(
              Icons.security_outlined,
              'صندوقچه پولادین (The Stoic Vault)',
              'اطلاعات شما ۱۰۰٪ متعلق به خودتان است و هرگز از تراشه دستگاه شما خارج نخواهد شد.',
              theme,
              spacing,
              radius,
            ),
            SizedBox(height: spacing.s),
            _buildBenefitCard(
              Icons.analytics_outlined,
              'تحلیلگر دقیق (High-Precision Analyst)',
              'پردازش خودکار پیامک‌ها، محاسبه درآمد و هزینه با موتور تطبیق دقیق عبارات.',
              theme,
              spacing,
              radius,
            ),
            SizedBox(height: spacing.s),
            _buildBenefitCard(
              Icons.spa_outlined,
              'یار آرامش‌بخش (The Calm Companion)',
              'رابط کاربری تیره، کنترل متمرکز و بدون استرس بر روی اهداف مالی شما.',
              theme,
              spacing,
              radius,
            ),
          ],
        ),
      ),
      bottomAction: PrimaryButton(label: 'ادامه مسیر', onPressed: nextPage),
    );
  }

  Widget _buildPrivacyCommitmentSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'تعهدنامه حریم خصوصی',
      subtitle:
          'امنیت اطلاعات شما، خط قرمز ماست. ما تعهدات زیر را برای حریم خصوصی شما لازم‌الاجرا می‌دانیم.',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.m),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: ListView(
                  padding: EdgeInsets.all(spacing.m),
                  children: [
                    _buildPrivacyCommitmentPoint(
                      'عدم دسترسی به اینترنت',
                      'برنامه فاقد مجوز دسترسی به اینترنت بوده و امکان خروج داده به هیچ صورتی وجود ندارد.',
                    ),
                    const Divider(),
                    _buildPrivacyCommitmentPoint(
                      'عدم ردیابی ابری',
                      'هیچ سیستم تحلیل ابری، کوکی یا ردیابی در پس‌زمینه بانک‌یار تعبیه نشده است.',
                    ),
                    const Divider(),
                    _buildPrivacyCommitmentPoint(
                      'رمزنگاری سخت‌افزاری',
                      'تمامی اطلاعات پایگاه‌داده به صورت محلی با استاندارد AES-256 و کلید Keystore رمزنگاری می‌شوند.',
                    ),
                  ],
                ),
              ),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'من بیانیه تعهدنامه حریم خصوصی را به دقت خواندم و می‌پذیرم.',
                style: TextStyle(fontSize: 12, fontFamily: 'Vazirmatn'),
              ),
              value: _isPrivacyAccepted,
              onChanged: (val) {
                setState(() {
                  _isPrivacyAccepted = val ?? false;
                });
              },
            ),
          ],
        ),
      ),
      bottomAction: PrimaryButton(
        label: 'ادامه و پذیرش تعهدات',
        onPressed: _isPrivacyAccepted ? nextPage : null,
      ),
    );
  }

  Widget _buildOfflineExplanationSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'معماری صددرصد آفلاین',
      subtitle: 'چرا بانک‌یار هیچ دسترسی به دنیای خارج از گوشی شما ندارد؟',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.m),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDataFlowBlock(
                      Icons.sms_outlined,
                      'پیامک دریافتی',
                      theme,
                      spacing,
                      radius,
                    ),
                    Icon(Icons.arrow_back, color: theme.colorScheme.primary),
                    _buildDataFlowBlock(
                      Icons.storage_outlined,
                      'پایگاه داده محلی (رمزگذاری‌شده)',
                      theme,
                      spacing,
                      radius,
                    ),
                  ],
                ),
                SizedBox(height: spacing.l),
                const Divider(),
                SizedBox(height: spacing.l),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.red, size: 28),
                    SizedBox(width: spacing.s),
                    Text(
                      'عدم اتصال به سرور یا کلود',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomAction: PrimaryButton(label: 'متوجه شدم', onPressed: nextPage),
    );
  }

  Widget _buildSmsProcessingExplanationSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'نحوه پردازش و استخراج پیامک‌ها',
      subtitle: 'پیامک‌های دریافتی چگونه بدون دستکاری شخصی تحلیل می‌شوند؟',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildParsingStepCard(
              'مرحله ۱: دریافت امن',
              'برنامه پیامک دریافتی را مستقیماً از سیستم‌عامل دریافت می‌کند.',
              theme,
              radius,
              spacing,
            ),
            SizedBox(height: spacing.xs),
            _buildParsingStepCard(
              'مرحله ۲: استخراج با تطبیق الگو',
              'موتور استخراج متن با عبارات با قاعده (RegEx) مبلغ، حساب و نوع تراکنش را جدا می‌کند.',
              theme,
              radius,
              spacing,
            ),
            SizedBox(height: spacing.xs),
            _buildParsingStepCard(
              'مرحله ۳: دسته‌بندی خودکار',
              'تراکنش بر اساس نام فرستنده یا توضیحات به طور هوشمند سازماندهی می‌شود.',
              theme,
              radius,
              spacing,
            ),
          ],
        ),
      ),
      bottomAction: PrimaryButton(
        label: 'مایلم بدانم چطور کار می‌کند',
        onPressed: nextPage,
      ),
    );
  }

  Widget _buildWhySmsPermissionSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'چرا به دسترسی پیامک نیاز داریم؟',
      subtitle:
          'بانک‌یار برای اینکه بتواند تراکنش‌های شما را به صورت خودکار رصد کند، نیاز به مجوز خواندن پیامک دارد.',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.m),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPermissionRuleRow(
                  Icons.check_circle_outline,
                  'برنامه فقط پیامک‌های با سرشماره عددی بانکی را تحلیل می‌کند.',
                  Colors.green,
                  theme,
                  spacing,
                ),
                const Divider(),
                _buildPermissionRuleRow(
                  Icons.cancel_outlined,
                  'برنامه هرگز پیامک‌های شخصی، کدهای یکبار مصرف یا چت‌های شما را لمس نمی‌کند.',
                  Colors.red,
                  theme,
                  spacing,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: _smsStatus == PermissionStatus.granted
                ? 'دسترسی پیامک اعطا شد ✓'
                : 'تأیید و اعطای دسترسی به پیامک',
            onPressed: _smsStatus == PermissionStatus.granted
                ? nextPage
                : _requestSmsPermission,
          ),
          if (_smsStatus != PermissionStatus.granted) ...[
            SizedBox(height: spacing.xs),
            TextButton(
              onPressed: nextPage,
              child: const Text(
                'تنظیم دستی ورودی‌ها (بدون مجوز)',
                style: TextStyle(color: Colors.grey, fontFamily: 'Vazirmatn'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationBenefitsSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'اطلاع‌رسانی سریع تراکنش‌ها',
      subtitle: 'چرا فعال‌سازی اعلان‌ها برای صندوقچه شما سودمند است؟',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: Column(
          children: [
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.m),
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.m),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active_outlined,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: spacing.m),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'بانک ملی - برداشت',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazirmatn',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'مبلغ ۵۰,۰۰۰ تومان از حساب شما برداشت شد. ثبت شد.',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Vazirmatn',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.m),
            Text(
              'با فعال‌سازی مجوز اعلان، به محض دریافت پیامک بانکی، برنامه آن را سریع ثبت کرده و نتیجه را برای شما گزارش می‌کند.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      ),
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: _notifStatus == PermissionStatus.granted
                ? 'مجوز اعلان‌ها تایید شد ✓'
                : 'تأیید و فعال‌سازی اعلان‌ها',
            onPressed: _notifStatus == PermissionStatus.granted
                ? nextPage
                : _requestNotificationPermission,
          ),
          SizedBox(height: spacing.xs),
          TextButton(
            onPressed: nextPage,
            child: const Text(
              'فعلاً رد کن',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOverviewSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'بررسی لایه‌های امنیتی',
      subtitle:
          'تمامی اطلاعات شما به صورت صفحه به صفحه با الگوریتم‌های فوق امن رمزگذاری می‌شوند.',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildSecurityPointCard(
              Icons.enhanced_encryption,
              'پایگاه داده SQLCipher رمزنگاری شده',
              'با الگوریتم AES-256 رمزنگاری شده و کلید آن در تراشه امنیتی Keystore گوشی ذخیره می‌گردد.',
              theme,
              radius,
              spacing,
            ),
            SizedBox(height: spacing.s),
            _buildSecurityPointCard(
              Icons.timer_outlined,
              'قفل انقضای خودکار نشست',
              'در صورت خروج از برنامه، به منظور جلوگیری از دسترسی فیزیکی دیگران، بلافاصله برنامه قفل می‌شود.',
              theme,
              radius,
              spacing,
            ),
          ],
        ),
      ),
      bottomAction: PrimaryButton(
        label: 'ادامه و تنظیم پین‌کد',
        onPressed: nextPage,
      ),
    );
  }

  Widget _buildFeatureHighlightsSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    return _buildSlideSkeleton(
      title: 'امکانات برجسته بانک‌یار',
      subtitle:
          'صندوقچه شما امکانات متعددی را برای بهبود مدیریت مالی به صورت آفلاین ارائه می‌دهد.',
      theme: theme,
      spacing: spacing,
      child: Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: spacing.s,
          mainAxisSpacing: spacing.s,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureGridCard(
              Icons.search,
              'جستجوی پیشرفته FTS4',
              theme,
              radius,
              spacing,
            ),
            _buildFeatureGridCard(
              Icons.analytics,
              'آمار و نمودارهای پویا',
              theme,
              radius,
              spacing,
            ),
            _buildFeatureGridCard(
              Icons.backup,
              'پشتیبان‌گیری رمزگذاری‌شده',
              theme,
              radius,
              spacing,
            ),
            _buildFeatureGridCard(
              Icons.note_add,
              'امکان یادداشت‌گذاری و تگ',
              theme,
              radius,
              spacing,
            ),
          ],
        ),
      ),
      bottomAction: PrimaryButton(
        label: 'آماده برای راه‌اندازی',
        onPressed: nextPage,
      ),
    );
  }

  Widget _buildPinSetupSlide(ThemeData theme, SpacingExtension spacing) {
    final activeBuffer = _pinStep == 1 ? _pinBuffer : _confirmBuffer;

    return Column(
      children: [
        SizedBox(height: spacing.s),
        Icon(
          _pinStep == 1 ? Icons.password : Icons.verified_user,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: spacing.s),
        Text(
          _pinStep == 1 ? 'تنظیم پین‌کد ۴ رقمی ورود' : 'تکرار پین‌کد جهت تأیید',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        SizedBox(height: spacing.xxs),
        Text(
          _pinStep == 1
              ? 'یک رمز عبور ۴ رقمی جدید برای ورود به صندوقچه تعریف کنید.'
              : 'پین‌کد ۴ رقمی را مجدداً وارد نمایید.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'Vazirmatn',
          ),
        ),
        if (_pinError != null) ...[
          SizedBox(height: spacing.s),
          Text(
            _pinError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ],
        SizedBox(height: spacing.m),
        _buildPinDotsDisplay(activeBuffer, spacing, theme),
        const Spacer(),
        PinKeypad(onDigitTap: _onPinDigit, onBackspaceTap: _onPinBackspace),
        SizedBox(height: spacing.m),
      ],
    );
  }

  Widget _buildPermissionPreparationSlide(
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    final isPrepFinished = _checklistActiveStep >= _checklistSteps.length - 1;

    return Padding(
      padding: EdgeInsets.all(spacing.m),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPrepFinished ? Icons.check_circle_outline : Icons.sync,
            size: 64,
            color: isPrepFinished ? Colors.green : theme.colorScheme.primary,
          ),
          SizedBox(height: spacing.m),
          Text(
            isPrepFinished
                ? 'پیکربندی محیط امن با موفقیت پایان یافت!'
                : 'در حال آماده‌سازی و ساخت صندوقچه امن...',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
          SizedBox(height: spacing.l),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.m),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_checklistSteps.length, (index) {
                  final isDone = index < _checklistActiveStep;
                  final isActive = index == _checklistActiveStep;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.xs),
                    child: Row(
                      children: [
                        Icon(
                          isDone
                              ? Icons.check_circle
                              : (isActive
                                    ? Icons.sync
                                    : Icons.radio_button_unchecked),
                          color: isDone
                              ? Colors.green
                              : (isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline),
                          size: 18,
                        ),
                        SizedBox(width: spacing.s),
                        Expanded(
                          child: Text(
                            _checklistSteps[index],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: 'Vazirmatn',
                              color: isDone || isActive
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'ورود به صندوقچه مالی (داشبورد)',
            onPressed: isPrepFinished ? _completeOnboarding : null,
          ),
        ],
      ),
    );
  }

  // --- HELPER LAYOUTS & WIDGETS ---

  Widget _buildSlideSkeleton({
    required String title,
    required String subtitle,
    IconData? illustration,
    required ThemeData theme,
    required SpacingExtension spacing,
    Widget? child,
    required Widget bottomAction,
  }) {
    return Padding(
      padding: EdgeInsets.all(spacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (illustration != null) ...[
            Center(
              child: Icon(
                illustration,
                size: 72,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: spacing.m),
          ],
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              fontFamily: 'Vazirmatn',
            ),
          ),
          SizedBox(height: spacing.xxs),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'Vazirmatn',
            ),
          ),
          SizedBox(height: spacing.m),
          if (child != null) child else const Spacer(),
          bottomAction,
        ],
      ),
    );
  }

  Widget _buildBenefitCard(
    IconData icon,
    String title,
    String description,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.primary),
            SizedBox(width: spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyCommitmentPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataFlowBlock(
    IconData icon,
    String title,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.s),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.15),
          borderRadius: BorderRadius.circular(radius.s),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            SizedBox(height: spacing.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontFamily: 'Vazirmatn'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParsingStepCard(
    String title,
    String desc,
    ThemeData theme,
    RadiusExtension radius,
    SpacingExtension spacing,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.s),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.xxs),
            Text(
              desc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRuleRow(
    IconData icon,
    String text,
    Color color,
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: spacing.s),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Vazirmatn',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityPointCard(
    IconData icon,
    String title,
    String desc,
    ThemeData theme,
    RadiusExtension radius,
    SpacingExtension spacing,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            SizedBox(width: spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGridCard(
    IconData icon,
    String label,
    ThemeData theme,
    RadiusExtension radius,
    SpacingExtension spacing,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            SizedBox(height: spacing.s),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDotsDisplay(
    String pin,
    SpacingExtension spacing,
    ThemeData theme,
  ) {
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
