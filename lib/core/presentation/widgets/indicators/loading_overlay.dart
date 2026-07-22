import 'package:flutter/material.dart';
import 'circular_progress.dart';

/// A production-ready Loading Overlay.
/// Blocks user touches during background tasks and displays a clear spinner.
class LoadingOverlay extends StatelessWidget {
  /// Constructor for LoadingOverlay.
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.message,
  });

  /// Overlay is active when true.
  final bool isLoading;

  /// Underlying screen or widget view.
  final Widget child;

  /// Optional loading message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          // Block touches with a modal barrier
          const ModalBarrier(dismissible: false, color: Colors.black38),
          Center(
            child: Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CircularProgress(message: message),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
