import '../../domain/entities/bank_message_entity.dart';
import '../../domain/entities/parsed_transaction.dart';
import 'bank_registry.dart';
import 'regex_patterns.dart';
import 'modular_parsers.dart';
import 'duplicate_detector.dart';
import 'confidence_scorer.dart';

/// Container class holding the final output of the SMS processing pipeline.
class SmsPipelineResult {
  const SmsPipelineResult({
    required this.message,
    this.transaction,
    required this.status,
    required this.reason,
  });

  /// The processed bank message entity to be logged.
  final BankMessageEntity message;

  /// The parsed structured transaction entity, or null if parsing failed/ignored.
  final ParsedTransaction? transaction;

  /// The ingestion status.
  final IngestionStatus status;

  /// Human-readable reasoning explaining why this pipeline outcome occurred.
  final String reason;
}

/// Core pipeline orchestrator coordinating the sequential decoding of incoming banking texts.
class SmsPipelineEngine {
  /// Constructor defining standard pipeline components.
  const SmsPipelineEngine();

  /// Process raw incoming message.
  /// Does NOT write to database, strictly executes pure CPU-bound parsing & schema creation.
  SmsPipelineResult process({
    required String rawText,
    required String senderId,
    required int receivedAt,
    required bool isDuplicate,
    required String messageId,
    required String transactionId,
  }) {
    // 1. Permission Validation / Sanity check
    if (rawText.isEmpty || senderId.isEmpty) {
      final hash = DuplicateDetector.calculateHash(
        rawText: rawText,
        receivedAt: receivedAt,
        senderId: senderId,
      );
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: hash,
        ingestionStatus: IngestionStatus.failure,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.failure,
        reason: 'Empty message text or sender identifier.',
      );
    }

    // Generate deduplication hash
    final deduplicationHash = DuplicateDetector.calculateHash(
      rawText: rawText,
      receivedAt: receivedAt,
      senderId: senderId,
    );

    // 2. Message Filtering & Bank Identification
    final bank = BankRegistry.instance.detectBank(senderId, rawText);

    // Check if the message contains financial keyword triggers to filter out spam
    final isFinancial = _isFinancialMessage(rawText, senderId);

    if (bank == null && !isFinancial) {
      // Ignored: Not a banking SMS
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: deduplicationHash,
        ingestionStatus: IngestionStatus.ignored,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.ignored,
        reason:
            'Filtered: message does not match known bank profile or transactional keywords.',
      );
    }

    // 3. Duplicate Detection Check
    if (isDuplicate) {
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: deduplicationHash,
        ingestionStatus: IngestionStatus.duplicate,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.duplicate,
        reason: 'Duplicate SMS signature already ingested.',
      );
    }

    // 4. Message Normalization
    final normalizedText = RegexPatterns.normalizeNumerals(rawText).trim();

    // 5. Transaction Type Detection
    final isCredit = RegexPatterns.creditVerbs.hasMatch(normalizedText);
    final isDebit = RegexPatterns.debitVerbs.hasMatch(normalizedText);

    var txType = SmsTransactionType.unknown;
    if (isCredit && !isDebit) {
      txType = SmsTransactionType.credit;
    } else if (isDebit && !isCredit) {
      txType = SmsTransactionType.debit;
    } else if (isCredit && isDebit) {
      // Ambiguous, check ordering or default to debit for safety
      txType = SmsTransactionType.debit;
    }

    // 6. Amount Extraction
    final amount = AmountParser.parse(rawText);

    // 7. Card/Account Extraction
    final cardIdentifier = CardParser.parse(rawText);

    // 8. Date & Time Extraction
    final txTimestamp = DateTimeParser.parse(rawText, receivedAt);

    // 9. Balance Extraction
    final balance = BalanceParser.parse(rawText);

    // 10. Merchant Extraction
    final rawMerchant = MerchantParser.parse(rawText);
    final normalizedMerchant = rawMerchant.isNotEmpty
        ? rawMerchant
        : (bank?.name ?? 'Unknown Bank');

    // 11. Reference Number Extraction
    final referenceNumber = ReferenceParser.parse(rawText);

    // 12. Confidence Scoring
    final confidence = ConfidenceScorer.calculate(
      amount: amount,
      hasBank: bank != null,
      transactionType: txType,
      cardIdentifier: cardIdentifier,
    );

    // Determine currency default based on bank profiles / language
    // Typically IRR (Rials) or Toman. Default to Rials in standard Iranian contexts.
    var currency = 'IRR';
    if (RegexPatterns.tomanPattern.hasMatch(rawText)) {
      currency = 'Toman';
    } else if (RegexPatterns.rialPattern.hasMatch(rawText)) {
      currency = 'IRR';
    }

    // 13. Validation
    if (amount == null || amount <= 0) {
      // Failed to parse primary financial indicator
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: deduplicationHash,
        ingestionStatus: IngestionStatus.failure,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.failure,
        reason: 'Partial parsing failed: unable to isolate transaction amount.',
      );
    }

    // Success transaction extraction!
    final transaction = ParsedTransaction(
      id: transactionId,
      amount: amount,
      currency: currency,
      transactionType: txType,
      rawMerchant: rawMerchant,
      normalizedMerchant: normalizedMerchant,
      cardIdentifier: cardIdentifier,
      timestamp: txTimestamp,
      sourceSmsId: messageId,
      accountId: bank?.id,
      confidenceScore: confidence,
      parsingMethod: confidence >= 0.7 ? 'deterministic' : 'heuristic',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      balance: balance,
      referenceNumber: referenceNumber,
    );

    final msg = BankMessageEntity(
      id: messageId,
      rawText: rawText,
      senderId: senderId,
      receivedAt: receivedAt,
      deduplicationHash: deduplicationHash,
      ingestionStatus: IngestionStatus.success,
    );

    return SmsPipelineResult(
      message: msg,
      transaction: transaction,
      status: IngestionStatus.success,
      reason:
          'SMS parsed successfully. Confidence: $confidence (${transaction.parsingMethod}).',
    );
  }

  bool _isFinancialMessage(String rawText, String senderId) {
    // Basic verification check: does the message contain credit/debit verbs
    // or does the sender ID appear in standard bank sender formats?
    final text = rawText.toLowerCase();
    final hasVerbs =
        RegexPatterns.creditVerbs.hasMatch(text) ||
        RegexPatterns.debitVerbs.hasMatch(text);
    final hasIdentifiers =
        text.contains('ریال') ||
        text.contains('تومان') ||
        text.contains('rial') ||
        text.contains('toman') ||
        text.contains('کارت') ||
        text.contains('حساب');
    return hasVerbs && hasIdentifiers;
  }
}
