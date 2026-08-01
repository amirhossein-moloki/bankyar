/// Class representing an item in the unknown transaction queue.
class UnknownQueueItem {
  const UnknownQueueItem({
    required this.id,
    required this.rawText,
    required this.senderId,
    this.matchedBankId,
    this.templateCandidate,
    required this.confidence,
    required this.failureReason,
    required this.missingFields,
    required this.timestamp,
  });

  final String id;
  final String rawText;
  final String senderId;
  final String? matchedBankId;
  final String? templateCandidate;
  final double confidence;
  final String failureReason;
  final List<String> missingFields;
  final int timestamp;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rawText': rawText,
      'senderId': senderId,
      'matchedBankId': matchedBankId,
      'templateCandidate': templateCandidate,
      'confidence': confidence,
      'failureReason': failureReason,
      'missingFields': missingFields,
      'timestamp': timestamp,
    };
  }
}

/// Global thread-safe, memory-efficient queue managing transactions that failed to parse correctly.
class UnknownTransactionQueue {
  UnknownTransactionQueue._internal();

  static final UnknownTransactionQueue instance = UnknownTransactionQueue._internal();

  final List<UnknownQueueItem> _items = [];

  /// Retrieves all items currently in the queue.
  List<UnknownQueueItem> get items => List.unmodifiable(_items);

  /// Appends a new failed/unknown SMS parse result to the queue.
  void add({
    required String id,
    required String rawText,
    required String senderId,
    String? matchedBankId,
    String? templateCandidate,
    required double confidence,
    required String failureReason,
    required List<String> missingFields,
    required int timestamp,
  }) {
    _items.add(
      UnknownQueueItem(
        id: id,
        rawText: rawText,
        senderId: senderId,
        matchedBankId: matchedBankId,
        templateCandidate: templateCandidate,
        confidence: confidence,
        failureReason: failureReason,
        missingFields: missingFields,
        timestamp: timestamp,
      ),
    );
  }

  /// Clears the queue.
  void clear() {
    _items.clear();
  }
}
