// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BankYar';

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get lockScreenTitle => 'Unlock BankYar';

  @override
  String get unparsedTxAlert => 'Unparsed transaction detected';

  @override
  String get greetingTitle => 'Hello, dear Sohrab';

  @override
  String get greetingSubtitle => 'Your financial vault is secure and updated';

  @override
  String get totalBalanceLabel => 'Total Vault Assets';

  @override
  String get monthlyIncomeLabel => 'Monthly Inflow';

  @override
  String get monthlyExpenseLabel => 'Monthly Outflow';

  @override
  String get recentTransactionsTitle => 'Recent Transactions';

  @override
  String get emptyTransactionsTitle => 'No Transactions Found';

  @override
  String get emptyTransactionsMessage =>
      'No transaction records exist in your vault yet.';

  @override
  String get logManualAction => 'Log Manual';

  @override
  String get bankStatusTitle => 'Bank Status';

  @override
  String get fullyOfflineBadge => 'Fully Offline';

  @override
  String get retryAction => 'Retry';
}
