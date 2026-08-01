import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/sms_detection/sms_classification.dart';
import 'package:bankyar/features/sms_detection/data/parser/sms_pipeline_engine.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/domain/entities/bank_message_entity.dart';
import 'package:bankyar/features/sms_detection/data/parser/unknown_transaction_queue.dart';

void main() {
  group('Phase 1 — Architecture Verification (10-Stage Pipeline)', () {
    const engine = SmsPipelineEngine();

    test('Independently validates all 10 stages of the pipeline for a valid Melli transaction', () {
      const rawText = 'بانک ملی\nواریز مبلغ ۱۰,۰۰۰ ریال\nبه حساب *۱۲۳۴\nمانده ۵۰,۰۰۰';
      const senderId = 'Melli';
      const receivedAt = 1697360400000;

      final result = engine.process(
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        isDuplicate: false,
        messageId: 'msg-v1',
        transactionId: 'tx-v1',
      );

      final context = result.context;
      expect(context, isNotNull);

      // Stage 1: Raw SMS Verification
      expect(context!.rawText, equals(rawText));
      expect(context.senderId, equals(senderId));
      expect(context.receivedAt, equals(receivedAt));

      // Stage 2: Sender Normalization Verification
      expect(context.normalizedSender, equals('melli'));

      // Stage 3: Bank Detection Verification
      expect(context.matchedBank, isNotNull);
      expect(context.matchedBank!.bankId, equals('melli'));
      expect(context.confidenceScore, greaterThanOrEqualTo(50.0));
      expect(context.detectionReason, contains('Detected Bank Melli Iran'));

      // Stage 4: Message Classification Verification
      expect(context.classification, equals(SmsClassification.bank_transaction));

      // Stage 5: Template Matching Verification
      // No specific template matched since Melli is heuristic fallback, so matchedTemplate is null
      expect(context.matchedTemplate, isNull);

      // Stage 6: Field Extraction Verification
      expect(context.extractedAmount, equals(10000.0));
      expect(context.extractedCard, equals('1234'));
      expect(context.extractedBalance, equals(50000.0));

      // Stage 7: Direction Detection Verification
      expect(context.direction, equals(SmsTransactionType.credit));

      // Stage 8: Transaction Classification Verification (matches direction and category)
      expect(result.classification, equals(SmsClassification.bank_transaction));

      // Stage 9: Validation Verification
      expect(context.validationResult, isTrue);
      expect(context.failureReason, isEmpty);

      // Stage 10: Database DTO Verification
      expect(result.status, equals(IngestionStatus.success));
      expect(result.transaction, isNotNull);
      expect(result.transaction!.id, equals('tx-v1'));
      expect(result.transaction!.amount, equals(10000.0));
      expect(result.transaction!.cardIdentifier, equals('1234'));
      expect(result.transaction!.balance, equals(50000.0));
      expect(result.transaction!.transactionType, equals(SmsTransactionType.credit));
    });

    test('Validates Stage 9 Failure Path & Stage 10 Unknown Queue routing', () {
      // Message with low score/missing amount (should fail validation and route to Unknown Queue)
      const rawText = 'بانک ملی\nسلام روز بخیر.';
      const senderId = 'Melli';
      const receivedAt = 1697360400000;

      UnknownTransactionQueue.instance.clear();

      final result = engine.process(
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        isDuplicate: false,
        messageId: 'msg-fail',
        transactionId: 'tx-fail',
      );

      final context = result.context;
      expect(context, isNotNull);

      // Verify validation failed
      expect(context!.validationResult, isFalse);
      expect(context.failureReason, anyOf(contains('Validation failed'), contains('Early Ignored')));

      // Verify that it got stored inside UnknownTransactionQueue (PART 9 / Step 2 verified)
      final queueItems = UnknownTransactionQueue.instance.items;
      expect(queueItems.length, equals(1));
      expect(queueItems.first.id, equals('msg-fail'));
      expect(queueItems.first.rawText, equals(rawText));
      expect(queueItems.first.senderId, equals(senderId));
      expect(queueItems.first.matchedBankId, equals('melli'));
      expect(queueItems.first.failureReason, contains(context.failureReason));
    });
  });
}
