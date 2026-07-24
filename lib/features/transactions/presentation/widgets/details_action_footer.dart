import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Pinned footer controls for verifying and deleting the inspected transaction.
class DetailsActionFooter extends StatelessWidget {
  /// Constructor.
  const DetailsActionFooter({
    required this.isVerified,
    required this.onVerify,
    required this.onDelete,
    super.key,
  });

  /// True if transaction confidence score is promoted.
  final bool isVerified;

  /// Callback to verify transaction correctness.
  final VoidCallback onVerify;

  /// Callback to delete transaction permanently.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: isVerified
                  ? OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      label: const Text('تأیید شده'),
                    )
                  : PrimaryButton(
                      label: 'تأیید صحت اطلاعات',
                      onPressed: onVerify,
                    ),
            ),
            SizedBox(width: spacing.s),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: onDelete,
              child: const Text('حذف تراکنش'),
            ),
          ],
        ),
      ),
    );
  }
}
