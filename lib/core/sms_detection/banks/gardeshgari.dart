import '../bank_parser.dart';

class GardeshgariParser extends BaseBankParser {
  const GardeshgariParser();

  @override
  String get bankId => 'gardeshgari';

  @override
  String get bankName => 'Tourism Bank';

  @override
  List<String> get senderIds => const [
    'Gardeshgari',
    'gardeshgari',
    'TourismBank',
    'tourismbank',
    'B.Gardeshgari',
    'b.gardeshgari',
  ];

  @override
  List<String> get keywords => const ['گردشگری', 'بانک گردشگری', 'tourismbank'];
}
