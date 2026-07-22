/// Reusable utility class for user forms and secure inputs validation.
/// Conforms to FORMS_INPUT_SYSTEM.md specifications.
abstract class InputValidators {
  // Matches a valid monetary amount (e.g., "150000", "150,000", "150000.00")
  static final RegExp _amountRegex = RegExp(r'^\d{1,10}([.,]\d{1,2})?$');

  // Matches a valid 4-digit or 6-digit numeric security PIN input
  static final RegExp _pinRegex = RegExp(r'^\d{4}$|^\d{6}$');

  // Matches a standard date layout (e.g. "1402/10/25" or "2024/02/15")
  static final RegExp _dateRegex = RegExp(r'^\d{4}/\d{2}/\d{2}$');

  /// Validates standard monetary inputs.
  static bool isValidAmount(String input) {
    final clean = input.replaceAll(',', '').trim();
    if (clean.isEmpty) return false;
    return _amountRegex.hasMatch(clean);
  }

  /// Validates PIN security inputs (enforces strict length of 4 or 6 digits).
  static bool isValidPin(String input) {
    return _pinRegex.hasMatch(input);
  }

  /// Validates date layout inputs matching yyyy/MM/dd schemas.
  static bool isValidDate(String input) {
    return _dateRegex.hasMatch(input);
  }
}
