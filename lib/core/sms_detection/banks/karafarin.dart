import '../bank_parser.dart';

class KarafarinParser extends BaseBankParser {
  const KarafarinParser();

  @override
  String get bankId => 'karafarin';

  @override
  String get bankName => 'Karafarin Bank';

  @override
  List<String> get senderIds => const [
    'Karafarin',
    'karafarin',
    'B.Karafarin',
    'b.karafarin',
    'KarafarinBank',
    'karafarinbank',
  ];

  @override
  List<String> get keywords => const ['کارآفرین', 'بانک کارآفرین', 'karafarin'];
}
