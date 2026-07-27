import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/buttons/fab_button.dart';
import '../../../../l10n/app_localizations.dart';
import 'manual_transaction_bottom_sheet.dart';

/// Floating Action Button trigger to register a manual transaction locally.
/// Conforms to production architecture and opens the high-fidelity Manual Transaction Form.
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
      onPressed: () => _openManualTransactionForm(context),
    );
  }

  void _openManualTransactionForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ManualTransactionBottomSheet(),
    );
  }
}
