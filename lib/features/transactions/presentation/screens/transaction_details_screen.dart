import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../state/transaction_details_notifier.dart';
import '../widgets/details_action_footer.dart';
import '../widgets/details_metadata_grid.dart';
import '../widgets/details_notes_tags_section.dart';
import '../widgets/details_security_shield.dart';
import '../widgets/details_summary_card.dart';

/// Screen path for GoRouter.
class TransactionDetailsScreen extends ConsumerWidget {
  /// Constructor.
  const TransactionDetailsScreen({required this.transactionId, super.key});

  /// Transaction unique ID.
  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailsViewModelProvider(transactionId));
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final notifier = ref.read(
      transactionDetailsViewModelProvider(transactionId).notifier,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'جزئیات تراکنش',
        showBackButton: true,
        actions: state.when(
          initial: () => null,
          loading: (_) => null,
          error: (_) => null,
          success: (data) => [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _shareTransaction(context, data.transaction),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (f) =>
              ErrorState(message: f.message, onRetry: notifier.loadDetails),
          success: (data) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: spacing.s),
                      DetailsSummaryCard(
                        amount: data.transaction.amount,
                        transactionType: data.transaction.transactionType,
                        cardIdentifier: data.transaction.cardIdentifier,
                        confidenceScore: data.transaction.confidenceScore,
                      ),
                      SizedBox(height: spacing.s),
                      DetailsMetadataGrid(transaction: data.transaction),
                      const Divider(height: 32),
                      DetailsNotesTagsSection(
                        details: data,
                        onSaveNote: notifier.saveNote,
                        onAssignCategory: notifier.assignCategory,
                        onAssignTags: notifier.assignTags,
                      ),
                      const DetailsSecurityShield(),
                    ],
                  ),
                ),
              ),
              DetailsActionFooter(
                isVerified: data.transaction.confidenceScore >= 1.0,
                onVerify: notifier.verifyTransaction,
                onDelete: () => _showDeleteConfirmation(context, notifier),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareTransaction(BuildContext context, ParsedTransaction tx) {
    final typeStr = tx.transactionType == SmsTransactionType.credit
        ? 'ورودی/درآمد'
        : 'خروجی/هزینه';
    final amountStr = CurrencyFormatter.formatToman(tx.amount);
    final text =
        'جزئیات تراکنش بانک‌یار:\n'
        'نوع: $typeStr\n'
        'مبلغ: $amountStr\n'
        'پذیرنده: ${tx.normalizedMerchant}\n'
        'امن شده به صورت کاملاً آفلاین توسط بانک‌یار.';

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'متن تراکنش برای اشتراک‌گذاری کپی شد',
          textDirection: TextDirection.rtl,
        ),
        action: SnackBarAction(label: 'بستن', onPressed: () {}),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TransactionDetailsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف تراکنش', textDirection: TextDirection.rtl),
        content: const Text(
          'آیا از حذف دائمی این تراکنش اطمینان دارید؟ این اقدام غیرقابل بازگشت است.',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await notifier.deleteTransaction();
              result.when(
                success: (_) {
                  if (context.mounted) {
                    context.pop();
                  }
                },
                failure: (f) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('حذف با خطا مواجه شد: ${f.message}'),
                      ),
                    );
                  }
                },
                loading: (_) => null,
                empty: () => null,
              );
            },
            child: const Text(
              'حذف تراکنش',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
