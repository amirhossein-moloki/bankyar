import 'package:flutter/material.dart';
import '../../../theme/color_tokens.dart';
import '../../../theme/spacing_tokens.dart';
import 'base_card.dart';

/// A production-ready Material 3 Transaction Item Card.
/// Follows BankYar design tokens, semantic statuses, and accessibility.
class TransactionCard extends StatelessWidget {
  /// Constructor for TransactionCard.
  const TransactionCard({
    required this.amount,
    required this.timestamp,
    required this.category,
    required this.accountLabel,
    required this.isCredit,
    this.note,
    super.key,
    this.onTap,
  });

  /// Optional note for the transaction.
  final String? note;

  /// The formatted transaction amount.
  final String amount;

  /// The formatted date or time of transaction.
  final String timestamp;

  /// The category name tag.
  final String category;

  /// The bank card or account nickname.
  final String accountLabel;

  /// Whether transaction is incoming credit (+) or outgoing debit (-).
  final bool isCredit;

  /// Optional tap callback to open detailed sheets.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    final amountColor = isCredit ? semanticColor.success : semanticColor.error;

    return BaseCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spacing.l),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bank card / category details (Right side in Persian RTL, Left in English)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Row(
                    children: [
                      Text(
                        accountLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: spacing.s),
                      Text(
                        timestamp,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (note != null && note!.trim().isNotEmpty) ...[
                    SizedBox(height: spacing.xxs),
                    Row(
                      children: [
                        Icon(
                          Icons.edit_note_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: spacing.xxs),
                        Expanded(
                          child: Text(
                            note!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Amount and direction indicator (Left side in Persian RTL)
            Text(
              amount,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
