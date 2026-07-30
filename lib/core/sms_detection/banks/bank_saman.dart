import '../bank_parser.dart';

class SamanParser extends BaseBankParser {
  const SamanParser();

  @override
  String get bankId => 'saman';

  @override
  String get bankName => 'Saman Bank';

  @override
  List<String> get senderIds => const [
        'Saman',
        'B.Saman',
        'B-Saman',
        'BSB',
        'saman',
        'b.saman',
        'b-saman',
        'bsb',
        'SamanBank',
        'samanbank'
      ];

  @override
  List<String> get keywords => const ['سامان', 'بانک سامان', 'saman'];
}
