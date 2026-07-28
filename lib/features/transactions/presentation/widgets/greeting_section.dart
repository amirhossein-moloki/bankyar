// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Provider exposing the securely stored username of the active profile.
final usernameProvider = FutureProvider<String?>((ref) async {
  final prefs = ref.watch(preferencesStorageProvider);
  return await prefs.getString('by_username');
});

/// Section showing the welcome greeting and safe offline badge.
class GreetingSection extends ConsumerWidget {
  /// Constructor.
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final usernameAsync = ref.watch(usernameProvider);
    final username = usernameAsync.value ?? '';

    final greeting = username.isNotEmpty
        ? l10n.greetingTitle(username)
        : l10n.greetingTitle('کاربر');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  l10n.greetingSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const _OfflineBadgeWidget(),
        ],
      ),
    );
  }
}

class _OfflineBadgeWidget extends StatelessWidget {
  const _OfflineBadgeWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final semanticColor = theme.extension<SemanticColorExtension>()!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: semanticColor.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(spacing.xs),
        border: Border.all(
          color: semanticColor.success.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: semanticColor.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: spacing.xs),
          Text(
            l10n.fullyOfflineBadge,
            style: theme.textTheme.labelSmall?.copyWith(
              color: semanticColor.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
