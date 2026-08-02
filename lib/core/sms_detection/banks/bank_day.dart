import '../bank_parser.dart';

class DayParser extends BaseBankParser {
  const DayParser();

  @override
  String get bankId => 'day';

  @override
  String get bankName => 'Bank Day';

  @override
  List<String> get senderIds => const [
    'Day',
    'B.Day',
    'B-Day',
    'day',
    'b.day',
    'b-day',
    'DayBank',
    'daybank',
  ];

  @override
  List<String> get keywords => const ['دی', 'بانک دی', 'day'];
}
