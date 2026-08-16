/// Data transfer object mapping payment verification requests to SQLite tables and API payloads.
class PaymentRequestDto {
  /// Constructor.
  const PaymentRequestDto({
    required this.id,
    required this.bankName,
    required this.amount,
    required this.cardLastFour,
    required this.referenceNumber,
    required this.smsRaw,
    required this.detectedAt,
    this.sentAt,
    required this.status,
    this.retryCount = 0,
    this.apiResponse,
    this.errorMessage,
  });

  /// Unique UUID string.
  final String id;

  /// Name of the bank issuing payment SMS.
  final String bankName;

  /// Payment amount value.
  final double amount;

  /// Last four digits of card or account.
  final String cardLastFour;

  /// Unique bank transaction reference or tracking number.
  final String referenceNumber;

  /// Raw body of detected bank SMS.
  final String smsRaw;

  /// Millisecond timestamp of SMS detection.
  final int detectedAt;

  /// Millisecond timestamp when sent to API.
  final int? sentAt;

  /// Current request status (Detected, Parsed, Waiting Upload, Sending, Sent, Success, Failed, Duplicate).
  final String status;

  /// Number of API upload retry attempts.
  final int retryCount;

  /// Server API response text or JSON string.
  final String? apiResponse;

  /// Error message on failure.
  final String? errorMessage;

  /// Convert DTO to SQLite map row.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bank_name': bankName,
      'amount': amount,
      'card_last_four': cardLastFour,
      'reference_number': referenceNumber,
      'sms_raw': smsRaw,
      'detected_at': detectedAt,
      'sent_at': sentAt,
      'status': status,
      'retry_count': retryCount,
      'api_response': apiResponse,
      'error_message': errorMessage,
    };
  }

  /// Create DTO from SQLite map row.
  factory PaymentRequestDto.fromMap(Map<String, dynamic> map) {
    return PaymentRequestDto(
      id: map['id'] as String,
      bankName: map['bank_name'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      cardLastFour: map['card_last_four'] as String? ?? '',
      referenceNumber: map['reference_number'] as String? ?? '',
      smsRaw: map['sms_raw'] as String? ?? '',
      detectedAt: map['detected_at'] as int? ?? 0,
      sentAt: map['sent_at'] as int?,
      status: map['status'] as String? ?? 'Detected',
      retryCount: map['retry_count'] as int? ?? 0,
      apiResponse: map['api_response'] as String?,
      errorMessage: map['error_message'] as String?,
    );
  }

  /// Convert DTO to API JSON payload matching prompt spec Section 13.
  Map<String, dynamic> toApiPayload(String apiToken) {
    return {
      'api_token': apiToken,
      'bank_name': bankName,
      'amount': amount.toInt(),
      'source_card_last_four': cardLastFour,
      'ref_num': referenceNumber,
      'sms_raw': smsRaw,
      'timestamp': (detectedAt / 1000).round(),
    };
  }

  /// Copy with updated parameters.
  PaymentRequestDto copyWith({
    String? id,
    String? bankName,
    double? amount,
    String? cardLastFour,
    String? referenceNumber,
    String? smsRaw,
    int? detectedAt,
    int? sentAt,
    String? status,
    int? retryCount,
    String? apiResponse,
    String? errorMessage,
  }) {
    return PaymentRequestDto(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      amount: amount ?? this.amount,
      cardLastFour: cardLastFour ?? this.cardLastFour,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      smsRaw: smsRaw ?? this.smsRaw,
      detectedAt: detectedAt ?? this.detectedAt,
      sentAt: sentAt ?? this.sentAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      apiResponse: apiResponse ?? this.apiResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
