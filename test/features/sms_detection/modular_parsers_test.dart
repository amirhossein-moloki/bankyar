import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/features/sms_detection/data/parser/modular_parsers.dart';

void main() {
  group('Modular Parsers Tests', () {
    group('AmountParser', () {
      test('extracts clean English decimal amount', () {
        expect(AmountParser.parse('Spent 1,250,000 Rls'), 1250000.0);
        expect(AmountParser.parse('Charged 450.75 USD'), 450.75);
      });

      test('extracts and converts Persian numeral amount', () {
        expect(AmountParser.parse('مبلغ ۱۲,۵۰۰,۰۰۰ ریال'), 12500000.0);
        expect(AmountParser.parse('پرداخت ۴۵۰٫۰۰ تومان'), 450.0);
      });

      test('ignores dates and card suffixes when finding amounts', () {
        expect(
          AmountParser.parse('تاریخ 1402/11/25 کارت 1234 مبلغ 5,000'),
          5000.0,
        );
      });

      test('returns null for empty or non-numeric strings', () {
        expect(AmountParser.parse(''), null);
        expect(AmountParser.parse('سلام بانک ملی ایران'), null);
      });
    });

    group('CardParser', () {
      test('extracts account and card suffixes cleanly', () {
        expect(CardParser.parse('واریز به حساب *1234'), '1234');
        expect(CardParser.parse('کارت ۵۰۲۲***۴۳۲۱'), '4321');
        expect(CardParser.parse('from acc: 9876'), '9876');
      });

      test('returns null when no card indicators are present', () {
        expect(CardParser.parse('مبلغ ۵,۰۰۰ ریال'), null);
      });
    });

    group('BalanceParser', () {
      test('extracts post-transaction balances correctly', () {
        expect(BalanceParser.parse('مانده: ۱,۲۰۰,۰۰۰ ریال'), 1200000.0);
        expect(BalanceParser.parse('موجودی جدید: 45000'), 45000.0);
        expect(BalanceParser.parse('bal: 950.50'), 950.50);
      });

      test('returns null if balance keyword is absent', () {
        expect(BalanceParser.parse('مبلغ ۵,۰۰۰ ریال'), null);
      });
    });

    group('MerchantParser', () {
      test('extracts Farsi and English merchant names', () {
        expect(MerchantParser.parse('خرید از فروشگاه رفاه'), 'فروشگاه رفاه');
        expect(MerchantParser.parse('پذیرنده: اسنپ مارکت'), 'اسنپ مارکت');
        expect(MerchantParser.parse('at Snapp Taxi'), 'Snapp Taxi');
      });

      test('cleans trailing numbers or punctuation from merchant', () {
        expect(
          MerchantParser.parse('خرید از فروشگاه کوروش، ساعت ۱۲:۳۰'),
          'فروشگاه کوروش',
        );
      });

      test('returns empty string if no merchant is found', () {
        expect(MerchantParser.parse('کارت ۴۳۲۱ مبلغ ۵,۰۰۰ ریال'), '');
      });
    });

    group('ReferenceParser', () {
      test('extracts reference/tracking identifiers', () {
        expect(ReferenceParser.parse('شماره پیگیری: ۱۲۳۴۵۶۷۸۹'), '123456789');
        expect(ReferenceParser.parse('کدرهگیری: 987654321'), '987654321');
        expect(ReferenceParser.parse('trace: 554433'), '554433');
      });

      test('falls back to standalone numeric sequences of correct length', () {
        expect(
          ReferenceParser.parse('تراکنش با موفقیت انجام شد. ۱۲۳۴۵۶'),
          '123456',
        );
      });
    });

    group('DateTimeParser', () {
      test('updates receivedAt timestamp with explicit clock times', () {
        final receivedAt = DateTime(
          2023,
          10,
          15,
          12,
          0,
          0,
        ).millisecondsSinceEpoch;
        final updated = DateTimeParser.parse('ساعت ۱۶:۴۵:۳۰', receivedAt);
        final parsedDate = DateTime.fromMillisecondsSinceEpoch(updated);

        expect(parsedDate.hour, 16);
        expect(parsedDate.minute, 45);
        expect(parsedDate.second, 30);
      });

      test(
        'falls back to receivedAt if time parameters are absent or invalid',
        () {
          final receivedAt = DateTime(
            2023,
            10,
            15,
            12,
            0,
            0,
          ).millisecondsSinceEpoch;
          expect(DateTimeParser.parse('ساعت ۲۵:۷۰', receivedAt), receivedAt);
          expect(DateTimeParser.parse('بدون ساعت', receivedAt), receivedAt);
        },
      );
    });
  });
}
