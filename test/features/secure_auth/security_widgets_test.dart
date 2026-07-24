import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/presentation/widgets/widgets.dart';
import 'package:bankyar/features/secure_auth/domain/entities/session_model.dart';
import 'package:bankyar/features/secure_auth/domain/entities/security_settings.dart';
import 'package:bankyar/features/secure_auth/domain/entities/biometric_capabilities.dart';
import 'package:bankyar/features/secure_auth/domain/usecases/verify_biometrics_use_case.dart';
import 'package:bankyar/features/secure_auth/domain/usecases/verify_pin_use_case.dart';
import 'package:bankyar/features/secure_auth/data/repositories/security_repository_provider.dart';
import 'package:bankyar/features/secure_auth/data/repositories/local_security_repository.dart';
import 'package:bankyar/features/secure_auth/presentation/widgets/pin_keypad.dart';
import 'package:bankyar/features/secure_auth/presentation/screens/unlock_screen.dart';
import 'package:bankyar/features/secure_auth/presentation/screens/security_dashboard_screen.dart';

class MockVerifyPinUseCase extends Mock implements VerifyPinUseCase {}
class MockVerifyBiometricsUseCase extends Mock implements VerifyBiometricsUseCase {}
class MockLocalSecurityRepository extends Mock implements LocalSecurityRepository {}
class MockClock extends Mock implements Clock {}
class MockPermissionService extends Mock implements PermissionService {}

void main() {
  late MockVerifyPinUseCase verifyPinUseCase;
  late MockVerifyBiometricsUseCase verifyBiometricsUseCase;
  late MockLocalSecurityRepository securityRepository;
  late MockClock mockClock;
  late MockPermissionService mockPermissionService;

  setUpAll(() {
    registerFallbackValue(const SessionModel(isAuthenticated: false, failedAttempts: 0));
    registerFallbackValue(SecuritySettings.initial());
    registerFallbackValue(AppPermission.biometrics);
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    verifyPinUseCase = MockVerifyPinUseCase();
    verifyBiometricsUseCase = MockVerifyBiometricsUseCase();
    securityRepository = MockLocalSecurityRepository();
    mockClock = MockClock();
    mockPermissionService = MockPermissionService();

    final nowTime = DateTime(2023, 10, 1, 12, 0, 0);
    when(() => mockClock.now()).thenReturn(nowTime);

    when(() => securityRepository.getSession()).thenAnswer((_) async => const Result.success(SessionModel(
          isAuthenticated: false,
          failedAttempts: 0,
          lockoutUntil: null,
        )));
    when(() => securityRepository.getSettings()).thenAnswer((_) async => const Result.success(SecuritySettings(
          isPinEnabled: true,
          isBiometricsEnabled: true,
          autoLockTimeout: Duration(seconds: 30),
          isPrivacyModeEnabled: false,
        )));
    when(() => securityRepository.getBiometricCapabilities()).thenAnswer((_) async => const Result.success(
          BiometricCapabilities(isHardwareAvailable: true, isEnrolled: true, isEnabled: true),
        ));
    when(() => securityRepository.saveSession(any())).thenAnswer((_) async => const Result.success(null));

    when(() => mockPermissionService.onStatusesChanged).thenAnswer((_) => const Stream.empty());
    when(() => mockPermissionService.checkStatus(any())).thenAnswer((_) async => PermissionStatus.granted);
  });

  Widget createTestWidget(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.createThemeLight(),
        home: child,
      ),
    );
  }

  group('PinKeypad Widget Tests', () {
    testWidgets('Renders all digits and accessories correctly with semantic labels', (tester) async {
      String? tappedDigit;
      bool backspaceTapped = false;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.createThemeLight(), // Configures SpacingExtension correctly
        home: Scaffold(
          body: PinKeypad(
            onDigitTap: (d) => tappedDigit = d,
            onBackspaceTap: () => backspaceTapped = true,
          ),
        ),
      ));

      // Check digit rendering
      expect(find.text('1'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // Tap digit and verify callback
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(tappedDigit, equals('5'));

      // Find backspace icon and tap
      final backspaceFinder = find.byIcon(Icons.backspace_outlined);
      expect(backspaceFinder, findsOneWidget);
      await tester.tap(backspaceFinder);
      await tester.pump();
      expect(backspaceTapped, isTrue);

      // Validate accessibility semantics
      final semantics = tester.getSemantics(find.text('5'));
      expect(semantics.label, anyOf(equals('5'), contains('رقم 5')));
    });
  });

  group('UnlockScreen Tests', () {
    testWidgets('Renders PIN title, dots, and triggers biometrics verification on scan tap', (tester) async {
      final overrides = [
        clockProvider.overrideWithValue(mockClock),
        permissionServiceProvider.overrideWithValue(mockPermissionService),
        securityRepositoryProvider.overrideWithValue(securityRepository),
        verifyPinUseCaseProvider.overrideWithValue(verifyPinUseCase),
        verifyBiometricsUseCaseProvider.overrideWithValue(verifyBiometricsUseCase),
      ];

      await tester.pumpWidget(createTestWidget(const UnlockScreen(), overrides));
      await tester.pumpAndSettle();

      expect(find.text('کد عبور ۴ رقمی خود را وارد کنید'), findsOneWidget);
      expect(find.byIcon(Icons.lock_person_outlined), findsOneWidget);

      // Verify biometric scanning trigger button is present
      final bioButtonFinder = find.byIcon(Icons.fingerprint_outlined);
      expect(bioButtonFinder, findsOneWidget);

      // Set biometric authentication outcome
      when(() => verifyBiometricsUseCase(any())).thenAnswer((_) async => const Result.success(true));

      await tester.tap(bioButtonFinder);
      await tester.pumpAndSettle();

      verify(() => verifyBiometricsUseCase(any())).called(1);
    });

    testWidgets('Renders 12-Word support recovery layout when forgot PIN tapped', (tester) async {
      // Configure extremely tall viewport so all fields fit without scrolling
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final overrides = [
        clockProvider.overrideWithValue(mockClock),
        permissionServiceProvider.overrideWithValue(mockPermissionService),
        securityRepositoryProvider.overrideWithValue(securityRepository),
        verifyPinUseCaseProvider.overrideWithValue(verifyPinUseCase),
        verifyBiometricsUseCaseProvider.overrideWithValue(verifyBiometricsUseCase),
      ];

      await tester.pumpWidget(createTestWidget(const UnlockScreen(), overrides));
      await tester.pumpAndSettle();

      final forgotButton = find.text('فراموشی؟');
      expect(forgotButton, findsOneWidget);

      await tester.tap(forgotButton);
      await tester.pumpAndSettle();

      expect(find.text('بازیابی با کلمات پشتیبان'), findsOneWidget);

      // Verify TextInputField widgets exist
      expect(find.byType(TextInputField), findsNWidgets(12));
      expect(find.text('بررسی و تایید کلمات بازیابی'), findsOneWidget);
    });
  });

  group('SecurityDashboardScreen Tests', () {
    testWidgets('Renders security score, device trust, toggles, and emergency hold actions', (tester) async {
      final overrides = [
        clockProvider.overrideWithValue(mockClock),
        permissionServiceProvider.overrideWithValue(mockPermissionService),
        securityRepositoryProvider.overrideWithValue(securityRepository),
        verifyPinUseCaseProvider.overrideWithValue(verifyPinUseCase),
        verifyBiometricsUseCaseProvider.overrideWithValue(verifyBiometricsUseCase),
      ];

      await tester.pumpWidget(createTestWidget(const SecurityDashboardScreen(), overrides));
      await tester.pumpAndSettle();

      expect(find.text('امتیاز امنیت حساب کاربری'), findsOneWidget);
      expect(find.text('وضعیت اعتماد دستگاه'), findsOneWidget);
      expect(find.text('تنظیمات امنیتی ورود'), findsOneWidget);
      expect(find.text('نمای کلی مجوزهای سیستمی'), findsOneWidget);
      expect(find.text('بخش حریم خصوصی و عدم دسترسی اینترنت'), findsOneWidget);
      expect(find.text('حالت صددرصد آفلاین فعال است'), findsOneWidget);

      // Verify destructive hold button is rendered
      final deleteButton = find.text('حذف کامل تمامی اطلاعات (تخریب امن)');
      expect(deleteButton, findsOneWidget);
    });
  });
}
