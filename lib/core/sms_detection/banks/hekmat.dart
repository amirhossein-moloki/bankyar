import '../bank_parser.dart';

class HekmatParser extends BaseBankParser {
  const HekmatParser();

  @override
  String get bankId => 'hekmat';

  @override
  String get bankName => 'Hekmat Iranian Bank (Legacy)';

  @override
  List<String> get senderIds => const [
    'Hekmat',
    'hekmat',
    'HekmatBank',
    'hekmatbank',
    'B.Hekmat',
    'b.hekmat',
  ];

  @override
  List<String> get keywords => const ['حکمت', 'بانک حکمت', 'hekmat'];
}
