// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:bankyar/core/presentation/widgets/widgets.dart';
import 'package:bankyar/core/theme/radius_tokens.dart';
import 'package:bankyar/core/theme/spacing_tokens.dart';

/// Interactive custom dialog implementations for the Backup & Restore feature.
/// Strictly conforms to BACKUP_RESTORE_SCREEN_SPECIFICATION.md Section 5.
abstract class BackupDialogs {
  /// Dialog 1: Create Backup Confirmation Dialog
  static Future<void> showCreateConfirm({
    required BuildContext context,
    required void Function(String password, bool shareAutomatically) onConfirm,
  }) async {
    final passwordController = TextEditingController();
    bool shareAutomatically = false;

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.l),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.add_moderator_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: spacing.xs),
                    const Text(
                      'ایجاد فایل پشتیبان جدید',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'یک نسخه پشتیبان رمزگذاری‌شده از تمامی تراکنش‌ها و تنظیمات برنامه در حافظه گوشی ذخیره خواهد شد. جهت امنیت اطلاعات خود، یک رمز عبور تعیین کنید.',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: spacing.s),
                      TextInputField(
                        controller: passwordController,
                        label: 'رمز عبور پشتیبان‌گیری',
                        hintText: 'حداقل ۶ نویسه جهت رمزگذاری امن',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      SizedBox(height: spacing.xs),
                      CheckboxWidget(
                        label: 'اشتراک‌گذاری خودکار پس از ساخت',
                        value: shareAutomatically,
                        onChanged: (val) {
                          setState(() {
                            shareAutomatically = val ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text(
                      'انصراف',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final pwd = passwordController.text.trim();
                      if (pwd.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('رمز عبور باید حداقل ۴ نویسه باشد.'),
                          ),
                        );
                        return;
                      }
                      Navigator.pop(dialogCtx);
                      onConfirm(pwd, shareAutomatically);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.m),
                      ),
                    ),
                    child: const Text(
                      'تایید و ساخت فایل',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
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

  /// Dialog 2: Restore Backup Warning Dialog
  static Future<void> showRestoreWarning({
    required BuildContext context,
    required void Function(String password) onConfirm,
  }) async {
    final passwordController = TextEditingController();
    bool understandConsequences = false;

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.l),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: theme.colorScheme.error,
                    ),
                    SizedBox(width: spacing.xs),
                    const Text(
                      'بازیابی اطلاعات دیتابیس',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'شما در حال بارگذاری یک فایل پشتیبان هستید. جهت خروج اطلاعات از حالت رمزگذاری، رمز عبور پشتیبان‌گیری مربوط به همان فایل را وارد کنید.',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: spacing.s),
                      TextInputField(
                        controller: passwordController,
                        label: 'رمز عبور رمزگشایی فایل',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                      ),
                      SizedBox(height: spacing.xs),
                      CheckboxWidget(
                        label: 'من متوجه عواقب جایگزینی اطلاعات هستم',
                        value: understandConsequences,
                        onChanged: (val) {
                          setState(() {
                            understandConsequences = val ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text(
                      'انصراف',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: understandConsequences
                        ? () {
                            final pwd = passwordController.text.trim();
                            if (pwd.isEmpty) return;
                            Navigator.pop(dialogCtx);
                            onConfirm(pwd);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.errorContainer,
                      foregroundColor: theme.colorScheme.onErrorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.m),
                      ),
                    ),
                    child: const Text(
                      'تایید و شروع بازیابی',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
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

  /// Dialog 3: Overwrite Existing Data Critical Dialog (Side-by-side comparison & option selection)
  static Future<void> showConflictResolution({
    required BuildContext context,
    required int localTransactions,
    required int backupTransactions,
    required int localAccounts,
    required int backupAccounts,
    required void Function(bool forceReplace) onApply,
  }) async {
    bool forceReplace =
        false; // default is false (Option A: Merge & Deduplicate)

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.l),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.report_gmailerrorred_outlined,
                      color: theme.colorScheme.error,
                    ),
                    SizedBox(width: spacing.xs),
                    const Text(
                      'تداخل در فایل‌های دیتابیس',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'اطلاعات تداخل‌دار بین نسخه پشتیبان و دیتابیس فعلی پیدا شد. جهت حفظ اطلاعات، یکی از روش‌های زیر را انتخاب کنید:',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: spacing.s),
                      // Comparison Board Panel
                      Container(
                        padding: EdgeInsets.all(spacing.s),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withOpacity(0.4),
                          borderRadius: BorderRadius.circular(radius.s),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'شاخص مقایسه',
                                  style: TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'دیتابیس فعلی',
                                  style: TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'فایل پشتیبان',
                                  style: TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'تعداد تراکنش‌ها:',
                                  style: TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '$localTransactions',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '$backupTransactions',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: spacing.xxs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'حساب‌های بانکی:',
                                  style: TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '$localAccounts',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '$backupAccounts',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing.s),
                      RadioWidget<bool>(
                        label: 'ادغام هوشمند و حذف موارد تکراری (امن)',
                        value: false,
                        groupValue: forceReplace,
                        onChanged: (val) {
                          setState(() {
                            forceReplace = val ?? false;
                          });
                        },
                      ),
                      SizedBox(height: spacing.xs),
                      RadioWidget<bool>(
                        label: 'جایگزینی کامل دیتابیس فعلی (حذف قبلی)',
                        value: true,
                        groupValue: forceReplace,
                        onChanged: (val) {
                          setState(() {
                            forceReplace = val ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text(
                      'لغو بازیابی',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                      onApply(forceReplace);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: forceReplace
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      foregroundColor: forceReplace
                          ? theme.colorScheme.onError
                          : theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.m),
                      ),
                    ),
                    child: const Text(
                      'اعمال تصمیم',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
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

  /// Dialog 4: Delete Backup File Dialog conforming to standard Material Design 3 and RTL Persian layouts.
  static Future<void> showDeleteConfirm({
    required BuildContext context,
    required VoidCallback onDelete,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) => DeleteConfirmationDialog(
        onConfirm: onDelete,
      ),
    );
  }

  /// Dialog 5: Backup Verification Failed Dialog
  static Future<void> showVerificationFailed({
    required BuildContext context,
    required VoidCallback onVerifyAgain,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.l),
            ),
            title: Row(
              children: [
                Icon(Icons.gpp_bad_outlined, color: theme.colorScheme.error),
                SizedBox(width: spacing.xs),
                const Text(
                  'عدم تأیید سلامت فایل',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'بررسی سلامت دیتابیس ناموفق بود. امضای دیجیتال یا ساختار فایل خراب است. این فایل نباید برای بازیابی استفاده شود.',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text(
                  'فهمیدم',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  onVerifyAgain();
                },
                child: const Text(
                  'بررسی مجدد فایل',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialog 6: Restore Failed Safety Alert
  static Future<void> showRestoreFailed({
    required BuildContext context,
    required VoidCallback onRetry,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.l),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline_sharp, color: theme.colorScheme.error),
                SizedBox(width: spacing.xs),
                const Text(
                  'خطا در بازیابی اطلاعات',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'خطای غیرمنتظره‌ای هنگام مهاجرت پایگاه داده رخ داد. اطلاعات فعلی شما بدون هیچ تغییری حفظ شده است.',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('گزارش اشکال‌زدایی ذخیره شد.'),
                    ),
                  );
                },
                child: const Text(
                  'مشاهده گزارش خطا',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  onRetry();
                },
                child: const Text(
                  'تلاش مجدد',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialog 7: Corrupted Backup File Dialog
  static Future<void> showCorruptedFile({
    required BuildContext context,
    required VoidCallback onSelectAnother,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.l),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.running_with_errors_outlined,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: spacing.xs),
                const Text(
                  'فایل پشتیبان آسیب دیده است',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'ساختار فایل پشتیبان (.bankyar) خوانا نیست. این فایل ناقص است یا دچار خرابی شده است.',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text(
                  'انصراف',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  onSelectAnother();
                },
                child: const Text(
                  'انتخاب فایل دیگر',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialog 8: Wrong Decryption PIN Dialog
  static Future<void> showWrongDecryptionPin({
    required BuildContext context,
    required int attemptsRemaining,
    required VoidCallback onReenter,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.l),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.lock_person_outlined,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: spacing.xs),
                const Text(
                  'پین امنیتی اشتباه است',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Text(
              'پین یا رمز عبور وارد شده با کلید رمزگذاری فایل تطابق ندارد. لطفاً پس از بررسی مجدد تلاش کنید.\nتعداد تلاش‌های باقی‌مانده: $attemptsRemaining بار تلاش',
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text(
                  'انصراف',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  onReenter();
                },
                child: const Text(
                  'ورود مجدد پین',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Dialog 9: Storage Space Full Alert Dialog
  static Future<void> showStorageFull({
    required BuildContext context,
    required VoidCallback onRetry,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        final theme = Theme.of(context);
        final spacing = theme.extension<SpacingExtension>()!;
        final radius = theme.extension<RadiusExtension>()!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.l),
            ),
            title: Row(
              children: [
                Icon(Icons.disc_full_outlined, color: theme.colorScheme.error),
                SizedBox(width: spacing.xs),
                const Text(
                  'حافظه گوشی پر است',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              'فضای کافی جهت ایجاد فایل پشتیبان جدید در دسترس نیست. حداقل به ۱۰ مگابایت فضای خالی نیاز است.',
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text(
                  'لغو فرآیند',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  onRetry();
                },
                child: const Text(
                  'تلاش مجدد',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
