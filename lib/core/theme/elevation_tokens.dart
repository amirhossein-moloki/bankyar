import 'dart:ui';
import 'package:flutter/material.dart';

/// Elevation design tokens for visual depth hierarchy.
/// Conforms to BankYar SURFACE_ELEVATION_SYSTEM.md specifications.
abstract class ElevationTokens {
  /// Level 0 (0dp elevation) - flat surface
  static const double level0 = 0.0;

  /// Level 1 (1dp elevation) - light cards, list items
  static const double level1 = 1.0;

  /// Level 2 (3dp elevation) - prominent interactive surfaces
  static const double level2 = 3.0;

  /// Level 3 (6dp elevation) - floating action buttons, modals, dropdowns
  static const double level3 = 6.0;

  /// Level 4 (8dp elevation) - priority prompts, custom dialogs
  static const double level4 = 8.0;

  /// Level 5 (12dp elevation) - system-level alerts, critical state dialogs
  static const double level5 = 12.0;
}

/// Theme extension for elevation values to expose in BuildContext.
class ElevationExtension extends ThemeExtension<ElevationExtension> {
  /// Constructor for elevation tokens theme extension.
  const ElevationExtension({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  /// Flat surface (0dp)
  final double level0;

  /// Elevation Level 1 (1dp)
  final double level1;

  /// Elevation Level 2 (3dp)
  final double level2;

  /// Elevation Level 3 (6dp)
  final double level3;

  /// Elevation Level 4 (8dp)
  final double level4;

  /// Elevation Level 5 (12dp)
  final double level5;

  @override
  ThemeExtension<ElevationExtension> copyWith({
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
    double? level5,
  }) {
    return ElevationExtension(
      level0: level0 ?? this.level0,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      level4: level4 ?? this.level4,
      level5: level5 ?? this.level5,
    );
  }

  @override
  ThemeExtension<ElevationExtension> lerp(
    ThemeExtension<ElevationExtension>? other,
    double t,
  ) {
    if (other is! ElevationExtension) return this;
    return ElevationExtension(
      level0: lerpDouble(level0, other.level0, t)!,
      level1: lerpDouble(level1, other.level1, t)!,
      level2: lerpDouble(level2, other.level2, t)!,
      level3: lerpDouble(level3, other.level3, t)!,
      level4: lerpDouble(level4, other.level4, t)!,
      level5: lerpDouble(level5, other.level5, t)!,
    );
  }
}
