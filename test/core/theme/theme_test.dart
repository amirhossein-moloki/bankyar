import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/theme/color_tokens.dart';
import 'package:bankyar/core/theme/elevation_tokens.dart';
import 'package:bankyar/core/theme/motion_tokens.dart';
import 'package:bankyar/core/theme/radius_tokens.dart';
import 'package:bankyar/core/theme/spacing_tokens.dart';

void main() {
  group('AppTheme Token Configurations Tests', () {
    test('Light theme creates valid ThemeData with customized extensions', () {
      final theme = AppTheme.createThemeLight();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.light));
      expect(theme.colorScheme.primary, equals(ColorTokens.primaryLight));

      // Retrieve Theme Extensions
      final spacing = theme.extension<SpacingExtension>();
      final radius = theme.extension<RadiusExtension>();
      final elevation = theme.extension<ElevationExtension>();
      final motion = theme.extension<MotionExtension>();
      final semanticColor = theme.extension<SemanticColorExtension>();

      expect(spacing, isNotNull);
      expect(spacing!.l, equals(SpacingTokens.l));

      expect(radius, isNotNull);
      expect(radius!.m, equals(RadiusTokens.m));

      expect(elevation, isNotNull);
      expect(elevation!.level3, equals(ElevationTokens.level3));

      expect(motion, isNotNull);
      expect(motion!.durationStandard, equals(MotionTokens.durationStandard));

      expect(semanticColor, isNotNull);
      expect(semanticColor!.success, equals(ColorTokens.successLight));
    });

    test('Dark theme creates valid ThemeData with dark mode parameters', () {
      final theme = AppTheme.createThemeDark();

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.colorScheme.primary, equals(ColorTokens.primaryDark));

      final semanticColor = theme.extension<SemanticColorExtension>();
      expect(semanticColor, isNotNull);
      expect(semanticColor!.success, equals(ColorTokens.successDark));
    });
  });
}
