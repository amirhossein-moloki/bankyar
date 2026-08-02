import '../../features/sms_detection/domain/entities/parsed_transaction.dart';
import '../../features/sms_detection/data/parser/regex_patterns.dart';
import '../../features/sms_detection/data/parser/modular_parsers.dart';
import 'sms_classification.dart';
import 'bank_sms_template.dart';

/// Abstract interface representing a single bank's SMS parser and configuration.
abstract class BankParser {
  /// Unique bank ID (e.g. 'melli').
  String get bankId;

  /// Localized name of the bank (e.g. 'Bank Melli Iran').
  String get bankName;

  /// List of matching sender names, numbers, aliases, case variants, etc.
  List<String> get senderIds;

  /// List of bank-specific keywords for fallback/keyword matching.
  List<String> get keywords;

  /// List of independent templates owned by this bank.
  List<BankSmsTemplate> get templates;

  /// Classifies the given SMS raw body.
  SmsClassification classify(String rawText);

  /// Standard parser implementations for financial attributes.
  double? parseAmount(String rawText);
  String? parseCardIdentifier(String rawText);
  double? parseBalance(String rawText);
  String? parseReferenceNumber(String rawText);
  SmsTransactionType parseTransactionType(String rawText);
  String parseMerchant(String rawText);
}

/// Base abstract class providing robust, production-grade default parser logic.
abstract class BaseBankParser implements BankParser {
  const BaseBankParser();

  @override
  List<String> get keywords => const [];

  @override
  List<BankSmsTemplate> get templates => const [];

  @override
  SmsClassification classify(String rawText) {
    // 1. Try template matching first
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText)) {
        return template.classification;
      }
    }

    // 2. OTP/Dynamic password detection (Early rejection of transaction status)
    if (RegexPatterns.otpPattern.hasMatch(rawText)) {
      return SmsClassification.bank_otp;
    }

    final normalized = rawText.toLowerCase();

    // 3. Security Alerts
    if (normalized.contains('ورود به سیستم') ||
        normalized.contains('اینترنت بانک') ||
        normalized.contains('همراه بانک') ||
        normalized.contains('تغییر رمز') ||
        normalized.contains('مسدود شدن') ||
        normalized.contains('امنیتی') ||
        normalized.contains('پورتال') ||
        normalized.contains('نام کاربری')) {
      return SmsClassification.bank_security;
    }

    // 4. Bank Advertisements / Special Promos
    if (normalized.contains('جشنواره') ||
        normalized.contains('قرعه کشی') ||
        normalized.contains('تسهیلات ویژه') ||
        normalized.contains('قرعه‌کشی') ||
        normalized.contains('طرح فیروزه‌ای') ||
        normalized.contains('طرح امید') ||
        normalized.contains('تسهیلات') && normalized.contains('ویژه')) {
      return SmsClassification.bank_promotional;
    }

    // 5. Loans & Installments
    if (normalized.contains('قسط') ||
        normalized.contains('سررسید') ||
        normalized.contains('پرداخت وام') ||
        normalized.contains('سررسید وام') ||
        normalized.contains('اقساط')) {
      return SmsClassification.bank_loan;
    }

    // 6. Cheques
    if (normalized.contains('چک صیاد') ||
        normalized.contains('چک') ||
        normalized.contains('صیادی') ||
        normalized.contains('وصول چک') ||
        normalized.contains('برگشت چک')) {
      return SmsClassification.bank_cheque;
    }

    // 7. Card/Account Status Change
    if (normalized.contains('صدور کارت') ||
        (normalized.contains('کارت') &&
            (normalized.contains('صادر شد') ||
                normalized.contains('صادر و') ||
                normalized.contains('صادر گردید') ||
                normalized.contains('صدور'))) ||
        normalized.contains('انقضای کارت') ||
        normalized.contains('غیرفعال شدن کارت') ||
        normalized.contains('فعال سازی کارت') ||
        normalized.contains('فعال‌سازی کارت')) {
      return SmsClassification.bank_card_status;
    }

    // 8. Statements
    if (normalized.contains('خلاصه حساب') ||
        normalized.contains('صورتحساب') ||
        normalized.contains('گردش حساب')) {
      return SmsClassification.bank_statement;
    }

    // 9. Informational / Notifications / Branch updates
    if (normalized.contains('پیشخوان') ||
        normalized.contains('تبریک') ||
        normalized.contains('تولد') ||
        normalized.contains('ساعت کار') ||
        normalized.contains('تغییر ساعت') ||
        normalized.contains('مشتری گرامی')) {
      return SmsClassification.bank_information;
    }

    // 10. Standard Transaction with specialized categories
    final isCredit =
        RegexPatterns.creditVerbs.hasMatch(normalized) ||
        normalized.contains('+');
    final isDebit =
        RegexPatterns.debitVerbs.hasMatch(normalized) ||
        normalized.contains('-');
    final hasCurrency =
        normalized.contains('ریال') ||
        normalized.contains('تومان') ||
        normalized.contains('rial') ||
        normalized.contains('toman') ||
        normalized.contains('rls');
    final hasAmountMarker =
        normalized.contains('مبلغ') || AmountParser.parse(rawText) != null;

    if ((isCredit || isDebit) &&
        (hasCurrency ||
            normalized.contains('کارت') ||
            normalized.contains('حساب') ||
            hasAmountMarker)) {
      if (normalized.contains('پایا')) {
        return SmsClassification.bank_paya;
      }
      if (normalized.contains('ساتنا')) {
        return SmsClassification.bank_satna;
      }
      if (normalized.contains('پل')) {
        return SmsClassification.bank_pol;
      }
      if (normalized.contains('حقوق')) {
        return SmsClassification.bank_salary;
      }
      if (normalized.contains('سود')) {
        return SmsClassification.bank_interest;
      }
      if (normalized.contains('برگشت') || normalized.contains('اصلاح')) {
        return SmsClassification.bank_refund;
      }
      if (normalized.contains('افتتاح')) {
        return SmsClassification.bank_account_opening;
      }
      return SmsClassification.bank_transaction;
    }

    return SmsClassification.bank_unknown;
  }

  @override
  double? parseAmount(String rawText) {
    // 1. Try template-specific amount extraction first
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText) &&
          template.amountPattern != null) {
        final match = template.amountPattern!.firstMatch(rawText);
        if (match != null && match.groupCount >= 1) {
          final amtStr = match.group(1);
          if (amtStr != null) {
            final val = double.tryParse(amtStr.replaceAll(',', ''));
            if (val != null && val > 0) return val;
          }
        }
      }
    }
    return AmountParser.parse(rawText);
  }

  @override
  String? parseCardIdentifier(String rawText) {
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText) && template.cardPattern != null) {
        final match = template.cardPattern!.firstMatch(rawText);
        if (match != null && match.groupCount >= 1) {
          final card = match.group(1);
          if (card != null && card.isNotEmpty) return card;
        }
      }
    }
    return CardParser.parse(rawText);
  }

  @override
  double? parseBalance(String rawText) {
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText) &&
          template.balancePattern != null) {
        final match = template.balancePattern!.firstMatch(rawText);
        if (match != null && match.groupCount >= 1) {
          final balStr = match.group(1);
          if (balStr != null) {
            final val = double.tryParse(balStr.replaceAll(',', ''));
            if (val != null) return val;
          }
        }
      }
    }
    return BalanceParser.parse(rawText);
  }

  @override
  String? parseReferenceNumber(String rawText) {
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText) && template.refPattern != null) {
        final match = template.refPattern!.firstMatch(rawText);
        if (match != null && match.groupCount >= 1) {
          final ref = match.group(1);
          if (ref != null && ref.isNotEmpty) return ref;
        }
      }
    }
    return ReferenceParser.parse(rawText);
  }

  @override
  SmsTransactionType parseTransactionType(String rawText) {
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText) &&
          template.direction != SmsTransactionType.unknown) {
        return template.direction;
      }
    }

    final normalized = RegexPatterns.normalizeNumerals(rawText).trim();
    final isCredit = RegexPatterns.creditVerbs.hasMatch(normalized);
    final isDebit = RegexPatterns.debitVerbs.hasMatch(normalized);

    if (isCredit && !isDebit) {
      return SmsTransactionType.credit;
    } else if (isDebit && !isCredit) {
      return SmsTransactionType.debit;
    } else if (isCredit && isDebit) {
      return SmsTransactionType.debit; // safe fallback
    }
    return SmsTransactionType.unknown;
  }

  @override
  String parseMerchant(String rawText) {
    for (final template in templates) {
      if (template.pattern.hasMatch(rawText) &&
          template.merchantPattern != null) {
        final match = template.merchantPattern!.firstMatch(rawText);
        if (match != null && match.groupCount >= 1) {
          final merch = match.group(1);
          if (merch != null && merch.isNotEmpty) return merch;
        }
      }
    }
    return MerchantParser.parse(rawText);
  }
}
