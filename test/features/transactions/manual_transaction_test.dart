import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/presentation/widgets/inputs/amount_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/text_input_field.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/transactions/domain/entities/transaction_category.dart';
import 'package:bankyar/features/transactions/domain/repository/transaction_repository.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/widgets/manual_transaction_bottom_sheet.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class FakeParsedTransaction extends Fake implements ParsedTransaction {}

void main() {
  late MockTransactionRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeParsedTransaction());
  });

  setUp(() {
    mockRepository = MockTransactionRepository();

    // Default mock behaviors
    when(() => mockRepository.getCategories()).thenAnswer(
      (_) async => const Result.success(<TransactionCategory>[]),
    );
    when(() => mockRepository.saveTransaction(any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockRepository.saveNote(any(), any())).thenAnswer(
      (_) async => const Result.success(null),
    );
    when(() => mockRepository.assignTags(any(), any())).thenAnswer(
      (_) async => const Result.success(null),
    );
  });

  Widget buildTestableWidget(WidgetRef ref, Widget child) {
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
      home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      ),
    );
  }

  group('ManualTransactionBottomSheet Form & Validation Tests', () {
    testWidgets('Renders all input fields and starts empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: Consumer(
            builder: (context, ref, child) => buildTestableWidget(
              ref,
              const ManualTransactionBottomSheet(),
            ),
          ),
        ),
      );

      // Verify all static form fields render successfully and are empty
      expect(find.text('ثبت دستی تراکنش جدید'), findsOneWidget);
      expect(find.text('نوع تراکنش'), findsOneWidget);
      expect(find.text('مبلغ تراکنش'), findsOneWidget);
      expect(find.text('نام بانک'), findsOneWidget);
      expect(find.text('پذیرنده / پرداخت‌کننده'), findsOneWidget);
      expect(find.text('یادداشت (اختیاری)'), findsOneWidget);

      final amountField = tester.widget<TextFormField>(
        find.descendant(
          of: find.byType(AmountInputField),
          matching: find.byType(TextFormField),
        ),
      );
      expect(amountField.controller?.text, isEmpty);

      final bankField = tester.widget<TextFormField>(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) => widget is TextInputField && widget.label == 'نام بانک',
          ),
          matching: find.byType(TextFormField),
        ),
      );
      expect(bankField.controller?.text, isEmpty);
    });

    testWidgets('Triggers validation errors on empty inputs', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: Consumer(
            builder: (context, ref, child) => buildTestableWidget(
              ref,
              const ManualTransactionBottomSheet(),
            ),
          ),
        ),
      );

      // Ensure button is visible in scroll container and tap it
      final submitButton = find.text('ثبت و ذخیره تراکنش');
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('مبلغ تراکنش الزامی است'), findsOneWidget);
      expect(find.text('نام بانک الزامی است'), findsOneWidget);
      expect(find.text('نام پذیرنده الزامی است'), findsOneWidget);

      // Verify save is never triggered on repository
      verifyNever(() => mockRepository.saveTransaction(any()));
    });

    testWidgets('Triggers validation error on invalid amount <= 0', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: Consumer(
            builder: (context, ref, child) => buildTestableWidget(
              ref,
              const ManualTransactionBottomSheet(),
            ),
          ),
        ),
      );

      final amountTextFormField = find.descendant(
        of: find.byType(AmountInputField),
        matching: find.byType(TextFormField),
      );

      final bankTextFormField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TextInputField && widget.label == 'نام بانک',
        ),
        matching: find.byType(TextFormField),
      );

      final merchantTextFormField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TextInputField && widget.label == 'پذیرنده / پرداخت‌کننده',
        ),
        matching: find.byType(TextFormField),
      );

      // Enter invalid amount '0'
      await tester.enterText(amountTextFormField, '0');
      await tester.ensureVisible(bankTextFormField);
      await tester.enterText(bankTextFormField, 'بانک ملی');
      await tester.ensureVisible(merchantTextFormField);
      await tester.enterText(merchantTextFormField, 'فروشگاه');

      final submitButton = find.text('ثبت و ذخیره تراکنش');
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('مبلغ تراکنش باید بزرگتر از صفر باشد'), findsOneWidget);
      verifyNever(() => mockRepository.saveTransaction(any()));
    });

    testWidgets('Converts Persian digits and saves successful transaction', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: Consumer(
            builder: (context, ref, child) => buildTestableWidget(
              ref,
              const ManualTransactionBottomSheet(),
            ),
          ),
        ),
      );

      final amountTextFormField = find.descendant(
        of: find.byType(AmountInputField),
        matching: find.byType(TextFormField),
      );

      final bankTextFormField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TextInputField && widget.label == 'نام بانک',
        ),
        matching: find.byType(TextFormField),
      );

      final merchantTextFormField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TextInputField && widget.label == 'پذیرنده / پرداخت‌کننده',
        ),
        matching: find.byType(TextFormField),
      );

      final noteTextFormField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TextInputField && widget.label == 'یادداشت (اختیاری)',
        ),
        matching: find.byType(TextFormField),
      );

      final tagsTextFormField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TextInputField && widget.label == 'برچسب‌ها (با کاما جدا کنید)',
        ),
        matching: find.byType(TextFormField),
      );

      // Enter amount using Persian numerals: ۱۵۰,۰۰۰ (150,000)
      await tester.enterText(amountTextFormField, '۱۵۰,۰۰۰');
      await tester.ensureVisible(bankTextFormField);
      await tester.enterText(bankTextFormField, 'بانک ملت');
      await tester.ensureVisible(merchantTextFormField);
      await tester.enterText(merchantTextFormField, 'اسنپ باکس');

      // Enter notes and tags
      await tester.ensureVisible(noteTextFormField);
      await tester.enterText(noteTextFormField, 'کرایه اسنپ ناهار امروز');
      await tester.ensureVisible(tagsTextFormField);
      await tester.enterText(tagsTextFormField, 'اسنپ, سفر, ناهار');

      final submitButton = find.text('ثبت و ذخیره تراکنش');
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Ensure validation errors are cleared and repository save is triggered with parsed double amount
      expect(find.text('مبلغ تراکنش الزامی است'), findsNothing);
      expect(find.text('نام بانک الزامی است'), findsNothing);
      expect(find.text('نام پذیرنده الزامی است'), findsNothing);

      // Verify that saveTransaction was called with the correctly parsed double 150000.0
      final capturedTx = verify(() => mockRepository.saveTransaction(captureAny())).captured.first as ParsedTransaction;
      expect(capturedTx.amount, equals(150000.0));
      expect(capturedTx.rawMerchant, equals('اسنپ باکس'));
      expect(capturedTx.parsingMethod, equals('manual'));
      expect(capturedTx.confidenceScore, equals(1.0));

      // Verify notes & tags save actions are triggered with correct IDs
      verify(() => mockRepository.saveNote(capturedTx.id, 'کرایه اسنپ ناهار امروز')).called(1);
      verify(() => mockRepository.assignTags(capturedTx.id, ['اسنپ', 'سفر', 'ناهار'])).called(1);
    });
  });
}
