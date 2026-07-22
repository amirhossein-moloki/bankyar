import 'package:flutter/widgets.dart';

/// Reusable utility class for RTL Persian layout checks.
/// Conforms to ACCESSIBILITY_INCLUSIVE_SYSTEM.md and LAYOUT_SPACING_SYSTEM.md guidelines.
abstract class RtlHelpers {
  /// Returns true if the provided [locale] corresponds to an RTL language (like Farsi).
  static bool isRtl(String locale) {
    final normalized = locale.toLowerCase();
    return normalized == 'fa' ||
        normalized.startsWith('fa_') ||
        normalized == 'ar' ||
        normalized.startsWith('ar_');
  }

  /// Returns [TextDirection.rtl] for RTL locales, and [TextDirection.ltr] for LTR locales.
  static TextDirection textDirection(String locale) {
    return isRtl(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Returns aligned direction based on target [locale].
  static Alignment alignment(String locale) {
    return isRtl(locale) ? Alignment.centerRight : Alignment.centerLeft;
  }

  /// Returns starting alignment based on target [locale] (e.g. top right for RTL, top left for LTR).
  static Alignment directionalAlignment(String locale) {
    return isRtl(locale) ? Alignment.topRight : Alignment.topLeft;
  }
}
