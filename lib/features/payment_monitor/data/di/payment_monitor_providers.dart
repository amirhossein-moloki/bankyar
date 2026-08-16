import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logging/logger.dart';
import '../../domain/repository/payment_monitor_repository.dart';
import '../datasources/payment_api_client.dart';
import '../datasources/payment_request_dao.dart';
import '../repositories/payment_monitor_repository_impl.dart';

/// Provider for PaymentRequestDao.
final paymentRequestDaoProvider = Provider<PaymentRequestDao>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final logger = ref.watch(loggerProvider);
  return PaymentRequestDao(dbService, logger);
});

/// Provider for PaymentApiClient.
final paymentApiClientProvider = Provider<PaymentApiClient>((ref) {
  final logger = ref.watch(loggerProvider);
  return PaymentApiClient(logger: logger);
});

/// Provider for PaymentMonitorRepository interface.
final paymentMonitorRepositoryProvider =
    Provider<PaymentMonitorRepository>((ref) {
  final dao = ref.watch(paymentRequestDaoProvider);
  final apiClient = ref.watch(paymentApiClientProvider);
  final preferencesStorage = ref.watch(preferencesStorageProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final logger = ref.watch(loggerProvider);

  return PaymentMonitorRepositoryImpl(
    dao: dao,
    apiClient: apiClient,
    preferencesStorage: preferencesStorage,
    secureStorage: secureStorage,
    logger: logger,
  );
});
