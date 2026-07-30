import '../bank_parser.dart';

class ParsianParser extends BaseBankParser {
  const ParsianParser();

  @override
  String get bankId => 'parsian';

  @override
  String get bankName => 'Parsian Bank';

  @override
  List<String> get senderIds => const [
        'Parsian',
        'B.Parsian',
        'B-Parsian',
        'BPA',
        'parsian',
        'b.parsian',
        'b-parsian',
        'bpa',
        'ParsianBank',
        'parsianbank'
      ];

  @override
  List<String> get keywords => const ['پارسیان', 'بانک پارسیان', 'parsian'];
}
