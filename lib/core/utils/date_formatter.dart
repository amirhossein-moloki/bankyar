import 'package:intl/intl.dart';

/// Reusable utility class for localized Date Formatting.
/// Supports both Gregorian and Persian localization contexts out-of-the-box.
abstract class DateFormatter {
  /// Formats a standard Gregorian [DateTime] to a localized string using [intl].
  static String format(
    DateTime date, {
    String pattern = 'yyyy/MM/dd',
    String locale = 'fa',
  }) {
    return DateFormat(pattern, locale).format(date);
  }

  /// Formats a standard Gregorian [DateTime] into a friendly human-readable format.
  static String formatFriendly(DateTime date, {String locale = 'fa'}) {
    return DateFormat.yMMMMd(locale).format(date);
  }

  /// Converts English digits in a string to Persian digits (Farsi numerals).
  static String toPersianDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var result = input;
    for (var i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
  }
}
