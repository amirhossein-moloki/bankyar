import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/platform/sms_history_importer.dart';
import '../../data/datasources/bank_message_dao.dart';
import '../../data/repositories/sms_parser_repository_impl.dart';
import '../../domain/repository/sms_parser_repository.dart';
import '../../domain/usecases/process_incoming_sms_use_case.dart';

/// Provider exposing the localized Relational [BankMessageDao].
final bankMessageDaoProvider = Provider<BankMessageDao>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final logger = ref.watch(loggerProvider);
  return BankMessageDao(dbService, logger);
});

/// Provider exposing the core pipeline [SmsParserRepository] implementation.
final smsParserRepositoryProvider = Provider<SmsParserRepository>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final bankMessageDao = ref.watch(bankMessageDaoProvider);
  final uuidGenerator = ref.watch(uuidGeneratorProvider);
  final clock = ref.watch(clockProvider);
  final logger = ref.watch(loggerProvider);

  return SmsParserRepositoryImpl(
    dbService: dbService,
    bankMessageDao: bankMessageDao,
    uuidGenerator: uuidGenerator,
    clock: clock,
    logger: logger,
  );
});

/// Provider exposing the stateless, single-action [ProcessIncomingSmsUseCase].
final processIncomingSmsUseCaseProvider = Provider<ProcessIncomingSmsUseCase>((
  ref,
) {
  final repository = ref.watch(smsParserRepositoryProvider);
  return ProcessIncomingSmsUseCase(repository);
});

/// Provider exposing the historical SMS inbox synchronization service.
final smsHistoryImporterProvider = Provider<SmsHistoryImporter>((ref) {
  final permissionService = ref.watch(permissionServiceProvider);
  final preferencesStorage = ref.watch(preferencesStorageProvider);
  final processUseCase = ref.watch(processIncomingSmsUseCaseProvider);
  final logger = ref.watch(loggerProvider);

  return AndroidSmsHistoryImporter(
    permissionService: permissionService,
    preferencesStorage: preferencesStorage,
    processUseCase: processUseCase,
    logger: logger,
  );
});
