import '../bank_parser.dart';

class RefahParser extends BaseBankParser {
  const RefahParser();

  @override
  String get bankId => 'refah';

  @override
  String get bankName => 'Bank Refah';

  @override
  List<String> get senderIds => const [
    'Refah',
    'B.Refah',
    'B-Refah',
    'refah',
    'b.refah',
    'b-refah',
    'RefahBank',
    'refahbank',
  ];

  @override
  List<String> get keywords => const ['رفاه', 'بانک رفاه', 'refah'];
}
