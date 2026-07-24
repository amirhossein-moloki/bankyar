import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/cards/base_card.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../state/home_notifier.dart';

/// Total balance card exhibiting aggregated assets with visibility toggles.
class TotalBalanceCard extends ConsumerWidget {
  /// Constructor.
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final state = ref.watch(homeViewModelProvider);
    final totalBalance = state.when(
      initial: () => 0.0,
      loading: (_) => 0.0,
      error: (_) => 0.0,
      success: (d) => d.totalBalance,
    );
    final isObscured = state.when(
      initial: () => false,
      loading: (_) => false,
      error: (_) => false,
      success: (d) => d.isObscured,
    );

    final displayValue = isObscured
        ? '••••••'
        : CurrencyFormatter.formatToman(totalBalance, usePersianDigits: true);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: BaseCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.totalBalanceLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  _VisibilityToggleWidget(
                    isObscured: isObscured,
                    onTap: ref
                        .read(homeViewModelProvider.notifier)
                        .toggleVisibility,
                  ),
                ],
              ),
              SizedBox(height: spacing.s),
              Text(
                displayValue,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: isObscured ? 2.0 : 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisibilityToggleWidget extends StatelessWidget {
  const _VisibilityToggleWidget({
    required this.isObscured,
    required this.onTap,
  });

  final bool isObscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isObscured ? 'Show balance' : 'Hide balance',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            isObscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20.0,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
