import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/sms_detection/sms_classification.dart';
import 'package:bankyar/core/sms_detection/banks/bank_parsian.dart';
import 'package:bankyar/core/sms_detection/parser_registry.dart';
import 'package:bankyar/features/sms_detection/data/parser/sms_pipeline_engine.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/domain/entities/bank_message_entity.dart';
import 'package:bankyar/features/sms_detection/data/parser/unknown_transaction_queue.dart';

void main() {
  group('Parsian Bank SMS Parser - Comprehensive Unit & Regression Tests', () {
    const engine = SmsPipelineEngine();
    final parser =
        ParserRegistry.instance.parsers.firstWhere((p) => p.bankId == 'parsian')
            as ParsianParser;

    setUp(() {
      UnknownTransactionQueue.instance.clear();
    });

    test('1. Bank Identity Detection', () {
      final detected = ParserRegistry.instance.detectParser(
        'PARSIANBANK',
        'مبلغ:500,000+',
      );
      expect(detected, isNotNull);
      expect(detected!.bankId, equals('parsian'));
    });

    test(
      '2. Account Transaction - POL Credit (Farsi & English signs, diacritics)',
      () {
        const rawSms = '''47001231656601
مبلغ:500,000+
مانده:28,913,736
05/09
16:47
بابت :تراکنش پُل به مشخصات با کدِ رهگیریِ 140505091647036480563714988343، شناسه پرداخت ، به نامِ امیرحسین ملوکی و شماره شبا IR810560611828005964934101''';

        final classification = parser.classify(rawSms);
        expect(classification, equals(SmsClassification.bank_pol));

        final result = engine.process(
          rawText: rawSms,
          senderId: 'PARSIANBANK',
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'msg-1',
          transactionId: 'tx-1',
        );

        expect(result.status, equals(IngestionStatus.success));
        expect(result.transaction, isNotNull);
        expect(result.transaction!.amount, equals(500000.0));
        expect(result.transaction!.balance, equals(28913736.0));
        expect(
          result.transaction!.transactionType,
          equals(SmsTransactionType.credit),
        );
        expect(result.transaction!.cardIdentifier, equals('47001231656601'));
        expect(
          result.transaction!.referenceNumber,
          equals('140505091647036480563714988343'),
        );
      },
    );

    test('3. Account Transaction - Card Transfer Credit (with "+")', () {
      const rawSms = '''47001231656601
مبلغ:5,000,000+
مانده:245,143,919
03/03
12:02

بابت :انتقال از کارت 6219861888389987
به کارت 6221061233346800''';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_transaction));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-2',
        transactionId: 'tx-2',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(5000000.0));
      expect(result.transaction!.balance, equals(245143919.0));
      expect(
        result.transaction!.transactionType,
        equals(SmsTransactionType.credit),
      );
      expect(result.transaction!.cardIdentifier, equals('47001231656601'));
    });

    test('4. Account Transaction - Debit (with "-")', () {
      const rawSms = 'مبلغ:3,000,000-';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_transaction));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-3',
        transactionId: 'tx-3',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(3000000.0));
      expect(
        result.transaction!.transactionType,
        equals(SmsTransactionType.debit),
      );
    });

    test(
      '5. Card Transfer - Initiated/Incomplete (Must NOT create transaction)',
      () {
        const rawSms = '''انتقال به
603799*9522
مبلغ  2,000,000
رمز: 42365054''';

        final classification = parser.classify(rawSms);
        expect(classification, equals(SmsClassification.bank_otp));

        final result = engine.process(
          rawText: rawSms,
          senderId: 'PARSIANBANK',
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'msg-4',
          transactionId: 'tx-4',
        );

        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);
      },
    );

    test('6. OTP / Internet Bank Password (Must NOT create transaction)', () {
      const rawSms = '''رمز ورود به اینترنت بانک یا همراه بانک:
66505
مهلت استفاده دو دقیقه''';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_otp));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-5',
        transactionId: 'tx-5',
      );

      expect(result.status, equals(IngestionStatus.ignored));
      expect(result.transaction, isNull);
    });

    test('7. Mobile Bank Login (Must NOT create transaction)', () {
      const rawSms = 'ورود به همراه بانک 1404/04/21 زمان 12:55:30';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_security));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-6',
        transactionId: 'tx-6',
      );

      expect(result.status, equals(IngestionStatus.ignored));
      expect(result.transaction, isNull);
    });

    test('8. Mobile Recharge (Must NOT create transaction)', () {
      const rawSms = '''شارژ
992*0702
مبلغ 50,000
رمز:77076089''';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_information));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-7',
        transactionId: 'tx-7',
      );

      expect(result.status, equals(IngestionStatus.ignored));
      expect(result.transaction, isNull);
    });

    test(
      '9. Purchase / Service Payment - Initiated/Unconfirmed (Must NOT create transaction)',
      () {
        const rawSms = '''خرید
خدمات پرداخت بین‌الملل
مبلغ 15,601,502
Code:71121250''';

        final classification = parser.classify(rawSms);
        expect(classification, equals(SmsClassification.bank_security));

        final result = engine.process(
          rawText: rawSms,
          senderId: 'PARSIANBANK',
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'msg-8',
          transactionId: 'tx-8',
        );

        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);
      },
    );

    test('10. Security Alert - Suspicious (Must NOT create transaction)', () {
      const rawSms = '''کارت 6800**6221
به علت تراکنش مشکوک
مسدود گردید''';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_security));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-9',
        transactionId: 'tx-9',
      );

      expect(result.status, equals(IngestionStatus.ignored));
      expect(result.transaction, isNull);
    });

    test(
      '11. Account Change - Mobile Changed (Must NOT create transaction)',
      () {
        const rawSms = 'مشتری گرامی، شماره همراه شما به 09921100702 تغییر کرد.';

        final classification = parser.classify(rawSms);
        expect(classification, equals(SmsClassification.bank_security));

        final result = engine.process(
          rawText: rawSms,
          senderId: 'PARSIANBANK',
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'msg-10',
          transactionId: 'tx-10',
        );

        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);
      },
    );

    test('12. Password Change (Must NOT create transaction)', () {
      const rawSms = 'تغییر رمز درگاه غیرحضوری 1404/04/21 زمان 14:07:02؛';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_security));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-11',
        transactionId: 'tx-11',
      );

      expect(result.status, equals(IngestionStatus.ignored));
      expect(result.transaction, isNull);
    });

    test(
      '13. Unknown Message (Must be preserved in UnknownTransactionQueue)',
      () {
        const rawSms = 'مشتری گرامی بانک پارسیان، عید سعید فطر مبارک باد.';

        final classification = parser.classify(rawSms);
        expect(classification, equals(SmsClassification.bank_unknown));

        final result = engine.process(
          rawText: rawSms,
          senderId: 'PARSIANBANK',
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'msg-12',
          transactionId: 'tx-12',
        );

        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);

        final queue = UnknownTransactionQueue.instance.items;
        expect(queue.any((item) => item.id == 'msg-12'), isTrue);
      },
    );

    test('14. Cross-Contamination - OTP containing amount and card', () {
      const rawSms = '''رمز ورود به همراه بانک: 12345
کارت: 622106******6800
مبلغ: 50,000 ریال''';

      final classification = parser.classify(rawSms);
      expect(classification, equals(SmsClassification.bank_otp));

      final result = engine.process(
        rawText: rawSms,
        senderId: 'PARSIANBANK',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'msg-13',
        transactionId: 'tx-13',
      );

      expect(result.status, equals(IngestionStatus.ignored));
      expect(result.transaction, isNull);
    });
  });
}
