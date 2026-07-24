import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/repository/statistics_repository.dart';
import '../../domain/usecases/get_analytics_use_case.dart';
import '../repositories/statistics_repository_impl.dart';

/// Provider exposing the [StatisticsRepository] instance.
final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final logger = ref.watch(loggerProvider);
  return StatisticsRepositoryImpl(dbService, logger);
});

/// Provider exposing the [GetAnalyticsUseCase] instance.
final getAnalyticsUseCaseProvider = Provider<GetAnalyticsUseCase>((ref) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return GetAnalyticsUseCase(repository);
});
