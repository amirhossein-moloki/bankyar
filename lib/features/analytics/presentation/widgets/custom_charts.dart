import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/analytics_models.dart';

/// Trend Indicator displaying relative percentage change with a color-coded chevron.
class TrendIndicator extends StatelessWidget {
  /// Constructor.
  const TrendIndicator({
    required this.label,
    required this.value,
    required this.isPositive,
    super.key,
  });

  /// The relative percentage description (e.g. "+15%").
  final String label;

  /// The monetary amount or relative value associated with the trend.
  final double value;

  /// Whether this represents active financial health improvement.
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    final color = isPositive ? semanticColor.success : semanticColor.error;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        SizedBox(width: spacing.xxs),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Custom painted Line Chart supporting RTL flow, high-contrast, and Material Design 3 tokens.
class LineChart extends StatelessWidget {
  /// Constructor.
  const LineChart({required this.points, required this.height, super.key});

  /// Coordinates to plot.
  final List<TrendPoint> points;

  /// Standard vertical height bound.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('داده‌ای برای ترسیم نمودار وجود ندارد.'),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _LineChartPainter(
                points: points,
                primaryLineColor: theme.colorScheme.primary,
                secondaryLineColor: theme.colorScheme.tertiary,
                gridColor: theme.colorScheme.outlineVariant,
                textColor: theme.colorScheme.onSurfaceVariant,
                successColor: semanticColor.success,
                errorColor: semanticColor.error,
                isRtl: true,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.primaryLineColor,
    required this.secondaryLineColor,
    required this.gridColor,
    required this.textColor,
    required this.successColor,
    required this.errorColor,
    required this.isRtl,
  });

  final List<TrendPoint> points;
  final Color primaryLineColor;
  final Color secondaryLineColor;
  final Color gridColor;
  final Color textColor;
  final Color successColor;
  final Color errorColor;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    const double paddingLeft = 16.0;
    const double paddingRight = 48.0;
    const double paddingTop = 16.0;
    const double paddingBottom = 24.0;

    final double drawWidth = size.width - paddingLeft - paddingRight;
    final double drawHeight = size.height - paddingTop - paddingBottom;

    if (drawWidth <= 0 || drawHeight <= 0) return;

    double maxVal = 0.0;
    for (final p in points) {
      if (p.income > maxVal) maxVal = p.income;
      if (p.expense > maxVal) maxVal = p.expense;
    }
    if (maxVal == 0.0) maxVal = 1000.0;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.rtl);

    const int divisions = 4;
    for (int i = 0; i <= divisions; i++) {
      final double y = paddingTop + drawHeight - (i * (drawHeight / divisions));
      final double value = (maxVal / divisions) * i;

      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: CurrencyFormatter.formatToman(value),
        style: TextStyle(color: textColor, fontSize: 8),
      );
      textPainter.layout();

      final labelX = size.width - paddingRight + 4.0;
      textPainter.paint(canvas, Offset(labelX, y - textPainter.height / 2));
    }

    final double stepX = points.length > 1
        ? drawWidth / (points.length - 1)
        : drawWidth;

    final incomePath = Path();
    final expensePath = Path();

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final double incomeY =
          paddingTop + drawHeight - (p.income / maxVal) * drawHeight;
      final double expenseY =
          paddingTop + drawHeight - (p.expense / maxVal) * drawHeight;

      final double x = isRtl
          ? (size.width - paddingRight - (i * stepX))
          : (paddingLeft + (i * stepX));

      if (i == 0) {
        incomePath.moveTo(x, incomeY);
        expensePath.moveTo(x, expenseY);
      } else {
        incomePath.lineTo(x, incomeY);
        expensePath.lineTo(x, expenseY);
      }

      if (points.length < 7 ||
          i % (points.length ~/ 3).clamp(1, points.length) == 0) {
        textPainter.text = TextSpan(
          text: p.label,
          style: TextStyle(color: textColor, fontSize: 8),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height - paddingBottom + 4.0),
        );
      }
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(incomePath, linePaint..color = successColor);
    canvas.drawPath(expensePath, linePaint..color = errorColor);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.primaryLineColor != primaryLineColor ||
        oldDelegate.secondaryLineColor != secondaryLineColor ||
        oldDelegate.textColor != textColor;
  }
}

/// Responsive Bar Chart supporting RTL order and custom themes.
class BarChart extends StatelessWidget {
  /// Constructor.
  const BarChart({required this.points, required this.height, super.key});

  /// Trend coordinates representing columns.
  final List<TrendPoint> points;

  /// Standard vertical height bound.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('داده‌ای برای نمایش نمودار ستونی وجود ندارد.'),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _BarChartPainter(
                points: points,
                gridColor: theme.colorScheme.outlineVariant,
                textColor: theme.colorScheme.onSurfaceVariant,
                incomeColor: semanticColor.success,
                expenseColor: semanticColor.error,
                isRtl: true,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.points,
    required this.gridColor,
    required this.textColor,
    required this.incomeColor,
    required this.expenseColor,
    required this.isRtl,
  });

  final List<TrendPoint> points;
  final Color gridColor;
  final Color textColor;
  final Color incomeColor;
  final Color expenseColor;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    const double paddingLeft = 16.0;
    const double paddingRight = 48.0;
    const double paddingTop = 16.0;
    const double paddingBottom = 24.0;

    final double drawWidth = size.width - paddingLeft - paddingRight;
    final double drawHeight = size.height - paddingTop - paddingBottom;

    if (drawWidth <= 0 || drawHeight <= 0) return;

    double maxVal = 0.0;
    for (final p in points) {
      if (p.income > maxVal) maxVal = p.income;
      if (p.expense > maxVal) maxVal = p.expense;
    }
    if (maxVal == 0.0) maxVal = 1000.0;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(textDirection: TextDirection.rtl);

    const int divisions = 4;
    for (int i = 0; i <= divisions; i++) {
      final double y = paddingTop + drawHeight - (i * (drawHeight / divisions));
      final double value = (maxVal / divisions) * i;

      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      textPainter.text = TextSpan(
        text: CurrencyFormatter.formatToman(value),
        style: TextStyle(color: textColor, fontSize: 8),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(size.width - paddingRight + 4.0, y - textPainter.height / 2),
      );
    }

    final double totalBarGroups = points.length.toDouble();
    final double groupWidth = drawWidth / totalBarGroups;
    final double barWidth = (groupWidth * 0.3).clamp(4.0, 16.0);
    const double barSpacing = 2.0;

    final incomePaint = Paint()
      ..color = incomeColor
      ..style = PaintingStyle.fill;

    final expensePaint = Paint()
      ..color = expenseColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];

      final double incomeY =
          paddingTop + drawHeight - (p.income / maxVal) * drawHeight;
      final double expenseY =
          paddingTop + drawHeight - (p.expense / maxVal) * drawHeight;

      final double groupCenter = isRtl
          ? (size.width - paddingRight - (i * groupWidth) - groupWidth / 2)
          : (paddingLeft + (i * groupWidth) + groupWidth / 2);

      final double incomeX = groupCenter - barWidth - barSpacing;
      final double expenseX = groupCenter + barSpacing;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(
            incomeX,
            incomeY,
            incomeX + barWidth,
            paddingTop + drawHeight,
          ),
          topLeft: const Radius.circular(2),
          topRight: const Radius.circular(2),
        ),
        incomePaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(
            expenseX,
            expenseY,
            expenseX + barWidth,
            paddingTop + drawHeight,
          ),
          topLeft: const Radius.circular(2),
          topRight: const Radius.circular(2),
        ),
        expensePaint,
      );

      textPainter.text = TextSpan(
        text: p.label,
        style: TextStyle(color: textColor, fontSize: 8),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          groupCenter - textPainter.width / 2,
          size.height - paddingBottom + 4.0,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.textColor != textColor;
  }
}

/// Custom Donut/Pie Chart representing categorical distributions.
class PieDonutChart extends StatelessWidget {
  /// Constructor.
  const PieDonutChart({required this.data, required this.height, super.key});

  /// Categories mapping to absolute amounts.
  final Map<String, double> data;

  /// Display height limit.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('آماری برای نمایش سهم دسته‌بندی وجود ندارد.'),
        ),
      );
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalSum = data.values.fold(0.0, (sum, val) => sum + val);

    final palette = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.primaryContainer,
      theme.colorScheme.secondaryContainer,
      theme.colorScheme.tertiaryContainer,
      theme.colorScheme.outline,
    ];

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedEntries.length.clamp(0, 5),
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              final percentage = totalSum > 0
                  ? (entry.value / totalSum) * 100
                  : 0.0;
              final color = palette[index % palette.length];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.xxs),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}٪',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(width: spacing.m),
        SizedBox(
          width: height,
          height: height,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _PieDonutPainter(
                entries: sortedEntries,
                totalSum: totalSum,
                palette: palette,
                surfaceColor: theme.colorScheme.surface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PieDonutPainter extends CustomPainter {
  _PieDonutPainter({
    required this.entries,
    required this.totalSum,
    required this.palette,
    required this.surfaceColor,
  });

  final List<MapEntry<String, double>> entries;
  final double totalSum;
  final List<Color> palette;
  final Color surfaceColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (totalSum <= 0.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final sweepAngle = (entry.value / totalSum) * 2 * math.pi;

      paint.color = palette[i % palette.length];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    final linePaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    startAngle = -math.pi / 2;
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final sweepAngle = (entry.value / totalSum) * 2 * math.pi;

      final double endX = center.dx + radius * math.cos(startAngle);
      final double endY = center.dy + radius * math.sin(startAngle);

      canvas.drawLine(center, Offset(endX, endY), linePaint);

      startAngle += sweepAngle;
    }

    final hollowPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.55, hollowPaint);
  }

  @override
  bool shouldRepaint(covariant _PieDonutPainter oldDelegate) {
    return oldDelegate.totalSum != totalSum || oldDelegate.entries != entries;
  }
}
