import '../bank_parser.dart';

class PasargadParser extends BaseBankParser {
  const PasargadParser();

  @override
  String get bankId => 'pasargad';

  @override
  String get bankName => 'Pasargad Bank';

  @override
  List<String> get senderIds => const [
        'Pasargad',
        'B.Pasargad',
        'B-Pasargad',
        'BPI',
        'pasargad',
        'b.pasargad',
        'b-pasargad',
        'bpi',
        'PasargadBank',
        'pasargadbank'
      ];

  @override
  List<String> get keywords => const ['پاسارگاد', 'بانک پاسارگاد', 'pasargad'];
}
