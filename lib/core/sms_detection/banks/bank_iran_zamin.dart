import '../bank_parser.dart';

class IranZaminParser extends BaseBankParser {
  const IranZaminParser();

  @override
  String get bankId => 'iran_zamin';

  @override
  String get bankName => 'Bank Iran Zamin';

  @override
  List<String> get senderIds => const [
    'IranZamin',
    'iranzamin',
    'Iran_Zamin',
    'iran_zamin',
    'B.IranZamin',
    'b.iranzamin',
  ];

  @override
  List<String> get keywords => const [
    'ایران زمین',
    'بانک ایران زمین',
    'iranzamin',
  ];
}
