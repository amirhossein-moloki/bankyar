/// Utility class to identify and explicitly reject false positive SMS messages
/// (such as third-party ridesharing, e-commerce, telcos, utility bills,
/// government portals, tax, insurance, or general advertisements)
/// unless they are sent by a verified bank sender.
class FalsePositiveProtection {
  const FalsePositiveProtection._();

  /// Senders that are explicitly blocked.
  static const List<String> blockedSenders = [
    'snapp',
    'snapppay',
    'snapp_pay',
    'digikala',
    'mci',
    'hamrahaval',
    'hamrah_aval',
    'irancell',
    'rightel',
    'tapsi',
    'maxim',
    'sana',
    'sajam',
    'adliran',
    'adl_iran',
    'bimeh',
    'tax',
  ];

  /// Keywords in the text that, if found, indicate the message is a non-bank message,
  /// unless the sender is explicitly verified as a bank.
  static const List<String> nonBankKeywords = [
    'اسنپ',
    'اسنپ پی',
    'اسنپ‌پی',
    'دیجی کالا',
    'دیجیکالا',
    'همراه اول',
    'ایرانسل',
    'رایتل',
    'تپسی',
    'ماکسیم',
    'ثنا',
    'سجام',
    'عدل ایران',
    'بیمه',
    'مالیات',
    'امور مالیاتی',
    'شناسه قبض',
    'شناسه پرداخت',
    'قبض آب',
    'قبض گاز',
    'قبض برق',
    'قبض تلفن',
    'سازمان مالیاتی',
    'تبلیغ',
    'کد تخفیف',
    'شارژ مستقیم',
    'بسته اینترنت',
  ];

  /// Returns true if the sender identifier or message body matches non-bank criteria.
  /// This is used to filter out false positives.
  static bool isFalsePositive(String senderId, String rawText) {
    final normalizedSender = senderId.trim().toLowerCase().replaceAll(
      RegExp(r'[\s\.\-_]'),
      '',
    );
    final normalizedText = rawText.toLowerCase();

    // 1. Check if sender is explicitly in the blocked list
    if (blockedSenders.any((blocked) => normalizedSender.contains(blocked))) {
      return true;
    }

    // 2. Check if text contains any known non-bank keywords
    // We only apply this if the message is NOT from a verified bank sender.
    // That means if this method is called *after* we failed to find a bank parser
    // or if we want to early-reject general spam.
    if (nonBankKeywords.any((kw) => normalizedText.contains(kw))) {
      return true;
    }

    return false;
  }
}
