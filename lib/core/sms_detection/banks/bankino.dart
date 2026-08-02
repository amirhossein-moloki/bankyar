import '../bank_parser.dart';

class BankinoParser extends BaseBankParser {
  const BankinoParser();

  @override
  String get bankId => 'bankino';

  @override
  String get bankName => 'Bankino';

  @override
  List<String> get senderIds => const ['Bankino', 'bankino', 'Kino', 'kino'];

  @override
  List<String> get keywords => const ['بانکینو', 'bankino'];
}
