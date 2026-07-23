import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/presentation/widgets/buttons/fab_button.dart';
import '../../../../core/platform/uuid.dart';
import '../../../../core/platform/clock.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../state/home_notifier.dart';

/// Floating Action Button trigger to register a manual transaction locally.
class ManualLogFab extends ConsumerWidget {
  /// Constructor.
  const ManualLogFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return FabButton(
      label: l10n.logManualAction,
      icon: const Icon(Icons.add),
      tooltip: l10n.logManualAction,
      onPressed: () => _addMockManualTransaction(ref),
    );
  }

  void _addMockManualTransaction(WidgetRef ref) async {
    final uuidGen = ref.read(uuidGeneratorProvider);
    final clock = ref.read(clockProvider);
    final repo = ref.read(transactionRepositoryProvider);

    final mockId = uuidGen.generateV4();
    final now = clock.now().millisecondsSinceEpoch;

    // Alternate credits and debits to enrich data representation
    final isCredit = now % 2 == 0;
    final amount = isCredit ? 150000.0 : 45000.0;
    final merchant = isCredit ? 'واریز سود سپرده' : 'خرید از اسنپ';
    final type = isCredit
        ? SmsTransactionType.credit
        : SmsTransactionType.debit;

    final mockTx = ParsedTransaction(
      id: mockId,
      amount: amount,
      currency: 'IRR',
      transactionType: type,
      rawMerchant: merchant,
      normalizedMerchant: merchant,
      cardIdentifier: '1234',
      timestamp: now,
      confidenceScore: 1.0,
      parsingMethod: 'manual',
      createdAt: now,
      updatedAt: now,
    );

    await repo.saveTransaction(mockTx);
  }
}
