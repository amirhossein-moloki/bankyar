/// Configuration state for API connection and payment monitor behavior.
class PaymentMonitorConfig {
  /// Constructor.
  const PaymentMonitorConfig({
    this.domain = '',
    this.apiToken = '',
    this.isAutoUploadEnabled = false,
    this.lastConnectionTestAt,
    this.lastConnectionTestSuccess,
    this.lastConnectionTestMessage,
  });

  /// Configured server domain (e.g. https://example.com).
  final String domain;

  /// Secure API Token.
  final String apiToken;

  /// Whether detected payment SMS messages are automatically sent to API.
  final bool isAutoUploadEnabled;

  /// Timestamp of last test connection execution.
  final DateTime? lastConnectionTestAt;

  /// Status of last connection test (true = success, false = failure).
  final bool? lastConnectionTestSuccess;

  /// Error or success message from last connection test.
  final String? lastConnectionTestMessage;

  /// Returns masked API token for UI display (e.g., ****************abcd).
  String get maskedToken {
    final trimmed = apiToken.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.length <= 4) {
      return '*' * trimmed.length;
    }
    final visiblePart = trimmed.substring(trimmed.length - 4);
    final maskedPart = '*' * 16;
    return '$maskedPart$visiblePart';
  }

  /// Copy with helper.
  PaymentMonitorConfig copyWith({
    String? domain,
    String? apiToken,
    bool? isAutoUploadEnabled,
    DateTime? lastConnectionTestAt,
    bool? lastConnectionTestSuccess,
    String? lastConnectionTestMessage,
  }) {
    return PaymentMonitorConfig(
      domain: domain ?? this.domain,
      apiToken: apiToken ?? this.apiToken,
      isAutoUploadEnabled: isAutoUploadEnabled ?? this.isAutoUploadEnabled,
      lastConnectionTestAt: lastConnectionTestAt ?? this.lastConnectionTestAt,
      lastConnectionTestSuccess:
          lastConnectionTestSuccess ?? this.lastConnectionTestSuccess,
      lastConnectionTestMessage:
          lastConnectionTestMessage ?? this.lastConnectionTestMessage,
    );
  }
}
