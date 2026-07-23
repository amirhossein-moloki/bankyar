import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/cards/statistic_card.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../state/home_notifier.dart';

/// Row exhibiting parallel side-by-side Monthly Inflow and Outflow cards.
class MonthlySummaryCard extends ConsumerWidget {
  /// Constructor.
  const MonthlySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final state = ref.watch(homeViewModelProvider);
    final incomeAmount = state.when(
      initial: () => 0.0,
      loading: (_) => 0.0,
      error: (_) => 0.0,
      success: (d) => d.monthlyIncome,
    );
    final expenseAmount = state.when(
      initial: () => 0.0,
      loading: (_) => 0.0,
      error: (_) => 0.0,
      success: (d) => d.monthlyExpense,
    );
    final isObscured = state.when(
      initial: () => false,
      loading: (_) => false,
      error: (_) => false,
      success: (d) => d.isObscured,
    );

    final incomeText = isObscured
        ? '••••••'
        : CurrencyFormatter.formatToman(incomeAmount, usePersianDigits: true);

    final expenseText = isObscured
        ? '••••••'
        : CurrencyFormatter.formatToman(expenseAmount, usePersianDigits: true);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: Row(
        children: [
          Expanded(
            child: StatisticCard(
              title: l10n.monthlyIncomeLabel,
              value: incomeText,
              trendLabel: 'ورودی',
              isPositiveTrend: true,
            ),
          ),
          SizedBox(width: spacing.s),
          Expanded(
            child: StatisticCard(
              title: l10n.monthlyExpenseLabel,
              value: expenseText,
              trendLabel: 'خروجی',
              isPositiveTrend: false,
            ),
          ),
        ],
      ),
    );
  }
}
