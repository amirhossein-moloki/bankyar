import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/sms_history_importer.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/presentation/widgets/inputs/amount_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/text_input_field.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/presentation/state/sms_detection_providers.dart';
import 'package:bankyar/features/transactions/domain/entities/transaction_details.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_notifier.dart';
import 'package:bankyar/features/transactions/presentation/widgets/edit_transaction_bottom_sheet.dart';
import 'package:bankyar/features/transactions/presentation/screens/home_screen.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockSmsHistoryImporter extends Mock implements SmsHistoryImporter {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockAppLogger mockLogger;
  late MockPreferencesStorage mockPrefs;
  late MockSmsHistoryImporter mockImporter;
  late MockTransactionRepository mockRepository;

  const testTx = ParsedTransaction(
    id: 'tx-test-id',
    amount: 35000.0,
    currency: 'IRR',
    transactionType: SmsTransactionType.debit,
    rawMerchant: 'Snapp Food',
    normalizedMerchant: 'Snapp Food',
    cardIdentifier: 'Melli',
    timestamp: 1697360400000,
    confidenceScore: 1.0,
    parsingMethod: 'deterministic',
    createdAt: 1697360400000,
    updatedAt: 1697360400000,
    note: 'خرید پیتزا',
  );

  final testDetails = TransactionDetails(
    transactionId: 'tx-test-id',
    transaction: testTx,
    note: 'خرید پیتزا',
    category: null,
    tags: const ['غذا', 'خوشمزه'],
    rawSmsText: 'برداشت ۳۵۰۰۰ ریال از ملی',
  );

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.database);
    registerFallbackValue(testTx);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockPrefs = MockPreferencesStorage();
    mockImporter = MockSmsHistoryImporter();
    mockRepository = MockTransactionRepository();

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
    when(
      () => mockImporter.performIncrementalSync(),
    ).thenAnswer((_) async => 0);

    when(
      () => mockRepository.getCategories(),
    ).thenAnswer((_) async => const Result.success([]));

    when(
      () => mockRepository.saveTransaction(any()),
    ).thenAnswer((_) async => const Result.success(null));

    when(
      () => mockRepository.saveNote(any(), any()),
    ).thenAnswer((_) async => const Result.success(null));

    when(
      () => mockRepository.assignTags(any(), any()),
    ).thenAnswer((_) async => const Result.success(null));

    when(() => mockRepository.watchTransactions()).thenAnswer(
      (_) => Stream.value(const Result.success(<ParsedTransaction>[])),
    );
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
    'EditTransactionBottomSheet pre-populates current values and saves successfully',
    (tester) async {
      // Set physical size to avoid overflow in tests
      tester.view.physicalSize = const Size(1200, 1600);
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
            smsHistoryImporterProvider.overrideWithValue(mockImporter),
            transactionRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: buildTestableWidget(
            Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (_) =>
                          EditTransactionBottomSheet(details: testDetails),
                    );
                  },
                  child: const Text('باز کردن ویرایش'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap to open bottom sheet
      await tester.tap(find.text('باز کردن ویرایش'));
      await tester.pumpAndSettle();

      // Verify bottom sheet title
      expect(find.text('ویرایش جزئیات تراکنش'), findsOneWidget);

      // Verify pre-populated values inside controllers
      final amountField = tester.widget<TextFormField>(
        find.descendant(
          of: find.byType(AmountInputField),
          matching: find.byType(TextFormField),
        ),
      );
      expect(amountField.controller?.text, '35000');

      final bankField = tester.widget<TextFormField>(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is TextInputField &&
                widget.label == 'نام بانک یا شماره کارت',
          ),
          matching: find.byType(TextFormField),
        ),
      );
      expect(bankField.controller?.text, 'Melli');

      final merchantField = tester.widget<TextFormField>(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is TextInputField &&
                widget.label == 'پذیرنده / مبدأ تراکنش',
          ),
          matching: find.byType(TextFormField),
        ),
      );
      expect(merchantField.controller?.text, 'Snapp Food');

      final noteField = tester.widget<TextFormField>(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is TextInputField && widget.label == 'یادداشت (اختیاری)',
          ),
          matching: find.byType(TextFormField),
        ),
      );
      expect(noteField.controller?.text, 'خرید پیتزا');

      // Scroll to and tap submit button to save
      final submitBtn = find.text('ذخیره تغییرات تراکنش');
      await tester.ensureVisible(submitBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Verify sheet popped and closed
      expect(find.text('ویرایش جزئیات تراکنش'), findsNothing);

      // Verify save calls on repository
      verify(() => mockRepository.saveTransaction(any())).called(1);
      verify(
        () => mockRepository.saveNote('tx-test-id', 'خرید پیتزا'),
      ).called(1);
      verify(
        () => mockRepository.assignTags('tx-test-id', ['غذا', 'خوشمزه']),
      ).called(1);
    },
  );

  testWidgets('HomeScreen renders settings button in actions', (tester) async {
    when(
      () => mockPrefs.getBool('by_onboarding_completed'),
    ).thenAnswer((_) async => true);
    when(
      () => mockPrefs.getString('by_username'),
    ).thenAnswer((_) async => 'سهراب');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStorageProvider.overrideWithValue(mockPrefs),
          loggerProvider.overrideWithValue(mockLogger),
          smsHistoryImporterProvider.overrideWithValue(mockImporter),
          transactionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: buildTestableWidget(const HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify home title
    expect(find.text('بانک‌یار'), findsOneWidget);

    // Verify settings button is rendered
    final settingsBtn = find.byIcon(Icons.settings_outlined);
    expect(settingsBtn, findsOneWidget);
  });
}
