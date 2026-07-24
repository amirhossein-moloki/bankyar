import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Transaction Details summary card containing large amount highlight and masks.
class DetailsSummaryCard extends StatefulWidget {
  /// Constructor.
  const DetailsSummaryCard({
    required this.amount,
    required this.transactionType,
    this.cardIdentifier,
    required this.confidenceScore,
    super.key,
  });

  /// Raw transaction amount.
  final double amount;

  /// Transaction direction.
  final SmsTransactionType transactionType;

  /// Masked card suffix.
  final String? cardIdentifier;

  /// Scoring metric.
  final double confidenceScore;

  @override
  State<DetailsSummaryCard> createState() => _DetailsSummaryCardState();
}

class _DetailsSummaryCardState extends State<DetailsSummaryCard> {
  bool _isObscured = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    final isCredit = widget.transactionType == SmsTransactionType.credit;
    final amountColor = isCredit
        ? semanticColor.success
        : theme.colorScheme.onSurface;
    final amountPrefix = isCredit ? '+' : '-';

    final formattedAmount = _isObscured
        ? '••••••'
        : CurrencyFormatter.formatToman(widget.amount);

    final cardLabel = widget.cardIdentifier != null
        ? 'کارت *${widget.cardIdentifier}'
        : 'بانک‌یار';

    return BaseCard(
      onTap: () => setState(() => _isObscured = !_isObscured),
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          children: [
            Semantics(
              label: 'مبلغ تراکنش: $formattedAmount',
              child: Text(
                '$amountPrefix$formattedAmount',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
            ),
            SizedBox(height: spacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusBadge(theme, isCredit),
                SizedBox(width: spacing.s),
                Text(
                  cardLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, bool isCredit) {
    final semanticColor = theme.extension<SemanticColorExtension>()!;
    final color = isCredit ? semanticColor.success : theme.colorScheme.error;
    final label = isCredit ? 'درآمد / ورودی' : 'هزینه / خروجی';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
