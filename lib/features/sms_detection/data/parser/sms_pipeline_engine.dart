import '../../../../core/sms_detection/sms_classification.dart';
import '../../../../core/sms_detection/bank_parser.dart';
import '../../../../core/sms_detection/bank_sms_template.dart';
import '../../../../core/sms_detection/parser_registry.dart';
import '../../../../core/sms_detection/false_positive_protection.dart';
import '../../domain/entities/bank_message_entity.dart';
import '../../domain/entities/parsed_transaction.dart';
import 'regex_patterns.dart';
import 'duplicate_detector.dart';
import 'modular_parsers.dart';
import 'unknown_transaction_queue.dart';

/// Context container capturing intermediate state across all 10 independent pipeline stages.
class PipelineContext {
  PipelineContext({
    required this.rawText,
    required this.senderId,
    required this.receivedAt,
    required this.messageId,
    required this.transactionId,
    this.normalizedSender = '',
    this.matchedBank,
    this.confidenceScore = 0.0,
    this.detectionReason = '',
    this.classification = SmsClassification.non_bank,
    this.matchedTemplate,
    this.extractedAmount,
    this.extractedBalance,
    this.extractedCard,
    this.extractedRef,
    this.extractedMerchant = '',
    this.direction = SmsTransactionType.unknown,
    this.validationResult = false,
    this.failureReason = '',
    this.missingFields = const [],
  });

  final String rawText;
  final String senderId;
  final int receivedAt;
  final String messageId;
  final String transactionId;

  String normalizedSender;
  BankParser? matchedBank;
  double confidenceScore;
  String detectionReason;
  SmsClassification classification;
  BankSmsTemplate? matchedTemplate;
  double? extractedAmount;
  double? extractedBalance;
  String? extractedCard;
  String? extractedRef;
  String extractedMerchant;
  SmsTransactionType direction;
  bool validationResult;
  String failureReason;
  List<String> missingFields;

  Map<String, dynamic> toJson() {
    return {
      'sender': senderId,
      'normalizedSender': normalizedSender,
      'matchedBank': matchedBank?.bankId ?? 'none',
      'matchedTemplate': matchedTemplate?.id ?? 'none',
      'classification': classification.name,
      'direction': direction.name,
      'confidence': confidenceScore,
      'amount': extractedAmount,
      'balance': extractedBalance,
      'merchant': extractedMerchant,
      'validationResult': validationResult ? 'pass' : 'fail',
      'failureReason': failureReason,
      'missingFields': missingFields,
    };
  }
}

/// Container class holding the final output of the SMS processing pipeline.
class SmsPipelineResult {
  const SmsPipelineResult({
    required this.message,
    this.transaction,
    required this.status,
    required this.reason,
    this.classification = SmsClassification.non_bank,
    this.context,
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

  /// Pipeline stage context.
  final PipelineContext? context;

  /// Generate Debug Export JSON mapping (PART 11).
  Map<String, dynamic> toDebugMap() {
    return {
      'Sender': message.senderId,
      'Normalized Sender': context?.normalizedSender ?? '',
      'Matched Bank': context?.matchedBank?.bankName ?? 'none',
      'Matched Template': context?.matchedTemplate?.id ?? 'none',
      'Message Category': classification.name,
      'Transaction Direction': context?.direction.name ?? 'unknown',
      'Confidence': context?.confidenceScore ?? 0.0,
      'Extracted Amount': context?.extractedAmount ?? 0.0,
      'Extracted Balance': context?.extractedBalance ?? 0.0,
      'Merchant': context?.extractedMerchant ?? 'none',
      'Parser Used': context?.matchedTemplate != null ? 'template' : 'heuristic',
      'Validation Result': status == IngestionStatus.success ? 'pass' : 'fail',
      'Create Transaction': transaction != null,
      'Failure Reason': reason,
    };
  }
}

/// Core pipeline orchestrator coordinating the sequential stage-by-stage decoding
/// of incoming banking texts.
class SmsPipelineEngine {
  const SmsPipelineEngine();

  /// Process raw incoming message through 10 decoupled sequential stages.
  SmsPipelineResult process({
    required String rawText,
    required String senderId,
    required int receivedAt,
    required bool isDuplicate,
    required String messageId,
    required String transactionId,
  }) {
    // Stage 1: Raw SMS
    final context = PipelineContext(
      rawText: rawText,
      senderId: senderId,
      receivedAt: receivedAt,
      messageId: messageId,
      transactionId: transactionId,
    );

    // Guard: Check early for empty or obviously invalid inputs
    if (rawText.isEmpty || senderId.isEmpty) {
      final dedupeHash = DuplicateDetector.calculateHash(
        rawText: rawText,
        receivedAt: receivedAt,
        senderId: senderId,
      );
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: dedupeHash,
        ingestionStatus: IngestionStatus.failure,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.failure,
        reason: 'Empty message text or sender identifier.',
        classification: SmsClassification.non_bank,
        context: context,
      );
    }

    // Generate deduplication hash early
    final dedupeHash = DuplicateDetector.calculateHash(
      rawText: rawText,
      receivedAt: receivedAt,
      senderId: senderId,
    );

    // Stage 2: Sender Normalization
    context.normalizedSender = senderId.trim().toLowerCase().replaceAll(RegExp(r'[\s\.\-_]'), '');

    // Check false positive early to eliminate non-bank platforms
    final isFP = FalsePositiveProtection.isFalsePositive(senderId, rawText);

    // Stage 3: Bank Detection
    _detectBank(context);

    // Check if duplicate early to prevent double-inserting
    if (isDuplicate) {
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: dedupeHash,
        ingestionStatus: IngestionStatus.duplicate,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.duplicate,
        reason: 'Duplicate SMS signature already ingested.',
        classification: context.classification,
        context: context,
      );
    }

    if (isFP && (context.matchedBank == null || !_isVerifiedSender(context.matchedBank!, senderId))) {
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: dedupeHash,
        ingestionStatus: IngestionStatus.ignored,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.ignored,
        reason: 'Filtered: False positive protection matched.',
        classification: SmsClassification.non_bank,
        context: context,
      );
    }

    if (context.matchedBank == null) {
      final msg = BankMessageEntity(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        receivedAt: receivedAt,
        deduplicationHash: dedupeHash,
        ingestionStatus: IngestionStatus.ignored,
      );
      return SmsPipelineResult(
        message: msg,
        status: IngestionStatus.ignored,
        reason: 'Filtered: Sender does not match any registered bank profile.',
        classification: SmsClassification.non_bank,
        context: context,
      );
    }

    // Stage 4: Message Classification & Stage 5: Template Matching
    _classifyAndMatchTemplates(context);

    // Stage 6: Field Extraction
    _extractFields(context);

    // Stage 7: Direction Detection & Stage 8: Transaction Classification
    _detectDirectionAndTransactionType(context);

    // Stage 9: Validation & Confidence Scoring evaluation
    _validate(context);

    // Construct message DTO
    final msg = BankMessageEntity(
      id: messageId,
      rawText: rawText,
      senderId: senderId,
      receivedAt: receivedAt,
      deduplicationHash: dedupeHash,
      ingestionStatus: context.validationResult ? IngestionStatus.success : IngestionStatus.failure,
    );

    if (!context.validationResult) {
      // Stage 9: Store SMS inside UnknownTransactionQueue if parsing failed/validation rejected
      UnknownTransactionQueue.instance.add(
        id: messageId,
        rawText: rawText,
        senderId: senderId,
        matchedBankId: context.matchedBank?.bankId,
        templateCandidate: context.matchedTemplate?.id,
        confidence: context.confidenceScore,
        failureReason: context.failureReason,
        missingFields: context.missingFields,
        timestamp: receivedAt,
      );

      // Return a failed/ignored result with details
      final isOtp = context.classification == SmsClassification.bank_otp;
      final status = isOtp ? IngestionStatus.ignored : IngestionStatus.ignored;
      final reason = isOtp
          ? 'Filtered: OTP/dynamic password message ignored.'
          : 'Filtered: Message classification is ${context.classification}. Only financial_transaction creates ledger entries.';

      if (context.classification.isFinancialTransaction && (context.extractedAmount == null || context.extractedAmount! <= 0)) {
        return SmsPipelineResult(
          message: msg.copyWith(ingestionStatus: IngestionStatus.failure),
          status: IngestionStatus.failure,
          reason: 'Parsing failed: Transaction matched but unable to parse positive amount.',
          classification: context.classification,
          context: context,
        );
      }

      if (context.confidenceScore < 60) {
        return SmsPipelineResult(
          message: msg.copyWith(ingestionStatus: IngestionStatus.ignored),
          status: IngestionStatus.ignored,
          reason: 'Rejected: Deterministic confidence score is too low (${context.confidenceScore.toInt()} < 60).',
          classification: context.classification,
          context: context,
        );
      }

      return SmsPipelineResult(
        message: msg.copyWith(ingestionStatus: IngestionStatus.ignored),
        status: status,
        reason: reason,
        classification: context.classification,
        context: context,
      );
    }

    // Stage 10: Database DTO Creation (Success path)
    var currency = 'IRR';
    if (RegexPatterns.tomanPattern.hasMatch(rawText)) {
      currency = 'Toman';
    } else if (RegexPatterns.rialPattern.hasMatch(rawText)) {
      currency = 'IRR';
    }

    final tx = ParsedTransaction(
      id: transactionId,
      amount: context.extractedAmount!,
      currency: currency,
      transactionType: context.direction,
      rawMerchant: context.extractedMerchant,
      normalizedMerchant: context.extractedMerchant.isNotEmpty ? context.extractedMerchant : context.matchedBank!.bankName,
      cardIdentifier: context.extractedCard,
      timestamp: DateTimeParser.parse(rawText, receivedAt),
      sourceSmsId: messageId,
      accountId: context.matchedBank!.bankId,
      confidenceScore: context.confidenceScore / 100.0,
      parsingMethod: context.matchedTemplate != null ? 'template' : 'heuristic',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      balance: context.extractedBalance,
      referenceNumber: context.extractedRef,
    );

    return SmsPipelineResult(
      message: msg,
      transaction: tx,
      status: IngestionStatus.success,
      reason: 'SMS parsed successfully. Classification: ${context.classification}. Score: ${context.confidenceScore.toInt()}.',
      classification: context.classification,
      context: context,
    );
  }

  bool _isVerifiedSender(BankParser parser, String senderId) {
    final incomingNormalized = senderId.trim().toLowerCase().replaceAll(RegExp(r'[\s\.\-_]'), '');
    return parser.senderIds.any((id) =>
        id.trim().toLowerCase().replaceAll(RegExp(r'[\s\.\-_]'), '') == incomingNormalized);
  }

  /// Stage 3: Bank Detection with comprehensive confidence-scoring factors (PART 3).
  void _detectBank(PipelineContext context) {
    final registry = ParserRegistry.instance;
    final senderId = context.senderId;
    final rawText = context.rawText;
    final textNormalized = RegexPatterns.normalizeNumerals(rawText);

    BankParser? bestBank;
    var maxBankScore = 0.0;
    var bestReason = '';

    for (final parser in registry.parsers) {
      var score = 0.0;
      final isVerified = _isVerifiedSender(parser, senderId);

      // 1. Sender ID Match (+30 points)
      if (isVerified) {
        score += 30.0;
      }

      // 2. Normalized Sender ID contains bankId or aliases (+10 points)
      if (context.normalizedSender.contains(parser.bankId)) {
        score += 10.0;
      }

      // 3. Bank-specific Keywords match inside text body (+20 points)
      final textLower = rawText.toLowerCase();
      final hasBankKeyword = parser.keywords.any((kw) => textLower.contains(kw.toLowerCase()));
      if (hasBankKeyword) {
        score += 20.0;
      }

      // 4. Financial Keywords: Credit/Debit verbs (+10 points)
      final hasFinKeywords = RegexPatterns.creditVerbs.hasMatch(textLower) || RegexPatterns.debitVerbs.hasMatch(textLower);
      if (hasFinKeywords) {
        score += 10.0;
      }

      // 5. Message Structure: Multi-line or Key-Value delimiters (+5 points)
      final hasStructure = rawText.contains('\n') || rawText.contains(':') || rawText.contains('：');
      if (hasStructure) {
        score += 5.0;
      }

      // 6. Card or Account Numbers present (+10 points)
      final hasCard = RegexPatterns.cardPattern.hasMatch(rawText) || rawText.contains('کارت') || rawText.contains('حساب');
      if (hasCard) {
        score += 10.0;
      }

      // 7. IBAN presence like "شبا" or standard IR check (+5 points)
      final hasIban = rawText.contains('شبا') || RegExp(r'\bIR\d{24}\b', caseSensitive: false).hasMatch(textNormalized);
      if (hasIban) {
        score += 5.0;
      }

      // 8. Balance indicators present (+5 points)
      final hasBalance = RegexPatterns.balancePattern.hasMatch(rawText) || rawText.contains('مانده') || rawText.contains('موجودی');
      if (hasBalance) {
        score += 5.0;
      }

      // 9. Tracking/Reference Numbers present (+5 points)
      final hasRef = RegexPatterns.referencePattern.hasMatch(rawText) || rawText.contains('پیگیری') || rawText.contains('کدرهگیری');
      if (hasRef) {
        score += 5.0;
      }

      // 10. Merchant indicator present (+5 points)
      final hasMerchant = rawText.contains('خرید از') || rawText.contains('پذیرنده') || rawText.contains('فروشگاه');
      if (hasMerchant) {
        score += 5.0;
      }

      // 11. Amount presence (+10 points)
      final hasAmount = RegexPatterns.amountPattern.hasMatch(textNormalized);
      if (hasAmount) {
        score += 10.0;
      }

      // 12. Currency indicators present (+5 points)
      final hasCurrency = RegexPatterns.rialPattern.hasMatch(rawText) || RegexPatterns.tomanPattern.hasMatch(rawText);
      if (hasCurrency) {
        score += 5.0;
      }

      // Cap at 100 points
      final finalScore = score.clamp(0.0, 100.0);

      if (finalScore > maxBankScore) {
        maxBankScore = finalScore;
        bestBank = parser;
        bestReason = 'Detected ${parser.bankName} via score evaluation ($finalScore points).';
      }
    }

    if (maxBankScore >= 30.0 && bestBank != null) {
      context.matchedBank = bestBank;
      context.confidenceScore = maxBankScore;
      context.detectionReason = bestReason;
    } else {
      context.matchedBank = null;
      context.detectionReason = 'No bank matches score threshold.';
      context.confidenceScore = 0.0;
    }
  }

  /// Stage 4: Message Classification & Stage 5: Template Matching.
  void _classifyAndMatchTemplates(PipelineContext context) {
    final rawText = context.rawText;
    final bank = context.matchedBank;

    if (bank == null) {
      context.classification = SmsClassification.non_bank;
      return;
    }

    // Priority 1: Match against registered bank templates
    for (final template in bank.templates) {
      if (template.pattern.hasMatch(rawText)) {
        context.matchedTemplate = template;
        context.classification = template.classification;
        return;
      }
    }

    // Priority 2: Fall back to robust heuristic classification
    context.classification = bank.classify(rawText);
  }

  /// Stage 6: Field Extraction.
  void _extractFields(PipelineContext context) {
    final rawText = context.rawText;
    final bank = context.matchedBank;
    final template = context.matchedTemplate;

    if (bank == null) return;

    if (template != null) {
      // Try template-specific patterns first
      if (template.amountPattern != null) {
        final m = template.amountPattern!.firstMatch(rawText);
        if (m != null && m.groupCount >= 1) {
          context.extractedAmount = _parseAmountString(m.group(1));
        }
      }
      if (template.balancePattern != null) {
        final m = template.balancePattern!.firstMatch(rawText);
        if (m != null && m.groupCount >= 1) {
          context.extractedBalance = _parseAmountString(m.group(1));
        }
      }
      if (template.cardPattern != null) {
        final m = template.cardPattern!.firstMatch(rawText);
        if (m != null && m.groupCount >= 1) {
          context.extractedCard = m.group(1);
        }
      }
      if (template.refPattern != null) {
        final m = template.refPattern!.firstMatch(rawText);
        if (m != null && m.groupCount >= 1) {
          context.extractedRef = m.group(1);
        }
      }
      if (template.merchantPattern != null) {
        final m = template.merchantPattern!.firstMatch(rawText);
        if (m != null && m.groupCount >= 1) {
          context.extractedMerchant = _cleanMerchant(m.group(1)!);
        }
      }
    }

    // Fallback to flexible modular parsers for any missing fields
    context.extractedAmount ??= bank.parseAmount(rawText);
    context.extractedBalance ??= bank.parseBalance(rawText);
    context.extractedCard ??= bank.parseCardIdentifier(rawText);
    context.extractedRef ??= bank.parseReferenceNumber(rawText);
    if (context.extractedMerchant.isEmpty) {
      final parsedM = bank.parseMerchant(rawText);
      context.extractedMerchant = parsedM.isNotEmpty ? parsedM : '';
    }
  }

  double? _parseAmountString(String? text) {
    if (text == null) return null;
    final cleaned = RegexPatterns.normalizeNumerals(text).replaceAll(',', '').replaceAll(' ', '');
    return double.tryParse(cleaned);
  }

  /// Stage 7: Direction Detection & Stage 8: Transaction Classification.
  void _detectDirectionAndTransactionType(PipelineContext context) {
    final rawText = context.rawText;
    final template = context.matchedTemplate;

    // Multi-rule heuristic voting model (PART 5)
    var creditVotes = 0;
    var debitVotes = 0;

    // Rule 1: Template default direction
    if (template != null && template.direction != SmsTransactionType.unknown) {
      if (template.direction == SmsTransactionType.credit) {
        creditVotes += 15;
      } else if (template.direction == SmsTransactionType.debit) {
        debitVotes += 15;
      }
    }

    // Rule 2: Message Classification matching
    final classification = context.classification;
    if (classification == SmsClassification.bank_salary ||
        classification == SmsClassification.bank_interest ||
        classification == SmsClassification.bank_refund) {
      creditVotes += 10;
    }

    // Rule 3: Credit/Debit inline sign attached directly to amount (e.g. مبلغ:500,000+ or مبلغ:500,000-)
    final textNormalized = RegexPatterns.normalizeNumerals(rawText);
    if (textNormalized.contains('+') || textNormalized.contains('مبلغ+')) {
      creditVotes += 8;
    }
    if (textNormalized.contains('-') || textNormalized.contains('مبلغ-')) {
      debitVotes += 8;
    }

    // Rule 4: Verb-based Farsi/English indicator matching (Credit indicators)
    final strongCreditIndicators = [
      'واریز', 'بستانکار', 'افزایش موجودی', 'انتقال وجه دریافتی', 'انتقال از کارت', 'برگشت وجه', 'Incoming Transfer', 'credited', 'deposit'
    ];
    for (final indicator in strongCreditIndicators) {
      if (textNormalized.contains(indicator)) {
        creditVotes += 10;
      }
    }

    final generalCreditIndicators = [
      'حواله', 'پایا', 'پل', 'ساتنا', 'حقوق', 'سود'
    ];
    for (final indicator in generalCreditIndicators) {
      if (textNormalized.contains(indicator)) {
        creditVotes += 3;
      }
    }

    // Rule 5: Debit indicators
    final strongDebitIndicators = [
      'برداشت', 'خرید', 'پرداخت', 'کارت به کارت', 'قبض', 'کاهش موجودی', 'بدهکار', 'کسر', 'POS', 'ATM', 'withdrawal', 'spent'
    ];
    for (final indicator in strongDebitIndicators) {
      if (textNormalized.contains(indicator)) {
        debitVotes += 10;
      }
    }

    // Special substring exclusion to avoid matching 'انتقال' when it is actually 'انتقال از...'
    if (textNormalized.contains('انتقال') && !textNormalized.contains('انتقال از')) {
      debitVotes += 10;
    }

    final generalDebitIndicators = [
      'Internet Purchase', 'Mobile Banking'
    ];
    for (final indicator in generalDebitIndicators) {
      if (textNormalized.contains(indicator)) {
        debitVotes += 3;
      }
    }

    // Resolve direction
    if (creditVotes > debitVotes) {
      context.direction = SmsTransactionType.credit;
    } else if (debitVotes > creditVotes) {
      context.direction = SmsTransactionType.debit;
    } else {
      context.direction = SmsTransactionType.unknown;
    }
  }

  /// Stage 9: Validation and confidence score checks.
  void _validate(PipelineContext context) {
    final isFinancial = context.classification.isFinancialTransaction;

    // Recalculate Confidence points
    var score = 0.0;
    final isVerified = context.matchedBank != null && _isVerifiedSender(context.matchedBank!, context.senderId);
    if (isVerified) score += 50.0;
    if (context.classification != SmsClassification.bank_unknown && context.classification != SmsClassification.non_bank) score += 20.0;
    if (context.extractedAmount != null && context.extractedAmount! > 0) score += 10.0;
    if (context.extractedCard != null && context.extractedCard!.isNotEmpty) score += 10.0;
    if (context.extractedBalance != null && context.extractedBalance! > 0) score += 10.0;
    if (context.extractedRef != null && context.extractedRef!.isNotEmpty) score += 5.0;

    context.confidenceScore = score;

    final missing = <String>[];
    if (context.extractedAmount == null) missing.add('amount');
    if (context.extractedCard == null) missing.add('card');
    if (context.extractedBalance == null) missing.add('balance');
    context.missingFields = missing;

    if (context.classification == SmsClassification.bank_otp) {
      context.validationResult = false;
      context.failureReason = 'Early Ignored: OTP/dynamic code is not a financial transaction.';
      return;
    }

    if (!isFinancial) {
      context.validationResult = false;
      context.failureReason = 'Early Ignored: Classification is ${context.classification.name}.';
      return;
    }

    if (context.extractedAmount == null || context.extractedAmount! <= 0) {
      context.validationResult = false;
      context.failureReason = 'Validation failed: Extracted amount is missing or invalid.';
      return;
    }

    if (score < 60) {
      context.validationResult = false;
      context.failureReason = 'Validation failed: Match score ($score) is below threshold 60.';
      return;
    }

    context.validationResult = true;
  }

  String _cleanMerchant(String raw) {
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
