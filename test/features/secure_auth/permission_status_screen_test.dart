import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/platform/sms_receiver_service.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/state_management/state_wrappers.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/features/secure_auth/presentation/state/permission_notifier.dart';
import 'package:bankyar/features/secure_auth/presentation/screens/permission_status_screen.dart';
import 'package:bankyar/features/transactions/presentation/screens/home_screen.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/home_state.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockSmsReceiverService extends Mock implements SmsReceiverService {}

class FakeHomeNotifier extends StateNotifier<UiState<HomeState>>
    implements HomeNotifier {
  FakeHomeNotifier(super.state);

  @override
  void toggleVisibility() {}

  @override
  void selectBankFilter(String bankFilter) {}

  @override
  Future<void> refresh() async {}

  @override
  void setInitial() {}

  @override
  void setLoading({double? progress}) {}

  @override
  void setSuccess(HomeState data) {}

  @override
  void setError(dynamic failure) {}
}

class FakePermissionService implements PermissionService {
  final Map<AppPermission, PermissionStatus> _statuses = {
    AppPermission.smsRead: PermissionStatus.granted,
    AppPermission.smsReceive: PermissionStatus.granted,
    AppPermission.notifications: PermissionStatus.granted,
    AppPermission.batteryExclusion: PermissionStatus.granted,
    AppPermission.localFiles: PermissionStatus.granted,
    AppPermission.biometrics: PermissionStatus.granted,
    AppPermission.foregroundService: PermissionStatus.granted,
    AppPermission.autoStart: PermissionStatus.granted,
    AppPermission.exactAlarm: PermissionStatus.granted,
  };
  final _controller = StreamController<Map<AppPermission, PermissionStatus>>.broadcast();

  void setMockStatus(AppPermission perm, PermissionStatus status) {
    _statuses[perm] = status;
    _controller.add(Map.unmodifiable(_statuses));
  }

  @override
  Future<PermissionStatus> checkStatus(AppPermission permission) async {
    return _statuses[permission] ?? PermissionStatus.denied;
  }

  @override
  Future<PermissionStatus> request(AppPermission permission) async {
    final status = _statuses[permission] ?? PermissionStatus.granted;
    _statuses[permission] = status;
    _controller.add(Map.unmodifiable(_statuses));
    return status;
  }

  @override
  Stream<Map<AppPermission, PermissionStatus>> get onStatusesChanged => _controller.stream;

  @override
  Future<void> openSettings() async {}

  void dispose() {
    _controller.close();
  }
}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockSmsReceiverService mockReceiver;
  late FakePermissionService fakePermissionService;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.platform);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockPrefs = MockPreferencesStorage();
    mockImporter = MockSmsHistoryImporter();
    mockReceiver = MockSmsReceiverService();
    fakePermissionService = FakePermissionService();

    // Default mock behavior
    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(() => mockPrefs.getBool('by_onboarding_completed')).thenAnswer((_) async => true);
    when(() => mockPrefs.getString(any())).thenAnswer((_) async => 'کاربر');
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});

    when(
      () => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);

    when(() => mockImporter.performIncrementalSync()).thenAnswer((_) async => 0);
    when(() => mockReceiver.startListening()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa'), Locale('en')],
      locale: const Locale('fa'),
      home: child,
    );
  }

  group('PermissionState and PermissionNotifier Unit Tests', () {
    test('Percentage and counts are calculated accurately', () {
      final statuses = {
        AppPermission.smsRead: PermissionStatus.granted,
        AppPermission.smsReceive: PermissionStatus.granted,
        AppPermission.notifications: PermissionStatus.granted,
        AppPermission.batteryExclusion: PermissionStatus.denied,
        AppPermission.localFiles: PermissionStatus.denied,
        AppPermission.biometrics: PermissionStatus.permanentlyDenied,
        AppPermission.foregroundService: PermissionStatus.unavailable,
        AppPermission.autoStart: PermissionStatus.unavailable,
        AppPermission.exactAlarm: PermissionStatus.unavailable,
      };

      final state = PermissionState(statuses: statuses);

      expect(state.grantedCount, 3);
      expect(state.totalCount, 9);
      expect(state.percentage, 33); // (3/9)*100 = 33.33 => 33
      expect(state.isAnyCriticalMissing, isFalse); // smsRead, smsReceive, notifications are granted
    });

    test('Critical permission flags detect missing permissions', () {
      final statuses = {
        AppPermission.smsRead: PermissionStatus.denied,
        AppPermission.smsReceive: PermissionStatus.granted,
        AppPermission.notifications: PermissionStatus.granted,
      };

      final state = PermissionState(statuses: statuses);

      expect(state.isAnyCriticalMissing, isTrue);
    });

    test('PermissionNotifier updates state reactively upon stream broadcast', () async {
      final container = ProviderContainer(
        overrides: [
          permissionServiceProvider.overrideWithValue(fakePermissionService),
          loggerProvider.overrideWithValue(mockLogger),
        ],
      );

      final notifier = container.read(permissionNotifierProvider.notifier);

      // Complete asynchronous check
      await notifier.refresh();

      // Verify defaults are initially set to granted inside FakePermissionService
      expect(container.read(permissionNotifierProvider).isAnyCriticalMissing, isFalse);

      // Change smsRead to denied using mock modifier
      fakePermissionService.setMockStatus(AppPermission.smsRead, PermissionStatus.denied);

      // Wait brief moment for stream propagation
      await Future<void>.delayed(Duration.zero);

      expect(container.read(permissionNotifierProvider).isAnyCriticalMissing, isTrue);
      expect(container.read(permissionNotifierProvider).statuses[AppPermission.smsRead], PermissionStatus.denied);
    });
  });

  group('PermissionStatusScreen Widget Tests', () {
    testWidgets('Renders all 9 permissions with score and highlights criticals', (tester) async {
      tester.view.physicalSize = const Size(1200, 2500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Set custom statuses
      fakePermissionService.setMockStatus(AppPermission.smsRead, PermissionStatus.denied);
      fakePermissionService.setMockStatus(AppPermission.smsReceive, PermissionStatus.granted);
      fakePermissionService.setMockStatus(AppPermission.notifications, PermissionStatus.permanentlyDenied);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            loggerProvider.overrideWithValue(mockLogger),
          ],
          child: buildTestableWidget(const PermissionStatusScreen()),
        ),
      );

      // Advance virtual clock by 1 second to let all async initialization finish and rebuild
      await tester.pump(const Duration(seconds: 1));

      // Verify Diagnostics/Health Header Card
      expect(find.text('سلامت دسترسی‌های سیستم'), findsOneWidget);
      expect(find.textContaining('توجه: برخی مجوزهای حیاتی قطع هستند'), findsOneWidget);

      // Verify specific permission text & badges
      expect(find.text('خواندن پیامک‌های بانکی (READ_SMS)'), findsOneWidget);
      expect(find.text('دریافت آنی پیامک‌ها (RECEIVE_SMS)'), findsOneWidget);

      // Expect critical badges for the three critical ones
      expect(find.text('مجوز حیاتی'), findsNWidgets(3));

      // Verify status indicators are drawn
      expect(find.text('وضعیت: رد شده (غیرفعال)'), findsOneWidget); // smsRead
      expect(find.text('وضعیت: تایید شده (فعال)'), findsWidgets); // smsReceive is granted
      expect(find.text('وضعیت: ممنوعیت دائمی (تنظیمات)'), findsOneWidget); // notifications

      // Verify buttons exist for non-granted permissions
      expect(find.text('اعطای مجوز'), findsWidgets); // for smsRead
      expect(find.text('تنظیمات سیستمی'), findsWidgets); // for notifications
    });
  });

  group('Home Dashboard Warning Banner Integration Tests', () {
    testWidgets('Shows warning banner on HomeScreen when critical permission is missing', (tester) async {
      // Missing READ_SMS
      fakePermissionService.setMockStatus(AppPermission.smsRead, PermissionStatus.denied);
      fakePermissionService.setMockStatus(AppPermission.smsReceive, PermissionStatus.granted);
      fakePermissionService.setMockStatus(AppPermission.notifications, PermissionStatus.granted);

      final fakeHomeState = HomeState.empty();
      final notifier = FakeHomeNotifier(UiState.success(fakeHomeState));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            loggerProvider.overrideWithValue(mockLogger),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            smsReceiverServiceProvider.overrideWithValue(mockReceiver),
            homeViewModelProvider.overrideWith((ref) => notifier),
          ],
          child: buildTestableWidget(const HomeScreen()),
        ),
      );

      // Advance virtual clock by 1 second to let all async initialization finish and rebuild
      await tester.pump(const Duration(seconds: 1));

      // Warning banner is displayed
      expect(find.textContaining('بانک‌یار به برخی مجوزهای حیاتی دسترسی ندارد'), findsOneWidget);
      expect(find.text('مدیریت مجوزها'), findsOneWidget);

      // Dismiss the banner
      await tester.tap(find.text('بستن'));
      await tester.pump(const Duration(milliseconds: 100));

      // Warning banner should disappear
      expect(find.textContaining('بانک‌یار به برخی مجوزهای حیاتی دسترسی ندارد'), findsNothing);
    });

    testWidgets('Warning banner disappears instantly and starts engine when permission is granted later', (tester) async {
      fakePermissionService.setMockStatus(AppPermission.smsRead, PermissionStatus.denied);
      fakePermissionService.setMockStatus(AppPermission.smsReceive, PermissionStatus.granted);
      fakePermissionService.setMockStatus(AppPermission.notifications, PermissionStatus.granted);

      final fakeHomeState = HomeState.empty();
      final notifier = FakeHomeNotifier(UiState.success(fakeHomeState));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            permissionServiceProvider.overrideWithValue(fakePermissionService),
            loggerProvider.overrideWithValue(mockLogger),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            smsReceiverServiceProvider.overrideWithValue(mockReceiver),
            homeViewModelProvider.overrideWith((ref) => notifier),
          ],
          child: buildTestableWidget(const HomeScreen()),
        ),
      );

      // Advance virtual clock by 1 second to let all async initialization finish and rebuild
      await tester.pump(const Duration(seconds: 1));

      // Warning banner is initially displayed
      expect(find.textContaining('بانک‌یار به برخی مجوزهای حیاتی دسترسی ندارد'), findsOneWidget);

      // Clear interactions from mockito/mocktail to isolate the granting step
      clearInteractions(mockImporter);
      clearInteractions(mockReceiver);

      // User grants permission now
      fakePermissionService.setMockStatus(AppPermission.smsRead, PermissionStatus.granted);

      // Wait for stream event to propagate and rebuild UI
      await tester.pump(const Duration(milliseconds: 100));

      // Warning banner should disappear immediately
      expect(find.textContaining('بانک‌یار به برخی مجوزهای حیاتی دسترسی ندارد'), findsNothing);

      // Verify background engine / sync started automatically after permission became granted
      verify(() => mockImporter.performIncrementalSync()).called(1);
      verify(() => mockReceiver.startListening()).called(1);
    });
  });
}
