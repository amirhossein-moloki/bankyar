import '../bank_parser.dart';

class ResalatParser extends BaseBankParser {
  const ResalatParser();

  @override
  String get bankId => 'resalat';

  @override
  String get bankName => 'Qarz Al-Hasaneh Resalat Bank';

  @override
  List<String> get senderIds => const [
        'Resalat',
        'resalat',
        'B.Resalat',
        'b.resalat',
        'ResalatBank',
        'resalatbank'
      ];

  @override
  List<String> get keywords => const ['رسالت', 'بانک رسالت', 'resalat'];
}
