import '../bank_parser.dart';

class KhavarmianehParser extends BaseBankParser {
  const KhavarmianehParser();

  @override
  String get bankId => 'khavarmianeh';

  @override
  String get bankName => 'Middle East Bank';

  @override
  List<String> get senderIds => const [
    'Khavarmianeh',
    'khavarmianeh',
    'MiddleEastBank',
    'middleeastbank',
    'MEB',
    'meb',
    'B.Khavarmianeh',
    'b.khavarmianeh',
  ];

  @override
  List<String> get keywords => const ['خاورمیانه', 'بانک خاورمیانه', 'meb'];
}
