// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/platform/permission.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../state/permission_notifier.dart';

/// Central production-grade Permission Status Center Screen.
/// Displays status, diagnostics, custom actions, and deep links for every permission.
class PermissionStatusScreen extends ConsumerWidget {
  /// Constructor.
  const PermissionStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final state = ref.watch(permissionNotifierProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'مرکز مدیریت مجوزها'),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(spacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section I: Score & Diagnostics Card
                    _buildDiagnosticsCard(context, state, theme, spacing),
                    SizedBox(height: spacing.m),

                    // Section II: Section Header
                    Text(
                      'لیست مجوزهای مورد نیاز سیستمی',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    SizedBox(height: spacing.s),

                    // Section III: Permission Cards
                    ...AppPermission.values.map((perm) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: spacing.s),
                        child: _buildPermissionCard(
                          context,
                          ref,
                          perm,
                          state,
                          theme,
                          spacing,
                        ),
                      );
                    }),
                    SizedBox(height: spacing.xl),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDiagnosticsCard(
    BuildContext context,
    PermissionState state,
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final radius = theme.extension<RadiusExtension>()!;
    final semanticColors = theme.extension<SemanticColorExtension>()!;

    final allCriticalGranted = !state.isAnyCriticalMissing;
    final scoreColor = allCriticalGranted
        ? semanticColors.success
        : (state.percentage >= 60
              ? semanticColors.warning
              : semanticColors.error);

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
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    value: state.percentage / 100,
                    strokeWidth: 6,
                    color: scoreColor,
                    backgroundColor: theme.colorScheme.outlineVariant
                        .withOpacity(0.3),
                  ),
                ),
                Text(
                  '${state.percentage}٪',
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
                    'سلامت دسترسی‌های سیستم',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    'تعداد ${state.grantedCount} از ${state.totalCount} مجوز فعال است.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    allCriticalGranted
                        ? 'تمام مجوزهای حیاتی بانک‌یار اعطا شده است.'
                        : 'توجه: برخی مجوزهای حیاتی قطع هستند و ممکن است پیامک‌ها ثبت نشوند!',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: allCriticalGranted
                          ? semanticColors.success
                          : semanticColors.error,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPermissionCard(
    BuildContext context,
    WidgetRef ref,
    AppPermission perm,
    PermissionState state,
    ThemeData theme,
    SpacingExtension spacing,
  ) {
    final status = state.statuses[perm] ?? PermissionStatus.denied;
    final details = _getPermissionDetails(perm);
    final radius = theme.extension<RadiusExtension>()!;
    final semanticColors = theme.extension<SemanticColorExtension>()!;

    final isCritical =
        perm == AppPermission.smsRead ||
        perm == AppPermission.smsReceive ||
        perm == AppPermission.notifications;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case PermissionStatus.granted:
        statusColor = semanticColors.success;
        statusText = 'تایید شده (فعال)';
        statusIcon = Icons.check_circle_outline;
        break;
      case PermissionStatus.denied:
        statusColor = semanticColors.warning;
        statusText = 'رد شده (غیرفعال)';
        statusIcon = Icons.remove_circle_outline;
        break;
      case PermissionStatus.permanentlyDenied:
        statusColor = semanticColors.error;
        statusText = 'ممنوعیت دائمی (تنظیمات)';
        statusIcon = Icons.error_outline;
        break;
      case PermissionStatus.unavailable:
        statusColor = theme.colorScheme.outline;
        statusText = 'غیرقابل دسترس در این دستگاه';
        statusIcon = Icons.block_outlined;
        break;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(
          color: isCritical && status != PermissionStatus.granted
              ? semanticColors.error.withOpacity(0.5)
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: isCritical && status != PermissionStatus.granted ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Header (Icon, Title, Critical Badge)
            Row(
              children: [
                Icon(details.icon, color: theme.colorScheme.primary),
                SizedBox(width: spacing.s),
                Expanded(
                  child: Text(
                    details.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ),
                if (isCritical)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: semanticColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: semanticColors.error.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'مجوز حیاتی',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: semanticColors.error,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing.s),

            // Row 2: Status Row
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 16),
                SizedBox(width: spacing.xs),
                Text(
                  'وضعیت: $statusText',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.xs),

            // Row 3: Description
            Text(
              details.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.s),

            // Row 4: Action Button
            if (status != PermissionStatus.granted &&
                status != PermissionStatus.unavailable)
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: status == PermissionStatus.permanentlyDenied
                      ? 'تنظیمات سیستمی'
                      : 'اعطای مجوز',
                  onPressed: () {
                    ref
                        .read(permissionNotifierProvider.notifier)
                        .requestPermission(perm);
                  },
                ),
              ),
            if (status == PermissionStatus.granted)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.verified, color: semanticColors.success, size: 20),
                  SizedBox(width: spacing.xs),
                  Text(
                    'دسترسی با موفقیت برقرار است',
                    style: TextStyle(
                      color: semanticColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  _PermissionUiDetails _getPermissionDetails(AppPermission perm) {
    switch (perm) {
      case AppPermission.smsRead:
        return const _PermissionUiDetails(
          title: 'خواندن پیامک‌های بانکی (READ_SMS)',
          description:
              'بانک‌یار برای اینکه بتواند در گام نخست یا پس از نصب، پیامک‌های قدیمی تراکنش‌های بانکی شما را در صندوقچه مالی وارد کند، به این مجوز احتیاج دارد.',
          icon: Icons.sms_outlined,
        );
      case AppPermission.smsReceive:
        return const _PermissionUiDetails(
          title: 'دریافت آنی پیامک‌ها (RECEIVE_SMS)',
          description:
              'این مجوز به بانک‌یار اجازه می‌دهد تا بلافاصله پس از دریافت پیامک واریز یا برداشت جدید از سوی بانک، آن را بدون نیاز به ورود مجدد به برنامه، سازماندهی و پردازش کند.',
          icon: Icons.notifications_paused_outlined,
        );
      case AppPermission.notifications:
        return const _PermissionUiDetails(
          title: 'ارسال اعلان‌های سیستمی (POST_NOTIFICATIONS)',
          description:
              'برای اینکه بلافاصله پس از پردازش موفق هر پیامک بانکی در پس‌زمینه، خلاصه و تاییدیه ثبت تراکنش به عنوان اعلان (نوتیفیکیشن) برای شما ارسال شود.',
          icon: Icons.notifications_active_outlined,
        );
      case AppPermission.batteryExclusion:
        return const _PermissionUiDetails(
          title: 'لغو بهینه‌سازی باتری (Battery Optimization)',
          description:
              'سیستم‌عامل اندروید در صورت بی‌کار ماندن طولانی گوشی، فعالیت‌های پس‌زمینه را متوقف می‌کند. اعطای این مجوز مانع بسته‌شدن خودکار ناظر پیامک بانک‌یار می‌شود.',
          icon: Icons.battery_saver_outlined,
        );
      case AppPermission.foregroundService:
        return const _PermissionUiDetails(
          title: 'فعالیت سرویس پس‌زمینه (Foreground Service)',
          description:
              'برای حفظ یکپارچگی تحلیل، یک فرآیند سبک و پیوسته در سیستم‌عامل روشن می‌ماند تا هیچ پیامی در هیاهوی برنامه‌ها از دست نرود.',
          icon: Icons.sync_outlined,
        );
      case AppPermission.autoStart:
        return const _PermissionUiDetails(
          title: 'شروع خودکار پس از بوت (Auto Start)',
          description:
              'تنظیم تاییدیه برای بیدار شدن ناظر برنامه بلافاصله پس از راه‌اندازی یا روشن شدن مجدد گوشی بدون نیاز به اجرای دستی بانک‌یار (توصیه شده برای شیائومی و هوآوی).',
          icon: Icons.power_settings_new_outlined,
        );
      case AppPermission.exactAlarm:
        return const _PermissionUiDetails(
          title: 'آلارم دقیق سیستم (Exact Alarm)',
          description:
              'جهت زمان‌بندی همگام‌سازی‌های دوره‌ای و پایش خودکار با دقت بالا حتی زمانی که دستگاه در حالت بهینه‌سازی خواب قرار دارد.',
          icon: Icons.alarm_outlined,
        );
      case AppPermission.localFiles:
        return const _PermissionUiDetails(
          title: 'فضای ذخیره‌سازی محلی (Storage)',
          description:
              'برای خروجی گرفتن و یا وارد کردن فایل‌های پشتیبان رمزگذاری شده صندوقچه روی کارت حافظه یا حافظه عمومی دستگاه شما.',
          icon: Icons.folder_open_outlined,
        );
      case AppPermission.biometrics:
        return const _PermissionUiDetails(
          title: 'حسگرهای بیومتریک ورود (Biometrics)',
          description:
              'برای راحتی بیشتر، به جای وارد کردن همیشگی پین‌کد عبور، می‌توانید صندوقچه را از طریق حسگر اثر انگشت یا تشخیص چهره به طور امن باز کنید.',
          icon: Icons.fingerprint_outlined,
        );
    }
  }
}

class _PermissionUiDetails {
  const _PermissionUiDetails({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
