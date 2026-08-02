import '../bank_parser.dart';

class MehrEqtesadParser extends BaseBankParser {
  const MehrEqtesadParser();

  @override
  String get bankId => 'mehr_eqtesad';

  @override
  String get bankName => 'Mehr Eqtesad Bank (Legacy)';

  @override
  List<String> get senderIds => const [
    'MehrEqtesad',
    'mehreqtesad',
    'Mehr_Eqtesad',
    'mehr_eqtesad',
    'B.MehrEqtesad',
    'b.mehreqtesad',
  ];

  @override
  List<String> get keywords => const [
    'مهر اقتصاد',
    'بانک مهر اقتصاد',
    'mehreqtesad',
  ];
}
