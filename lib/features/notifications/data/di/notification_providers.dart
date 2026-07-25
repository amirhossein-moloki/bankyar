import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_service_impl.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/repository/notification_repository.dart';
import '../../domain/usecases/delete_notification_use_case.dart';
import '../../domain/usecases/get_notification_stream_use_case.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/insert_notification_use_case.dart';
import '../../domain/usecases/mark_notification_read_use_case.dart';
import '../datasources/notification_dao.dart';
import '../repositories/notification_repository_impl.dart';

/// Provider exposing the relational [NotificationDao] instance.
final notificationDaoProvider = Provider<NotificationDao>((ref) {
  final dbService = ref.watch(databaseServiceProvider) as DatabaseServiceImpl;
  final logger = ref.watch(loggerProvider);
  return NotificationDao(dbService, logger);
});

/// Provider exposing the [NotificationRepository] interface implementation.
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dao = ref.watch(notificationDaoProvider);
  return NotificationRepositoryImpl(dao);
});

/// Provider exposing [GetNotificationsUseCase].
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  final repository = ref.watch(notificationRepositoryProvider);
  return GetNotificationsUseCase(repository);
});

/// Provider exposing [GetNotificationStreamUseCase].
final getNotificationStreamUseCaseProvider =
    Provider<GetNotificationStreamUseCase>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return GetNotificationStreamUseCase(repository);
    });

/// Provider exposing [MarkNotificationReadUseCase].
final markNotificationReadUseCaseProvider =
    Provider<MarkNotificationReadUseCase>((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return MarkNotificationReadUseCase(repository);
    });

/// Provider exposing [DeleteNotificationUseCase].
final deleteNotificationUseCaseProvider = Provider<DeleteNotificationUseCase>((
  ref,
) {
  final repository = ref.watch(notificationRepositoryProvider);
  return DeleteNotificationUseCase(repository);
});

/// Provider exposing [InsertNotificationUseCase].
final insertNotificationUseCaseProvider = Provider<InsertNotificationUseCase>((
  ref,
) {
  final repository = ref.watch(notificationRepositoryProvider);
  return InsertNotificationUseCase(repository);
});
