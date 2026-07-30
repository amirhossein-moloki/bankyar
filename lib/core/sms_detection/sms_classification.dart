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
}
