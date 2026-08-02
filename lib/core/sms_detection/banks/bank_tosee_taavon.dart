import '../bank_parser.dart';

class ToseeTaavonParser extends BaseBankParser {
  const ToseeTaavonParser();

  @override
  String get bankId => 'tosee_taavon';

  @override
  String get bankName => 'Tosee Taavon Bank';

  @override
  List<String> get senderIds => const [
    'ToseeTaavon',
    'toseetaavon',
    'Tosee_Taavon',
    'tosee_taavon',
    'B.ToseeTaavon',
    'b.toseetaavon',
  ];

  @override
  List<String> get keywords => const [
    'توسعه تعاون',
    'بانک توسعه تعاون',
    'ttbank',
  ];
}
