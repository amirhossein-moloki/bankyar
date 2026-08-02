import '../bank_parser.dart';

class TejaratParser extends BaseBankParser {
  const TejaratParser();

  @override
  String get bankId => 'tejarat';

  @override
  String get bankName => 'Bank Tejarat';

  @override
  List<String> get senderIds => const [
    'Tejarat',
    'B.Tejarat',
    'B-Tejarat',
    'BTI',
    'tejarat',
    'b.tejarat',
    'b-tejarat',
    'bti',
    'TejaratBank',
    'tejaratbank',
  ];

  @override
  List<String> get keywords => const ['تجارت', 'بانک تجارت', 'tejarat'];
}
