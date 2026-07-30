import '../bank_parser.dart';

class SanatMadanParser extends BaseBankParser {
  const SanatMadanParser();

  @override
  String get bankId => 'sanat_madan';

  @override
  String get bankName => 'Bank Sanat va Madan';

  @override
  List<String> get senderIds => const [
        'SanatMadan',
        'sanatmadan',
        'Sanat_Madan',
        'sanat_madan',
        'BIM',
        'bim',
        'B.SanatMadan',
        'b.sanatmadan'
      ];

  @override
  List<String> get keywords => const ['صنعت و معدن', 'بانک صنعت و معدن', 'bim'];
}
