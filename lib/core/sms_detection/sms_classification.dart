/// Enum representing the detailed classification of a detected SMS message.
enum SmsClassification {
  /// Standard deposits, withdrawals, purchases, transfers.
  bank_transaction,

  /// OTP, verification, or dynamic passwords.
  bank_otp,

  /// Security alerts, login notifications, password changes.
  bank_security,

  /// Informational messages, branch updates, greeting messages.
  bank_information,

  /// Bank advertisements, loans or lottery promotions.
  bank_promotional,

  /// Detailed account statements or summaries.
  bank_statement,

  /// Card issuance, expiration, or activation updates.
  bank_card_status,

  /// Cheque registrations, clearances, or bounces.
  bank_cheque,

  /// Loan installment alerts, delays, or repayments.
  bank_loan,

  /// Message matches a bank but has unrecognized format or type.
  bank_unknown,

  /// Clearly non-banking messages, spam, or third-party platforms (e.g., Snapp).
  non_bank,

  /// Paya transfers (deposit or withdrawal).
  bank_paya,

  /// Satna transfers (deposit or withdrawal).
  bank_satna,

  /// Pol transfers (deposit or withdrawal).
  bank_pol,

  /// Bank interest deposit.
  bank_interest,

  /// Salary deposit.
  bank_salary,

  /// Refund credit.
  bank_refund,

  /// Account opening.
  bank_account_opening,
}

/// Helper extension on [SmsClassification] to determine processing logic.
extension SmsClassificationExtensions on SmsClassification {
  /// Returns whether this classification represents a financial transaction
  /// that is permitted to create a ledger entry.
  bool get isFinancialTransaction {
    switch (this) {
      case SmsClassification.bank_transaction:
      case SmsClassification.bank_paya:
      case SmsClassification.bank_satna:
      case SmsClassification.bank_pol:
      case SmsClassification.bank_interest:
      case SmsClassification.bank_salary:
      case SmsClassification.bank_refund:
        return true;
      default:
        return false;
    }
  }
}
