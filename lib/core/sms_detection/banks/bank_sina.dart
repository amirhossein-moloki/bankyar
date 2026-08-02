import '../bank_parser.dart';

class SinaParser extends BaseBankParser {
  const SinaParser();

  @override
  String get bankId => 'sina';

  @override
  String get bankName => 'Bank Sina';

  @override
  List<String> get senderIds => const [
    'Sina',
    'B.Sina',
    'B-Sina',
    'sina',
    'b.sina',
    'b-sina',
    'SinaBank',
    'sinabank',
  ];

  @override
  List<String> get keywords => const ['سینا', 'بانک سینا', 'sina'];
}
