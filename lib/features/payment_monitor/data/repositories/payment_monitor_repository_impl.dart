import '../../../../core/logging/logger.dart';
import '../../../../core/platform/secure_storage.dart';
import '../../../../core/storage/preferences_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/result_extensions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/payment_monitor_config.dart';
import '../../domain/entities/payment_request_log.dart';
import '../../domain/entities/system_log_entry.dart';
import '../../domain/repository/payment_monitor_repository.dart';
import '../datasources/payment_api_client.dart';
import '../datasources/payment_request_dao.dart';
import '../models/payment_request_dto.dart';

/// Concrete implementation of [PaymentMonitorRepository].
class PaymentMonitorRepositoryImpl implements PaymentMonitorRepository {
  /// Constructor.
  PaymentMonitorRepositoryImpl({
    required PaymentRequestDao dao,
    required PaymentApiClient apiClient,
    required PreferencesStorage preferencesStorage,
    required SecureStorage secureStorage,
    required AppLogger logger,
  })  : _dao = dao,
        _apiClient = apiClient,
        _preferencesStorage = preferencesStorage,
        _secureStorage = secureStorage,
        _logger = logger;

  final PaymentRequestDao _dao;
  final PaymentApiClient _apiClient;
  final PreferencesStorage _preferencesStorage;
  final SecureStorage _secureStorage;
  final AppLogger _logger;

  static const _keyDomain = 'pay_mon_domain';
  static const _keyToken = 'pay_mon_api_token';
  static const _keyAutoUpload = 'pay_mon_auto_upload';
  static const _keyLastTestAt = 'pay_mon_last_test_at';
  static const _keyLastTestSuccess = 'pay_mon_last_test_success';
  static const _keyLastTestMsg = 'pay_mon_last_test_msg';

  @override
  Future<Result<PaymentMonitorConfig>> getConfig() async {
    try {
      final domain =
          await _preferencesStorage.getString(_keyDomain) ?? '';
      final token =
          await _secureStorage.read(_keyToken) ?? '';
      final autoUpload =
          await _preferencesStorage.getBool(_keyAutoUpload) ?? false;

      final lastTestAtMs =
          await _preferencesStorage.getInt(_keyLastTestAt);
      final lastTestSuccess =
          await _preferencesStorage.getBool(_keyLastTestSuccess);
      final lastTestMsg =
          await _preferencesStorage.getString(_keyLastTestMsg);

      final config = PaymentMonitorConfig(
        domain: domain,
        apiToken: token,
        isAutoUploadEnabled: autoUpload,
        lastConnectionTestAt: lastTestAtMs != null
            ? DateTime.fromMillisecondsSinceEpoch(lastTestAtMs)
            : null,
        lastConnectionTestSuccess: lastTestSuccess,
        lastConnectionTestMessage: lastTestMsg,
      );

      return Result.success(config);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PAY_MON_GET_CONFIG_ERR',
        'Failed to read payment monitor config',
        error: e,
        stackTrace: stack,
      );
      return const Result.success(PaymentMonitorConfig());
    }
  }

  @override
  Future<Result<void>> saveDomain(String domain) async {
    try {
      await _preferencesStorage.setString(_keyDomain, domain.trim());
      await addSystemLog('API domain updated', details: domain.trim());
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PAY_MON_SAVE_DOMAIN_ERR',
        'Failed to save domain',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_PAY_MON_SAVE_DOMAIN_ERR',
          message: 'Error saving domain: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void>> saveApiToken(String apiToken) async {
    try {
      await _secureStorage.write(key: _keyToken, value: apiToken.trim());
      await addSystemLog('API token updated');
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.security,
        'BY_PAY_MON_SAVE_TOKEN_ERR',
        'Failed to save secure token',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_PAY_MON_SAVE_TOKEN_ERR',
          message: 'Error saving secure token: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<void>> setAutoUploadEnabled(bool enabled) async {
    try {
      await _preferencesStorage.setBool(_keyAutoUpload, enabled);
      await addSystemLog(
        'Automatic Payment Upload set to ${enabled ? "ON" : "OFF"}',
      );
      return const Result.success(null);
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_PAY_MON_AUTO_UP_ERR',
        'Failed to save auto upload setting',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_PAY_MON_AUTO_UP_ERR',
          message: 'Error saving auto upload: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Result<String>> testConnection() async {
    final configRes = await getConfig();
    final config = configRes.successOrCrash;

    final testAt = DateTime.now();
    await _preferencesStorage.setInt(
      _keyLastTestAt,
      testAt.millisecondsSinceEpoch,
    );

    final result = await _apiClient.testConnection(
      domain: config.domain,
      apiToken: config.apiToken,
    );

    return result.when(
      success: (msg) async {
        await _preferencesStorage.setBool(_keyLastTestSuccess, true);
        await _preferencesStorage.setString(_keyLastTestMsg, msg);
        await addSystemLog('API connection test successful', details: msg);
        return Result.success(msg);
      },
      failure: (failure) async {
        await _preferencesStorage.setBool(_keyLastTestSuccess, false);
        await _preferencesStorage.setString(
          _keyLastTestMsg,
          failure.message,
        );
        await addSystemLog(
          'API connection test failed',
          details: failure.message,
        );
        return Result.failure(failure);
      },
      loading: (_) => const Result.success(''),
      empty: () => const Result.success(''),
    );
  }

  @override
  Future<Result<List<PaymentRequestLog>>> getAllRequests() async {
    final result = await _dao.getAllRequests();
    return result.when(
      success: (maps) {
        final logs = maps.map((map) {
          final dto = PaymentRequestDto.fromMap(map);
          return PaymentRequestLog(
            id: dto.id,
            bankName: dto.bankName,
            amount: dto.amount,
            cardLastFour: dto.cardLastFour,
            referenceNumber: dto.referenceNumber,
            smsRaw: dto.smsRaw,
            detectedAt: DateTime.fromMillisecondsSinceEpoch(dto.detectedAt),
            sentAt: dto.sentAt != null
                ? DateTime.fromMillisecondsSinceEpoch(dto.sentAt!)
                : null,
            status: PaymentRequestStatus.fromCode(dto.status),
            retryCount: dto.retryCount,
            apiResponse: dto.apiResponse,
            errorMessage: dto.errorMessage,
          );
        }).toList();
        return Result.success(logs);
      },
      failure: (f) => Result.failure(f),
      loading: (_) => const Result.success([]),
      empty: () => const Result.success([]),
    );
  }

  @override
  Future<Result<int>> getPendingCount() => _dao.getPendingCount();

  @override
  Future<Result<int>> getFailedCount() => _dao.getFailedCount();

  @override
  Future<Result<void>> insertPaymentRequest(PaymentRequestLog request) async {
    final dto = PaymentRequestDto(
      id: request.id,
      bankName: request.bankName,
      amount: request.amount,
      cardLastFour: request.cardLastFour,
      referenceNumber: request.referenceNumber,
      smsRaw: request.smsRaw,
      detectedAt: request.detectedAt.millisecondsSinceEpoch,
      sentAt: request.sentAt?.millisecondsSinceEpoch,
      status: request.status.toCode(),
      retryCount: request.retryCount,
      apiResponse: request.apiResponse,
      errorMessage: request.errorMessage,
    );
    return _dao.insertRequest(dto.toMap());
  }

  @override
  Future<Result<void>> updatePaymentRequest(PaymentRequestLog request) async {
    final dto = PaymentRequestDto(
      id: request.id,
      bankName: request.bankName,
      amount: request.amount,
      cardLastFour: request.cardLastFour,
      referenceNumber: request.referenceNumber,
      smsRaw: request.smsRaw,
      detectedAt: request.detectedAt.millisecondsSinceEpoch,
      sentAt: request.sentAt?.millisecondsSinceEpoch,
      status: request.status.toCode(),
      retryCount: request.retryCount,
      apiResponse: request.apiResponse,
      errorMessage: request.errorMessage,
    );
    return _dao.updateRequest(dto.toMap());
  }

  @override
  Future<Result<PaymentRequestLog?>> findRequestByReferenceNumber(
    String referenceNumber,
  ) async {
    final res = await _dao.findRequestByReferenceNumber(referenceNumber);
    return res.when(
      success: (map) {
        if (map == null) return const Result.success(null);
        final dto = PaymentRequestDto.fromMap(map);
        final entity = PaymentRequestLog(
          id: dto.id,
          bankName: dto.bankName,
          amount: dto.amount,
          cardLastFour: dto.cardLastFour,
          referenceNumber: dto.referenceNumber,
          smsRaw: dto.smsRaw,
          detectedAt: DateTime.fromMillisecondsSinceEpoch(dto.detectedAt),
          sentAt: dto.sentAt != null
              ? DateTime.fromMillisecondsSinceEpoch(dto.sentAt!)
              : null,
          status: PaymentRequestStatus.fromCode(dto.status),
          retryCount: dto.retryCount,
          apiResponse: dto.apiResponse,
          errorMessage: dto.errorMessage,
        );
        return Result.success(entity);
      },
      failure: (f) => Result.failure(f),
      loading: (_) => const Result.success(null),
      empty: () => const Result.success(null),
    );
  }

  @override
  Future<Result<PaymentRequestLog>> sendPaymentRequest(
    PaymentRequestLog request,
  ) async {
    final configRes = await getConfig();
    final config = configRes.successOrCrash;

    final sendingRequest = request.copyWith(
      status: PaymentRequestStatus.sending,
    );
    await updatePaymentRequest(sendingRequest);
    await addSystemLog(
      'API request sent',
      details: '${request.bankName} - ${request.amount.toInt()} Rials',
    );

    final dto = PaymentRequestDto(
      id: request.id,
      bankName: request.bankName,
      amount: request.amount,
      cardLastFour: request.cardLastFour,
      referenceNumber: request.referenceNumber,
      smsRaw: request.smsRaw,
      detectedAt: request.detectedAt.millisecondsSinceEpoch,
      status: PaymentRequestStatus.sending.toCode(),
    );

    final payload = dto.toApiPayload(config.apiToken);

    final apiResult = await _apiClient.sendPaymentVerification(
      domain: config.domain,
      apiToken: config.apiToken,
      payload: payload,
    );

    final now = DateTime.now();

    return apiResult.when(
      success: (response) async {
        PaymentRequestStatus finalStatus;
        if (response.isSuccess) {
          finalStatus = PaymentRequestStatus.success;
        } else if (response.isDuplicate) {
          finalStatus = PaymentRequestStatus.duplicate;
        } else {
          finalStatus = PaymentRequestStatus.failed;
        }

        final updated = sendingRequest.copyWith(
          status: finalStatus,
          sentAt: now,
          apiResponse: response.rawResponseBody,
          errorMessage: response.errorMessage,
        );

        await updatePaymentRequest(updated);
        await addSystemLog(
          'API response received',
          details: 'Status: ${finalStatus.toCode()} | ${response.rawResponseBody}',
        );

        return Result.success(updated);
      },
      failure: (failure) async {
        final updated = sendingRequest.copyWith(
          status: PaymentRequestStatus.failed,
          errorMessage: failure.message,
        );
        await updatePaymentRequest(updated);
        await addSystemLog(
          'API request failed',
          details: failure.message,
        );
        return Result.success(updated);
      },
      loading: (_) => Result.success(sendingRequest),
      empty: () => Result.success(sendingRequest),
    );
  }

  @override
  Future<Result<int>> retryFailedRequests() async {
    final listRes = await _dao.getRequestsForRetry();
    return listRes.when(
      success: (maps) async {
        int count = 0;
        for (final map in maps) {
          final dto = PaymentRequestDto.fromMap(map);
          final request = PaymentRequestLog(
            id: dto.id,
            bankName: dto.bankName,
            amount: dto.amount,
            cardLastFour: dto.cardLastFour,
            referenceNumber: dto.referenceNumber,
            smsRaw: dto.smsRaw,
            detectedAt: DateTime.fromMillisecondsSinceEpoch(dto.detectedAt),
            status: PaymentRequestStatus.fromCode(dto.status),
            retryCount: dto.retryCount + 1,
          );
          await sendPaymentRequest(request);
          count++;
        }
        await addSystemLog('Retry failed requests executed', details: '$count retried');
        return Result.success(count);
      },
      failure: (f) => Result.failure(f),
      loading: (_) => const Result.success(0),
      empty: () => const Result.success(0),
    );
  }

  @override
  Future<Result<List<SystemLogEntry>>> getSystemLogs({int limit = 100}) async {
    final res = await _dao.getSystemLogs(limit: limit);
    return res.when(
      success: (maps) {
        final logs = maps.map((m) {
          return SystemLogEntry(
            id: m['id'] as String,
            timestamp: DateTime.fromMillisecondsSinceEpoch(
              m['timestamp'] as int? ?? 0,
            ),
            event: m['event'] as String? ?? '',
            details: m['details'] as String?,
          );
        }).toList();
        return Result.success(logs);
      },
      failure: (f) => Result.failure(f),
      loading: (_) => const Result.success([]),
      empty: () => const Result.success([]),
    );
  }

  @override
  Future<Result<void>> addSystemLog(String event, {String? details}) async {
    final now = DateTime.now();
    final id = 'sys_log_${now.millisecondsSinceEpoch}_${now.microsecondsSinceEpoch % 1000}';
    return _dao.insertSystemLog({
      'id': id,
      'timestamp': now.millisecondsSinceEpoch,
      'event': event,
      'details': details,
    });
  }
}
