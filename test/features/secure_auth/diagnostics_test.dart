import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/background_service_manager.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/database/database_service.dart';
import 'package:bankyar/features/secure_auth/presentation/screens/security_dashboard_screen.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockPermissionService extends Mock implements PermissionService {}

class MockBackgroundServiceManager extends Mock
    implements BackgroundServiceManager {}

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockPermissionService mockPermissionService;
  late MockBackgroundServiceManager mockBgService;
  late MockDatabaseService mockDbService;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(AppPermission.smsRead);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockPrefs = MockPreferencesStorage();
    mockPermissionService = MockPermissionService();
    mockBgService = MockBackgroundServiceManager();
    mockDbService = MockDatabaseService();

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

    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(() => mockPrefs.getString(any())).thenAnswer((_) async => null);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async {});

    when(
      () => mockPermissionService.checkStatus(any()),
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(
      () => mockPermissionService.onStatusesChanged,
    ).thenAnswer((_) => const Stream.empty());

    when(() => mockBgService.isServiceRunning()).thenAnswer((_) async => true);
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
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    );
  }

  testWidgets(
    'SecurityDashboardScreen renders SMS Diagnostics Card and lets users toggle brand chip instructions',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            loggerProvider.overrideWithValue(mockLogger),
            permissionServiceProvider.overrideWithValue(mockPermissionService),
            backgroundServiceManagerProvider.overrideWithValue(mockBgService),
            databaseServiceProvider.overrideWithValue(mockDbService),
          ],
          child: buildTestableWidget(const SecurityDashboardScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Diagnostics Title is visible
      expect(
        find.text('عیب‌یابی ناظر پیامک و فعالیت پس‌زمینه (Diagnostics)'),
        findsOneWidget,
      );

      // Verify active monitor parameters are drawn
      expect(find.text('ناظر سیستم‌عامل (SMS Listener)'), findsOneWidget);
      expect(find.text('سرویس پس‌زمینه (Foreground Sync)'), findsOneWidget);
      expect(find.text('مدیریت هوشمند باتری'), findsOneWidget);

      // Verify status states
      expect(find.text('فعال و بیدار'), findsOneWidget);
      expect(find.text('در حال اجرا'), findsOneWidget);
      expect(find.text('معاف شده (بدون محدودیت)'), findsOneWidget);

      // Verify brand chips exist
      expect(find.text('Samsung'), findsOneWidget);
      expect(find.text('Xiaomi'), findsOneWidget);

      // Default brand is Samsung, let's verify Samsung instruction is visible
      expect(
        find.text(
          'به بخش تنظیمات (Settings) و سپس Battery and device care بروید.',
        ),
        findsOneWidget,
      );

      // Tap on Xiaomi chip
      await tester.tap(find.text('Xiaomi'));
      await tester.pumpAndSettle();

      // Xiaomi instruction should now be displayed
      expect(find.text('گزینه Autostart را فعال کنید.'), findsOneWidget);
    },
  );
}
