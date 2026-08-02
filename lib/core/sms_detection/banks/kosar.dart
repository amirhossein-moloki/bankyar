import '../bank_parser.dart';

class KosarParser extends BaseBankParser {
  const KosarParser();

  @override
  String get bankId => 'kosar';

  @override
  String get bankName => 'Kosar Credit Institution (Legacy)';

  @override
  List<String> get senderIds => const [
    'Kosar',
    'kosar',
    'KosarBank',
    'kosarbank',
    'B.Kosar',
    'b.kosar',
  ];

  @override
  List<String> get keywords => const ['کوثر', 'موسسه کوثر', 'kosar'];
}
