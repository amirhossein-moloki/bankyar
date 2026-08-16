/// Supported statuses for payment verification requests according to prompt specs.
enum PaymentRequestStatus {
  /// Payment SMS detected by system.
  detected,

  /// Payment details extracted/parsed.
  parsed,

  /// Queued locally waiting for connection or upload enablement.
  waitingUpload,

  /// Currently sending to remote API.
  sending,

  /// Sent to remote API awaiting confirmation.
  sent,

  /// Successfully verified by API.
  success,

  /// Verification failed or network error occurred.
  failed,

  /// Duplicate request detected and ignored.
  duplicate;

  /// String representation matching prompt requirements (Section 7).
  String toCode() {
    switch (this) {
      case PaymentRequestStatus.detected:
        return 'Detected';
      case PaymentRequestStatus.parsed:
        return 'Parsed';
      case PaymentRequestStatus.waitingUpload:
        return 'Waiting Upload';
      case PaymentRequestStatus.sending:
        return 'Sending';
      case PaymentRequestStatus.sent:
        return 'Sent';
      case PaymentRequestStatus.success:
        return 'Success';
      case PaymentRequestStatus.failed:
        return 'Failed';
      case PaymentRequestStatus.duplicate:
        return 'Duplicate';
    }
  }

  /// Parse string status code to enum.
  static PaymentRequestStatus fromCode(String code) {
    switch (code) {
      case 'Detected':
        return PaymentRequestStatus.detected;
      case 'Parsed':
        return PaymentRequestStatus.parsed;
      case 'Waiting Upload':
        return PaymentRequestStatus.waitingUpload;
      case 'Sending':
        return PaymentRequestStatus.sending;
      case 'Sent':
        return PaymentRequestStatus.sent;
      case 'Success':
        return PaymentRequestStatus.success;
      case 'Failed':
        return PaymentRequestStatus.failed;
      case 'Duplicate':
        return PaymentRequestStatus.duplicate;
      default:
        return PaymentRequestStatus.detected;
    }
  }

  /// Persian display label.
  String toPersianLabel() {
    switch (this) {
      case PaymentRequestStatus.detected:
        return 'شناسایی شده';
      case PaymentRequestStatus.parsed:
        return 'پردازش شده';
      case PaymentRequestStatus.waitingUpload:
        return 'در انتظار ارسال';
      case PaymentRequestStatus.sending:
        return 'در حال ارسال';
      case PaymentRequestStatus.sent:
        return 'ارسال شده';
      case PaymentRequestStatus.success:
        return 'تایید شده';
      case PaymentRequestStatus.failed:
        return 'خطا در ارسال';
      case PaymentRequestStatus.duplicate:
        return 'تکراری';
    }
  }
}

/// Domain entity representing a payment verification request log entry.
class PaymentRequestLog {
  /// Constructor.
  const PaymentRequestLog({
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

  /// Issuing bank name.
  final String bankName;

  /// Transaction amount in Rials.
  final double amount;

  /// Last four digits of debit card or account.
  final String cardLastFour;

  /// Bank reference/tracking number.
  final String referenceNumber;

  /// Raw SMS body text.
  final String smsRaw;

  /// SMS detection timestamp.
  final DateTime detectedAt;

  /// API transmission timestamp.
  final DateTime? sentAt;

  /// Request processing status.
  final PaymentRequestStatus status;

  /// Retry count.
  final int retryCount;

  /// API response string.
  final String? apiResponse;

  /// Error message on failure.
  final String? errorMessage;

  /// Copy with helper.
  PaymentRequestLog copyWith({
    String? id,
    String? bankName,
    double? amount,
    String? cardLastFour,
    String? referenceNumber,
    String? smsRaw,
    DateTime? detectedAt,
    DateTime? sentAt,
    PaymentRequestStatus? status,
    int? retryCount,
    String? apiResponse,
    String? errorMessage,
  }) {
    return PaymentRequestLog(
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
