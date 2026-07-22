import 'package:intl/intl.dart';
import 'date_formatter.dart';

/// Reusable utility class for localized Currency Formatting.
/// Tailored specifically for Persian/Iranian finance units (Rial and Toman).
abstract class CurrencyFormatter {
  /// Formats a numeric amount into a standardized comma-separated string.
  static String format(double amount, {String locale = 'fa'}) {
    final formatter = NumberFormat('#,###', locale);
    return formatter.format(amount);
  }

  /// Formats a monetary value to Rial currency (e.g., "۱۵۰,۰۰۰ ریال").
  static String formatRial(
    double amount, {
    bool usePersianDigits = true,
    bool appendSymbol = true,
  }) {
    final formatted = format(amount, locale: 'en'); // get english commas first
    final withDigits = usePersianDigits
        ? DateFormatter.toPersianDigits(formatted)
        : formatted;
    return appendSymbol ? '$withDigits ریال' : withDigits;
  }

  /// Formats a monetary value to Toman currency (e.g., "۱۵,۰۰۰ تومان").
  static String formatToman(
    double amount, {
    bool usePersianDigits = true,
    bool appendSymbol = true,
  }) {
    final formatted = format(amount, locale: 'en'); // get english commas first
    final withDigits = usePersianDigits
        ? DateFormatter.toPersianDigits(formatted)
        : formatted;
    return appendSymbol ? '$withDigits تومان' : withDigits;
  }
}
