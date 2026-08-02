import '../bank_parser.dart';

class ToseeSaderatParser extends BaseBankParser {
  const ToseeSaderatParser();

  @override
  String get bankId => 'tosee_saderat';

  @override
  String get bankName => 'Tosee Saderat Bank';

  @override
  List<String> get senderIds => const [
    'ToseeSaderat',
    'toseesaderat',
    'Tosee_Saderat',
    'tosee_saderat',
    'B.ToseeSaderat',
    'b.toseesaderat',
    'EDBI',
    'edbi',
  ];

  @override
  List<String> get keywords => const [
    'توسعه صادرات',
    'بانک توسعه صادرات',
    'edbi',
  ];
}
