import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/features/sms_detection/data/parser/regex_patterns.dart';

void main() {
  group('RegexPatterns and Numeral Normalization Tests', () {
    test('normalizeNumerals standardizes Persian digits to English digits', () {
      expect(RegexPatterns.normalizeNumerals('۱۲۳۴۵۶۷۸۹۰'), '1234567890');
      expect(
        RegexPatterns.normalizeNumerals('١٢٣٤٥٦٧٨٩٠'),
        '1234567890',
      ); // Arabic
      expect(RegexPatterns.normalizeNumerals('۱,۲۵۰٫۵۰'), '1,250.50');
    });

    test('normalizeNumerals preserves standard English alphanumeric text', () {
      expect(RegexPatterns.normalizeNumerals('Hello 1234!'), 'Hello 1234!');
    });

    test('amountPattern matches standard western currency amounts', () {
      const text = 'Spent 45,000 Rls on groceries and 120.50 USD';
      final matches = RegexPatterns.amountPattern
          .allMatches(text)
          .map((m) => m.group(0))
          .toList();
      expect(matches, contains('45,000'));
      expect(matches, contains('120.50'));
    });

    test('localizedAmountPattern matches western and eastern digits', () {
      const text = 'مبلغ ۱۲,۵۰۰,۰۰۰ ریال به کارت واریز شد';
      final matches = RegexPatterns.localizedAmountPattern
          .allMatches(text)
          .map((m) => m.group(0))
          .toList();
      expect(matches, contains('۱۲,۵۰۰,۰۰۰'));
    });

    test('rialPattern matches Farsi and English Rial markers', () {
      expect(RegexPatterns.rialPattern.hasMatch('ریال'), isTrue);
      expect(RegexPatterns.rialPattern.hasMatch('Rial'), isTrue);
      expect(RegexPatterns.rialPattern.hasMatch('rls'), isTrue);
    });

    test('tomanPattern matches Farsi and English Toman markers', () {
      expect(RegexPatterns.tomanPattern.hasMatch('تومان'), isTrue);
      expect(RegexPatterns.tomanPattern.hasMatch('Toman'), isTrue);
    });

    test(
      'creditVerbs and debitVerbs classify transaction indicators correctly',
      () {
        expect(RegexPatterns.creditVerbs.hasMatch('واریز شد'), isTrue);
        expect(RegexPatterns.creditVerbs.hasMatch('بستانکار'), isTrue);
        expect(RegexPatterns.creditVerbs.hasMatch('deposit'), isTrue);

        expect(RegexPatterns.debitVerbs.hasMatch('برداشت'), isTrue);
        expect(RegexPatterns.debitVerbs.hasMatch('خرید از پذیرنده'), isTrue);
        expect(RegexPatterns.debitVerbs.hasMatch('withdrawal'), isTrue);
      },
    );
  });
}
