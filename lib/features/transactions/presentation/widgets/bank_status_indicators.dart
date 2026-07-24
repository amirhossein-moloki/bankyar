import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/cards/base_card.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Row/Grid exhibiting active supported banks and their secure offline parsing status.
class BankStatusIndicators extends StatelessWidget {
  /// Constructor.
  const BankStatusIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final banks = [
      {'name': 'ملی', 'active': true},
      {'name': 'ملت', 'active': true},
      {'name': 'تجارت', 'active': true},
      {'name': 'صادرات', 'active': true},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m),
      child: BaseCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bankStatusTitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: banks.map((bank) {
                  return _BankStatusBadge(
                    name: bank['name'] as String,
                    isActive: bank['active'] as bool,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BankStatusBadge extends StatelessWidget {
  const _BankStatusBadge({required this.name, required this.isActive});

  final String name;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(spacing.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? semanticColor.success : theme.colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: spacing.xs),
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
