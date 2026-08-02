import '../bank_parser.dart';

class MellatParser extends BaseBankParser {
  const MellatParser();

  @override
  String get bankId => 'mellat';

  @override
  String get bankName => 'Bank Mellat';

  @override
  List<String> get senderIds => const [
    'Mellat',
    'B.Mellat',
    'B-Mellat',
    'BML',
    'mellat',
    'b.mellat',
    'b-mellat',
    'bml',
    'MellatBank',
    'mellatbank',
    '9820002011',
    '20002011',
  ];

  @override
  List<String> get keywords => const ['ملت', 'بانک ملت', 'mellat'];
}
