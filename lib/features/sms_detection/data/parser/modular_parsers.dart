import 'regex_patterns.dart';

/// Specialized parser focusing on isolating and normalizing transactional amounts.
class AmountParser {
  const AmountParser._();

  /// Extracts transaction amount from raw SMS body.
  /// Standardizes Persian/Arabic digits, handles formatting grouping symbols,
  /// and outputs a parsed double.
  static double? parse(String rawText) {
    if (rawText.isEmpty) return null;

    // Strip date strings (e.g. 1402/11/25 or 2023-10-15) first to avoid date numerals leaking as amounts
    final dateRegExp = RegExp(
      r'[0-9۰-۹]{2,4}[/\-][0-9۰-۹]{1,2}[/\-][0-9۰-۹]{1,2}',
    );
    final textWithoutDates = rawText.replaceAll(dateRegExp, ' ');

    final normalized = RegexPatterns.normalizeNumerals(textWithoutDates);

    // Look for localized amount matches first
    final matches = RegexPatterns.localizedAmountPattern.allMatches(normalized);
    if (matches.isEmpty) return null;

    for (final match in matches) {
      final matchStr = match.group(0);
      if (matchStr == null || matchStr.trim().isEmpty) continue;

      // Ensure it has at least one digit
      if (!RegExp(r'\d').hasMatch(matchStr)) continue;

      // Clean string: remove commas used as grouping separators
      final cleanedStr = _cleanNumericString(matchStr);
      final val = double.tryParse(cleanedStr);
      if (val != null && val > 0 && val < 1000000000000) {
        // If it's 4 digits, let's verify it's not a card or account identifier
        if (cleanedStr.length == 4 &&
            _isProbablyCardOrAccount(normalized, matchStr)) {
          continue;
        }
        return val;
      }
    }

    // Try a simpler match if above fails
    final simpleMatches = RegexPatterns.amountPattern.allMatches(normalized);
    for (final match in simpleMatches) {
      final matchStr = match.group(0);
      if (matchStr == null) continue;
      final cleanedStr = _cleanNumericString(matchStr);
      final val = double.tryParse(cleanedStr);
      if (val != null &&
          val > 0 &&
          !_isProbablyCardOrAccount(normalized, matchStr)) {
        return val;
      }
    }

    return null;
  }

  static String _cleanNumericString(String input) {
    var clean = input.replaceAll(
      '٫',
      '.',
    ); // Standardize Persian decimal separator
    if (clean.contains(',') && clean.contains('.')) {
      clean = clean.replaceAll(',', '');
    } else if (clean.contains(',')) {
      final parts = clean.split(',');
      if (parts.length > 1 && parts.sublist(1).every((p) => p.length == 3)) {
        clean = clean.replaceAll(',', '');
      } else {
        clean = clean.replaceAll(',', '.');
      }
    }
    return clean;
  }

  static bool _isProbablyCardOrAccount(
    String normalizedText,
    String candidate,
  ) {
    final index = normalizedText.indexOf(candidate);
    if (index == -1) return false;

    // Check immediately preceding characters for card/account labels (max 8 chars before)
    final start = (index - 8).clamp(0, normalizedText.length);
    final snippet = normalizedText.substring(start, index).toLowerCase();

    if (snippet.contains('کارت') ||
        snippet.contains('حساب') ||
        snippet.contains('card') ||
        snippet.contains('acc')) {
      return true;
    }
    return false;
  }
}

/// Specialized parser to extract credit card or bank account identifier suffixes.
class CardParser {
  const CardParser._();

  /// Extracts card suffix or account number (typically final 4 digits, or a masked string).
  static String? parse(String rawText) {
    if (rawText.isEmpty) return null;

    final normalized = RegexPatterns.normalizeNumerals(rawText);

    // 1. Try to find a match with asterisks or X masks first, e.g. ***4321
    final maskedCardPattern = RegExp(r'(?:\*+|[xX]+)([0-9]{4})\b');
    final maskedMatch = maskedCardPattern.firstMatch(normalized);
    if (maskedMatch != null && maskedMatch.groupCount >= 1) {
      final suffix = maskedMatch.group(1);
      if (suffix != null && suffix.isNotEmpty) {
        return suffix;
      }
    }

    // 2. Try standard card pattern next
    final match = RegexPatterns.cardPattern.firstMatch(normalized);
    if (match != null && match.groupCount >= 1) {
      final digits = match.group(1);
      if (digits != null && digits.isNotEmpty) {
        return digits.length > 4 ? digits.substring(digits.length - 4) : digits;
      }
    }

    // 3. Fallback: return the last 4-digit sequence found in the message
    final standaloneRefPattern = RegExp(r'\b[0-9]{4}\b');
    final matches = standaloneRefPattern.allMatches(normalized).toList();
    if (matches.isNotEmpty) {
      final matchStr = matches.last.group(0);
      if (matchStr != null) {
        return matchStr;
      }
    }

    return null;
  }
}

/// Specialized parser to extract post-transaction account balance figures.
class BalanceParser {
  const BalanceParser._();

  /// Extracts the active balance from the raw text body.
  static double? parse(String rawText) {
    if (rawText.isEmpty) return null;

    final normalized = RegexPatterns.normalizeNumerals(rawText);
    final match = RegexPatterns.balancePattern.firstMatch(normalized);
    if (match != null && match.groupCount >= 1) {
      final valStr = match.group(1);
      if (valStr != null) {
        final cleaned = valStr.replaceAll(',', '').replaceAll(' ', '');
        return double.tryParse(cleaned);
      }
    }
    return null;
  }
}

/// Specialized parser to isolate merchant counterparties or store names.
class MerchantParser {
  const MerchantParser._();

  /// Extracts merchant name from raw SMS text.
  static String parse(String rawText) {
    if (rawText.isEmpty) return '';

    // Flexible Iranian bank merchant markers supporting optional colons
    final merchantIndicators = [
      RegExp(r'خرید\s+از\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
      RegExp(r'فروشگاه\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
      RegExp(r'پذیرنده\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
      RegExp(r'انتقال\s+به\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
      RegExp(r'بابت\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
      RegExp(r'at\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
      RegExp(r'to\s*[:\-]?\s*([^:\-\n\r]+)', caseSensitive: false),
    ];

    for (final regex in merchantIndicators) {
      final match = regex.firstMatch(rawText);
      if (match != null && match.groupCount >= 1) {
        final merchant = match.group(1)?.trim();
        if (merchant != null && merchant.isNotEmpty) {
          return _cleanMerchantName(merchant);
        }
      }
    }

    return '';
  }

  static String _cleanMerchantName(String rawMerchant) {
    var cleaned = rawMerchant;

    final separators = ['،', ',', ';', '|', '\t', ' - '];
    for (final sep in separators) {
      if (cleaned.contains(sep)) {
        cleaned = cleaned.split(sep).first;
      }
    }

    cleaned = cleaned.replaceAll(RegExp(r'\b[0-9۰-۹]{5,}\b'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (cleaned.length > 50) {
      cleaned = cleaned.substring(0, 50).trim();
    }

    return cleaned;
  }
}

/// Specialized parser to extract reference, tracking, or trace numbers.
class ReferenceParser {
  const ReferenceParser._();

  /// Extracts a transaction reference or tracking code.
  static String? parse(String rawText) {
    if (rawText.isEmpty) return null;

    final normalized = RegexPatterns.normalizeNumerals(rawText);
    final match = RegexPatterns.referencePattern.firstMatch(normalized);
    if (match != null && match.groupCount >= 1) {
      final ref = match.group(1)?.trim();
      if (ref != null && ref.isNotEmpty && ref.length >= 4) {
        return ref;
      }
    }

    final standaloneRefPattern = RegExp(r'\b[0-9]{6,12}\b');
    final matches = standaloneRefPattern.allMatches(normalized);
    for (final m in matches) {
      final matchStr = m.group(0);
      if (matchStr != null &&
          !matchStr.contains('/') &&
          !matchStr.contains(':')) {
        return matchStr;
      }
    }

    return null;
  }
}

/// Specialized parser to extract date and time parameters, matching Persian or Gregorian formats.
class DateTimeParser {
  const DateTimeParser._();

  /// Attempts to parse transactional date/time from raw text.
  /// Falls back to [receivedAt] if explicit parameters aren't found or parsed.
  static int parse(String rawText, int receivedAt) {
    if (rawText.isEmpty) return receivedAt;

    final normalized = RegexPatterns.normalizeNumerals(rawText);

    final timeRegex = RegExp(r'\b(\d{2}):(\d{2})(?::(\d{2}))?\b');
    final timeMatch = timeRegex.firstMatch(normalized);

    int? hour;
    int? minute;
    int? second;

    if (timeMatch != null) {
      hour = int.tryParse(timeMatch.group(1) ?? '');
      minute = int.tryParse(timeMatch.group(2) ?? '');
      second = int.tryParse(timeMatch.group(3) ?? '0');
    }

    if (hour != null && minute != null && second != null) {
      if (hour >= 0 &&
          hour < 24 &&
          minute >= 0 &&
          minute < 60 &&
          second >= 0 &&
          second < 60) {
        final originalDate = DateTime.fromMillisecondsSinceEpoch(receivedAt);
        final updatedDate = DateTime(
          originalDate.year,
          originalDate.month,
          originalDate.day,
          hour,
          minute,
          second,
        );
        return updatedDate.millisecondsSinceEpoch;
      }
    }

    return receivedAt;
  }
}
