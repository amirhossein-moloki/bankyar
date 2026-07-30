import '../bank_parser.dart';

class MelliParser extends BaseBankParser {
  const MelliParser();

  @override
  String get bankId => 'melli';

  @override
  String get bankName => 'Bank Melli Iran';

  @override
  List<String> get senderIds => const [
        'Melli',
        'B.Melli',
        'B-Melli',
        'BMI',
        'melli',
        'b.melli',
        'b-melli',
        'bmi',
        '9820004007',
        '20004007',
        'MelliBank',
        'mellibank'
      ];

  @override
  List<String> get keywords => const ['ملی', 'بانک ملی', 'melli'];
}
