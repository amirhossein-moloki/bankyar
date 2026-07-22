import 'package:flutter/material.dart';
import '../../../theme/radius_tokens.dart';

/// A production-ready pulsing Loading Skeleton block.
/// Follows BankYar design tokens, dimensions mappings, and accessibility.
class SkeletonLoader extends StatefulWidget {
  /// Constructor for SkeletonLoader.
  const SkeletonLoader({
    required this.width,
    required this.height,
    super.key,
    this.borderRadius,
  });

  /// Visual width.
  final double width;

  /// Visual height.
  final double height;

  /// Optional custom border radius.
  final double? borderRadius;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.35,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<RadiusExtension>()!;

    return Semantics(
      label: 'Loading placeholder',
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.12),
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? radius.s,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
