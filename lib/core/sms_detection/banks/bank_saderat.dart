import '../bank_parser.dart';

class SaderatParser extends BaseBankParser {
  const SaderatParser();

  @override
  String get bankId => 'saderat';

  @override
  String get bankName => 'Bank Saderat Iran';

  @override
  List<String> get senderIds => const [
        'Saderat',
        'B.Saderat',
        'B-Saderat',
        'BSI',
        'saderat',
        'b.saderat',
        'b-saderat',
        'bsi',
        'SaderatBank',
        'saderatbank'
      ];

  @override
  List<String> get keywords => const ['صادرات', 'بانک صادرات', 'saderat'];
}
