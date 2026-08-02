import '../bank_parser.dart';
import '../sms_classification.dart';
import '../bank_sms_template.dart';
import '../../../features/sms_detection/domain/entities/parsed_transaction.dart';

class ParsianParser extends BaseBankParser {
  const ParsianParser();

  @override
  String get bankId => 'parsian';

  @override
  String get bankName => 'Parsian Bank';

  @override
  List<String> get senderIds => const [
    'Parsian',
    'B.Parsian',
    'B-Parsian',
    'BPA',
    'parsian',
    'b.parsian',
    'b-parsian',
    'bpa',
    'ParsianBank',
    'parsianbank',
  ];

  @override
  List<String> get keywords => const ['پارسیان', 'بانک پارسیان', 'parsian'];

  @override
  List<BankSmsTemplate> get templates => [
    BankSmsTemplate(
      id: 'parsian_debit',
      pattern: RegExp(r'برداشت|کاهش', unicode: true),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.debit,
    ),
    BankSmsTemplate(
      id: 'parsian_credit',
      pattern: RegExp(r'واریز|افزایش', unicode: true),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.credit,
    ),
    BankSmsTemplate(
      id: 'parsian_pos',
      pattern: RegExp(r'خرید\s+از\s+پذیرنده|پایانه\s+فروش', unicode: true),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.debit,
    ),
    BankSmsTemplate(
      id: 'parsian_atm',
      pattern: RegExp(
        r'خودپرداز|ATM|برداشت\s+وجه',
        caseSensitive: false,
        unicode: true,
      ),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.debit,
    ),
    BankSmsTemplate(
      id: 'parsian_card_to_card',
      pattern: RegExp(r'کارت\s+به\s+کارت|انتقال\s+کارت', unicode: true),
      classification: SmsClassification.bank_transaction,
      direction: SmsTransactionType.debit,
    ),
    BankSmsTemplate(
      id: 'parsian_paya',
      pattern: RegExp(r'پایا', unicode: true),
      classification: SmsClassification.bank_paya,
      direction: SmsTransactionType.unknown,
    ),
    BankSmsTemplate(
      id: 'parsian_satna',
      pattern: RegExp(r'ساتنا', unicode: true),
      classification: SmsClassification.bank_satna,
      direction: SmsTransactionType.unknown,
    ),
    BankSmsTemplate(
      id: 'parsian_pol',
      pattern: RegExp(r'\bپل\b', unicode: true),
      classification: SmsClassification.bank_pol,
      direction: SmsTransactionType.unknown,
    ),
    BankSmsTemplate(
      id: 'parsian_salary',
      pattern: RegExp(r'حقوق', unicode: true),
      classification: SmsClassification.bank_salary,
      direction: SmsTransactionType.credit,
    ),
    BankSmsTemplate(
      id: 'parsian_interest',
      pattern: RegExp(r'سود', unicode: true),
      classification: SmsClassification.bank_interest,
      direction: SmsTransactionType.credit,
    ),
    BankSmsTemplate(
      id: 'parsian_refund',
      pattern: RegExp(r'برگشت\s+وجه|برگشت|اصلاح', unicode: true),
      classification: SmsClassification.bank_refund,
      direction: SmsTransactionType.credit,
    ),
  ];
}
