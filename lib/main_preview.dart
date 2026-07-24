import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/di/dependency_injection.dart';
import 'core/logging/logger.dart';
import 'core/storage/preferences_storage.dart';
import 'core/platform/secure_storage.dart';
import 'core/platform/sms_history_importer.dart';
import 'core/architecture/use_case.dart';
import 'core/utils/result.dart';
import 'core/utils/result_extensions.dart';
import 'features/sms_detection/domain/entities/parsed_transaction.dart';
import 'features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'features/transactions/domain/usecases/get_transactions_use_case.dart';
import 'features/transactions/domain/repository/transaction_repository.dart';
import 'features/transactions/domain/entities/transaction_details.dart';
import 'features/transactions/domain/entities/transaction_category.dart';
import 'features/transactions/presentation/state/home_notifier.dart';
import 'features/analytics/domain/usecases/get_analytics_use_case.dart';
import 'features/analytics/domain/entities/analytics_models.dart';
import 'features/analytics/domain/entities/time_range.dart';
import 'features/analytics/data/di/analytics_dependencies.dart';
import 'features/search/domain/entities/search_models.dart';
import 'features/search/domain/repository/search_repository.dart';
import 'features/search/domain/usecases/search_transactions_usecase.dart';
import 'features/search/data/di/search_dependencies.dart';

// In-Memory Fake Secure Storage
class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read(String key) async => _storage[key];

  @override
  Future<void> write({required String key, required String value}) async {
    _storage[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _storage.clear();
  }
}

// In-Memory Fake Preferences Storage
class FakePreferencesStorage extends PreferencesStorage {
  FakePreferencesStorage(super.secureStorage, super.logger);
}

// Fake Sms History Importer
class FakeSmsHistoryImporter implements SmsHistoryImporter {
  @override
  Future<int> synchronizeInbox({required int forceSinceTimestamp}) async => 0;

  @override
  Future<int> performIncrementalSync() async => 0;
}

// Static mockup dataset representing realistic bank transactions in Iran
final List<ParsedTransaction> _mockTransactionsList = [
  ParsedTransaction(
    id: 'tx-1',
    amount: 125000.0,
    currency: 'تومان',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'اسنپ فود (SnappFood)',
    normalizedMerchant: 'اسنپ فود',
    cardIdentifier: '۶۰۳۷****۱۲۳۴',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)).millisecondsSinceEpoch,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    referenceNumber: '۹۸۱۲۷۳۶۴۵',
    balance: 4850000.0,
  ),
  ParsedTransaction(
    id: 'tx-2',
    amount: 5200000.0,
    currency: 'تومان',
    transactionType: SmsTransactionType.credit,
    rawMerchant: 'واریز حقوق دی ماه - شرکت رایان',
    normalizedMerchant: 'حقوق و دستمزد',
    cardIdentifier: '۶۲۱۹****۵۶۷۸',
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)).millisecondsSinceEpoch,
    confidenceScore: 0.99,
    parsingMethod: 'deterministic',
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    referenceNumber: '۷۷۱۱۲۳۰۹۸',
    balance: 10050000.0,
  ),
  ParsedTransaction(
    id: 'tx-3',
    amount: 45000.0,
    currency: 'تومان',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'تاکسی اینترنتی اسنپ (Snapp)',
    normalizedMerchant: 'اسنپ',
    cardIdentifier: '۶۰۳۷****۱۲۳۴',
    timestamp: DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
    confidenceScore: 0.96,
    parsingMethod: 'heuristic',
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    referenceNumber: '۵۵۴۶۳۷۲۸۱',
    balance: 4850000.0,
  ),
  ParsedTransaction(
    id: 'tx-4',
    amount: 320000.0,
    currency: 'تومان',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'فروشگاه دیجی‌کالا (Digikala)',
    normalizedMerchant: 'دیجی‌کالا',
    cardIdentifier: '۶۲۱۹****۵۶۷۸',
    timestamp: DateTime.now().subtract(const Duration(days: 4)).millisecondsSinceEpoch,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    referenceNumber: '۴۴۳۳۲۲۱۱۰',
    balance: 5170000.0,
  ),
];

// Fake Transaction Repository implementation
class FakeTransactionRepository implements TransactionRepository {
  @override
  Stream<Result<List<ParsedTransaction>>> watchTransactions() {
    return Stream.value(Result.success(_mockTransactionsList));
  }

  @override
  Future<Result<List<ParsedTransaction>>> getTransactions() async {
    return Result.success(_mockTransactionsList);
  }

  @override
  Future<Result<void>> saveTransaction(ParsedTransaction transaction) async {
    final idx = _mockTransactionsList.indexWhere((tx) => tx.id == transaction.id);
    if (idx != -1) {
      _mockTransactionsList[idx] = transaction;
    } else {
      _mockTransactionsList.add(transaction);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    _mockTransactionsList.removeWhere((tx) => tx.id == id);
    return const Result.success(null);
  }

  @override
  Future<Result<List<ParsedTransaction>>> getTransactionsPaged({
    required int limit,
    required int offset,
    String? bankFilter,
    String? categoryId,
    String? typeFilter,
    String? searchQuery,
    String? sortBy,
    bool descending = true,
  }) async {
    var list = List<ParsedTransaction>.from(_mockTransactionsList);
    if (bankFilter != null && bankFilter != 'All') {
      list = list.where((tx) => tx.normalizedMerchant.contains(bankFilter)).toList();
    }
    return Result.success(list);
  }

  @override
  Future<Result<TransactionDetails>> getTransactionDetails(String id) async {
    final tx = _mockTransactionsList.firstWhere(
      (t) => t.id == id,
      orElse: () => _mockTransactionsList.first,
    );
    final category = TransactionCategory(
      id: tx.transactionType == SmsTransactionType.credit ? 'cat-income' : 'cat-shopping',
      name: tx.transactionType == SmsTransactionType.credit ? 'حقوق و درآمد' : 'خرید و خدمات',
      colorHex: tx.transactionType == SmsTransactionType.credit ? '#4CAF50' : '#FF9800',
      isSystemDefined: true,
    );

    return Result.success(
      TransactionDetails(
        transactionId: id,
        transaction: tx,
        note: id == 'tx-1' ? 'شام دیشب به همراه دوستان' : null,
        category: category,
        tags: const ['غذا', 'تفریح'],
        rawSmsText: tx.transactionType == SmsTransactionType.credit
            ? 'بانک ملت\nواریز حقوق\nمبلغ: ۵,۲۰۰,۰۰۰ تومان\nکارت: ۵۶۷۸\nکد پیگیری: ۷۷۱۱۲۳۰۹۸'
            : 'بانک ملی\nبرداشت خرید\nمبلغ: ۱۲۵,۰۰۰ تومان\nکارت: ۱۲۳۴\nکد پیگیری: ۹۸۱۲۷۳۶۴۵',
      ),
    );
  }

  @override
  Future<Result<void>> saveNote(String transactionId, String text) async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteNote(String transactionId) async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> assignCategory(String transactionId, String? categoryId) async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> assignTags(String transactionId, List<String> tags) async {
    return const Result.success(null);
  }

  @override
  Future<Result<List<TransactionCategory>>> getCategories() async {
    return const Result.success([
      TransactionCategory(id: 'cat-income', name: 'حقوق و درآمد', colorHex: '#4CAF50', isSystemDefined: true),
      TransactionCategory(id: 'cat-shopping', name: 'خرید و خدمات', colorHex: '#FF9800', isSystemDefined: true),
      TransactionCategory(id: 'cat-transport', name: 'حمل و نقل', colorHex: '#2196F3', isSystemDefined: true),
      TransactionCategory(id: 'cat-food', name: 'کافه و رستوران', colorHex: '#E91E63', isSystemDefined: true),
    ]);
  }

  @override
  Future<Result<List<String>>> getTags() async {
    return const Result.success(['غذا', 'تاکسی', 'خرید', 'حقوق']);
  }
}

// Fake Search Repository implementation
class FakeSearchRepository implements SearchRepository {
  final List<String> _history = ['اسنپ', 'دیجی‌کالا'];

  @override
  Future<Result<List<String>>> getSearchHistory() async => Result.success(_history);

  @override
  Future<Result<void>> saveSearchToHistory(String query) async {
    if (!_history.contains(query)) _history.insert(0, query);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> clearSearchHistory() async {
    _history.clear();
    return const Result.success(null);
  }

  @override
  Future<Result<List<ParsedTransaction>>> searchTransactions(SearchQuery query) async {
    var list = List<ParsedTransaction>.from(_mockTransactionsList);
    if (query.text.trim().isNotEmpty) {
      list = list.where((tx) =>
          tx.normalizedMerchant.contains(query.text) ||
          tx.rawMerchant.contains(query.text)).toList();
    }
    return Result.success(list);
  }
}

// Fake GetTransactionsUseCase implementation
class FakeGetTransactionsUseCase extends GetTransactionsUseCase {
  FakeGetTransactionsUseCase(super.repository);

  @override
  Stream<Result<List<ParsedTransaction>>> call(NoParams params) {
    return Stream.value(Result.success(_mockTransactionsList));
  }
}

// Fake SearchTransactionsUseCase implementation
class FakeSearchTransactionsUseCase extends SearchTransactionsUseCase {
  final SearchRepository repository;
  FakeSearchTransactionsUseCase(this.repository) : super(repository);

  @override
  Future<Result<List<ParsedTransaction>>> call(SearchQuery query) async {
    return repository.searchTransactions(query);
  }
}

// Fake GetAnalyticsUseCase implementation
class FakeGetAnalyticsUseCase extends GetAnalyticsUseCase {
  FakeGetAnalyticsUseCase() : super(null as dynamic);

  @override
  AsyncResult<AnalyticsSummary> call(GetAnalyticsParams params) async {
    final now = DateTime.now();
    final summary = AnalyticsSummary(
      totalIncome: 5200000.0,
      totalExpenses: 490000.0,
      netBalance: 4710000.0,
      transactionCount: 4,
      averageTransaction: 1422500.0,
      largestIncome: 5200000.0,
      largestExpense: 320000.0,
      categoryTotals: {
        'cat-income': 5200000.0,
        'cat-shopping': 320000.0,
        'cat-food': 125000.0,
        'cat-transport': 45000.0,
      },
      bankTotals: {
        'ملی': 170000.0,
        'ملت': 5520000.0,
      },
      tagStatistics: {
        'غذا': 125000.0,
        'تاکسی': 45000.0,
        'خرید': 320000.0,
      },
      dailyTrends: [
        TrendPoint(label: 'شنبه', income: 0, expense: 320000, timestamp: now.subtract(const Duration(days: 4))),
        TrendPoint(label: 'یکشنبه', income: 0, expense: 0, timestamp: now.subtract(const Duration(days: 3))),
        TrendPoint(label: 'دوشنبه', income: 0, expense: 45000, timestamp: now.subtract(const Duration(days: 2))),
        TrendPoint(label: 'سه‌شنبه', income: 5200000, expense: 0, timestamp: now.subtract(const Duration(days: 1))),
        TrendPoint(label: 'چهارشنبه', income: 0, expense: 125000, timestamp: now),
      ],
      weeklyTrends: [
        TrendPoint(label: 'هفته ۱', income: 0, expense: 320000, timestamp: now.subtract(const Duration(days: 14))),
        TrendPoint(label: 'هفته ۲', income: 5200000, expense: 170000, timestamp: now),
      ],
      monthlyTrends: [
        TrendPoint(label: 'آذر', income: 4500000, expense: 2800000, timestamp: now.subtract(const Duration(days: 30))),
        TrendPoint(label: 'دی', income: 5200000, expense: 490000, timestamp: now),
      ],
      recentInsights: [
        const FinancialInsight(
          id: 'in-1',
          type: InsightType.largestExpense,
          title: 'بزرگترین مخارج دوره: دیجی‌کالا',
          description: 'شما بیشترین خرید تک‌باره را به مبلغ ۳۲۰,۰۰۰ تومان از دیجی‌کالا ثبت کرده‌اید.',
          value: 320000.0,
          isPositive: false,
        ),
        const FinancialInsight(
          id: 'in-2',
          type: InsightType.topSpendingDay,
          title: 'کاهش هزینه‌های حمل‌ونقل',
          description: 'میزان مخارج سفر درون‌شهری شما در این هفته ۲۵ درصد نسبت به هفته قبل کاهش یافته است.',
          value: 45000.0,
          isPositive: true,
        ),
      ],
    );
    return Result.success(summary);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create fake shared instances
  final mockSecureStorage = InMemorySecureStorage();
  final mockLogger = AppLoggerImpl(isDiagnosticsEnabled: true, consoleOutput: true);
  final fakePrefs = FakePreferencesStorage(mockSecureStorage, mockLogger);
  final fakeRepo = FakeTransactionRepository();
  final fakeSearchRepo = FakeSearchRepository();

  runApp(
    ProviderScope(
      overrides: [
        loggerProvider.overrideWithValue(mockLogger),
        preferencesStorageProvider.overrideWithValue(fakePrefs),
        smsHistoryImporterProvider.overrideWithValue(FakeSmsHistoryImporter()),
        transactionRepositoryProvider.overrideWithValue(fakeRepo),
        getTransactionsUseCaseProvider.overrideWithValue(FakeGetTransactionsUseCase(fakeRepo)),
        searchRepositoryProvider.overrideWithValue(fakeSearchRepo),
        searchTransactionsUseCaseProvider.overrideWithValue(FakeSearchTransactionsUseCase(fakeSearchRepo)),
        getAnalyticsUseCaseProvider.overrideWithValue(FakeGetAnalyticsUseCase()),
      ],
      child: const BankYarApp(),
    ),
  );
}
