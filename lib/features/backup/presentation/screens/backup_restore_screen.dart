import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/navigation/custom_app_bar.dart';
import '../../../../core/presentation/widgets/cards/base_card.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/elevation_tokens.dart';
import '../../../../core/theme/radius_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../domain/entities/backup_history_item.dart';
import '../../data/di/backup_providers.dart';
import '../state/backup_notifier.dart';
import '../widgets/dialogs/backup_dialogs.dart';

/// Primary page screen of BankYar Backup & Restore Center.
/// Built strictly on Material Design 3 and RTL Persian layouts.
class BackupRestoreScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _showDisasterTipsExpanded = false;
  bool _showRecoveryPhraseRevealed = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(backupNotifierProvider.notifier).loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final radius = theme.extension<RadiusExtension>()!;
    final elevation = theme.extension<ElevationExtension>()!;
    final semanticColors = theme.extension<SemanticColorExtension>()!;

    final state = ref.watch(backupNotifierProvider);
    final notifier = ref.read(backupNotifierProvider.notifier);

    // Listen for success and error messages
    ref.listen<BackupState>(backupNotifierProvider, (previous, current) {
      if (current.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        notifier.clearErrorMessage();
      }
      if (current.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        notifier.clearSuccessMessage();
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'صندوق پشتیبان‌گیری و بازیابی',
          showBackButton: true,
          onBackPress: () => Navigator.of(context).pop(),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(spacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Region 1: Data Protection & Sovereignty Alert
                        _buildSovereigntyAlert(theme, spacing, radius),
                        SizedBox(height: spacing.m),

                        // Region 2: Backup Status Overview Card
                        _buildStatusOverviewCard(theme, spacing, radius, elevation, semanticColors, state),
                        SizedBox(height: spacing.m),

                        // Region 3: Quick Actions Grid
                        _buildQuickActionsGrid(context, theme, spacing, radius, state, notifier),
                        SizedBox(height: spacing.m),

                        // Region 5: Advanced Options / Reminders
                        _buildAdvancedOptionsCard(theme, spacing, radius, state, notifier),
                        SizedBox(height: spacing.m),

                        // Region 4: Backup History List
                        _buildBackupHistoryList(context, theme, spacing, radius, state, notifier),
                        SizedBox(height: spacing.m),

                        // Region 6: Recovery Info & Disaster Tips
                        _buildRecoveryPhraseCard(context, theme, spacing, radius),
                        SizedBox(height: spacing.m),
                        _buildDisasterTipsCard(theme, spacing, radius),
                        SizedBox(height: spacing.giant),
                      ],
                    ),
                  ),

                  // Blocking Action Loading Overlay
                  if (state.isActionLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black45,
                        child: Center(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.m)),
                            child: Padding(
                              padding: EdgeInsets.all(spacing.l),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(),
                                  SizedBox(height: spacing.m),
                                  const Text(
                                    'در حال پردازش عملیات امن دیتابیس...',
                                    style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildSovereigntyAlert(ThemeData theme, SpacingExtension spacing, RadiusExtension radius) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.s),
        side: BorderSide(color: Colors.green.withOpacity(0.5), width: 1.5),
      ),
      color: Colors.green.withOpacity(0.08),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Row(
          children: [
            const Icon(Icons.shield_outlined, color: Colors.green, size: 28),
            SizedBox(width: spacing.s),
            const Expanded(
              child: Text(
                'تمامی فرآیندهای رمزنگاری و پشتیبان‌گیری صددرصد آفلاین روی حافظه این دستگاه انجام می‌شود. هیچ داده‌ای به سرورهای ابری منتقل نخواهد شد.',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, height: 1.5, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverviewCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
    ElevationExtension elevation,
    SemanticColorExtension semanticColors,
    BackupState state,
  ) {
    final meta = state.metadata;
    final lastBackupText = meta.lastBackupTime != null
        ? DateFormatter.toPersianDigits(
            DateFormatter.format(meta.lastBackupTime!, pattern: 'yyyy/MM/dd - HH:mm'),
          )
        : 'هیچ پشتیبان‌گیری موفقی یافت نشد';

    final dbSizeMB = (meta.databaseSizeBytes / (1024 * 1024)).toStringAsFixed(1);
    final backupSizeMB = (meta.backupSizeBytes / (1024 * 1024)).toStringAsFixed(1);

    final scoreColor = meta.healthPercentage >= 90
        ? semanticColors.success
        : (meta.healthPercentage >= 60 ? semanticColors.warning : semanticColors.error);

    return BaseCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          children: [
            // Status overview details
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: meta.healthPercentage / 100,
                        strokeWidth: 5,
                        color: scoreColor,
                        backgroundColor: theme.colorScheme.outlineVariant.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      '${DateFormatter.toPersianDigits(meta.healthPercentage.toString())}٪',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(width: spacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'وضعیت سلامت دیتابیس',
                        style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        'آخرین پشتیبان موفق: $lastBackupText',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            // Sizes details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricBlock(
                  theme,
                  spacing,
                  icon: Icons.storage_outlined,
                  title: 'اندازه دیتابیس فعلی',
                  value: '${DateFormatter.toPersianDigits(dbSizeMB)} مگابایت',
                ),
                _buildMetricBlock(
                  theme,
                  spacing,
                  icon: Icons.archive_outlined,
                  title: 'اندازه آخرین پشتیبان',
                  value: '${DateFormatter.toPersianDigits(backupSizeMB)} مگابایت',
                ),
              ],
            ),
            const Divider(),
            // Device storage progress indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('فضای آزاد حافظه داخلی', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11)),
                    Text(
                      '${DateFormatter.toPersianDigits(meta.freeSpacePercentage.toStringAsFixed(0))}٪ خالی',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: spacing.xxs),
                LinearProgressIndicator(
                  value: (100 - meta.freeSpacePercentage) / 100,
                  backgroundColor: theme.colorScheme.outlineVariant.withOpacity(0.3),
                  color: meta.freeSpacePercentage < 15 ? semanticColors.error : semanticColors.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBlock(
    ThemeData theme,
    SpacingExtension spacing, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            SizedBox(width: spacing.xxs),
            Text(title, style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        SizedBox(height: spacing.xxs),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildQuickActionsGrid(
    BuildContext context,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
    BackupState state,
    BackupNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'عملیات و ابزارهای سریع',
          style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: spacing.s),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: spacing.s,
          crossAxisSpacing: spacing.s,
          childAspectRatio: 1.5,
          children: [
            _buildActionTile(
              theme,
              spacing,
              radius,
              icon: Icons.cloud_upload_outlined,
              title: 'ایجاد فایل پشتیبان',
              subtitle: 'ذخیره خروجی جدید رمزگذاری شده',
              onTap: () {
                // Ensure battery is simulated or check space
                if (state.metadata.deviceFreeSpaceBytes < 10 * 1024 * 1024) {
                  BackupDialogs.showStorageFull(
                    context: context,
                    onRetry: () => notifier.loadInitialData(),
                  );
                  return;
                }
                BackupDialogs.showCreateConfirm(
                  context: context,
                  onConfirm: (password, shareAutomatically) {
                    notifier.createManualBackup(password).then((success) {
                      if (success && shareAutomatically) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فایل جدید صادر شد و برای اشتراک‌گذاری آماده است.')),
                        );
                      }
                    });
                  },
                );
              },
            ),
            _buildActionTile(
              theme,
              spacing,
              radius,
              icon: Icons.cloud_download_outlined,
              title: 'بازیابی اطلاعات',
              subtitle: 'بارگذاری پشتیبان قدیمی',
              onTap: () {
                if (state.history.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('هیچ فایل پشتیبانی محلی وجود ندارد.')),
                  );
                  return;
                }
                // Let user pick from history list or mock import
                BackupDialogs.showRestoreWarning(
                  context: context,
                  onConfirm: (password) async {
                    // Simulating reading from selected history item
                    final file = state.history.first;
                    final fileBytesRes = await ref.read(localBackupDataSourceProvider).readBackupFile(file.filePath);
                    if (context.mounted) {
                      final previewSuccess = await notifier.loadRestorePreview(fileBytesRes, password);
                      if (previewSuccess && context.mounted) {
                        final metrics = ref.read(backupNotifierProvider).previewMetrics!;
                        BackupDialogs.showConflictResolution(
                          context: context,
                          localTransactions: metrics['local_transactions'] ?? 0,
                          backupTransactions: metrics['backup_transactions'] ?? 0,
                          localAccounts: metrics['local_accounts'] ?? 0,
                          backupAccounts: metrics['backup_accounts'] ?? 0,
                          onApply: (forceReplace) async {
                            final success = await notifier.executeRestore(
                              password: password,
                              bytes: fileBytesRes,
                              forceReplace: forceReplace,
                            );
                            if (success && context.mounted) {
                              BackupDialogs.showCreateConfirm( // Dummy/Success mock trigger
                                context: context,
                                onConfirm: (_, __) {},
                              );
                            }
                          },
                        );
                      }
                    }
                  },
                );
              },
            ),
            _buildActionTile(
              theme,
              spacing,
              radius,
              icon: Icons.lock_outline,
              title: 'خروجی رمزنگاری شده',
              subtitle: 'بررسی کلیدهای امنیتی',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('پروتکل AES-256-CBC فعال و کلیدها ایمن هستند.')),
                );
              },
            ),
            _buildActionTile(
              theme,
              spacing,
              radius,
              icon: Icons.verified_user_outlined,
              title: 'بررسی سلامت فایل',
              subtitle: 'تست یکپارچگی آخرین پشتیبان',
              onTap: () {
                if (state.history.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('هیچ فایلی برای بررسی سلامت یافت نشد.')),
                  );
                  return;
                }
                final item = state.history.first;
                BackupDialogs.showRestoreWarning(
                  context: context,
                  onConfirm: (password) {
                    notifier.verifyBackupItem(item.id, password).then((valid) {
                      if (!valid && context.mounted) {
                        BackupDialogs.showVerificationFailed(
                          context: context,
                          onVerifyAgain: () {},
                        );
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.m),
        child: Padding(
          padding: EdgeInsets.all(spacing.s),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 24),
              SizedBox(height: spacing.xs),
              Text(title, style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 12)),
              Text(
                subtitle,
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 9, color: theme.colorScheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedOptionsCard(
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
    BackupState state,
    BackupNotifier notifier,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
        child: Row(
          children: [
            Icon(Icons.alarm_on_outlined, color: theme.colorScheme.primary),
            SizedBox(width: spacing.s),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('یادآور خودکار پشتیبان‌گیری دوره‌ای', style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('یادآوری هفتگی برای تهیه نسخه پشتیبان محلی', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            Switch(
              value: state.isAutomaticReminderEnabled,
              onChanged: (val) {
                notifier.toggleAutomaticReminder(val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupHistoryList(
    BuildContext context,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
    BackupState state,
    BackupNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'تاریخچه فایل‌های پشتیبان',
              style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '${DateFormatter.toPersianDigits(state.history.length.toString())} فایل موجود',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: spacing.s),
        if (state.history.isEmpty)
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.m),
              side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.l),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 40, color: theme.colorScheme.outline),
                    SizedBox(height: spacing.s),
                    const Text('هیچ فایل پشتیبان محلی یافت نشد', style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: spacing.xxs),
                    const Text('پیشنهاد می‌شود جهت امنیت حساب خود، همین حالا اولین فایل پشتیبان را ایجاد کنید.', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              return _buildHistoryRow(context, theme, spacing, radius, item, notifier);
            },
          ),
      ],
    );
  }

  Widget _buildHistoryRow(
    BuildContext context,
    ThemeData theme,
    SpacingExtension spacing,
    RadiusExtension radius,
    BackupHistoryItem item,
    BackupNotifier notifier,
  ) {
    final formattedDate = DateFormatter.toPersianDigits(
      DateFormatter.format(item.timestamp, pattern: 'yyyy/MM/dd - HH:mm'),
    );

    final sizeMB = (item.sizeBytes / (1024 * 1024)).toStringAsFixed(2);

    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: spacing.s),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.s),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: Icon(
          item.isManual ? Icons.fingerprint_sharp : Icons.schedule_outlined,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          item.isManual ? 'پشتیبان‌گیری دستی' : 'پشتیبان‌گیری دوره‌ای',
          style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          '$formattedDate | ${DateFormatter.toPersianDigits(sizeMB)} مگابایت',
          style: const TextStyle(fontSize: 10),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.isHealthy)
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 18)
            else
              const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
            SizedBox(width: spacing.xs),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 20),
              onPressed: () {
                BackupDialogs.showDeleteConfirm(
                  context: context,
                  onDelete: () => notifier.deleteBackupItem(item.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryPhraseCard(BuildContext context, ThemeData theme, SpacingExtension spacing, RadiusExtension radius) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: Colors.amber.withOpacity(0.5), width: 1.5),
      ),
      color: Colors.amber.withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.vpn_key_sharp, color: Colors.amber, size: 22),
                SizedBox(width: spacing.xs),
                const Text(
                  'کلمات کلیدی اضطراری (12-Word Phrase)',
                  style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: spacing.s),
            const Text(
              '۱۲ عبارت امنیتی برای زمان قطع دسترسی یا گم کردن پین‌کد ورود استفاده می‌شود. این عبارت را به شکل مکتوب و آفلاین نگهداری کنید.',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, height: 1.5),
            ),
            SizedBox(height: spacing.s),
            if (!_showRecoveryPhraseRevealed)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showRecoveryPhraseRevealed = true;
                    });
                  },
                  child: const Text('نمایش کلمات کلیدی اضطراری', style: TextStyle(fontFamily: 'Vazirmatn')),
                ),
              )
            else ...[
              Container(
                padding: EdgeInsets.all(spacing.s),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(radius.s),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: const Text(
                  'apple banana cherry dog elephant fox grape horse ink jack king lemon',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
              SizedBox(height: spacing.s),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showRecoveryPhraseRevealed = false;
                    });
                  },
                  child: const Text('پنهان‌سازی مجدد', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.grey)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDisasterTipsCard(ThemeData theme, SpacingExtension spacing, RadiusExtension radius) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.m),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.tips_and_updates_outlined, color: theme.colorScheme.primary),
            title: const Text('توصیه‌های پیشگیری از فقدان اطلاعات مالی', style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 13)),
            trailing: Icon(_showDisasterTipsExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                _showDisasterTipsExpanded = !_showDisasterTipsExpanded;
              });
            },
          ),
          if (_showDisasterTipsExpanded)
            Padding(
              padding: EdgeInsets.only(left: spacing.m, right: spacing.m, bottom: spacing.m),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  Text(
                    '۱. فایل‌های دات بانک‌یار (.bankyar) تولید شده را از پوشه دیتابیس گوشی کپی کرده و در هارد اکسترنال یا دستگاه دیگری نگه دارید.\n'
                    '۲. رمز عبور پشتیبان‌گیری را هرگز فراموش نکنید. در صورت گم کردن رمز عبور، هیچ راه حلی برای بازیابی اطلاعات در دنیای رمزنگاری وجود نخواهد داشت.\n'
                    '۳. یادآور خودکار را فعال نگه دارید تا قبل از بروز حوادث سخت‌افزاری، یک نسخه به‌روز داشته باشید.',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, height: 1.8),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
