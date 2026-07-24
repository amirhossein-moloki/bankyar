import 'package:flutter/material.dart';
import '../../../../core/theme/spacing_tokens.dart';

/// Centers a trust shield banner re-assuring offline on-device local encryption.
class DetailsSecurityShield extends StatelessWidget {
  /// Constructor.
  const DetailsSecurityShield({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
      child: Container(
        padding: EdgeInsets.all(spacing.m),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.security_outlined,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            SizedBox(width: spacing.s),
            Expanded(
              child: Text(
                'این تراکنش به صورت کاملاً محلی در دستگاه شما رمزنگاری شده است و به هیچ شبکه خارج از گوشی دسترسی ندارد.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
