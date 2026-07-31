import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/sms_detection/sms_classification.dart';
import 'package:bankyar/features/sms_detection/domain/entities/bank_message_entity.dart';
import 'package:bankyar/features/sms_detection/data/parser/sms_pipeline_engine.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';

void main() {
  group('Credit Transaction Detection Tests', () {
    const engine = SmsPipelineEngine();

    test('Parsian Bank Credit Sample 1 - "انتقال از کارت"', () {
      const smsText = '''PARSIANBANK

47001231656601
مبلغ:5,000,000+
مانده:245,143,919
03/03
12:02

بابت :انتقال از کارت 6219861888389987
به کارت 6221061233346800''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Parsian',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'parsian-credit-1',
        transactionId: 'tx-parsian-credit-1',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(5000000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
      expect(result.transaction!.balance, equals(245143919.0));
    });

    test('Parsian Bank Credit Sample 2', () {
      const smsText = '''PARSIANBANK

47001231656601
مبلغ:15,000,000+
مانده:581,076,063
03/06
02:03

بابت :انتقال از کارت ...''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Parsian',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'parsian-credit-2',
        transactionId: 'tx-parsian-credit-2',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(15000000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
      expect(result.transaction!.balance, equals(581076063.0));
    });

    test('Parsian Bank Credit Sample 3', () {
      const smsText = '''PARSIANBANK

47001231656601
مبلغ:3,000,000+
مانده:514,431,176
02/14
20:32

بابت :انتقال از کارت ...''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Parsian',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'parsian-credit-3',
        transactionId: 'tx-parsian-credit-3',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(3000000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
      expect(result.transaction!.balance, equals(514431176.0));
    });

    test('Parsian Bank Credit Sample 4', () {
      const smsText = '''PARSIANBANK

47001231656601
مبلغ:1,800,000+
مانده:636,553,886
02/18
00:23

بابت :انتقال از کارت ...''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Parsian',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'parsian-credit-4',
        transactionId: 'tx-parsian-credit-4',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(1800000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
      expect(result.transaction!.balance, equals(636553886.0));
    });

    test('Parsian Bank Credit Sample 5', () {
      const smsText = '''PARSIANBANK

47001231656601
مبلغ:5,250,000+
مانده:196,164,653
04/29
23:05

بابت :انتقال از کارت ...''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Parsian',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'parsian-credit-5',
        transactionId: 'tx-parsian-credit-5',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(5250000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
      expect(result.transaction!.balance, equals(196164653.0));
    });

    test('Saman Bank Credit Sample', () {
      const smsText = '''47001231656601
مبلغ:500,000+
مانده:28,913,736
05/09
16:47
بابت :تراکنش پُل به مشخصات با کدِ رهگیریِ 140505091647036480563714988343، شناسه پرداخت ، به نامِ  امیرحسین ملوکی  و شماره شبا IR810560611828005964934101   -  بانک سامان''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Saman',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'saman-credit-1',
        transactionId: 'tx-saman-credit-1',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(500000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
      expect(result.transaction!.balance, equals(28913736.0));
      expect(result.transaction!.referenceNumber, equals('140505091647036480563714988343'));
    });

    test('Parsian Bank Debit Sample (No Regression)', () {
      const smsText = '''PARSIANBANK

47001231656601
مبلغ:3,000,000-
مانده:242,143,919
03/03
12:15

بابت :خرید از فروشگاه''';

      final result = engine.process(
        rawText: smsText,
        senderId: 'Parsian',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'parsian-debit-1',
        transactionId: 'tx-parsian-debit-1',
      );

      expect(result.status, equals(IngestionStatus.success));
      expect(result.classification, equals(SmsClassification.bank_transaction));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.amount, equals(3000000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.debit));
      expect(result.transaction!.balance, equals(242143919.0));
    });
  });
}
