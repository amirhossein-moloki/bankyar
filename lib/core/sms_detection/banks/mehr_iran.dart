import '../bank_parser.dart';

class MehrIranParser extends BaseBankParser {
  const MehrIranParser();

  @override
  String get bankId => 'mehr_iran';

  @override
  String get bankName => 'Qarz Al-Hasaneh Mehr Iran Bank';

  @override
  List<String> get senderIds => const [
        'MehrIran',
        'mehriran',
        'Mehr_Iran',
        'mehr_iran',
        'B.MehrIran',
        'b.mehriran',
        'QZMehr',
        'qzmehr'
      ];

  @override
  List<String> get keywords => const ['مهر ایران', 'بانک مهر ایران', 'mehriran'];
}
