import '../bank_parser.dart';

class AnsarParser extends BaseBankParser {
  const AnsarParser();

  @override
  String get bankId => 'ansar';

  @override
  String get bankName => 'Ansar Bank (Legacy)';

  @override
  List<String> get senderIds => const [
        'Ansar',
        'ansar',
        'AnsarBank',
        'ansarbank',
        'B.Ansar',
        'b.ansar'
      ];

  @override
  List<String> get keywords => const ['انصار', 'بانک انصار', 'ansar'];
}
