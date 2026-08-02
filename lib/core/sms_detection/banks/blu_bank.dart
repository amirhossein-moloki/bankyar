import '../bank_parser.dart';

class BluBankParser extends BaseBankParser {
  const BluBankParser();

  @override
  String get bankId => 'blu_bank';

  @override
  String get bankName => 'BluBank';

  @override
  List<String> get senderIds => const [
    'BluBank',
    'blubank',
    'Blu',
    'blu',
    'Vandar',
    'vandar',
  ];

  @override
  List<String> get keywords => const ['بلو', 'بلوبانک', 'blubank'];
}
