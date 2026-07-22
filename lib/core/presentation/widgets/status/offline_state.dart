import 'package:flutter/material.dart';

/// A production-ready Offline State banner/card widget.
/// Follows BankYar design tokens, privacy policies, and accessibility.
class OfflineState extends StatelessWidget {
  /// Constructor for OfflineState.
  const OfflineState({required this.message, super.key, this.title});

  /// Offline explanation message.
  final String message;

  /// Optional heading title.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64.0,
              color: theme.colorScheme.onSurface.withOpacity(0.38),
            ),
            const SizedBox(height: 16.0),
            Text(
              title ?? 'Offline Mode',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
