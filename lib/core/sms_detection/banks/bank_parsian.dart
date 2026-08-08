import '../bank_parser.dart';
import '../sms_classification.dart';
import '../bank_sms_template.dart';
import '../../../features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/data/parser/regex_patterns.dart';

class ParsianParser extends BaseBankParser {
  const ParsianParser();

  @override
  String get bankId => 'parsian';

  @override
  String get bankName => 'Parsian Bank';

  @override
  List<String> get senderIds => const [
    'Parsian',
    'B.Parsian',
    'B-Parsian',
    'BPA',
    'parsian',
    'b.parsian',
    'b-parsian',
    'bpa',
    'ParsianBank',
    'parsianbank',
  ];

  @override
  List<String> get keywords => const ['پارسیان', 'بانک پارسیان', 'parsian'];

  @override
  List<BankSmsTemplate> get templates => [
    // 1. OTP / Internet Bank Password (high priority to prevent login-template overlap)
    BankSmsTemplate(
      id: 'parsian_otp',
      pattern: RegExp(
        r'رمز\s+ورود\s+به\s+(?:اینترنت|همراه)\s+بانک|مهلت\s+استفاده',
        unicode: true,
      ),
      classification: SmsClassification.bank_otp,
      direction: SmsTransactionType.unknown,
    ),
    // 2. Card Transfer (incomplete/initiation)
    BankSmsTemplate(
      id: 'parsian_card_transfer_init',
      pattern: RegExp(
        r'انتقال\s+به\s+[\s\S]*مبلغ\s*[\s\S]*رمز\s*:',
        unicode: true,
      ),
      classification: SmsClassification.bank_otp,
      direction: SmsTransactionType.unknown,
    ),
    // 3. Recharge
    BankSmsTemplate(
      id: 'parsian_recharge',
      pattern: RegExp(r'شارژ\s+[\s\S]*مبلغ\s*[\s\S]*رمز\s*:', unicode: true),
      classification: SmsClassification.bank_information,
      direction: SmsTransactionType.unknown,
    ),
    // 4. Purchase / Service Payment unconfirmed/initiated
    BankSmsTemplate(
      id: 'parsian_purchase_init',
      pattern: RegExp(r'خرید\s+[\s\S]*مبلغ\s*[\s\S]*Code\s*:', unicode: true),
      classification: SmsClassification.bank_security,
      direction: SmsTransactionType.unknown,
    ),
    // 5. Account Transactions - POL
    BankSmsTemplate(
      id: 'parsian_pol',
      pattern: RegExp(r'تراکنش\s+پُل|پُل|پل', unicode: true),
      classification: SmsClassification.bank_pol,
      direction: SmsTransactionType.unknown,
    ),
    // 6. Account Transactions - Paya
    BankSmsTemplate(
      id: 'parsian_paya',
      pattern: RegExp(r'پایا', unicode: true),
      classification: SmsClassification.bank_paya,
      direction: SmsTransactionType.unknown,
    ),
    // 7. Account Transactions - Satna
    BankSmsTemplate(
      id: 'parsian_satna',
      pattern: RegExp(r'ساتنا', unicode: true),
      classification: SmsClassification.bank_satna,
      direction: SmsTransactionType.unknown,
    ),
    // 8. Account Transactions - Salary
    BankSmsTemplate(
      id: 'parsian_salary',
      pattern: RegExp(r'حقوق', unicode: true),
      classification: SmsClassification.bank_salary,
      direction: SmsTransactionType.credit,
    ),
    // 9. Account Transactions - Interest
    BankSmsTemplate(
      id: 'parsian_interest',
      pattern: RegExp(r'سود', unicode: true),
      classification: SmsClassification.bank_interest,
      direction: SmsTransactionType.credit,
    ),
    // 10. Account Transactions - Refund
    BankSmsTemplate(
      id: 'parsian_refund',
      pattern: RegExp(r'برگشت\s+وجه|برگشت|اصلاح', unicode: true),
      classification: SmsClassification.bank_refund,
      direction: SmsTransactionType.credit,
    ),
    // 11. General Debit
    BankSmsTemplate(
      id: 'parsian_debit',
      pattern: RegExp(r'مبلغ\s*:\s*[0-9۰-۹٠-٩,]+\s*-', unicode: true),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.debit,
    ),
    // 12. General Credit
    BankSmsTemplate(
      id: 'parsian_credit',
      pattern: RegExp(r'مبلغ\s*:\s*[0-9۰-۹٠-٩,]+\s*\+', unicode: true),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.credit,
    ),
    // 13. Mobile Bank Login
    BankSmsTemplate(
      id: 'parsian_login',
      pattern: RegExp(
        r'ورود\s+به\s+همراه\s+بانک|ورود\s+به\s+سیستم',
        unicode: true,
      ),
      classification: SmsClassification.bank_security,
      direction: SmsTransactionType.unknown,
    ),
    // 14. Security Alert
    BankSmsTemplate(
      id: 'parsian_security_alert',
      pattern: RegExp(
        r'به\s+علت\s+تراکنش\s+مشکوک\s+مسدود|مسدود\s+گردید',
        unicode: true,
      ),
      classification: SmsClassification.bank_security,
      direction: SmsTransactionType.unknown,
    ),
    // 15. Mobile Number Change
    BankSmsTemplate(
      id: 'parsian_mobile_change',
      pattern: RegExp(
        r'شماره\s+همراه\s+شما\s+به\s+[\s\S]*تغییر\s+کرد',
        unicode: true,
      ),
      classification: SmsClassification.bank_security,
      direction: SmsTransactionType.unknown,
    ),
    // 16. Password Change
    BankSmsTemplate(
      id: 'parsian_password_change',
      pattern: RegExp(r'تغییر\s+رمز\s+درگاه\s+غیرحضوری', unicode: true),
      classification: SmsClassification.bank_security,
      direction: SmsTransactionType.unknown,
    ),
  ];

  @override
  SmsClassification classify(String rawText) {
    // 1. Try template matching first
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText)) {
        return template.classification;
      }
    }

    // 2. Custom Parsian heuristic fallbacks
    final normalized = RegexPatterns.normalizeNumerals(rawText).toLowerCase();

    if (normalized.contains('رمز ورود') ||
        normalized.contains('مهلت استفاده') ||
        normalized.contains('رمز پویا') ||
        normalized.contains('کد تایید') ||
        normalized.contains('رمز یکبار مصرف')) {
      return SmsClassification.bank_otp;
    }

    if (normalized.contains('ورود به همراه بانک') ||
        normalized.contains('تغییر رمز') ||
        normalized.contains('مسدود گردید') ||
        normalized.contains('تراکنش مشکوک')) {
      return SmsClassification.bank_security;
    }

    if (normalized.contains('شارژ') && normalized.contains('رمز:')) {
      return SmsClassification.bank_information;
    }

    if (normalized.contains('تغییر کرد') &&
        normalized.contains('شماره همراه')) {
      return SmsClassification.bank_security;
    }

    // If it has standard transaction indicators but is a completed one
    final hasAmountWithSign = RegExp(
      r'مبلغ\s*:\s*[0-9۰-۹٠-٩,]+\s*[+-]',
      unicode: true,
    ).hasMatch(rawText);
    final isClassicCompleted =
        (normalized.contains('واریز') ||
            normalized.contains('برداشت') ||
            normalized.contains('مبلغ')) &&
        (normalized.contains('کارت') ||
            normalized.contains('حساب') ||
            normalized.contains('مانده') ||
            normalized.contains('موجودی'));

    if (hasAmountWithSign || isClassicCompleted) {
      if (normalized.contains('پایا')) return SmsClassification.bank_paya;
      if (normalized.contains('ساتنا')) return SmsClassification.bank_satna;
      if (normalized.contains('پل') || normalized.contains('پُل'))
        return SmsClassification.bank_pol;
      if (normalized.contains('حقوق')) return SmsClassification.bank_salary;
      if (normalized.contains('سود')) return SmsClassification.bank_interest;
      if (normalized.contains('برگشت') || normalized.contains('اصلاح'))
        return SmsClassification.bank_refund;
      return SmsClassification.bank_transaction;
    }

    return SmsClassification.bank_unknown;
  }

  @override
  double? parseAmount(String rawText) {
    final normalized = RegexPatterns.normalizeNumerals(rawText);
    final match = RegExp(
      r'مبلغ\s*:\s*([0-9,]+)',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(normalized);
    if (match != null) {
      final amtStr = match.group(1);
      if (amtStr != null) {
        final val = double.tryParse(amtStr.replaceAll(',', ''));
        if (val != null && val > 0) return val;
      }
    }
    return super.parseAmount(rawText);
  }

  @override
  double? parseBalance(String rawText) {
    final normalized = RegexPatterns.normalizeNumerals(rawText);
    final match = RegExp(
      r'مانده\s*:\s*([0-9,]+)',
      caseSensitive: false,
      unicode: true,
    ).firstMatch(normalized);
    if (match != null) {
      final balStr = match.group(1);
      if (balStr != null) {
        final val = double.tryParse(balStr.replaceAll(',', ''));
        if (val != null) return val;
      }
    }
    return super.parseBalance(rawText);
  }

  @override
  String? parseCardIdentifier(String rawText) {
    final normalized = RegexPatterns.normalizeNumerals(rawText);
    final startMatch = RegExp(r'^\s*([0-9]{10,16})').firstMatch(normalized);
    if (startMatch != null) {
      return startMatch.group(1);
    }
    final cardMatch = RegExp(r'کارت\s+([0-9*xX]{4,16})').firstMatch(normalized);
    if (cardMatch != null) {
      return cardMatch.group(1);
    }
    return super.parseCardIdentifier(rawText);
  }

  @override
  String? parseReferenceNumber(String rawText) {
    final normalized = RegexPatterns.normalizeNumerals(rawText);
    final cleanText = normalized
        .replaceAll('\u0650', '')
        .replaceAll('\u0651', '');

    final match = RegExp(
      r'کد\s*رهگیری\s*([0-9]+)',
      unicode: true,
    ).firstMatch(cleanText);
    if (match != null) {
      return match.group(1);
    }

    final match2 = RegExp(
      r'رهگیری\s*([0-9]+)',
      unicode: true,
    ).firstMatch(cleanText);
    if (match2 != null) {
      return match2.group(1);
    }
    return super.parseReferenceNumber(rawText);
  }

  @override
  SmsTransactionType parseTransactionType(String rawText) {
    final normalized = RegexPatterns.normalizeNumerals(rawText).toLowerCase();
    final match = RegExp(
      r'مبلغ\s*:\s*[0-9,]+\s*([+-])',
      unicode: true,
    ).firstMatch(normalized);
    if (match != null) {
      final sign = match.group(1);
      if (sign == '+') {
        return SmsTransactionType.credit;
      } else if (sign == '-') {
        return SmsTransactionType.debit;
      }
    }
    return super.parseTransactionType(rawText);
  }

  @override
  String parseMerchant(String rawText) {
    final match = RegExp(
      r'بابت\s*:\s*(.+)',
      caseSensitive: false,
      dotAll: true,
      unicode: true,
    ).firstMatch(rawText);
    if (match != null) {
      final val = match.group(1);
      if (val != null) {
        return val.trim().replaceAll(RegExp(r'\s+'), ' ');
      }
    }
    return super.parseMerchant(rawText);
  }
}
