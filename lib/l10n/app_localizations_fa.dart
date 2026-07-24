// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'بانک‌یار';

  @override
  String get loading => 'در حال بارگذاری...';

  @override
  String get errorOccurred => 'خطایی رخ داده است';

  @override
  String get lockScreenTitle => 'قفل‌گشایی بانک‌یار';

  @override
  String get unparsedTxAlert => 'تراکنش تجزیه‌نشده شناسایی شد';

  @override
  String get greetingTitle => 'سلام، سهراب عزیز';

  @override
  String get greetingSubtitle => 'صندوقچه مالی شما امن و به‌روز است';

  @override
  String get totalBalanceLabel => 'دارایی کل صندوقچه';

  @override
  String get monthlyIncomeLabel => 'ورودی این ماه';

  @override
  String get monthlyExpenseLabel => 'خروجی این ماه';

  @override
  String get recentTransactionsTitle => 'تراکنش‌های اخیر';

  @override
  String get emptyTransactionsTitle => 'تراکنشی یافت نشد';

  @override
  String get emptyTransactionsMessage =>
      'هیچ تراکنشی در صندوقچه شما ثبت نشده است.';

  @override
  String get logManualAction => 'ثبت دستی';

  @override
  String get bankStatusTitle => 'وضعیت بانک‌ها';

  @override
  String get fullyOfflineBadge => 'کاملاً آفلاین';

  @override
  String get retryAction => 'تلاش مجدد';
}
