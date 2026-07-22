import 'package:flutter/material.dart';

/// Design tokens for typography and text styles.
/// Conforms to BankYar TYPOGRAPHY_SYSTEM.md specifications.
abstract class TypographyTokens {
  /// Base font family definitions (System Default falls back to system fonts)
  static const String fontFamilyEn = 'Roboto';

  /// Primary Farsi font family
  static const String fontFamilyFa = 'Vazirmatn';

  /// Bold weight constant
  static const FontWeight weightBold = FontWeight.w700;

  /// Medium weight constant
  static const FontWeight weightMedium = FontWeight.w500;

  /// Regular weight constant
  static const FontWeight weightRegular = FontWeight.w400;

  /// Generates a standardized [TextTheme] based on specifications
  static TextTheme createTextTheme(String fontFamily) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 57.0,
        fontWeight: weightRegular,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 45.0,
        fontWeight: weightRegular,
        letterSpacing: 0.0,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36.0,
        fontWeight: weightRegular,
        letterSpacing: 0.0,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32.0,
        fontWeight: weightRegular,
        letterSpacing: 0.0,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28.0,
        fontWeight: weightRegular,
        letterSpacing: 0.0,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24.0,
        fontWeight: weightRegular,
        letterSpacing: 0.0,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22.0,
        fontWeight: weightMedium,
        letterSpacing: 0.0,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: weightMedium,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: weightMedium,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16.0,
        fontWeight: weightRegular,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: weightRegular,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: weightRegular,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.0,
        fontWeight: weightMedium,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12.0,
        fontWeight: weightMedium,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 11.0,
        fontWeight: weightMedium,
        letterSpacing: 0.5,
      ),
    );
  }
}
