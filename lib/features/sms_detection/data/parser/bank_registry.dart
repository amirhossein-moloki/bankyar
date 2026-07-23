import 'package:meta/meta.dart';

/// Entity/Model representing a financial institution's matching registry metadata.
@immutable
class BankProfile {
  /// Constructor defining registration boundaries for a single bank.
  const BankProfile({
    required this.id,
    required this.name,
    required this.senderIds,
    required this.keywords,
    this.aliases = const [],
  });

  /// Unique lowercase computer-readable code identifier (e.g. 'melli').
  final String id;

  /// Human-readable localized name (e.g. 'Bank Melli Iran').
  final String name;

  /// List of possible SMS sender names or prefixes matching this bank (case-insensitive).
  final List<String> senderIds;

  /// Core keywords associated with this bank's transactional body.
  final List<String> keywords;

  /// Alternate names, aliases, or text markers.
  final List<String> aliases;

  /// Verifies if a given sender ID matches this bank profile.
  bool matchesSender(String incomingSenderId) {
    final normalizedInput = incomingSenderId.trim().toLowerCase();
    return senderIds.any((id) => id.toLowerCase() == normalizedInput);
  }

  /// Verifies if a given SMS body matches this bank profile.
  bool matchesBody(String rawText) {
    final normalizedText = rawText.toLowerCase();
    // Match either the bank's keywords or aliases
    final hasKeyword = keywords.any(
      (kw) => normalizedText.contains(kw.toLowerCase()),
    );
    final hasAlias = aliases.any(
      (alias) => normalizedText.contains(alias.toLowerCase()),
    );
    return hasKeyword || hasAlias;
  }
}

/// Registry manager governing known bank definitions and custom template extensions.
class BankRegistry {
  /// Internal constructor with pre-registered primary Iranian banks.
  BankRegistry._internal() {
    _resetDefaults();
  }

  /// Singleton instance of the registry.
  static final BankRegistry instance = BankRegistry._internal();

  final List<BankProfile> _profiles = [];

  /// Resets the registry to its default built-in profiles.
  void _resetDefaults() {
    _profiles.clear();
    _profiles.addAll([
      const BankProfile(
        id: 'melli',
        name: 'Bank Melli Iran',
        senderIds: ['Melli', 'B.Melli', 'B-Melli'],
        keywords: ['ملی', 'بانک ملی', 'melli'],
        aliases: ['BMI'],
      ),
      const BankProfile(
        id: 'mellat',
        name: 'Bank Mellat',
        senderIds: ['Mellat', 'B.Mellat', 'MellatBank'],
        keywords: ['ملت', 'بانک ملت', 'mellat'],
        aliases: ['BML'],
      ),
      const BankProfile(
        id: 'tejarat',
        name: 'Bank Tejarat',
        senderIds: ['Tejarat', 'B.Tejarat'],
        keywords: ['تجارت', 'بانک تجارت', 'tejarat'],
        aliases: ['BTI'],
      ),
      const BankProfile(
        id: 'saman',
        name: 'Saman Bank',
        senderIds: ['Saman', 'B.Saman', 'SamanBank'],
        keywords: ['سامان', 'بانک سامان', 'saman'],
        aliases: ['BSB'],
      ),
      const BankProfile(
        id: 'pasargad',
        name: 'Pasargad Bank',
        senderIds: ['Pasargad', 'B.Pasargad', 'PasargadBank'],
        keywords: ['پاسارگاد', 'بانک پاسارگاد', 'pasargad'],
        aliases: ['BPI'],
      ),
      const BankProfile(
        id: 'saderat',
        name: 'Bank Saderat Iran',
        senderIds: ['Saderat', 'B.Saderat'],
        keywords: ['صادرات', 'بانک صادرات', 'saderat'],
        aliases: ['BSI'],
      ),
      const BankProfile(
        id: 'parsian',
        name: 'Parsian Bank',
        senderIds: ['Parsian', 'B.Parsian', 'ParsianBank'],
        keywords: ['پارسیان', 'بانک پارسیان', 'parsian'],
        aliases: ['BPA'],
      ),
    ]);
  }

  /// Fetch all active bank profiles.
  List<BankProfile> get profiles => List.unmodifiable(_profiles);

  /// Dynamically register a new bank profile (for future bank updates).
  void registerBank(BankProfile profile) {
    // If profile already exists, replace it, otherwise append.
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _profiles[index] = profile;
    } else {
      _profiles.add(profile);
    }
  }

  /// Resets the registry back to default built-in profiles (helpful in tests).
  void reset() {
    _resetDefaults();
  }

  /// Detects bank profile by sender ID and/or message content matching.
  BankProfile? detectBank(String senderId, String rawText) {
    // 1. Try to match strictly by senderId first
    for (final profile in _profiles) {
      if (profile.matchesSender(senderId)) {
        return profile;
      }
    }

    // 2. Fallback to keyword matching inside the raw text body
    for (final profile in _profiles) {
      if (profile.matchesBody(rawText)) {
        return profile;
      }
    }

    return null;
  }
}
