import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'elevation_tokens.dart';
import 'motion_tokens.dart';
import 'radius_tokens.dart';
import 'spacing_tokens.dart';
import 'typography_tokens.dart';

/// Central theme engine constructing light and dark Material Design 3 configurations.
/// Integrates all custom design token extensions.
abstract class AppTheme {
  /// Theme extension builder helper for Light Mode.
  static List<ThemeExtension<dynamic>> _extensionsLight(String font) => [
    const SpacingExtension(
      xxs: SpacingTokens.xxs,
      xs: SpacingTokens.xs,
      s: SpacingTokens.s,
      m: SpacingTokens.m,
      l: SpacingTokens.l,
      xl: SpacingTokens.xl,
      xxl: SpacingTokens.xxl,
      xxxl: SpacingTokens.xxxl,
      giant: SpacingTokens.giant,
    ),
    const RadiusExtension(
      none: RadiusTokens.none,
      xs: RadiusTokens.xs,
      s: RadiusTokens.s,
      m: RadiusTokens.m,
      l: RadiusTokens.l,
      xl: RadiusTokens.xl,
      max: RadiusTokens.max,
    ),
    const ElevationExtension(
      level0: ElevationTokens.level0,
      level1: ElevationTokens.level1,
      level2: ElevationTokens.level2,
      level3: ElevationTokens.level3,
      level4: ElevationTokens.level4,
      level5: ElevationTokens.level5,
    ),
    const MotionExtension(
      durationUltraFast: MotionTokens.durationUltraFast,
      durationFast: MotionTokens.durationFast,
      durationMediumFast: MotionTokens.durationMediumFast,
      durationStandard: MotionTokens.durationStandard,
      durationSlow: MotionTokens.durationSlow,
      durationUltraSlow: MotionTokens.durationUltraSlow,
      curveStandard: MotionTokens.curveStandard,
      curveIncoming: MotionTokens.curveIncoming,
      curveOutgoing: MotionTokens.curveOutgoing,
      curveBounce: MotionTokens.curveBounce,
    ),
    const SemanticColorExtension(
      success: ColorTokens.successLight,
      onSuccess: ColorTokens.onSuccessLight,
      warning: ColorTokens.warningLight,
      onWarning: ColorTokens.onWarningLight,
      error: ColorTokens.errorLight,
      onError: ColorTokens.onErrorLight,
      cardCreditLabel: ColorTokens.successLight,
      cardDebitLabel: ColorTokens.errorLight,
    ),
  ];

  /// Theme extension builder helper for Dark Mode.
  static List<ThemeExtension<dynamic>> _extensionsDark(String font) => [
    const SpacingExtension(
      xxs: SpacingTokens.xxs,
      xs: SpacingTokens.xs,
      s: SpacingTokens.s,
      m: SpacingTokens.m,
      l: SpacingTokens.l,
      xl: SpacingTokens.xl,
      xxl: SpacingTokens.xxl,
      xxxl: SpacingTokens.xxxl,
      giant: SpacingTokens.giant,
    ),
    const RadiusExtension(
      none: RadiusTokens.none,
      xs: RadiusTokens.xs,
      s: RadiusTokens.s,
      m: RadiusTokens.m,
      l: RadiusTokens.l,
      xl: RadiusTokens.xl,
      max: RadiusTokens.max,
    ),
    const ElevationExtension(
      level0: ElevationTokens.level0,
      level1: ElevationTokens.level1,
      level2: ElevationTokens.level2,
      level3: ElevationTokens.level3,
      level4: ElevationTokens.level4,
      level5: ElevationTokens.level5,
    ),
    const MotionExtension(
      durationUltraFast: MotionTokens.durationUltraFast,
      durationFast: MotionTokens.durationFast,
      durationMediumFast: MotionTokens.durationMediumFast,
      durationStandard: MotionTokens.durationStandard,
      durationSlow: MotionTokens.durationSlow,
      durationUltraSlow: MotionTokens.durationUltraSlow,
      curveStandard: MotionTokens.curveStandard,
      curveIncoming: MotionTokens.curveIncoming,
      curveOutgoing: MotionTokens.curveOutgoing,
      curveBounce: MotionTokens.curveBounce,
    ),
    const SemanticColorExtension(
      success: ColorTokens.successDark,
      onSuccess: ColorTokens.onSuccessDark,
      warning: ColorTokens.warningDark,
      onWarning: ColorTokens.onWarningDark,
      error: ColorTokens.errorDark,
      onError: ColorTokens.onErrorDark,
      cardCreditLabel: ColorTokens.successDark,
      cardDebitLabel: ColorTokens.errorDark,
    ),
  ];

  /// Generates the complete [ThemeData] configuration for Light Mode.
  static ThemeData createThemeLight({
    String fontFamily = TypographyTokens.fontFamilyEn,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ColorTokens.primaryLight,
        onPrimary: ColorTokens.onPrimaryLight,
        primaryContainer: ColorTokens.primaryContainerLight,
        onPrimaryContainer: ColorTokens.onPrimaryContainerLight,
        secondary: ColorTokens.secondaryLight,
        onSecondary: ColorTokens.onSecondaryLight,
        secondaryContainer: ColorTokens.secondaryContainerLight,
        onSecondaryContainer: ColorTokens.onSecondaryContainerLight,
        background: ColorTokens.backgroundLight,
        onBackground: ColorTokens.onBackgroundLight,
        surface: ColorTokens.surfaceLight,
        onSurface: ColorTokens.onSurfaceLight,
        surfaceVariant: ColorTokens.surfaceVariantLight,
        onSurfaceVariant: ColorTokens.onSurfaceVariantLight,
        error: ColorTokens.errorLight,
        onError: ColorTokens.onErrorLight,
      ),
      textTheme: TypographyTokens.createTextTheme(fontFamily),
      extensions: _extensionsLight(fontFamily),
    );
  }

  /// Generates the complete [ThemeData] configuration for Dark Mode.
  static ThemeData createThemeDark({
    String fontFamily = TypographyTokens.fontFamilyEn,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ColorTokens.primaryDark,
        onPrimary: ColorTokens.onPrimaryDark,
        primaryContainer: ColorTokens.primaryContainerDark,
        onPrimaryContainer: ColorTokens.onPrimaryContainerDark,
        secondary: ColorTokens.secondaryDark,
        onSecondary: ColorTokens.onSecondaryDark,
        secondaryContainer: ColorTokens.secondaryContainerDark,
        onSecondaryContainer: ColorTokens.onSecondaryContainerDark,
        background: ColorTokens.backgroundDark,
        onBackground: ColorTokens.onBackgroundDark,
        surface: ColorTokens.surfaceDark,
        onSurface: ColorTokens.onSurfaceDark,
        surfaceVariant: ColorTokens.surfaceVariantDark,
        onSurfaceVariant: ColorTokens.onSurfaceVariantDark,
        error: ColorTokens.errorDark,
        onError: ColorTokens.onErrorDark,
      ),
      textTheme: TypographyTokens.createTextTheme(fontFamily),
      extensions: _extensionsDark(fontFamily),
    );
  }
}
