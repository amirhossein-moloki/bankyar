import 'package:flutter/widgets.dart';

/// Reusable utility class assisting offline-first translations.
abstract class LocalizationHelpers {
  /// Resolves the current app locale code from active [BuildContext].
  static String getLocaleCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  /// Selects localized content based on active language code.
  /// Handy for toggling titles, categories, or descriptions inline.
  static T select<T>(
    BuildContext context, {
    required T farsi,
    required T english,
  }) {
    final code = getLocaleCode(context);
    return code == 'fa' ? farsi : english;
  }
}
