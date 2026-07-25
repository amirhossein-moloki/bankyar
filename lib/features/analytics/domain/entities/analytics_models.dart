import '../../../../core/architecture/entity.dart';

/// Enum representing the nature of an automated smart financial insight.
enum InsightType {
  /// Day of week with highest spending.
  topSpendingDay,

  /// Day of week with highest inflow.
  topIncomeDay,

  /// Card or bank with the highest usage frequency.
  mostActiveBank,

  /// Largest singular debit transaction amount.
  largestExpense,

  /// Largest singular credit transaction amount.
  largestIncome,
}

/// Node representation for visualization charts (Line, Bar graphs).
class TrendPoint {
  /// Constructor defining trend coordinates.
  const TrendPoint({
    required this.label,
    required this.income,
    required this.expense,
    required this.timestamp,
  });

  /// The localized label (e.g. day of week, month name, date day).
  final String label;

  /// Inflow value recorded at this coordinate.
  final double income;

  /// Outflow value recorded at this coordinate.
  final double expense;

  /// Coordinate temporal anchor.
  final DateTime timestamp;
}

/// Automated behavior analytics insight computed on-device.
class FinancialInsight extends Entity<String> {
  /// Constructor.
  const FinancialInsight({
    required String id,
    required this.type,
    required this.title,
    required this.description,
    required this.value,
    required this.isPositive,
  }) : super(id);

  /// Specific behavioral category of this insight.
  final InsightType type;

  /// Short localized heading of the insight.
  final String title;

  /// Detailed contextual description of the user's spending habits.
  final String description;

  /// Relevant monetary value or statistic.
  final double value;

  /// Indicates if this represents a positive behavior (e.g., lower spend, high income).
  final bool isPositive;
}

/// Comprehensive aggregate financial analytical summary for a date range.
class AnalyticsSummary {

  /// Factory creating empty summary state when no records exist.
  factory AnalyticsSummary.empty() {
    return const AnalyticsSummary(
      totalIncome: 0.0,
      totalExpenses: 0.0,
      netBalance: 0.0,
      transactionCount: 0,
      averageTransaction: 0.0,
      largestIncome: 0.0,
      largestExpense: 0.0,
      categoryTotals: {},
      bankTotals: {},
      tagStatistics: {},
      dailyTrends: [],
      weeklyTrends: [],
      monthlyTrends: [],
      recentInsights: [],
    );
  }
  /// Constructor.
  const AnalyticsSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.transactionCount,
    required this.averageTransaction,
    required this.largestIncome,
    required this.largestExpense,
    required this.categoryTotals,
    required this.bankTotals,
    required this.tagStatistics,
    required this.dailyTrends,
    required this.weeklyTrends,
    required this.monthlyTrends,
    required this.recentInsights,
  });

  /// Total credit transaction sum.
  final double totalIncome;

  /// Total debit transaction sum.
  final double totalExpenses;

  /// Net cash flow balance (Income - Expenses).
  final double netBalance;

  /// Singular transaction count.
  final int transactionCount;

  /// Average absolute amount per transaction.
  final double averageTransaction;

  /// Largest singular income transaction amount.
  final double largestIncome;

  /// Largest singular expense transaction amount.
  final double largestExpense;

  /// Inflow/outflow aggregates grouped by Category ID.
  final Map<String, double> categoryTotals;

  /// Aggregates grouped by bank/card prefix or identifier.
  final Map<String, double> bankTotals;

  /// Aggregates grouped by tag label.
  final Map<String, double> tagStatistics;

  /// Daily data aggregates for plotting.
  final List<TrendPoint> dailyTrends;

  /// Weekly data aggregates for plotting.
  final List<TrendPoint> weeklyTrends;

  /// Monthly data aggregates for plotting.
  final List<TrendPoint> monthlyTrends;

  /// Highly prioritized smart insights generated on-device.
  final List<FinancialInsight> recentInsights;
}
