import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/features/sms_detection/data/parser/regex_patterns.dart';

void main() {
  test('Debug Saman Diacritics', () {
    const rawText = '''47001231656601
مبلغ:500,000+
مانده:28,913,736
05/09
16:47
بابت :تراکنش پُل به مشخصات با کدِ رهگیریِ 140505091647036480563714988343، شناسه پرداخت ، به نامِ  امیرحسین ملوکی  و شماره شبا IR810560611828005964934101   -  بانک سامان''';

    var normalized = RegexPatterns.normalizeNumerals(rawText).toLowerCase().trim();
    print('Before stripping diacritics:');
    print('Has match: ${RegexPatterns.referencePattern.hasMatch(normalized)}');

    // Strip diacritics
    normalized = normalized.replaceAll(RegExp(r'[\u064B-\u0652\u0656\u065F\u0640]'), '');
    print('After stripping diacritics:');
    print('Normalized:');
    print(normalized);
    final match = RegexPatterns.referencePattern.firstMatch(normalized);
    print('Has match: ${match != null}');
    if (match != null) {
      print('Group 1: ${match.group(1)}');
    }
  });
}
