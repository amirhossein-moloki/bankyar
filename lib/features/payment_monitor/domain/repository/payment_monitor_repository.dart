import '../../../../core/utils/result.dart';
import '../entities/payment_monitor_config.dart';
import '../entities/payment_request_log.dart';
import '../entities/system_log_entry.dart';

/// Contract governing payment verification API monitoring, storage, and synchronization.
abstract class PaymentMonitorRepository {
  /// Load stored configuration parameters (domain, token, auto upload state, test info).
  Future<Result<PaymentMonitorConfig>> getConfig();

  /// Save API server domain.
  Future<Result<void>> saveDomain(String domain);

  /// Securely save API token.
  Future<Result<void>> saveApiToken(String apiToken);

  /// Toggle automatic payment upload mode (ON / OFF).
  Future<Result<void>> setAutoUploadEnabled(bool enabled);

  /// Perform connection test against configured API endpoint.
  Future<Result<String>> testConnection();

  /// Get list of all payment verification requests.
  Future<Result<List<PaymentRequestLog>>> getAllRequests();

  /// Count pending requests awaiting upload or sending.
  Future<Result<int>> getPendingCount();

  /// Count failed requests.
  Future<Result<int>> getFailedCount();

  /// Insert a new payment request log into local storage.
  Future<Result<void>> insertPaymentRequest(PaymentRequestLog request);

  /// Update existing payment request log.
  Future<Result<void>> updatePaymentRequest(PaymentRequestLog request);

  /// Look up existing request by reference number (for duplicate detection).
  Future<Result<PaymentRequestLog?>> findRequestByReferenceNumber(
    String referenceNumber,
  );

  /// Transmit payment request log to remote API.
  Future<Result<PaymentRequestLog>> sendPaymentRequest(
    PaymentRequestLog request,
  );

  /// Retry sending failed or queued requests.
  Future<Result<int>> retryFailedRequests();

  /// Get system event logs for debugging.
  Future<Result<List<SystemLogEntry>>> getSystemLogs({int limit = 100});

  /// Record a system event log.
  Future<Result<void>> addSystemLog(String event, {String? details});
}
