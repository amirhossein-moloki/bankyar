import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/cards/transaction_card.dart';
import '../../../../core/presentation/widgets/layout/section_header.dart';
import '../../../../core/presentation/widgets/status/empty_state.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../state/home_notifier.dart';

/// Sliver component rendering the section header of recent transactions.
class RecentTransactionsHeaderSliver extends ConsumerWidget {
  /// Constructor.
  const RecentTransactionsHeaderSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final state = ref.watch(homeViewModelProvider);
    final transactions = state.when(
      initial: () => <ParsedTransaction>[],
      loading: (_) => <ParsedTransaction>[],
      error: (_) => <ParsedTransaction>[],
      success: (d) => d.transactions,
    );

    if (transactions.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.m,
          vertical: spacing.s,
        ),
        child: SectionHeader(title: l10n.recentTransactionsTitle),
      ),
    );
  }
}

/// Sliver component rendering lazy lists of parsed transactions chronologically.
class RecentTransactionsListSliver extends ConsumerWidget {
  /// Constructor.
  const RecentTransactionsListSliver({this.onTapTransaction, super.key});

  /// Optional tap callback on transaction card.
  final ValueChanged<ParsedTransaction>? onTapTransaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final state = ref.watch(homeViewModelProvider);
    final transactions = state.when(
      initial: () => <ParsedTransaction>[],
      loading: (_) => <ParsedTransaction>[],
      error: (_) => <ParsedTransaction>[],
      success: (d) => d.transactions,
    );
    final isObscured = state.when(
      initial: () => false,
      loading: (_) => false,
      error: (_) => false,
      success: (d) => d.isObscured,
    );

    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: spacing.xl),
          child: EmptyState(
            title: l10n.emptyTransactionsTitle,
            message: l10n.emptyTransactionsMessage,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final tx = transactions[index];
          return Padding(
            padding: EdgeInsets.only(bottom: spacing.s),
            child: _TransactionItemWidget(
              transaction: tx,
              isObscured: isObscured,
              onTap: onTapTransaction != null
                  ? () => onTapTransaction!(tx)
                  : null,
            ),
          );
        }, childCount: transactions.length),
      ),
    );
  }
}

class _TransactionItemWidget extends StatelessWidget {
  const _TransactionItemWidget({
    required this.transaction,
    required this.isObscured,
    this.onTap,
  });

  final ParsedTransaction transaction;
  final bool isObscured;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.transactionType == SmsTransactionType.credit;
    final amountText = isObscured
        ? '••••••'
        : CurrencyFormatter.format(transaction.amount, locale: 'fa');

    final dt = DateTime.fromMillisecondsSinceEpoch(transaction.timestamp);
    final formattedDate = DateFormatter.toPersianDigits(
      DateFormatter.format(dt, pattern: 'yyyy/MM/dd'),
    );

    final cardLabel = transaction.cardIdentifier != null
        ? 'کارت *${DateFormatter.toPersianDigits(transaction.cardIdentifier!)}'
        : 'بانک‌یار';

    return TransactionCard(
      amount: '$amountText تومان',
      timestamp: formattedDate,
      category: transaction.normalizedMerchant,
      accountLabel: cardLabel,
      isCredit: isCredit,
      onTap: onTap,
    );
  }
}
