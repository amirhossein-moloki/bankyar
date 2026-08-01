import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/sms_detection/sms_classification.dart';
import 'package:bankyar/core/sms_detection/parser_registry.dart';
import 'package:bankyar/core/sms_detection/false_positive_protection.dart';
import 'package:bankyar/features/sms_detection/data/parser/sms_pipeline_engine.dart';
import 'package:bankyar/features/sms_detection/domain/entities/bank_message_entity.dart';

void main() {
  group('32 Bank Parsers Positive Unit Tests', () {
    const engine = SmsPipelineEngine();
    final registry = ParserRegistry.instance;

    // Mapping of bankId to a valid senderId and a standard Iranian transaction SMS text.
    final Map<String, Map<String, String>> positiveSamples = {
      'melli': {
        'sender': 'Melli',
        'body': 'بانک ملی\nواریز مبلغ ۱,۲۵۰,۰۰۰ ریال\nبه حساب *۱۲۳۴\nمانده ۵,۰۰۰,۰۰۰',
      },
      'mellat': {
        'sender': 'B.Mellat',
        'body': 'بانک ملت\nبرداشت مبلغ ۴۵۰,۰۰۰ ریال\nاز کارت ۵۶۷۸\nکدپیگیری ۹۸۷۶۵۴۳',
      },
      'tejarat': {
        'sender': 'Tejarat',
        'body': 'بانک تجارت\nواریز مبلغ ۳,۰۰۰,۰۰۰ ریال\nبه حساب ۱۲۳۴۵۶\nکدرهگیری ۷۷۶۵۴۳۲',
      },
      'saman': {
        'sender': 'Saman',
        'body': 'بانک سامان\nواریز ۲,۵۰۰,۰۰۰ ریال به کارت *۸۸۷۶',
      },
      'pasargad': {
        'sender': 'Pasargad',
        'body': 'بانک پاسارگاد\nبرداشت ۵,۰۰۰,۰۰۰ ریال از کارت *۲۳۴۱\nمانده ۱۰,۰۰۰,۰۰۰',
      },
      'sepah': {
        'sender': 'Sepah',
        'body': 'بانک سپه\nواریز ۶,۰۰۰,۰۰۰ ریال به حساب *۳۳۲۱\nرهگیری ۱۲۳۴۵۶۷',
      },
      'maskan': {
        'sender': 'Maskan',
        'body': 'بانک مسکن\nواریز ۴,۵۰۰,۰۰۰ ریال به حساب *۹۹۰۱',
      },
      'keshavarzi': {
        'sender': 'Keshavarzi',
        'body': 'بانک کشاورزی\nبرداشت ۱,۵۰۰,۰۰۰ ریال از کارت *۷۷۶۱',
      },
      'refah': {
        'sender': 'Refah',
        'body': 'بانک رفاه\nواریز مبلغ ۸,۹۰۰,۰۰۰ ریال به کارت *۵۵۴۳',
      },
      'saderat': {
        'sender': 'Saderat',
        'body': 'بانک صادرات\nبرداشت ۳,۲۰۰,۰۰۰ ریال از حساب *۲۲۳۴',
      },
      'shahr': {
        'sender': 'B.Shahr',
        'body': 'بانک شهر\nواریز ۷۰۰,۰۰۰ ریال به کارت *۱۱۱۲',
      },
      'ayandeh': {
        'sender': 'Ayandeh',
        'body': 'بانک آینده\nواریز مبلغ ۲,۰۰۰,۰۰۰ ریال به حساب *۹۹۸۸',
      },
      'eghtesad_novin': {
        'sender': 'ENBank',
        'body': 'بانک اقتصاد نوین\nبرداشت ۴,۰۰۰,۰۰۰ ریال از کارت *۳۳۴۴',
      },
      'parsian': {
        'sender': 'Parsian',
        'body': 'بانک پارسیان\nواریز ۹,۰۰۰,۰۰۰ ریال به کارت *۹۰۱۲',
      },
      'sina': {
        'sender': 'Sina',
        'body': 'بانک سینا\nبرداشت ۵۰۰,۰۰۰ ریال از کارت *۴۴۳۲',
      },
      'day': {
        'sender': 'Day',
        'body': 'بانک دی\nواریز ۱,۸۰۰,۰۰۰ ریال به کارت *۹۸۷۶',
      },
      'iran_zamin': {
        'sender': 'IranZamin',
        'body': 'بانک ایران زمین\nبرداشت ۶۵۰,۰۰۰ ریال از حساب *۲۲۲۲',
      },
      'tosee_taavon': {
        'sender': 'ToseeTaavon',
        'body': 'بانک توسعه تعاون\nواریز ۳,۲۵۰,۰۰۰ ریال به حساب *۴۴۵۵',
      },
      'tosee_saderat': {
        'sender': 'ToseeSaderat',
        'body': 'بانک توسعه صادرات\nبرداشت ۱۲,۰۰۰,۰۰۰ ریال از کارت *۳۳۳۳',
      },
      'sanat_madan': {
        'sender': 'SanatMadan',
        'body': 'بانک صنعت و معدن\nواریز ۱۵,۰۰۰,۰۰۰ ریال به حساب *۱۱۱۱',
      },
      'post_bank': {
        'sender': 'PostBank',
        'body': 'پست بانک\nبرداشت ۸۰۰,۰۰۰ ریال از کارت *۴۳۲۱',
      },
      'mehr_iran': {
        'sender': 'MehrIran',
        'body': 'بانک مهر ایران\nواریز ۲,۴۰۰,۰۰۰ ریال به حساب *۹۹۱۱',
      },
      'resalat': {
        'sender': 'Resalat',
        'body': 'بانک رسالت\nبرداشت مبلغ ۳,۵۰۰,۰۰۰ ریال از حساب *۲۳۴۵',
      },
      'karafarin': {
        'sender': 'Karafarin',
        'body': 'بانک کارآفرین\nواریز ۶,۸۰۰,۰۰۰ ریال به کارت *۱۲۱۲',
      },
      'khavarmianeh': {
        'sender': 'Khavarmianeh',
        'body': 'بانک خاورمیانه\nبرداشت ۱,۹۰۰,۰۰۰ ریال از کارت *۵۴۳۲',
      },
      'gardeshgari': {
        'sender': 'Gardeshgari',
        'body': 'بانک گردشگری\nواریز ۴,۴۰۰,۰۰۰ ریال به کارت *۳۴۳۴',
      },
      'blu_bank': {
        'sender': 'BluBank',
        'body': 'بلو\nواریز ۳۰۰,۰۰۰ ریال به کارت *۴۳۲۱',
      },
      'bankino': {
        'sender': 'Bankino',
        'body': 'بانکینو\nبرداشت ۹۵۰,۰۰۰ ریال از کارت *۵۵۵۵',
      },
      'ansar': {
        'sender': 'Ansar',
        'body': 'بانک انصار\nواریز ۱,۲۰۰,۰۰۰ ریال به کارت *۴۴۴۴',
      },
      'mehr_eqtesad': {
        'sender': 'MehrEqtesad',
        'body': 'بانک مهر اقتصاد\nبرداشت ۴,۵۰۰,۰۰۰ ریال از حساب *۹۹۰۰',
      },
      'kosar': {
        'sender': 'Kosar',
        'body': 'موسسه کوثر\nواریز ۲,۸۰۰,۰۰۰ ریال به کارت *۱۱۲۲',
      },
      'hekmat': {
        'sender': 'Hekmat',
        'body': 'بانک حکمت\nبرداشت ۶۰۰,۰۰۰ ریال از کارت *۷۷۸۸',
      },
    };

    test('verifies all 32 banks are covered by the test map', () {
      expect(positiveSamples.length, equals(32));
    });

    for (final entry in positiveSamples.entries) {
      final bankId = entry.key;
      final senderId = entry.value['sender']!;
      final body = entry.value['body']!;

      test('Positive test for $bankId ($senderId)', () {
        final parser = registry.detectParser(senderId, body);
        expect(parser, isNotNull, reason: 'Failed to detect parser for $bankId');
        expect(parser!.bankId, equals(bankId));

        final classification = parser.classify(body);
        expect(classification, equals(SmsClassification.bank_transaction),
            reason: '$bankId should classify message as bank_transaction');

        final result = engine.process(
          rawText: body,
          senderId: senderId,
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'test-msg-$bankId',
          transactionId: 'test-tx-$bankId',
        );

        expect(result.status, equals(IngestionStatus.success),
            reason: 'Pipeline should successfully ingest $bankId message');
        expect(result.transaction, isNotNull);
        expect(result.transaction!.amount, isPositive);
        expect(result.transaction!.cardIdentifier, isNotNull);
      });
    }
  });

  group('False Positive and Negative Unit Tests', () {
    const engine = SmsPipelineEngine();
    final registry = ParserRegistry.instance;

    test('Explicitly rejects non-bank platform senders (Snapp, Digikala, Hamrah Aval, etc.)', () {
      final nonBankSamples = [
        {'sender': 'Snapp', 'body': 'اسنپ سفر شما با موفقیت پایان یافت. مبلغ: ۴۵۰,۰۰۰ ریال'},
        {'sender': 'SnappPay', 'body': 'اسنپ پی پرداخت قسط خرید اقساطی شما انجام شد.'},
        {'sender': 'Digikala', 'body': 'دیجیکالا: سفارش شما بسته بندی شد و آماده ارسال است.'},
        {'sender': 'MCI', 'body': 'همراه اول: بسته اینترنت آلفا+ شما فعال گردید.'},
        {'sender': 'Irancell', 'body': 'ایرانسل: شارژ مستقیم ۵۰,۰۰۰ ریال انجام شد.'},
        {'sender': 'RighTel', 'body': 'رایتل: تبریک! سیم‌کارت شما فعال شد.'},
        {'sender': 'Tapsi', 'body': 'تپسی: کد تایید شما برای ورود به برنامه: ۵۵۴۳'},
        {'sender': 'Maxim', 'body': 'ماکسیم: درخواست سفر از مبدا شما ثبت شد.'},
      ];

      for (final sample in nonBankSamples) {
        final sender = sample['sender']!;
        final body = sample['body']!;

        expect(FalsePositiveProtection.isFalsePositive(sender, body), isTrue);

        final result = engine.process(
          rawText: body,
          senderId: sender,
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'test-fp',
          transactionId: 'test-fp-tx',
        );

        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);
        expect(result.reason, contains('False positive protection matched'));
      }
    });

    test('Explicitly rejects non-bank keyword categories (bills, government, tax, insurance)', () {
      final negativeSpamSamples = [
        {'sender': '98200088', 'body': 'بیمه ایران: خسارت خودروی شما پرداخت شد.'},
        {'sender': 'TAX-INFO', 'body': 'سازمان امور مالیاتی: اظهارنامه مالیاتی ارزش افزوده ثبت شد.'},
        {'sender': 'ADLIRAN', 'body': 'عدل ایران: ابلاغیه الکترونیکی شماره ۱۲۳۴۵۶ در حساب کاربری شما قرار گرفت.'},
        {'sender': 'SanaSupport', 'body': 'سامانه ثنا: رمز موقت ورود شما به سامانه عدل ایران: ۸۸۷۶۵'},
        {'sender': 'SajamSystem', 'body': 'سجام: کد احراز هویت شما: ۱۱۲۴۳'},
        {'sender': 'GovPortal', 'body': 'دولت الکترونیک: ثبت نام ملی مسکن شما با موفقیت ثبت شد.'},
        {'sender': '981000121', 'body': 'قبض برق دوره جدید صادر شد. شناسه قبض: ۸۸۷۶، شناسه پرداخت: ۹۹۸۸'},
      ];

      for (final sample in negativeSpamSamples) {
        final sender = sample['sender']!;
        final body = sample['body']!;

        final result = engine.process(
          rawText: body,
          senderId: sender,
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'test-neg',
          transactionId: 'test-neg-tx',
        );

        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);
      }
    });

    test('Classifies and rejects non-transaction bank messages (OTP, security, loans, promotional)', () {
      final bankNonTransactionSamples = [
        {
          'sender': 'Melli',
          'body': 'بانک ملی\nرمز یکبار مصرف شما برای خرید اینترنتی: ۸۸۴۳۲۱',
          'expectedClass': SmsClassification.bank_otp,
        },
        {
          'sender': 'B.Mellat',
          'body': 'بانک ملت\nمشتری گرامی، رمز همراه بانک شما با موفقیت تغییر یافت.',
          'expectedClass': SmsClassification.bank_security,
        },
        {
          'sender': 'Tejarat',
          'body': 'بانک تجارت\nجشنواره فیروزه‌ای بانک تجارت شروع شد! برای افتتاح حساب آنلاین کلیک کنید.',
          'expectedClass': SmsClassification.bank_promotional,
        },
        {
          'sender': 'Saman',
          'body': 'بانک سامان\nمشتری گرامی، سررسید قسط تسهیلات شماره ۱۱۲۳ نزدیک است. مبلغ: ۵,۰۰۰,۰۰۰ ریال',
          'expectedClass': SmsClassification.bank_loan,
        },
        {
          'sender': 'Pasargad',
          'body': 'بانک پاسارگاد\nمشتری گرامی پیشخوان الکترونیکی پاسارگاد در خدمت شماست.',
          'expectedClass': SmsClassification.bank_information,
        },
        {
          'sender': 'Saderat',
          'body': 'بانک صادرات\nچک صیادی شماره ۱۱۲۳۴۵۶۷۸ به نام شما ثبت گردید.',
          'expectedClass': SmsClassification.bank_cheque,
        },
        {
          'sender': 'Sina',
          'body': 'بانک سینا\nکارت شما به شماره *۴۳۲۱ صادر و فعال شد.',
          'expectedClass': SmsClassification.bank_card_status,
        },
        {
          'sender': 'Melli',
          'body': 'بانک ملی\nخلاصه حساب شماره ۱۲۳۴۵۶ در تاریخ امروز ارسال شد.',
          'expectedClass': SmsClassification.bank_statement,
        },
      ];

      for (final sample in bankNonTransactionSamples) {
        final sender = sample['sender']! as String;
        final body = sample['body']! as String;
        final expectedClass = sample['expectedClass']! as SmsClassification;

        final parser = registry.detectParser(sender, body);
        expect(parser, isNotNull);

        final classification = parser!.classify(body);
        expect(classification, equals(expectedClass));

        final result = engine.process(
          rawText: body,
          senderId: sender,
          receivedAt: DateTime.now().millisecondsSinceEpoch,
          isDuplicate: false,
          messageId: 'test-non-tx',
          transactionId: 'test-non-tx-id',
        );

        // OTPs, security alerts, loans, etc. must NEVER create transactions
        expect(result.status, equals(IngestionStatus.ignored));
        expect(result.transaction, isNull);
      }
    });

    test('Enforces deterministic scoring and rejects low-score transactions (< 60)', () {
      // Score calculation:
      // Valid sender: +50
      // Transaction keywords: +20
      // Amount: +10
      // Card number: +10
      // Balance: +10
      // Reference: +5

      // Sample 1: Low-score fallback matching with NO verified sender ID (e.g. sender is a numeric shortcode '1000789' not registered as Melli senderId, but body contains Melli keyword and واریز)
      // Score: Valid sender (0) + Keywords (20) + Amount (10) = 30 < 60 -> REJECT
      const rawText1 = 'بانک ملی\nواریز مبلغ ۵۰۰,۰۰۰ ریال';
      final result1 = engine.process(
        rawText: rawText1,
        senderId: '1000789',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'test-low-score-1',
        transactionId: 'test-low-score-1-tx',
      );
      expect(result1.status, equals(IngestionStatus.ignored));
      expect(result1.transaction, isNull);
      expect(result1.reason, contains('Deterministic confidence score is too low'));

      // Sample 2: Valid bank sender but no amount, no keywords, etc. (Score: 50 + 0 = 50 < 60) -> REJECT
      const rawText2 = 'بانک ملی\nسلام روز بخیر.';
      final result2 = engine.process(
        rawText: rawText2,
        senderId: 'Melli',
        receivedAt: DateTime.now().millisecondsSinceEpoch,
        isDuplicate: false,
        messageId: 'test-low-score-2',
        transactionId: 'test-low-score-2-tx',
      );
      expect(result2.status, equals(IngestionStatus.ignored));
      expect(result2.transaction, isNull);
    });
  });
}
