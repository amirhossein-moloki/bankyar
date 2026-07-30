import '../bank_parser.dart';

class MaskanParser extends BaseBankParser {
  const MaskanParser();

  @override
  String get bankId => 'maskan';

  @override
  String get bankName => 'Bank Maskan';

  @override
  List<String> get senderIds => const [
        'Maskan',
        'B.Maskan',
        'B-Maskan',
        'maskan',
        'b.maskan',
        'b-maskan',
        'MaskanBank',
        'maskanbank'
      ];

  @override
  List<String> get keywords => const ['مسکن', 'بانک مسکن', 'maskan'];
}
