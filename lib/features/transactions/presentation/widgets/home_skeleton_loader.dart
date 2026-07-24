import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/indicators/skeleton_loader.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Shimmer loading skeleton layout for the Home Dashboard.
class HomeSkeletonLoader extends StatelessWidget {
  /// Constructor.
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return ListView(
      padding: EdgeInsets.all(spacing.m),
      children: [
        const SkeletonLoader(width: 200, height: 24),
        SizedBox(height: spacing.m),
        const SkeletonLoader(width: double.infinity, height: 120),
        SizedBox(height: spacing.m),
        Row(
          children: [
            const Expanded(child: SkeletonLoader(width: 100, height: 80)),
            SizedBox(width: spacing.s),
            const Expanded(child: SkeletonLoader(width: 100, height: 80)),
          ],
        ),
        SizedBox(height: spacing.l),
        const SkeletonLoader(width: 150, height: 20),
        SizedBox(height: spacing.m),
        const SkeletonLoader(width: double.infinity, height: 60),
        SizedBox(height: spacing.s),
        const SkeletonLoader(width: double.infinity, height: 60),
      ],
    );
  }
}
