import 'package:flutter/material.dart';

/// Semantic color design tokens.
/// Conforms to BankYar SEMANTIC_COLOR_SYSTEM.md and DARK_THEME_SPECIFICATION.md.
abstract class ColorTokens {
  // Primaries (Light Mode)
  static const Color primaryLight = Color(0xFF1E3A8A); // Deep Navy Blue
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFDBEAFE);
  static const Color onPrimaryContainerLight = Color(0xFF1E40AF);

  // Primaries (Dark Mode)
  static const Color primaryDark = Color(0xFF93C5FD); // Light Pastel Blue
  static const Color onPrimaryDark = Color(0xFF1E3A8A);
  static const Color primaryContainerDark = Color(0xFF1E40AF);
  static const Color onPrimaryContainerDark = Color(0xFFDBEAFE);

  // Secondaries (Light Mode)
  static const Color secondaryLight = Color(0xFF0F766E); // Teal
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFCCFBF1);
  static const Color onSecondaryContainerLight = Color(0xFF115E59);

  // Secondaries (Dark Mode)
  static const Color secondaryDark = Color(0xFF5EEAD4); // Light Teal
  static const Color onSecondaryDark = Color(0xFF0F766E);
  static const Color secondaryContainerDark = Color(0xFF115E59);
  static const Color onSecondaryContainerDark = Color(0xFFCCFBF1);

  // Background and Surfaces (Light Mode)
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate Soft White
  static const Color onBackgroundLight = Color(0xFF0F172A); // Charcoal Black
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color surfaceVariantLight = Color(0xFFE2E8F0);
  static const Color onSurfaceVariantLight = Color(0xFF475569);

  // Background and Surfaces (Dark Mode)
  static const Color backgroundDark = Color(0xFF0B0F19); // Ink/Dark Slate Blue
  static const Color onBackgroundDark = Color(0xFFF1F5F9); // Crisp White/Grey
  static const Color surfaceDark = Color(0xFF111827);
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF1F2937);
  static const Color onSurfaceVariantDark = Color(0xFF9CA3AF);

  // Semantic Alerts / Statuses
  static const Color successLight = Color(0xFF16A34A);
  static const Color onSuccessLight = Color(0xFFFFFFFF);
  static const Color warningLight = Color(0xFFD97706);
  static const Color onWarningLight = Color(0xFFFFFFFF);
  static const Color errorLight = Color(0xFFDC2626);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  static const Color successDark = Color(0xFF4ADE80);
  static const Color onSuccessDark = Color(0xFF16A34A);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color onWarningDark = Color(0xFFD97706);
  static const Color errorDark = Color(0xFFF87171);
  static const Color onErrorDark = Color(0xFFDC2626);
}

/// Theme extension for custom financial transaction statuses and alerts.
class SemanticColorExtension extends ThemeExtension<SemanticColorExtension> {
  /// Constructor for semantic color extension.
  const SemanticColorExtension({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.error,
    required this.onError,
    required this.cardCreditLabel,
    required this.cardDebitLabel,
  });

  /// Success color
  final Color success;

  /// On Success color
  final Color onSuccess;

  /// Warning color
  final Color warning;

  /// On Warning color
  final Color onWarning;

  /// Error color
  final Color error;

  /// On Error color
  final Color onError;

  /// Highlight color for credit transactions
  final Color cardCreditLabel;

  /// Highlight color for debit transactions
  final Color cardDebitLabel;

  @override
  ThemeExtension<SemanticColorExtension> copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? error,
    Color? onError,
    Color? cardCreditLabel,
    Color? cardDebitLabel,
  }) {
    return SemanticColorExtension(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      cardCreditLabel: cardCreditLabel ?? this.cardCreditLabel,
      cardDebitLabel: cardDebitLabel ?? this.cardDebitLabel,
    );
  }

  @override
  ThemeExtension<SemanticColorExtension> lerp(
    ThemeExtension<SemanticColorExtension>? other,
    double t,
  ) {
    if (other is! SemanticColorExtension) return this;
    return SemanticColorExtension(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      cardCreditLabel: Color.lerp(cardCreditLabel, other.cardCreditLabel, t)!,
      cardDebitLabel: Color.lerp(cardDebitLabel, other.cardDebitLabel, t)!,
    );
  }
}
