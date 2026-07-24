import 'package:intl/intl.dart';
import '../../../../core/architecture/base_repository.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../domain/entities/analytics_models.dart';
import '../../domain/repository/statistics_repository.dart';

/// Concrete relational database implementation of [StatisticsRepository].
/// Combines high-speed SQLite queries with localized calendar aggregates and smart on-device insights.
class StatisticsRepositoryImpl extends BaseRepository implements StatisticsRepository {
  /// Constructor injecting standard secure DB Service and central logger.
  StatisticsRepositoryImpl(this._dbService, this._logger);

  final DatabaseServiceImpl _dbService;
  final AppLogger _logger;

  @override
  Future<Result<AnalyticsSummary>> getStatistics({
    required DateTime startDate,
    required DateTime endDate,
    String? bankFilter,
  }) {
    return executeSafe(() async {
      final db = _dbService.database;

      final int startMillis = startDate.millisecondsSinceEpoch;
      final int endMillis = endDate.millisecondsSinceEpoch;

      _logger.log(
        LogLevel.info,
        LogCategories.database,
        'BY_STAT_LOAD',
        'Calculating financial aggregates from $startMillis to $endMillis. Bank filter: $bankFilter',
      );

      final List<String> whereClauses = [
        't.timestamp >= ?',
        't.timestamp <= ?',
      ];
      final List<dynamic> whereArgs = [startMillis, endMillis];

      if (bankFilter != null && bankFilter != 'All' && bankFilter.isNotEmpty) {
        whereClauses.add(
          '(t.card_identifier = ? OR t.normalized_merchant LIKE ? OR t.raw_merchant LIKE ?)',
        );
        whereArgs.add(bankFilter);
        whereArgs.add('%$bankFilter%');
        whereArgs.add('%$bankFilter%');
      }

      final String whereSection = 'WHERE ${whereClauses.join(' AND ')}';

      // 1. Query matching transactions with category details
      final txQuery = '''
        SELECT t.*, c.name as category_name, c.color_hex as category_color
        FROM transactions t
        LEFT JOIN categories c ON t.category_id = c.id
        $whereSection
        ORDER BY t.timestamp ASC
      ''';

      final txResults = await db.rawQuery(txQuery, whereArgs);

      if (txResults.isEmpty) {
        return AnalyticsSummary.empty();
      }

      // 2. Query all matching tags in batch to avoid N+1 queries
      final String tagsQuery = '''
        SELECT tt.transaction_id, tg.label_text
        FROM transaction_tags tt
        INNER JOIN tags tg ON tt.tag_id = tg.id
        WHERE tt.transaction_id IN (
          SELECT id FROM transactions t
          $whereSection
        )
      ''';

      final tagResults = await db.rawQuery(tagsQuery, whereArgs);

      // Group tags by transaction_id
      final Map<String, List<String>> txTags = {};
      for (final row in tagResults) {
        final txId = row['transaction_id'] as String;
        final tagLabel = row['label_text'] as String;
        txTags.putIfAbsent(txId, () => []).add(tagLabel);
      }

      // 3. Process & Aggregate in memory (O(N) operations, extremely fast)
      double totalIncome = 0.0;
      double totalExpenses = 0.0;
      int txCount = 0;
      double sumAmount = 0.0;
      double largestIncome = 0.0;
      double largestExpense = 0.0;

      final Map<String, double> categoryTotals = {};
      final Map<String, double> bankTotals = {};
      final Map<String, double> tagTotals = {};

      final List<ParsedTransaction> txList = [];

      for (final row in txResults) {
        final txId = row['id'] as String;
        final amount = row['amount'] as double;
        final txTypeStr = row['transaction_type'] as String;
        final txType = txTypeStr == 'credit' ? SmsTransactionType.credit : SmsTransactionType.debit;
        final cardId = row['card_identifier'] as String?;
        final merchant = row['normalized_merchant'] as String;
        final rawMerchant = row['raw_merchant'] as String;
        final timestamp = row['timestamp'] as int;
        final currency = row['currency'] as String;
        final confidence = row['confidence_score'] as double;
        final method = row['parsing_method'] as String;
        final catName = row['category_name'] as String? ?? 'متفرقه';

        final tx = ParsedTransaction(
          id: txId,
          amount: amount,
          currency: currency,
          transactionType: txType,
          rawMerchant: rawMerchant,
          normalizedMerchant: merchant,
          cardIdentifier: cardId,
          timestamp: timestamp,
          confidenceScore: confidence,
          parsingMethod: method,
          createdAt: row['created_at'] as int,
          updatedAt: row['updated_at'] as int,
        );

        txList.add(tx);

        txCount++;
        sumAmount += amount;

        if (txType == SmsTransactionType.credit) {
          totalIncome += amount;
          if (amount > largestIncome) {
            largestIncome = amount;
          }
        } else {
          totalExpenses += amount;
          if (amount > largestExpense) {
            largestExpense = amount;
          }
        }

        // Category sums
        categoryTotals[catName] = (categoryTotals[catName] ?? 0.0) + amount;

        // Bank/Card sums
        final bankName = cardId ?? 'سایر حساب‌ها';
        bankTotals[bankName] = (bankTotals[bankName] ?? 0.0) + amount;

        // Tag sums
        final tags = txTags[txId] ?? [];
        for (final tag in tags) {
          tagTotals[tag] = (tagTotals[tag] ?? 0.0) + amount;
        }
      }

      final double averageTransaction = txCount > 0 ? sumAmount / txCount : 0.0;
      final double netBalance = totalIncome - totalExpenses;

      // 4. Calculate Trends
      final dailyTrends = _calculateDailyTrends(txList);
      final weeklyTrends = _calculateWeeklyTrends(txList);
      final monthlyTrends = _calculateMonthlyTrends(txList);

      // 5. Calculate Smart Insights
      final recentInsights = _generateInsights(txList, totalIncome, totalExpenses, bankTotals);

      return AnalyticsSummary(
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netBalance: netBalance,
        transactionCount: txCount,
        averageTransaction: averageTransaction,
        largestIncome: largestIncome,
        largestExpense: largestExpense,
        categoryTotals: categoryTotals,
        bankTotals: bankTotals,
        tagStatistics: tagTotals,
        dailyTrends: dailyTrends,
        weeklyTrends: weeklyTrends,
        monthlyTrends: monthlyTrends,
        recentInsights: recentInsights,
      );
    });
  }

  List<TrendPoint> _calculateDailyTrends(List<ParsedTransaction> txs) {
    final Map<String, List<ParsedTransaction>> groupedByDay = {};
    for (final tx in txs) {
      final date = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
      final dayKey = DateFormat('yyyy/MM/dd', 'fa').format(date);
      groupedByDay.putIfAbsent(dayKey, () => []).add(tx);
    }

    final List<TrendPoint> points = [];
    groupedByDay.forEach((dayKey, dayTxs) {
      double income = 0.0;
      double expense = 0.0;
      for (final tx in dayTxs) {
        if (tx.transactionType == SmsTransactionType.credit) {
          income += tx.amount;
        } else {
          expense += tx.amount;
        }
      }
      final anchorDate = DateTime.fromMillisecondsSinceEpoch(dayTxs.first.timestamp);
      final label = DateFormat('d MMMM', 'fa').format(anchorDate);

      points.add(TrendPoint(
        label: label,
        income: income,
        expense: expense,
        timestamp: anchorDate,
      ));
    });

    return points;
  }

  List<TrendPoint> _calculateWeeklyTrends(List<ParsedTransaction> txs) {
    final Map<int, List<ParsedTransaction>> groupedByWeek = {};
    for (final tx in txs) {
      final weekIndex = (tx.timestamp / (7 * 24 * 60 * 60 * 1000)).floor();
      groupedByWeek.putIfAbsent(weekIndex, () => []).add(tx);
    }

    final List<TrendPoint> points = [];
    final sortedKeys = groupedByWeek.keys.toList()..sort();

    int weekCounter = 1;
    for (final weekKey in sortedKeys) {
      final weekTxs = groupedByWeek[weekKey]!;
      double income = 0.0;
      double expense = 0.0;
      for (final tx in weekTxs) {
        if (tx.transactionType == SmsTransactionType.credit) {
          income += tx.amount;
        } else {
          expense += tx.amount;
        }
      }
      final anchorDate = DateTime.fromMillisecondsSinceEpoch(weekTxs.first.timestamp);
      points.add(TrendPoint(
        label: 'هفته $weekCounter',
        income: income,
        expense: expense,
        timestamp: anchorDate,
      ));
      weekCounter++;
    }

    return points;
  }

  List<TrendPoint> _calculateMonthlyTrends(List<ParsedTransaction> txs) {
    final Map<String, List<ParsedTransaction>> groupedByMonth = {};
    for (final tx in txs) {
      final date = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
      final monthKey = DateFormat('yyyy/MM', 'fa').format(date);
      groupedByMonth.putIfAbsent(monthKey, () => []).add(tx);
    }

    final List<TrendPoint> points = [];
    final sortedKeys = groupedByMonth.keys.toList()..sort();

    for (final monthKey in sortedKeys) {
      final monthTxs = groupedByMonth[monthKey]!;
      double income = 0.0;
      double expense = 0.0;
      for (final tx in monthTxs) {
        if (tx.transactionType == SmsTransactionType.credit) {
          income += tx.amount;
        } else {
          expense += tx.amount;
        }
      }
      final anchorDate = DateTime.fromMillisecondsSinceEpoch(monthTxs.first.timestamp);
      final label = DateFormat('MMMM yyyy', 'fa').format(anchorDate);

      points.add(TrendPoint(
        label: label,
        income: income,
        expense: expense,
        timestamp: anchorDate,
      ));
    }

    return points;
  }

  List<FinancialInsight> _generateInsights(
    List<ParsedTransaction> txs,
    double totalIncome,
    double totalExpenses,
    Map<String, double> bankTotals,
  ) {
    final List<FinancialInsight> insights = [];

    final Map<int, double> spendByWeekday = {};
    final Map<int, double> incomeByWeekday = {};

    ParsedTransaction? largestTxExpense;
    ParsedTransaction? largestTxIncome;

    for (final tx in txs) {
      final date = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
      final weekday = date.weekday;

      if (tx.transactionType == SmsTransactionType.credit) {
        incomeByWeekday[weekday] = (incomeByWeekday[weekday] ?? 0.0) + tx.amount;
        if (largestTxIncome == null || tx.amount > largestTxIncome.amount) {
          largestTxIncome = tx;
        }
      } else {
        spendByWeekday[weekday] = (spendByWeekday[weekday] ?? 0.0) + tx.amount;
        if (largestTxExpense == null || tx.amount > largestTxExpense.amount) {
          largestTxExpense = tx;
        }
      }
    }

    if (spendByWeekday.isNotEmpty) {
      final topSpendDay = spendByWeekday.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final weekdayName = _getFarsiWeekdayName(topSpendDay);
      insights.add(FinancialInsight(
        id: 'insight_top_spend_day',
        type: InsightType.topSpendingDay,
        title: 'بیشترین روز مخارج: $weekdayName',
        description: 'در این دوره، بیشترین سهم از کل هزینه‌های شما متعلق به روز $weekdayName بوده است.',
        value: spendByWeekday[topSpendDay]!,
        isPositive: false,
      ));
    }

    if (incomeByWeekday.isNotEmpty) {
      final topIncomeDay = incomeByWeekday.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final weekdayName = _getFarsiWeekdayName(topIncomeDay);
      insights.add(FinancialInsight(
        id: 'insight_top_income_day',
        type: InsightType.topIncomeDay,
        title: 'بیشترین روز واریزی: $weekdayName',
        description: 'در این بازه، بالاترین مجموع منابع مالی دریافتی شما در روز $weekdayName ثبت گردیده است.',
        value: incomeByWeekday[topIncomeDay]!,
        isPositive: true,
      ));
    }

    if (bankTotals.isNotEmpty) {
      final topBank = bankTotals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      insights.add(FinancialInsight(
        id: 'insight_most_active_bank',
        type: InsightType.mostActiveBank,
        title: 'فعال‌ترین حساب: $topBank',
        description: 'بیشترین گردش مالی از طریق کارت یا حساب بانکی با مشخصه $topBank انجام پذیرفته است.',
        value: bankTotals[topBank]!,
        isPositive: true,
      ));
    }

    if (largestTxExpense != null) {
      insights.add(FinancialInsight(
        id: 'insight_largest_expense',
        type: InsightType.largestExpense,
        title: 'بزرگترین هزینه یکجا',
        description: 'پرداخت بزرگترین تراکنش برداشت به مبلغ مشخص در پذیرنده ${largestTxExpense.normalizedMerchant} رخ داده است.',
        value: largestTxExpense.amount,
        isPositive: false,
      ));
    }

    if (largestTxIncome != null) {
      insights.add(FinancialInsight(
        id: 'insight_largest_income',
        type: InsightType.largestIncome,
        title: 'بزرگترین درآمد یکجا',
        description: 'دریافت بزرگترین تراکنش واریز به حساب شما از فرستنده ${largestTxIncome.normalizedMerchant} ثبت گردیده است.',
        value: largestTxIncome.amount,
        isPositive: true,
      ));
    }

    return insights;
  }

  String _getFarsiWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'شنبه';
      case DateTime.sunday:
        return 'یکشنبه';
      case DateTime.monday:
        return 'دوشنبه';
      case DateTime.tuesday:
        return 'سه‌شنبه';
      case DateTime.wednesday:
        return 'چهارشنبه';
      case DateTime.thursday:
        return 'پنج‌شنبه';
      case DateTime.friday:
        return 'جمعه';
      default:
        return 'نامشخص';
    }
  }
}
