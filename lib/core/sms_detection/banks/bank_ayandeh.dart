import '../bank_parser.dart';

class AyandehParser extends BaseBankParser {
  const AyandehParser();

  @override
  String get bankId => 'ayandeh';

  @override
  String get bankName => 'Bank Ayandeh';

  @override
  List<String> get senderIds => const [
    'Ayandeh',
    'B.Ayandeh',
    'B-Ayandeh',
    'ayandeh',
    'b.ayandeh',
    'b-ayandeh',
    'AyandehBank',
    'ayandehbank',
  ];

  @override
  List<String> get keywords => const ['آینده', 'بانک آینده', 'ayandeh'];
}
