import '../bank_parser.dart';

class ShahrParser extends BaseBankParser {
  const ShahrParser();

  @override
  String get bankId => 'shahr';

  @override
  String get bankName => 'Bank Shahr';

  @override
  List<String> get senderIds => const [
        'Shahr',
        'B.Shahr',
        'B-Shahr',
        'shahr',
        'b.shahr',
        'b-shahr',
        'ShahrBank',
        'shahrbank'
      ];

  @override
  List<String> get keywords => const ['شهر', 'بانک شهر', 'shahr'];
}
