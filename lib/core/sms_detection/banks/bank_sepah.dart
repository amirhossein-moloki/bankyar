import '../bank_parser.dart';

class SepahParser extends BaseBankParser {
  const SepahParser();

  @override
  String get bankId => 'sepah';

  @override
  String get bankName => 'Bank Sepah';

  @override
  List<String> get senderIds => const [
        'Sepah',
        'B.Sepah',
        'B-Sepah',
        'sepah',
        'b.sepah',
        'b-sepah',
        'SepahBank',
        'sepahbank'
      ];

  @override
  List<String> get keywords => const ['سپه', 'بانک سپه', 'sepah'];
}
