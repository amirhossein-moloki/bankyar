import '../../domain/entities/parsed_transaction.dart';

/// Calculation engine designed to score pipeline reliability based on extracted attributes.
class ConfidenceScorer {
  const ConfidenceScorer._();

  /// Calculates a parsing confidence score between 0.0 and 1.0.
  ///
  /// Weights:
  /// - Amount successfully extracted: +0.4
  /// - Bank identified: +0.3
  /// - Transaction type resolved (Credit/Debit): +0.2
  /// - Card/Account reference isolated: +0.1
  static double calculate({
    required double? amount,
    required bool hasBank,
    required SmsTransactionType transactionType,
    required String? cardIdentifier,
  }) {
    var score = 0.0;

    if (amount != null && amount > 0) {
      score += 0.4;
    }

    if (hasBank) {
      score += 0.3;
    }

    if (transactionType != SmsTransactionType.unknown) {
      score += 0.2;
    }

    if (cardIdentifier != null && cardIdentifier.isNotEmpty) {
      score += 0.1;
    }

    // Round to 1 decimal place to clean floating representation errors
    return double.parse(score.toStringAsFixed(1));
  }

  /// Evaluates whether a score warrants flagging for review.
  /// Standard low-confidence threshold is 0.7.
  static bool isLowConfidence(double score) {
    return score < 0.7;
  }
}
