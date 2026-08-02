import '../bank_parser.dart';

class KeshavarziParser extends BaseBankParser {
  const KeshavarziParser();

  @override
  String get bankId => 'keshavarzi';

  @override
  String get bankName => 'Bank Keshavarzi';

  @override
  List<String> get senderIds => const [
    'Keshavarzi',
    'B.Keshavarzi',
    'B-Keshavarzi',
    'keshavarzi',
    'b.keshavarzi',
    'b-keshavarzi',
    'KeshavarziBank',
    'keshavarzibank',
  ];

  @override
  List<String> get keywords => const ['کشاورزی', 'بانک کشاورزی', 'keshavarzi'];
}
