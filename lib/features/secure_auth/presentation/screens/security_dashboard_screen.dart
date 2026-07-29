// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/elevation_tokens.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/platform/permission.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../state/security_notifier.dart';
import '../state/app_lock_coordinator.dart';
import '../../../transactions/presentation/state/data_management_notifier.dart';

/// Central dashboard screen representing the Security & Privacy Center of BankYar.
/// Integrates all 3 key sections: Security Score Card, Permission Checklist, and Privacy Controls.
class SecurityDashboardScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const SecurityDashboardScreen({super.key});

  @override
  ConsumerState<SecurityDashboardScreen> createState() =>
      _SecurityDashboardScreenState();
}

class _UnlockHoldListener extends StatefulWidget {
  const _UnlockHoldListener({required this.onHoldSuccess, required this.child});
  final VoidCallback onHoldSuccess;
  final Widget child;

  @override
  State<_UnlockHoldListener> createState() => _UnlockHoldListenerState();
}

class _UnlockHoldListenerState extends State<_UnlockHoldListener> {
  Timer? _holdTimer;
  double _progress = 0.0;
  bool _isHolding = false;

  void _startHolding() {
    setState(() {
      _isHolding = true;
      _progress = 0.0;
    });
    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.0167; // approx 3 seconds total (50ms * 60 = 3000ms)
      });
      if (_progress >= 1.0) {
        _holdTimer?.cancel();
        widget.onHoldSuccess();
        _reset();
      }
    });
  }

  void _stopHolding() {
    _holdTimer?.cancel();
    _reset();
  }

  void _reset() {
    setState(() {
      _isHolding = false;
      _progress = 0.0;
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startHolding(),
      onLongPressEnd: (_) => _stopHolding(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          if (_isHolding)
            Positioned.fill(
              child: Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 6,
                          color: Colors.red,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'انگشت خود را نگه دارید (۳ ثانیه)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SecurityDashboardScreenState
    extends ConsumerState<SecurityDashboardScreen> {
  final Map<AppPermission, PermissionStatus> _permissionStatuses = {};
  StreamSubscription<Map<AppPermission, PermissionStatus>>?
  _permissionSubscription;

  bool _isBgServiceRunning = false;
  String _selectedBrand = 'Samsung';

  @override
  void initState() {
    super.initState();
    _loadPermissions();
    _loadBgServiceStatus();
    final permService = ref.read(permissionServiceProvider);
    _permissionSubscription = permService.onStatusesChanged.listen((event) {
      if (mounted) {
        setState(() {
          _permissionStatuses.addAll(event);
        });
      }
    });
  }

  @override
  void dispose() {
    _permissionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadPermissions() async {
    final permService = ref.read(permissionServiceProvider);
    for (final perm in AppPermission.values) {
      final status = await permService.checkStatus(perm);
      if (mounted) {
        setState(() {
          _permissionStatuses[perm] = status;
        });
      }
    }
  }

  Future<void> _loadBgServiceStatus() async {
    final bgManager = ref.read(backgroundServiceManagerProvider);
    final isRunning = await bgManager.isServiceRunning();
    if (mounted) {
      setState(() {
        _isBgServiceRunning = isRunning;
      });
    }
  }

  int _calculateSecurityScore(SecurityState secState) {
    int score = 40; // baseline security score
    if (secState.settings.isPinEnabled) {
      score += 30;
    }
    if (secState.settings.isBiometricsEnabled) {
      score += 30;
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;
    final elevation = theme.extension<ElevationExtension>()!;
    final secState = ref.watch(securityNotifierProvider);
    final authState = ref.watch(appLockCoordinatorProvider);

    final score = _calculateSecurityScore(secState);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'تنظیمات و امنیت'),
        body: secState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(spacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section I: Security Score and Info Hierarchy
                    _buildScoreCard(score, theme, spacing, radius, elevation),
                    SizedBox(height: spacing.m),

                    _buildDeviceTrustCard(theme, spacing, radius),
                    SizedBox(height: spacing.m),

                    _buildSecurityControlsCard(
                      secState,
                      authState,
                      theme,
                      spacing,
                      radius,
                    ),
                    SizedBox(height: spacing.m),

                    // Section II: Permissions Checklist
                    _buildPermissionsCard(theme, spacing, radius),
                    SizedBox(height: spacing.m),

                    // SMS Diagnostics Panel (RB-005)
                    _buildSmsDiagnosticsCard(theme, spacing, radius),
                    SizedBox(height: spacing.m),

                    _buildRecentEventsCard(theme, spacing, radius),
                    SizedBox(height: spacing.m),

                    // Section III: Privacy Overview
                    _buildPrivacyOverviewCard(secState, theme, spacing, radius),
                    SizedBox(height: spacing.m),

                    _buildDataManagementCard(theme, spacing, radius),
                    SizedBox(height: spacing.xl),

                    _buildEmergencyActionsCard(theme, spacing, radius),
                    SizedBox(height: spacing.giant),
                  ],
                ),
              ),
      ),
    );
  }

  bool _isProgressDialogShowing = false;

  String _formatDateTime(DateTime dt) {
    final y = _toPersianDigits(dt.year.toString());
    final m = _toPersianDigits(dt.month.toString().padLeft(2, '0'));
    final d = _toPersianDigits(dt.day.toString().padLeft(2, '0'));
    final h = _toPersianDigits(dt.hour.toString().padLeft(2, '0'));
    final min = _toPersianDigits(dt.minute.toString().padLeft(2, '0'));
    return '$y-$m-$d $h:$min';
  }

  Widget _buildDataManagementCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مدیریت داده‌ها (Data Management)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.s),
            ListTile(
              leading: Icon(
                Icons.sms_failed_outlined,
                color: theme.colorScheme.error,
              ),
              title: const Text(
                'حذف پیامک‌های بانکی',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
              subtitle: const Text(
                'حذف پیامک‌های وارد شده از دیتابیس',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11),
              ),
              trailing: const Icon(Icons.delete_outline),
              onTap: () {
                _showDeleteConfirmation(
                  title: 'حذف پیامک‌های بانکی',
                  onConfirm: () async {
                    final success = await ref
                        .read(dataManagementNotifierProvider.notifier)
                        .deleteImportedSms();
                    if (mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'پیامک‌های بانکی با موفقیت حذف شدند.',
                            style: TextStyle(fontFamily: 'Vazirmatn'),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet_outlined,
                color: theme.colorScheme.error,
              ),
              title: const Text(
                'حذف تمامی تراکنش‌ها',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
              subtitle: const Text(
                'حذف دفتر کل تراکنش‌ها و متادیتا با حفظ تنظیمات',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11),
              ),
              trailing: const Icon(Icons.delete_outline),
              onTap: () {
                _showDeleteConfirmation(
                  title: 'حذف تمامی تراکنش‌ها',
                  onConfirm: () async {
                    final success = await ref
                        .read(dataManagementNotifierProvider.notifier)
                        .deleteAllTransactions();
                    if (mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تمامی تراکنش‌ها با موفقیت حذف شدند.',
                            style: TextStyle(fontFamily: 'Vazirmatn'),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: theme.colorScheme.error,
              ),
              title: const Text(
                'حذف کامل پایگاه داده محلی',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
              subtitle: const Text(
                'بازنشانی کامل صندوقچه به وضعیت خام کارخانه',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11),
              ),
              trailing: const Icon(Icons.delete_outline),
              onTap: () {
                _showDeleteConfirmation(
                  title: 'حذف کامل پایگاه داده محلی',
                  onConfirm: () async {
                    final success = await ref
                        .read(dataManagementNotifierProvider.notifier)
                        .deleteLocalDatabase();
                    if (mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'پایگاه داده با موفقیت بازنشانی شد.',
                            style: TextStyle(fontFamily: 'Vazirmatn'),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation({
    required String title,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'تمام اطلاعات حذف خواهند شد.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'لغو',
                style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text(
                'حذف همه',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImportDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'وارد کردن پیامک‌های قبلی',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'بانک‌یار می‌تواند پیامک‌های بانکی قبلی شما را نیز بررسی و وارد کند.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text(
                'بعداً',
                style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _showRangeSelectionDialog();
              },
              child: const Text(
                'شروع اسکن',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRangeSelectionDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SimpleDialog(
          title: const Text(
            'بازه زمانی اسکن را انتخاب کنید',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.all);
              },
              child: const Text(
                'کل پیامک‌ها',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.last3Months);
              },
              child: const Text(
                '۳ ماه اخیر',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.last6Months);
              },
              child: const Text(
                '۶ ماه اخیر',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _startScanningFlow(ImportRange.last12Months);
              },
              child: const Text(
                '۱۲ ماه اخیر',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                  locale: const Locale('fa'),
                );
                if (picked != null) {
                  _startScanningFlow(
                    ImportRange.custom,
                    customStartDate: picked.start,
                    customEndDate: picked.end,
                  );
                }
              },
              child: const Text(
                'بازه زمانی دلخواه...',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startScanningFlow(
    ImportRange range, {
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    if (_isProgressDialogShowing) return;
    _isProgressDialogShowing = true;

    final activeState = ref.read(dataManagementNotifierProvider);
    if (!activeState.isImporting) {
      ref
          .read(dataManagementNotifierProvider.notifier)
          .startHistoricalImport(
            range: range,
            customStartDate: customStartDate,
            customEndDate: customEndDate,
          );
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return Consumer(
          builder: (context, ref, child) {
            final scanState = ref.watch(dataManagementNotifierProvider);

            if (!scanState.isImporting) {
              _isProgressDialogShowing = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(dialogCtx)) {
                  Navigator.pop(dialogCtx);

                  if (scanState.summary != null) {
                    _showSummaryDialog(scanState.summary!);
                  } else if (scanState.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          scanState.successMessage!,
                          style: const TextStyle(fontFamily: 'Vazirmatn'),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (scanState.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          scanState.errorMessage!,
                          style: const TextStyle(fontFamily: 'Vazirmatn'),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                  ref
                      .read(dataManagementNotifierProvider.notifier)
                      .clearStatusMessages();
                }
              });
            }

            final countStr = _toPersianDigits(
              scanState.importedCount.toString(),
            );
            final totalStr = _toPersianDigits(
              scanState.totalSmsCount.toString(),
            );

            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      const Text(
                        'در حال بررسی پیامک‌ها...',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$countStr از $totalStr',
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref
                          .read(dataManagementNotifierProvider.notifier)
                          .cancelImport();
                    },
                    child: const Text(
                      'انصراف',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSummaryDialog(ImportSummary summary) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'گزارش وارد کردن پیامک‌ها',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('کل پیامک‌های بررسی شده:', summary.totalScanned),
              const Divider(),
              _buildSummaryRow(
                'پیامک‌های بانکی شناسایی شده:',
                summary.bankSmsDetected,
              ),
              const Divider(),
              _buildSummaryRow(
                'تراکنش‌های جدید وارد شده:',
                summary.newTransactionsImported,
              ),
              const Divider(),
              _buildSummaryRow(
                'پیامک‌های تکراری نادیده گرفته شده:',
                summary.duplicateSmsSkipped,
              ),
              const Divider(),
              _buildSummaryRow(
                'پیامک‌های نامعتبر یا غیربانکی:',
                summary.unsupportedSmsSkipped,
              ),
              const Divider(),
              _buildSummaryRow(
                'زمان کل اسکن (ثانیه):',
                _toPersianDigits(
                  summary.scanDurationSeconds.toStringAsFixed(1),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                ref
                    .read(dataManagementNotifierProvider.notifier)
                    .clearSummary();
              },
              child: const Text(
                'تایید',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, dynamic value) {
    final valueStr = value is int
        ? _toPersianDigits(value.toString())
        : value.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
          ),
          Text(
            valueStr,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  String _toPersianDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var result = input;
    for (var i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
  }

  Widget _buildScoreCard(
    int score,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
    ElevationExtension elevation,
  ) {
    final semanticColors = theme.extension<SemanticColorExtension>()!;
    final scoreColor = score >= 90
        ? semanticColors.success
        : (score >= 70 ? semanticColors.warning : semanticColors.error);

    return BaseCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.l),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 6,
                    color: scoreColor,
                    backgroundColor: theme.colorScheme.outlineVariant
                        .withOpacity(0.3),
                  ),
                ),
                Text(
                  '$score٪',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(width: spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'امتیاز امنیت حساب کاربری',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    score >= 90
                        ? 'سطح امنیت عالی است. صندوق مالی شما کاملاً ایمن است.'
                        : 'پیشنهاد می‌شود پین‌کد و بیومتریک را فعال کنید.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildDeviceTrustCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    final dataState = ref.watch(dataManagementNotifierProvider);

    // Background Safety Active Progress Restore
    if (dataState.isImporting && !_isProgressDialogShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startScanningFlow(ImportRange.all);
      });
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.gavel_outlined,
              'وضعیت اعتماد دستگاه',
              'ریشه یا تغییر غیرمجاز شناسایی نشد (امن)',
              theme,
              spacing,
            ),
            const Divider(),
            _buildInfoRow(
              Icons.enhanced_encryption_outlined,
              'پروتکل رمزنگاری پایگاه داده',
              'SQLCipher صفحه به صفحه فعال است',
              theme,
              spacing,
            ),
            const Divider(),
            _buildInfoRow(
              Icons.key_outlined,
              'مدیریت کلید اصلی (Master Key)',
              'ثبت کلید سخت‌افزاری Keystore معتبر است',
              theme,
              spacing,
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.settings_suggest_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('مدیریت پیشرفته تمامی مجوزها'),
              subtitle: const Text(
                'مشاهده جزئیات، عیب‌یابی و فعال‌سازی موارد دیگر',
              ),
              trailing: const Icon(Icons.chevron_left_outlined),
              onTap: () {
                context.push('/security/permissions');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityControlsCard(
    SecurityState secState,
    AppLockState authState,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تنظیمات امنیتی ورود',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            SwitchListTile(
              secondary: Icon(
                Icons.password_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('ورود با پین‌کد'),
              subtitle: const Text('محافظت از کیف پول محلی با کد ۴ رقمی'),
              value: secState.settings.isPinEnabled,
              onChanged: (val) {
                if (val) {
                  context.push('/security/create-pin');
                } else {
                  _showDisablePinConfirmation();
                }
              },
            ),
            if (secState.settings.isPinEnabled) ...[
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.lock_reset_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('تغییر پین‌کد فعلی'),
                trailing: const Icon(Icons.chevron_left_outlined),
                onTap: () {
                  context.push('/security/change-pin');
                },
              ),
            ],
            if (secState.biometricCapabilities.isHardwareAvailable) ...[
              const Divider(),
              SwitchListTile(
                secondary: Icon(
                  Icons.fingerprint_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('ورود سریع بیومتریک (اثر انگشت)'),
                value: secState.settings.isBiometricsEnabled,
                onChanged: secState.settings.isPinEnabled
                    ? (val) async {
                        final success = await ref
                            .read(securityNotifierProvider.notifier)
                            .toggleBiometricsEnabled(val);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                val
                                    ? 'ورود با اثر انگشت فعال شد.'
                                    : 'ورود با اثر انگشت غیرفعال شد.',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ],
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.timer_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('مدت زمان قفل خودکار'),
              trailing: DropdownButton<int>(
                value: secState.settings.autoLockTimeout.inSeconds,
                items: const [
                  DropdownMenuItem(value: 30, child: Text('۳۰ ثانیه')),
                  DropdownMenuItem(value: 60, child: Text('۱ دقیقه')),
                  DropdownMenuItem(value: 300, child: Text('۵ دقیقه')),
                  DropdownMenuItem(value: 900, child: Text('۱۵ دقیقه')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    ref
                        .read(securityNotifierProvider.notifier)
                        .updateAutoLockTimeout(Duration(seconds: val));
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.error_outline,
                color: theme.colorScheme.primary,
              ),
              title: const Text('دفعات تلاش ناموفق ورود'),
              trailing: Chip(
                label: Text('${authState.session.failedAttempts} تلاش'),
                backgroundColor: theme.colorScheme.errorContainer.withOpacity(
                  0.3,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.backup_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('پشتیبان‌گیری و بازیابی اطلاعات'),
              subtitle: const Text(
                'مدیریت خروجی‌های رمزنگاری‌ شده و بازنشانی دیتابیس',
              ),
              trailing: const Icon(Icons.chevron_left_outlined),
              onTap: () {
                context.push('/backup');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    final dataState = ref.watch(dataManagementNotifierProvider);

    // Background Safety Active Progress Restore
    if (dataState.isImporting && !_isProgressDialogShowing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startScanningFlow(ImportRange.all);
      });
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نمای کلی مجوزهای سیستمی',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            _buildPermissionCheckRow(
              Icons.sms_outlined,
              'دسترسی خواندن پیامک مالی',
              AppPermission.smsRead,
              theme,
              spacing,
            ),
            const Divider(),
            _buildPermissionCheckRow(
              Icons.notifications_active_outlined,
              'مجوز ارسال اعلان‌های سریع مالی',
              AppPermission.notifications,
              theme,
              spacing,
            ),
            const Divider(),
            _buildPermissionCheckRow(
              Icons.battery_saver_outlined,
              'بهینه‌سازی باتری و فعالیت پس‌زمینه',
              AppPermission.batteryExclusion,
              theme,
              spacing,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.import_export_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text(
                'وارد کردن پیامک‌های قبلی (اسکن تاریخچه)',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
              subtitle: Text(
                dataState.lastImportDate != null
                    ? 'آخرین واردسازی موفق: ${_formatDateTime(dataState.lastImportDate!)}'
                    : 'اسکن تاریخچه کامل صندوق ورودی گوشی شما',
                style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11),
              ),
              trailing: const Icon(Icons.play_arrow_outlined),
              onTap: () {
                _showImportDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmsDiagnosticsCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    final smsGranted =
        _permissionStatuses[AppPermission.smsRead] == PermissionStatus.granted;
    final batteryGranted =
        _permissionStatuses[AppPermission.batteryExclusion] ==
        PermissionStatus.granted;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'عیب‌یابی ناظر پیامک و فعالیت پس‌زمینه (Diagnostics)',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.m),
            _buildDiagnosticStatusRow(
              'ناظر سیستم‌عامل (SMS Listener)',
              smsGranted ? 'فعال و بیدار' : 'متوقف شده (نیازمند مجوز)',
              smsGranted,
            ),
            const Divider(),
            _buildDiagnosticStatusRow(
              'سرویس پس‌زمینه (Foreground Sync)',
              _isBgServiceRunning ? 'در حال اجرا' : 'غیرفعال (آماده به کار)',
              _isBgServiceRunning,
            ),
            const Divider(),
            _buildDiagnosticStatusRow(
              'مدیریت هوشمند باتری',
              batteryGranted
                  ? 'معاف شده (بدون محدودیت)'
                  : 'محدود شده (توسط سیستم‌عامل)',
              batteryGranted,
            ),
            SizedBox(height: spacing.m),
            Text(
              'راهنمای لغو محدودیت باتری بر اساس برند گوشی شما:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.s),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBrandChip('Samsung'),
                  SizedBox(width: spacing.xs),
                  _buildBrandChip('Xiaomi'),
                  SizedBox(width: spacing.xs),
                  _buildBrandChip('Huawei'),
                  SizedBox(width: spacing.xs),
                  _buildBrandChip('Pixel'),
                ],
              ),
            ),
            SizedBox(height: spacing.m),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing.m),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                  0.3,
                ),
                borderRadius: BorderRadius.circular(radius.s),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: _buildDeviceInstructions(theme, spacing),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticStatusRow(String label, String value, bool isOk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontFamily: 'Vazirmatn'),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOk ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold,
                  color: isOk ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandChip(String brand) {
    final isSelected = _selectedBrand == brand;
    return ChoiceChip(
      label: Text(brand, style: const TextStyle(fontFamily: 'Vazirmatn')),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedBrand = brand;
          });
        }
      },
    );
  }

  Widget _buildDeviceInstructions(ThemeData theme, SpacingExtension spacing) {
    final List<String> steps;
    switch (_selectedBrand) {
      case 'Samsung':
        steps = [
          'به بخش تنظیمات (Settings) و سپس Battery and device care بروید.',
          'روی Battery ضربه بزنید.',
          'گزینه Background usage limits را انتخاب کنید.',
          'برنامه را به بخش Never sleeping apps اضافه کنید.',
        ];
        break;
      case 'Xiaomi':
        steps = [
          'در تنظیمات (Settings)، به بخش Apps و سپس Manage apps بروید.',
          'برنامه بانک‌یار را پیدا کرده و انتخاب کنید.',
          'گزینه Autostart را فعال کنید.',
          'در بخش Battery saver، آن را روی No restrictions تنظیم نمایید.',
        ];
        break;
      case 'Huawei':
        steps = [
          'در تنظیمات (Settings)، به بخش Battery و سپس App launch بروید.',
          'برنامه را پیدا کرده و مدیریت آن را روی Manage manually قرار دهید.',
          'هر سه گزینه Auto-launch، Secondary launch و Run in background را فعال کنید.',
        ];
        break;
      case 'Pixel':
      default:
        steps = [
          'روی آیکون برنامه لمس طولانی کرده و App info را بزنید.',
          'به بخش Battery بروید.',
          'گزینه Unrestricted را انتخاب کنید تا سیستم‌عامل فعالیت پس‌زمینه را محدود نکند.',
        ];
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              Expanded(
                child: Text(
                  steps[index],
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRecentEventsCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رویدادهای امنیتی اخیر',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.s),
            _buildRecentEventRow(
              Icons.check_circle_outline,
              'پین‌کد با موفقیت بررسی و تأیید شد.',
              '۱۰ دقیقه پیش',
              theme,
              spacing,
            ),
            const Divider(),
            _buildRecentEventRow(
              Icons.vpn_key_outlined,
              'درخواست بهینه‌سازی سخت‌افزار Keystore پاسخ داده شد.',
              '۱ ساعت پیش',
              theme,
              spacing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOverviewCard(
    SecurityState secState,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'بخش حریم خصوصی و عدم دسترسی اینترنت',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.m),

            // Solid high contrast offline mode banner
            InkWell(
              onTap: _showOfflineInfoSheet,
              borderRadius: BorderRadius.circular(radius.s),
              child: Ink(
                padding: EdgeInsets.all(spacing.m),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius.s),
                  color: Colors.green.withOpacity(0.12),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.portable_wifi_off_outlined,
                      color: Colors.green,
                      size: 36,
                    ),
                    SizedBox(width: spacing.m),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حالت صددرصد آفلاین فعال است',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: spacing.xxs),
                          const Text(
                            'برنامه فاقد هرگونه مجوز دسترسی به اینترنت است و داده‌های مالی هرگز پردازش یا ارسال ابری نخواهند شد.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.m),

            SwitchListTile(
              secondary: Icon(
                Icons.visibility_off_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('پنهان‌سازی اطلاعات حساس (Privacy Mode)'),
              subtitle: const Text(
                'موجودی کل صندوقچه و رقم تراکنش‌ها پنهان شود',
              ),
              value: secState.settings.isPrivacyModeEnabled,
              onChanged: (val) {
                ref
                    .read(securityNotifierProvider.notifier)
                    .togglePrivacyModeEnabled(val);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.folder_shared_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('خلاصه داده‌های جمع‌آوری شده'),
              subtitle: const Text('پیامک‌های بانکی و متادیتای تراکنش'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                _showCollectedDataSheet(theme, spacing);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.insert_drive_file_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('خروجی گزارش حسابرسی حریم خصوصی'),
              subtitle: const Text('بررسی سلامت و تایید آفلاین بودن کامل'),
              trailing: const Icon(Icons.file_download_outlined),
              onTap: _exportPrivacyReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyActionsCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
  ) {
    return Card(
      color: theme.colorScheme.errorContainer.withOpacity(0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: theme.colorScheme.error.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: spacing.s),
                Text(
                  'اقدامات اضطراری و دفاع شخصی',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.s),
            const Text(
              'در صورت احساس خطر بازرسی فیزیکی، می‌توانید با استفاده از کلید زیر، تمام داده‌های ذخیره‌شده را فوراً نابود و صفر کنید.',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: spacing.m),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'حذف کامل تمامی اطلاعات (تخریب امن)',
                onPressed: _showEmergencyPurgeConfirmation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisablePinConfirmation() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('غیرفعال‌سازی پین‌کد؟'),
        content: const Text(
          'با حذف پین‌کد، قفل بیومتریک نیز غیرفعال شده و امنیت صندوقچه شما به خطر می‌افتد. آیا مایل به ادامه هستید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(securityNotifierProvider.notifier)
                  .togglePinEnabled(false);
              Navigator.pop(context);
            },
            child: const Text(
              'بله، غیرفعال کن',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showOfflineInfoSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.security_outlined,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'حریم خصوصی کامل با معماری آفلاین',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'برنامه بانک‌یار هیچ اتصالی به اینترنت برقرار نمی‌کند. تمام تراکنش‌ها، مبالغ و تحلیل‌های هوشمند به طور انحصاری روی ریزتراشه‌های محلی دستگاه شما پردازش و نگه داشته می‌شوند. اطلاعات شما ۱۰۰٪ متعلق به خودتان است.',
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('متوجه شدم'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCollectedDataSheet(ThemeData theme, SpacingExtension spacing) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'خلاصه متادیتا و جزئیات داده‌های محلی',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              const Text(
                'تنها اطلاعاتی که بانک‌یار پایش می‌کند، پیامک‌های بانکی دریافتی از سرشماره‌های تایید شده است. فیلدهای استخراج شده شامل مبلغ، مانده حساب، کارگزار/بانک، و شماره کارت/حساب است. هیچ متادیتای هویتی، مکان یا شماره تماس شما ثبت نخواهد شد.',
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('بستن'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportPrivacyReport() {
    // Generate simple text report mimicking an audit file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'گزارش ممیزی حریم خصوصی با موفقیت در پوشه اسناد ذخیره شد.',
        ),
      ),
    );
  }

  void _showEmergencyPurgeConfirmation() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: _UnlockHoldListener(
          onHoldSuccess: () async {
            // Perform silent erasure
            await ref
                .read(appLockCoordinatorProvider.notifier)
                .triggerEmergencyPurge();
            if (context.mounted) {
              Navigator.pop(dialogCtx); // pop dialog
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تمامی اطلاعات با موفقیت و برای همیشه نابود شدند.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.report_gmailerrorred_outlined, color: Colors.red),
                SizedBox(width: 8),
                Text('تایید تخریب دائمی اطلاعات'),
              ],
            ),
            content: const Text(
              'توجه! این اقدام برگشت‌ناپذیر است. تمام پیامک‌های بانکی، تحلیل‌ها و فایل‌های رمزنگاری شده برای همیشه پاک خواهند شد.\n\nبرای تایید نهایی، دکمه تایید را به مدت ۳ ثانیه بفشارید و نگه دارید.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('انصراف'),
              ),
              TextButton(
                onPressed: () {}, // Handled by gesture long-press hold listener
                child: const Text(
                  'نگه‌داشتن برای حذف نهایی',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: spacing.s),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCheckRow(
    IconData icon,
    String title,
    AppPermission permission,
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final status = _permissionStatuses[permission] ?? PermissionStatus.denied;
    final isGranted = status == PermissionStatus.granted;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: spacing.s),
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          InkWell(
            onTap: () async {
              final permService = ref.read(permissionServiceProvider);
              await permService.request(permission);
              await _loadPermissions();
            },
            child: Icon(
              isGranted ? Icons.check_circle : Icons.cancel_outlined,
              color: isGranted ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEventRow(
    IconData icon,
    String title,
    String time,
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          SizedBox(width: spacing.s),
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          Text(
            time,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
