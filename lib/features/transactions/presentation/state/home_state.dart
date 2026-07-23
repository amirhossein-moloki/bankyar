import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Immutable model representing the compiled datasets exhibited on the Home Dashboard.
class HomeState {
  /// Constructor.
  const HomeState({
    required this.transactions,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.isObscured,
    required this.selectedBankFilter,
  });

  /// Creates an initial empty dashboard state representation.
  factory HomeState.empty() {
    return const HomeState(
      transactions: [],
      totalBalance: 0.0,
      monthlyIncome: 0.0,
      monthlyExpense: 0.0,
      isObscured: false,
      selectedBankFilter: 'All',
    );
  }

  /// The complete chronological list of transactions.
  final List<ParsedTransaction> transactions;

  /// Calculated aggregate total balance of the vault.
  final double totalBalance;

  /// Calculated aggregate incoming funds (credits) for the current month.
  final double monthlyIncome;

  /// Calculated aggregate outgoing funds (debits) for the current month.
  final double monthlyExpense;

  /// Whether the numerical asset values are masked on-screen.
  final bool isObscured;

  /// Currently selected bank filter (e.g. 'All', 'Melli', 'Mellat').
  final String selectedBankFilter;

  /// Creates a copy of this state with modified parameters.
  HomeState copyWith({
    List<ParsedTransaction>? transactions,
    double? totalBalance,
    double? monthlyIncome,
    double? monthlyExpense,
    bool? isObscured,
    String? selectedBankFilter,
  }) {
    return HomeState(
      transactions: transactions ?? this.transactions,
      totalBalance: totalBalance ?? this.totalBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      isObscured: isObscured ?? this.isObscured,
      selectedBankFilter: selectedBankFilter ?? this.selectedBankFilter,
    );
  }
}
