import '../bank_parser.dart';

class PostBankParser extends BaseBankParser {
  const PostBankParser();

  @override
  String get bankId => 'post_bank';

  @override
  String get bankName => 'Post Bank Iran';

  @override
  List<String> get senderIds => const [
    'PostBank',
    'postbank',
    'Post_Bank',
    'post_bank',
    'B.PostBank',
    'b.postbank',
  ];

  @override
  List<String> get keywords => const ['پست بانک', 'پست‌بانک', 'postbank'];
}
