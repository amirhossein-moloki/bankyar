import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Grid exhibiting details and metadata of a transaction.
class DetailsMetadataGrid extends StatelessWidget {
  /// Constructor.
  const DetailsMetadataGrid({required this.transaction, super.key});

  /// Relational transaction entity.
  final ParsedTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final dt = DateTime.fromMillisecondsSinceEpoch(transaction.timestamp);
    final dateStr = DateFormatter.toPersianDigits(
      DateFormatter.format(dt, pattern: 'yyyy/MM/dd'),
    );
    final timeStr = DateFormatter.toPersianDigits(
      DateFormatter.format(dt, pattern: 'HH:mm'),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(context, 'تاریخ وقوع', dateStr),
          const Divider(),
          _buildRow(context, 'ساعت وقوع', timeStr),
          const Divider(),
          _buildRow(context, 'پذیرنده / مبدأ', transaction.normalizedMerchant),
          const Divider(),
          if (transaction.referenceNumber != null) ...[
            _buildCopyableRow(
              context,
              'شماره پیگیری',
              transaction.referenceNumber!,
            ),
            const Divider(),
          ],
          _buildRow(
            context,
            'روش تجزیه',
            transaction.parsingMethod == 'deterministic'
                ? 'قاعده‌مند سنتی'
                : 'هوشمند',
          ),
          const Divider(),
          _buildRow(
            context,
            'ضریب اطمینان',
            '${DateFormatter.toPersianDigits((transaction.confidenceScore * 100).toStringAsFixed(0))}%',
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final persianVal = DateFormatter.toPersianDigits(value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              Text(
                persianVal,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'شماره پیگیری در حافظه موقت کپی شد',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
