import 'dart:ui';
import 'package:flutter/material.dart';

/// Design tokens for layout and spacing metrics.
/// Conforms to BankYar LAYOUT_SPACING_SYSTEM.md specifications.
abstract class SpacingTokens {
  /// Extra extra small spacing (2dp)
  static const double xxs = 2.0;

  /// Extra small spacing (4dp)
  static const double xs = 4.0;

  /// Small spacing (8dp)
  static const double s = 8.0;

  /// Medium spacing (12dp)
  static const double m = 12.0;

  /// Large spacing (16dp)
  static const double l = 16.0;

  /// Extra large spacing (24dp)
  static const double xl = 24.0;

  /// Extra extra large spacing (32dp)
  static const double xxl = 32.0;

  /// Extra extra extra large spacing (48dp)
  static const double xxxl = 48.0;

  /// Giant spacing (64dp)
  static const double giant = 64.0;

  /// Default padding for standard screens
  static const double screenPadding = l;

  /// Default spacing between stacked cards
  static const double cardSpacing = m;
}

/// Theme extension for layout spacing to expose to BuildContext.
class SpacingExtension extends ThemeExtension<SpacingExtension> {
  /// Constructor for spacing tokens theme extension.
  const SpacingExtension({
    required this.xxs,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.giant,
  });

  /// Extra extra small spacing
  final double xxs;

  /// Extra small spacing
  final double xs;

  /// Small spacing
  final double s;

  /// Medium spacing
  final double m;

  /// Large spacing
  final double l;

  /// Extra large spacing
  final double xl;

  /// Extra extra large spacing
  final double xxl;

  /// Extra extra extra large spacing
  final double xxxl;

  /// Giant spacing
  final double giant;

  @override
  ThemeExtension<SpacingExtension> copyWith({
    double? xxs,
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? xxl,
    double? xxxl,
    double? giant,
  }) {
    return SpacingExtension(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      s: s ?? this.s,
      m: m ?? this.m,
      l: l ?? this.l,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      giant: giant ?? this.giant,
    );
  }

  @override
  ThemeExtension<SpacingExtension> lerp(
    ThemeExtension<SpacingExtension>? other,
    double t,
  ) {
    if (other is! SpacingExtension) return this;
    return SpacingExtension(
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      s: lerpDouble(s, other.s, t)!,
      m: lerpDouble(m, other.m, t)!,
      l: lerpDouble(l, other.l, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
      giant: lerpDouble(giant, other.giant, t)!,
    );
  }
}
