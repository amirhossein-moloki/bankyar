import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../data/di/payment_monitor_providers.dart';
import '../../domain/entities/payment_monitor_config.dart';
import '../../domain/entities/payment_request_log.dart';
import '../../domain/entities/system_log_entry.dart';
import '../../domain/repository/payment_monitor_repository.dart';

/// Immutable UI state for the Payment Monitor feature.
class PaymentMonitorState {
  /// Constructor.
  const PaymentMonitorState({
    this.config = const PaymentMonitorConfig(),
    this.requests = const [],
    this.systemLogs = const [],
    this.pendingCount = 0,
    this.failedCount = 0,
    this.isLoading = false,
    this.isTestingConnection = false,
    this.isRetrying = false,
    this.testMessage,
    this.errorMessage,
    this.successMessage,
  });

  /// Configured domain and token settings.
  final PaymentMonitorConfig config;

  /// History list of payment requests.
  final List<PaymentRequestLog> requests;

  /// Recent system event logs.
  final List<SystemLogEntry> systemLogs;

  /// Count of requests waiting or sending.
  final int pendingCount;

  /// Count of failed requests.
  final int failedCount;

  /// Loading state flag.
  final bool isLoading;

  /// Connection test progress flag.
  final bool isTestingConnection;

  /// Retry requests progress flag.
  final bool isRetrying;

  /// Result message from connection test.
  final String? testMessage;

  /// Error message.
  final String? errorMessage;

  /// Success snackbar message.
  final String? successMessage;

  /// Copy with helper.
  PaymentMonitorState copyWith({
    PaymentMonitorConfig? config,
    List<PaymentRequestLog>? requests,
    List<SystemLogEntry>? systemLogs,
    int? pendingCount,
    int? failedCount,
    bool? isLoading,
    bool? isTestingConnection,
    bool? isRetrying,
    String? testMessage,
    String? errorMessage,
    String? successMessage,
  }) {
    return PaymentMonitorState(
      config: config ?? this.config,
      requests: requests ?? this.requests,
      systemLogs: systemLogs ?? this.systemLogs,
      pendingCount: pendingCount ?? this.pendingCount,
      failedCount: failedCount ?? this.failedCount,
      isLoading: isLoading ?? this.isLoading,
      isTestingConnection: isTestingConnection ?? this.isTestingConnection,
      isRetrying: isRetrying ?? this.isRetrying,
      testMessage: testMessage,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

/// Notifier managing Payment Monitor state transitions.
class PaymentMonitorNotifier extends StateNotifier<PaymentMonitorState> {
  /// Constructor.
  PaymentMonitorNotifier(this._repository)
      : super(const PaymentMonitorState()) {
    loadData();
  }

  final PaymentMonitorRepository _repository;

  /// Load configuration, request history, queue stats, and system logs.
  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);

    final configRes = await _repository.getConfig();
    final requestsRes = await _repository.getAllRequests();
    final pendingRes = await _repository.getPendingCount();
    final failedRes = await _repository.getFailedCount();
    final logsRes = await _repository.getSystemLogs();

    state = state.copyWith(
      isLoading: false,
      config: configRes.dataOrNull ?? state.config,
      requests: requestsRes.dataOrNull ?? state.requests,
      pendingCount: pendingRes.dataOrNull ?? 0,
      failedCount: failedRes.dataOrNull ?? 0,
      systemLogs: logsRes.dataOrNull ?? state.systemLogs,
    );
  }

  /// Update server domain.
  Future<void> saveDomain(String domain) async {
    final res = await _repository.saveDomain(domain);
    if (res.isSuccess) {
      state = state.copyWith(
        successMessage: 'دامنه سرور ذخیره شد',
      );
      await loadData();
    } else {
      state = state.copyWith(
        errorMessage: res.failureOrCrash.message,
      );
    }
  }

  /// Update API token.
  Future<void> saveApiToken(String token) async {
    final res = await _repository.saveApiToken(token);
    if (res.isSuccess) {
      state = state.copyWith(
        successMessage: 'توکن API با موفقیت ذخیره شد',
      );
      await loadData();
    } else {
      state = state.copyWith(
        errorMessage: res.failureOrCrash.message,
      );
    }
  }

  /// Toggle automatic payment upload mode.
  Future<void> toggleAutoUpload(bool enabled) async {
    final res = await _repository.setAutoUploadEnabled(enabled);
    if (res.isSuccess) {
      state = state.copyWith(
        config: state.config.copyWith(isAutoUploadEnabled: enabled),
        successMessage: enabled ? 'ارسال خودکار فعال شد' : 'ارسال خودکار غیرفعال شد',
      );
      await loadData();
    }
  }

  /// Test connectivity to API.
  Future<void> testConnection() async {
    state = state.copyWith(isTestingConnection: true);

    final res = await _repository.testConnection();

    if (res.isSuccess) {
      state = state.copyWith(
        isTestingConnection: false,
        testMessage: 'Connection successful',
      );
    } else {
      state = state.copyWith(
        isTestingConnection: false,
        testMessage: 'Connection failed\nReason: ${res.failureOrCrash.message}',
      );
    }

    await loadData();
  }

  /// Retry pending/failed requests in queue.
  Future<void> retryFailedRequests() async {
    state = state.copyWith(isRetrying: true);

    final res = await _repository.retryFailedRequests();

    if (res.isSuccess) {
      final count = res.successOrCrash;
      state = state.copyWith(
        isRetrying: false,
        successMessage: count > 0
            ? '$count درخواست با موفقیت مجدداً ارسال شد'
            : 'درخواستی برای ارسال مجدد وجود ندارد',
      );
    } else {
      state = state.copyWith(
        isRetrying: false,
        errorMessage: res.failureOrCrash.message,
      );
    }

    await loadData();
  }

  /// Clear messages.
  void clearMessages() {
    state = state.copyWith();
  }
}

/// Riverpod provider for PaymentMonitorNotifier.
final paymentMonitorNotifierProvider =
    StateNotifierProvider<PaymentMonitorNotifier, PaymentMonitorState>((ref) {
  final repo = ref.watch(paymentMonitorRepositoryProvider);
  return PaymentMonitorNotifier(repo);
});
