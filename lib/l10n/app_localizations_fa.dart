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
}
