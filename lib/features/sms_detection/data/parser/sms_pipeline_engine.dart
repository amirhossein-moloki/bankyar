import '../../../../core/sms_detection/sms_classification.dart';
import '../../../../core/sms_detection/bank_parser.dart';
import '../../../../core/sms_detection/parser_registry.dart';
import '../../../../core/sms_detection/false_positive_protection.dart';
import '../../domain/entities/bank_message_entity.dart';
import '../../domain/entities/parsed_transaction.dart';
import 'regex_patterns.dart';
import 'duplicate_detector.dart';

/// Container class holding the final output of the SMS processing pipeline.
class SmsPipelineResult {
  const SmsPipelineResult({
    required this.message,
    this.transaction,
    required this.status,
    required this.reason,
    this.classification = SmsClassification.non_bank,
  });

  /// The processed bank message entity to be logged.
  final BankMessageEntity message;

  /// The parsed structured transaction entity, or null if parsing failed/ignored.
  final ParsedTransaction? transaction;

  /// The ingestion status.
  final IngestionStatus status;

  /// Human-readable reasoning explaining why this pipeline outcome occurred.
  final String reason;

  /// Detailed SMS classification.
  final SmsClassification classification;
}

/// Core pipeline orchestrator coordinating the sequential decoding of incoming banking texts
/// using the Offline SMS Detection Engine.
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
        classification: SmsClassification.non_bank,
      );
    }

    // Generate deduplication hash
    final deduplicationHash = DuplicateDetector.calculateHash(
      rawText: rawText,
      receivedAt: receivedAt,
      senderId: senderId,
    );

    // 2. Message Filtering & Bank Identification
    final parser = ParserRegistry.instance.detectParser(senderId, rawText);

    // Verify if the sender ID is explicitly registered as a valid sender for this bank
    final isVerifiedBankSender = parser != null &&
        parser.senderIds.any((id) =>
            id.trim().toLowerCase().replaceAll(RegExp(r'[\s\.\-_]'), '') ==
            senderId.trim().toLowerCase().replaceAll(RegExp(r'[\s\.\-_]'), ''));

    // Check false positive criteria
    final isFP = FalsePositiveProtection.isFalsePositive(senderId, rawText);

    if (isFP && !isVerifiedBankSender) {
      // Ignored: Non-bank message or advertising/billing false positive
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
        reason: 'Filtered: False positive protection matched.',
        classification: SmsClassification.non_bank,
      );
    }

    if (parser == null) {
      // Ignored: Not a recognized bank
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
        reason: 'Filtered: sender does not match any registered bank profile.',
        classification: SmsClassification.non_bank,
      );
    }

    // 3. Classification
    final classification = parser.classify(rawText);

    // 4. Duplicate Detection Check
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
        classification: classification,
      );
    }

    // Only bank_transaction is allowed to enter the ledger and create transactions!
    if (classification != SmsClassification.bank_transaction) {
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: deduplicationHash,
        ingestionStatus: IngestionStatus.ignored,
      );

      var reason = 'Filtered: Message classification is $classification. Only bank_transaction creates ledger entries.';
      if (classification == SmsClassification.bank_otp) {
        reason = 'Filtered: OTP/dynamic password message ignored.';
      }

      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.ignored,
        reason: reason,
        classification: classification,
      );
    }

    // 5. Message Normalization and Extraction using the specialized bank parser
    final normalizedText = RegexPatterns.normalizeNumerals(rawText).trim();

    final txType = parser.parseTransactionType(rawText);
    final amount = parser.parseAmount(rawText);
    final cardIdentifier = parser.parseCardIdentifier(rawText);
    final balance = parser.parseBalance(rawText);
    final referenceNumber = parser.parseReferenceNumber(rawText);
    final rawMerchant = parser.parseMerchant(rawText);
    final normalizedMerchant = rawMerchant.isNotEmpty ? rawMerchant : parser.bankName;

    // 6. Deterministic Scoring
    final hasValidSender = isVerifiedBankSender;
    final hasTransactionKeywords = RegexPatterns.creditVerbs.hasMatch(normalizedText) ||
        RegexPatterns.debitVerbs.hasMatch(normalizedText);
    final hasAmount = amount != null && amount > 0;
    final hasCard = cardIdentifier != null && cardIdentifier.isNotEmpty;
    final hasBalance = balance != null && balance > 0;
    final hasReference = referenceNumber != null && referenceNumber.isNotEmpty;

    var score = 0;
    if (hasValidSender) score += 50;
    if (hasTransactionKeywords) score += 20;
    if (hasAmount) score += 10;
    if (hasCard) score += 10;
    if (hasBalance) score += 10;
    if (hasReference) score += 5;

    final normalizedScore = score / 100.0;

    // 7. Score rejection threshold check
    if (score < 60) {
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
        reason: 'Rejected: Deterministic confidence score is too low ($score < 60).',
        classification: classification,
      );
    }

    // 8. In-depth Validation: ledger transactions must contain a valid amount
    if (amount == null || amount <= 0) {
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
        reason: 'Parsing failed: Transaction matched but unable to parse positive amount.',
        classification: classification,
      );
    }

    // Determine currency default based on bank profiles / language
    var currency = 'IRR';
    if (RegexPatterns.tomanPattern.hasMatch(rawText)) {
      currency = 'Toman';
    } else if (RegexPatterns.rialPattern.hasMatch(rawText)) {
      currency = 'IRR';
    }

    final txTimestamp = receivedAt; // fallback / extracted time

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
      accountId: parser.bankId,
      confidenceScore: normalizedScore,
      parsingMethod: 'deterministic',
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
      reason: 'SMS parsed successfully. Classification: $classification. Score: $score.',
      classification: classification,
    );
  }
}
