import 'bank_parser.dart';
import 'banks/bank_melli.dart';
import 'banks/bank_mellat.dart';
import 'banks/bank_tejarat.dart';
import 'banks/bank_saman.dart';
import 'banks/bank_pasargad.dart';
import 'banks/bank_sepah.dart';
import 'banks/bank_maskan.dart';
import 'banks/bank_keshavarzi.dart';
import 'banks/bank_refah.dart';
import 'banks/bank_saderat.dart';
import 'banks/bank_shahr.dart';
import 'banks/bank_ayandeh.dart';
import 'banks/bank_eghtesad_novin.dart';
import 'banks/bank_parsian.dart';
import 'banks/bank_sina.dart';
import 'banks/bank_day.dart';
import 'banks/bank_iran_zamin.dart';
import 'banks/bank_tosee_taavon.dart';
import 'banks/bank_tosee_saderat.dart';
import 'banks/bank_sanat_madan.dart';
import 'banks/post_bank.dart';
import 'banks/mehr_iran.dart';
import 'banks/resalat.dart';
import 'banks/karafarin.dart';
import 'banks/khavarmianeh.dart';
import 'banks/gardeshgari.dart';
import 'banks/blu_bank.dart';
import 'banks/bankino.dart';
import 'banks/ansar.dart';
import 'banks/mehr_eqtesad.dart';
import 'banks/kosar.dart';
import 'banks/hekmat.dart';

/// Central registry managing all registered Bank SMS parsers.
class ParserRegistry {
  ParserRegistry._internal() {
    _registerAll();
  }

  /// Singleton instance of the registry.
  static final ParserRegistry instance = ParserRegistry._internal();

  final List<BankParser> _parsers = [];

  void _registerAll() {
    _parsers.clear();
    _parsers.addAll(const [
      MelliParser(),
      MellatParser(),
      TejaratParser(),
      SamanParser(),
      PasargadParser(),
      SepahParser(),
      MaskanParser(),
      KeshavarziParser(),
      RefahParser(),
      SaderatParser(),
      ShahrParser(),
      AyandehParser(),
      EghtesadNovinParser(),
      ParsianParser(),
      SinaParser(),
      DayParser(),
      IranZaminParser(),
      ToseeTaavonParser(),
      ToseeSaderatParser(),
      SanatMadanParser(),
      PostBankParser(),
      MehrIranParser(),
      ResalatParser(),
      KarafarinParser(),
      KhavarmianehParser(),
      GardeshgariParser(),
      BluBankParser(),
      BankinoParser(),
      AnsarParser(),
      MehrEqtesadParser(),
      KosarParser(),
      HekmatParser(),
    ]);
  }

  /// Returns all registered bank parsers.
  List<BankParser> get parsers => List.unmodifiable(_parsers);

  /// Dynamically register a new bank parser.
  void registerParser(BankParser parser) {
    // If already registered, replace it; otherwise add.
    final index = _parsers.indexWhere((p) => p.bankId == parser.bankId);
    if (index >= 0) {
      _parsers[index] = parser;
    } else {
      _parsers.add(parser);
    }
  }

  /// Resets the registry back to standard default parsers.
  void reset() {
    _registerAll();
  }

  /// Detects the matching bank parser for a given sender ID and/or raw SMS body.
  /// First attempts strict sender ID matching, then fallback to keyword matching inside the text body.
  BankParser? detectParser(String senderId, String rawText) {
    if (senderId.isEmpty) return null;

    // 1. Strict sender ID matching
    for (final parser in _parsers) {
      if (_matchesSender(parser, senderId)) {
        return parser;
      }
    }

    // 2. Fallback to keyword matching if sender is not explicitly blocked/non-bank
    final normalizedText = rawText.toLowerCase();
    for (final parser in _parsers) {
      final matchesKeyword = parser.keywords.any(
        (kw) => normalizedText.contains(kw.toLowerCase()),
      );
      if (matchesKeyword) {
        return parser;
      }
    }

    return null;
  }

  bool _matchesSender(BankParser parser, String incomingSenderId) {
    final incomingNormalized = _normalizeSenderId(incomingSenderId);
    return parser.senderIds.any(
      (id) => _normalizeSenderId(id) == incomingNormalized,
    );
  }

  String _normalizeSenderId(String senderId) {
    return senderId.trim().replaceAll(RegExp(r'[\s\.\-_]'), '').toLowerCase();
  }
}
