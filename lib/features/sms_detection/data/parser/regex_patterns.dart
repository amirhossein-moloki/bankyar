/// Reusable pre-compiled regular expressions and character maps
/// supporting high-performance Persian and English SMS text decoding.
class RegexPatterns {
  // Pure static utility: no instantiation.
  const RegexPatterns._();

  /// Persian/Arabic digits map to English numbers.
  static const Map<String, String> persianArabicDigitsMap = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  /// Matches any Persian or Arabic numeric characters.
  static final RegExp persianArabicDigitRegExp = RegExp(r'[۰-۹٠-٩]');

  /// Matches all non-digit and non-decimal/comma characters to help extract numbers.
  static final RegExp nonNumberRegExp = RegExp(r'[^0-9.,]');

  /// General financial decimal amount pattern (supports commas/dots as grouping/decimal separators).
  /// For example, extracts numbers like "1,250,000", "450.00", "۱۲,۵۰۰,۰۰۰".
  static final RegExp amountPattern = RegExp(
    r'(?:\d{1,3}(?:[.,]\d{3})+|\d+)(?:[.]\d+)?',
    unicode: true,
  );

  /// Persian version of the amount pattern matching both western and eastern digits.
  /// Removed \b boundaries to support non-ASCII Persian word boundaries correctly.
  static final RegExp localizedAmountPattern = RegExp(
    r'(?:[0-9۰-۹٠-٩]{1,3}(?:[.,٫][0-9۰-۹٠-٩]{3})+|[0-9۰-۹٠-٩]+)(?:[.,٫][0-9۰-۹٠-٩]+)?',
    unicode: true,
  );

  /// Currency identifiers.
  static final RegExp rialPattern = RegExp(
    r'ریال|Rial|Rls',
    caseSensitive: false,
  );
  static final RegExp tomanPattern = RegExp(
    r'تومان|Toman',
    caseSensitive: false,
  );

  /// Card/Account indicators (Farsi and English).
  static final RegExp cardPattern = RegExp(
    r'(?:کارت|حساب|به کارت|از کارت|به حساب|از حساب|card|acc|account|a/c)\s*[:\-\s]*\s*(?:\*+|x+|X+)?([0-9۰-۹٠-٩]+)',
    caseSensitive: false,
    unicode: true,
  );

  /// Explicit 4-digit card or account suffix patterns.
  static final RegExp cardSuffixPattern = RegExp(r'[0-9۰-۹]{4}', unicode: true);

  /// Balance extraction patterns.
  /// Matches "مانده", "موجودی", "balance", "bal", optionally followed by "جدید", etc.
  static final RegExp balancePattern = RegExp(
    r'(?:مانده|موجودی|bal|balance)(?:\s+جدید|\s+کارت|\s+حساب)?\s*[:\-\s]*\s*([0-9۰-۹٠-٩\.,]+)',
    caseSensitive: false,
    unicode: true,
  );

  /// Reference/Tracking code extraction patterns.
  /// Matches "پیگیری", "ارجاع", "مرجع", "ref", "rrn", "trace", "کدرهگیری".
  static final RegExp referencePattern = RegExp(
    r'(?:پیگیری|ارجاع|مرجع|ref|rrn|trace|کدرهگیری|شناسه|ش\.پ)\s*[:\-\s]*\s*([a-zA-Z0-9۰-۹٠-٩]+)',
    caseSensitive: false,
    unicode: true,
  );

  /// Transaction direction markers (Credit vs Debit).
  static final RegExp creditVerbs = RegExp(
    r'واریز|بستانکار|افزایش|برگشت|deposit|credited|received|refund|credit',
    caseSensitive: false,
    unicode: true,
  );

  static final RegExp debitVerbs = RegExp(
    r'برداشت|بدهکار|کاهش|خرید|انتقال|کسر|پرداخت|قبض|withdrawal|debited|paid|spent|purchase|debit',
    caseSensitive: false,
    unicode: true,
  );

  /// Matches OTP/dynamic passwords, verification codes, or activation codes.
  static final RegExp otpPattern = RegExp(
    r'رمز\s*پویا|رمز\s*یکبار\s*مصرف|رمز\s*یکبارمصرف|کد\s*تایید|کد\s*فعالسازی|کد\s*فعال\s*سازی|رمز\s*موقت|کد\s*موقت|رمز\s*دوم\s*پویا',
    caseSensitive: false,
    unicode: true,
  );

  /// Normalizes eastern (Persian/Arabic) numerals to standard western ASCII string.
  static String normalizeNumerals(String input) {
    if (input.isEmpty) return '';
    var buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      final mapped = persianArabicDigitsMap[char];
      if (mapped != null) {
        buffer.write(mapped);
      } else {
        // Handle Persian decimal separator (٫) standardizing to dot (.)
        if (char == '٫') {
          buffer.write('.');
        } else {
          buffer.write(char);
        }
      }
    }
    return buffer.toString();
  }
}
