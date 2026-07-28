import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/core/presentation/widgets/buttons/primary_button.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockPermissionService mockPermissionService;

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
    ).thenAnswer((_) async => PermissionStatus.denied);
    when(
      () => mockPermissionService.request(any()),
    ).thenAnswer((_) async => PermissionStatus.granted);
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

  testWidgets('Onboarding Screen sequential wizard flow test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStorageProvider.overrideWithValue(mockPrefs),
          loggerProvider.overrideWithValue(mockLogger),
          permissionServiceProvider.overrideWithValue(mockPermissionService),
        ],
        child: buildTestableWidget(const OnboardingScreen()),
      ),
    );

    // 1. Initial State should be Step 0 (Splash)
    expect(find.text('صندوقچه شخصی مالی کاملاً آفلاین'), findsOneWidget);

    // Jump straight to Step 1 (Welcome Screen) using jumpToPage helper
    final state = tester.state<OnboardingScreenState>(
      find.byType(OnboardingScreen),
    );
    state.jumpToPage(1);
    await tester.pump();
    await tester.pump();

    // 2. Step 1 (Welcome Screen) should be displayed
    expect(find.text('به بانک‌یار خوش آمدید'), findsOneWidget);

    // Tap on "شروع راه‌اندازی امن"
    await tester.tap(find.text('شروع راه‌اندازی امن'));
    await tester.pump();
    await tester.pump();

    // 3. Step 2 (Core Benefits)
    expect(find.text('ارزش‌های محوری صندوق مالی'), findsOneWidget);
    await tester.tap(find.text('ادامه مسیر'));
    await tester.pump();
    await tester.pump();

    // 4. Step 3 (Privacy Commitment)
    expect(find.text('تعهدنامه حریم خصوصی'), findsOneWidget);

    // Next button should be disabled because privacy terms are not checked
    var nextButton = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(nextButton.onPressed, isNull);

    // Tap on checkbox to accept privacy commitment
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.pump();

    // Next button should now be enabled
    nextButton = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
    expect(nextButton.onPressed, isNotNull);

    // Progress to Step 4
    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();
    await tester.pump();

    // 5. Step 4 (Offline Architecture)
    expect(find.text('معماری صددرصد آفلاین'), findsOneWidget);
  });
}
