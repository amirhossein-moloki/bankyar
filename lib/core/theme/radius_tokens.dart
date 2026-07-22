import 'dart:ui';
import 'package:flutter/material.dart';

/// Corner radius tokens for borders and shapes.
/// Conforms to BankYar SURFACE_ELEVATION_SYSTEM.md specifications.
abstract class RadiusTokens {
  /// Zero corner radius (0dp)
  static const double none = 0.0;

  /// Extra small corner radius (4dp)
  static const double xs = 4.0;

  /// Small corner radius (8dp)
  static const double s = 8.0;

  /// Medium corner radius (12dp)
  static const double m = 12.0;

  /// Large corner radius (16dp)
  static const double l = 16.0;

  /// Extra large corner radius (24dp)
  static const double xl = 24.0;

  /// Maximum circular corner radius (999dp / Pill shape)
  static const double max = 999.0;
}

/// Theme extension for corner radius tokens.
class RadiusExtension extends ThemeExtension<RadiusExtension> {
  /// Constructor for corner radius tokens theme extension.
  const RadiusExtension({
    required this.none,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.max,
  });

  /// Zero radius
  final double none;

  /// Extra small radius
  final double xs;

  /// Small radius
  final double s;

  /// Medium radius
  final double m;

  /// Large radius
  final double l;

  /// Extra large radius
  final double xl;

  /// Max (pill-shaped) radius
  final double max;

  @override
  ThemeExtension<RadiusExtension> copyWith({
    double? none,
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? max,
  }) {
    return RadiusExtension(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      max: max ?? this.max,
    );
  }

  @override
  ThemeExtension<RadiusExtension> lerp(
    ThemeExtension<RadiusExtension>? other,
    double t,
  ) {
    if (other is! RadiusExtension) return this;
    return RadiusExtension(
      none: lerpDouble(none, other.none, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      s: lerpDouble(s, other.s, t)!,
      m: lerpDouble(m, other.m, t)!,
      l: lerpDouble(l, other.l, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      max: lerpDouble(max, other.max, t)!,
    );
  }
}
