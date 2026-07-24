import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/repository/search_repository.dart';
import '../../domain/usecases/search_transactions_usecase.dart';
import '../datasources/search_local_datasource.dart';
import '../repositories/search_repository_impl.dart';

/// Provider exposing the [SearchLocalDataSource] instance.
final searchLocalDataSourceProvider = Provider<SearchLocalDataSource>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final preferencesStorage = ref.watch(preferencesStorageProvider);
  final logger = ref.watch(loggerProvider);
  return SearchLocalDataSourceImpl(
    dbService: dbService,
    preferencesStorage: preferencesStorage,
    logger: logger,
  );
});

/// Provider exposing the [SearchRepository] instance.
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dataSource = ref.watch(searchLocalDataSourceProvider);
  return SearchRepositoryImpl(dataSource);
});

/// Provider exposing the [SearchTransactionsUseCase] instance.
final searchTransactionsUseCaseProvider = Provider<SearchTransactionsUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchTransactionsUseCase(repository);
});
