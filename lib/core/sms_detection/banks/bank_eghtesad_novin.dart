import '../bank_parser.dart';

class EghtesadNovinParser extends BaseBankParser {
  const EghtesadNovinParser();

  @override
  String get bankId => 'eghtesad_novin';

  @override
  String get bankName => 'Eghtesad Novin Bank';

  @override
  List<String> get senderIds => const [
        'ENBank',
        'enbank',
        'EghtesadNovin',
        'eghtesadnovin',
        'Eghtesad_Novin',
        'eghtesad_novin',
        'B.EghtesadNovin',
        'b.eghtesadnovin'
      ];

  @override
  List<String> get keywords => const ['اقتصاد نوین', 'بانک اقتصاد نوین', 'enbank'];
}
