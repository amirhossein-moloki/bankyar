import 'package:flutter/material.dart';

/// Motion and transition design tokens.
/// Conforms to BankYar MOTION_SYSTEM.md specifications.
abstract class MotionTokens {
  /// Ultra fast duration (50ms) - minor state adjustments, hover transitions
  static const Duration durationUltraFast = Duration(milliseconds: 50);

  /// Fast duration (100ms) - simple fading, checkmark transitions
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Medium fast duration (150ms) - simple expansions, slider steps
  static const Duration durationMediumFast = Duration(milliseconds: 150);

  /// Standard duration (200ms) - standard page transitions, bottom sheet slides
  static const Duration durationStandard = Duration(milliseconds: 200);

  /// Slow duration (300ms) - multi-stage layouts, heavy dialog reveals
  static const Duration durationSlow = Duration(milliseconds: 300);

  /// Ultra slow duration (500ms) - splash screens, complex skeleton reveals
  static const Duration durationUltraSlow = Duration(milliseconds: 500);

  /// Standard Material design curve (FastOutSlowIn)
  static const Curve curveStandard = Curves.fastOutSlowIn;

  /// Accelerate / decelerate curve for entering transitions
  static const Curve curveIncoming = Curves.easeOutCubic;

  /// Easing curve optimized for exit transitions
  static const Curve curveOutgoing = Curves.easeInCubic;

  /// Sharp spring/bounce curve for custom notifications or alarms
  static const Curve curveBounce = Curves.elasticOut;
}

/// Theme extension for motion tokens to expose to BuildContext.
class MotionExtension extends ThemeExtension<MotionExtension> {
  /// Constructor for motion tokens theme extension.
  const MotionExtension({
    required this.durationUltraFast,
    required this.durationFast,
    required this.durationMediumFast,
    required this.durationStandard,
    required this.durationSlow,
    required this.durationUltraSlow,
    required this.curveStandard,
    required this.curveIncoming,
    required this.curveOutgoing,
    required this.curveBounce,
  });

  /// Ultra fast duration (50ms)
  final Duration durationUltraFast;

  /// Fast duration (100ms)
  final Duration durationFast;

  /// Medium fast duration (150ms)
  final Duration durationMediumFast;

  /// Standard duration (200ms)
  final Duration durationStandard;

  /// Slow duration (300ms)
  final Duration durationSlow;

  /// Ultra slow duration (500ms)
  final Duration durationUltraSlow;

  /// Standard transition curve
  final Curve curveStandard;

  /// Incoming/Enter transition curve
  final Curve curveIncoming;

  /// Outgoing/Exit transition curve
  final Curve curveOutgoing;

  /// Bounce curve
  final Curve curveBounce;

  @override
  ThemeExtension<MotionExtension> copyWith({
    Duration? durationUltraFast,
    Duration? durationFast,
    Duration? durationMediumFast,
    Duration? durationStandard,
    Duration? durationSlow,
    Duration? durationUltraSlow,
    Curve? curveStandard,
    Curve? curveIncoming,
    Curve? curveOutgoing,
    Curve? curveBounce,
  }) {
    return MotionExtension(
      durationUltraFast: durationUltraFast ?? this.durationUltraFast,
      durationFast: durationFast ?? this.durationFast,
      durationMediumFast: durationMediumFast ?? this.durationMediumFast,
      durationStandard: durationStandard ?? this.durationStandard,
      durationSlow: durationSlow ?? this.durationSlow,
      durationUltraSlow: durationUltraSlow ?? this.durationUltraSlow,
      curveStandard: curveStandard ?? this.curveStandard,
      curveIncoming: curveIncoming ?? this.curveIncoming,
      curveOutgoing: curveOutgoing ?? this.curveOutgoing,
      curveBounce: curveBounce ?? this.curveBounce,
    );
  }

  @override
  ThemeExtension<MotionExtension> lerp(
    ThemeExtension<MotionExtension>? other,
    double t,
  ) {
    if (other is! MotionExtension) return this;
    return MotionExtension(
      durationUltraFast: t < 0.5 ? durationUltraFast : other.durationUltraFast,
      durationFast: t < 0.5 ? durationFast : other.durationFast,
      durationMediumFast: t < 0.5
          ? durationMediumFast
          : other.durationMediumFast,
      durationStandard: t < 0.5 ? durationStandard : other.durationStandard,
      durationSlow: t < 0.5 ? durationSlow : other.durationSlow,
      durationUltraSlow: t < 0.5 ? durationUltraSlow : other.durationUltraSlow,
      curveStandard: t < 0.5 ? curveStandard : other.curveStandard,
      curveIncoming: t < 0.5 ? curveIncoming : other.curveIncoming,
      curveOutgoing: t < 0.5 ? curveOutgoing : other.curveOutgoing,
      curveBounce: t < 0.5 ? curveBounce : other.curveBounce,
    );
  }
}
