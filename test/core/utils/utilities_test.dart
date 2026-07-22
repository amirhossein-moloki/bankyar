import 'package:bankyar/core/errors/exceptions.dart';
import 'package:bankyar/core/utils/currency_formatter.dart';
import 'package:bankyar/core/utils/date_formatter.dart';
import 'package:bankyar/core/utils/debouncer.dart';
import 'package:bankyar/core/utils/input_validators.dart';
import 'package:bankyar/core/utils/localization_helpers.dart';
import 'package:bankyar/core/utils/retry_policy.dart';
import 'package:bankyar/core/utils/rtl_helpers.dart';
import 'package:bankyar/core/utils/throttler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('fa', null);

  group('Date and Currency Formatter Tests', () {
    test('DateFormatter converts Gregorian and to Persian digits', () {
      final date = DateTime(2024, 2, 15);
      final formatted = DateFormatter.format(
        date,
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );
      expect(formatted, equals('2024-02-15'));

      final friendly = DateFormatter.formatFriendly(date, locale: 'en');
      expect(friendly, contains('February'));

      final persianDigits = DateFormatter.toPersianDigits('2024-02-15');
      expect(persianDigits, equals('۲۰۲۴-۰۲-۱۵'));
    });

    test(
      'CurrencyFormatter formats Rial and Toman with commas and symbols',
      () {
        const amount = 150000.00;
        final formattedRial = CurrencyFormatter.formatRial(
          amount,
          usePersianDigits: false,
          appendSymbol: true,
        );
        expect(formattedRial, equals('150,000 ریال'));

        final formattedToman = CurrencyFormatter.formatToman(
          amount,
          usePersianDigits: true,
          appendSymbol: true,
        );
        expect(formattedToman, equals('۱۵۰,۰۰۰ تومان'));
      },
    );
  });

  group('RTL and Localization Helpers Tests', () {
    test('RtlHelpers determines text direction and alignments correctly', () {
      expect(RtlHelpers.isRtl('fa'), isTrue);
      expect(RtlHelpers.isRtl('fa_IR'), isTrue);
      expect(RtlHelpers.isRtl('en'), isFalse);

      expect(RtlHelpers.textDirection('fa'), equals(TextDirection.rtl));
      expect(RtlHelpers.textDirection('en'), equals(TextDirection.ltr));

      expect(RtlHelpers.alignment('fa'), equals(Alignment.centerRight));
      expect(RtlHelpers.alignment('en'), equals(Alignment.centerLeft));

      expect(RtlHelpers.directionalAlignment('fa'), equals(Alignment.topRight));
      expect(RtlHelpers.directionalAlignment('en'), equals(Alignment.topLeft));
    });

    testWidgets(
      'LocalizationHelpers resolves and selects correctly based on active locale',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          Localizations(
            locale: const Locale('fa'),
            delegates: const [DefaultWidgetsLocalizations.delegate],
            child: Builder(
              builder: (context) {
                final localeCode = LocalizationHelpers.getLocaleCode(context);
                expect(localeCode, equals('fa'));

                final selected = LocalizationHelpers.select(
                  context,
                  farsi: 'سیب',
                  english: 'apple',
                );
                expect(selected, equals('سیب'));

                return const SizedBox();
              },
            ),
          ),
        );

        // Now pump with LTR English locale
        await tester.pumpWidget(
          Localizations(
            locale: const Locale('en'),
            delegates: const [DefaultWidgetsLocalizations.delegate],
            child: Builder(
              builder: (context) {
                final localeCode = LocalizationHelpers.getLocaleCode(context);
                expect(localeCode, equals('en'));

                final selected = LocalizationHelpers.select(
                  context,
                  farsi: 'سیب',
                  english: 'apple',
                );
                expect(selected, equals('apple'));

                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  });

  group('InputValidators Tests', () {
    test('isValidAmount validates numbers with and without commas', () {
      expect(InputValidators.isValidAmount('150000'), isTrue);
      expect(InputValidators.isValidAmount('150,000'), isTrue);
      expect(InputValidators.isValidAmount('150,000.50'), isTrue);
      expect(InputValidators.isValidAmount('150000.50'), isTrue);
      expect(InputValidators.isValidAmount('150,000,000.00'), isTrue);
      expect(InputValidators.isValidAmount('abc'), isFalse);
      expect(InputValidators.isValidAmount(''), isFalse);
    });

    test('isValidPin enforces 4 or 6 digits', () {
      expect(InputValidators.isValidPin('1234'), isTrue);
      expect(InputValidators.isValidPin('123456'), isTrue);
      expect(InputValidators.isValidPin('123'), isFalse);
      expect(InputValidators.isValidPin('12345'), isFalse);
      expect(InputValidators.isValidPin('abcd'), isFalse);
    });

    test('isValidDate matches yyyy/MM/dd schemas', () {
      expect(InputValidators.isValidDate('1402/10/25'), isTrue);
      expect(InputValidators.isValidDate('2024/02/15'), isTrue);
      expect(InputValidators.isValidDate('1402-10-25'), isFalse);
      expect(InputValidators.isValidDate('1402/10/2'), isFalse);
    });
  });

  group('Debouncer and Throttler UI Helpers Tests', () {
    test('Debouncer delays action execution correctly', () async {
      final debouncer = Debouncer(milliseconds: 50);
      int count = 0;

      debouncer.run(() => count++);
      debouncer.run(() => count++);
      debouncer.run(() => count++);

      expect(count, equals(0)); // delayed
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(count, equals(1)); // only last runs

      debouncer.dispose();
    });

    test('Throttler limits action execution rate correctly', () async {
      final throttler = Throttler(milliseconds: 50);
      int count = 0;

      throttler.run(() => count++);
      throttler.run(() => count++); // ignored
      throttler.run(() => count++); // ignored

      expect(count, equals(1));
      await Future<void>.delayed(const Duration(milliseconds: 80));
      throttler.run(() => count++); // runs
      expect(count, equals(2));
    });
  });

  group('RetryPolicy Tests', () {
    test('RetryPolicy retries on recoverable exceptions', () async {
      const retry = RetryPolicy(
        maxAttempts: 3,
        baseDelayMs: 10,
        maxDelayMs: 50,
      );
      int runs = 0;

      final val = await retry.execute(() async {
        runs++;
        if (runs < 3) {
          throw const DatabaseException(
            code: 'BY_INF_DB_LOCK',
            message: 'Locked',
          );
        }
        return 42;
      });

      expect(val, equals(42));
      expect(runs, equals(3));
    });

    test('RetryPolicy immediately fails on security exceptions', () async {
      const retry = RetryPolicy(
        maxAttempts: 3,
        baseDelayMs: 10,
        maxDelayMs: 50,
      );
      int runs = 0;

      expect(
        () => retry.execute(() async {
          runs++;
          throw const SecurityException(
            code: 'BY_SEC_PIN_LOCKOUT',
            message: 'Locked',
          );
        }),
        throwsA(isA<SecurityException>()),
      );
      expect(runs, equals(1)); // Aborted immediately after first run
    });
  });
}
