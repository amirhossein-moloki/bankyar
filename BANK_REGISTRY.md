# BankYar Offline SMS Detection Engine & Bank Registry Specification

BankYar features an enterprise-grade, 100% offline, deterministic SMS Detection Engine to identify, classify, and extract transactional financial events from Iranian banking SMS notifications while completely eliminating false positives from non-banking platform sources.

---

## 1. Supported Banks & Financial Institutions

The engine natively registers and supports **32 banks and financial institutions** (including legacy merged banks):

| No. | Bank / Institution Code | Localized Farsi Name | Standard Sender Names / Numbers |
|---|---|---|---|
| 1 | `melli` | بانک ملی ایران | Melli, B.Melli, BMI, 9820004007, 20004007 |
| 2 | `mellat` | بانک ملت | Mellat, B.Mellat, BML, MellatBank, 9820002011, 20002011 |
| 3 | `tejarat` | بانک تجارت | Tejarat, B.Tejarat, BTI, TejaratBank |
| 4 | `saman` | بانک سامان | Saman, B.Saman, BSB, SamanBank |
| 5 | `pasargad` | بانک پاسارگاد | Pasargad, B.Pasargad, BPI, PasargadBank |
| 6 | `sepah` | بانک سپه | Sepah, B.Sepah, SepahBank |
| 7 | `maskan` | بانک مسکن | Maskan, B.Maskan, MaskanBank |
| 8 | `keshavarzi` | بانک کشاورزی | Keshavarzi, B.Keshavarzi, KeshavarziBank |
| 9 | `refah` | بانک رفاه | Refah, B.Refah, RefahBank |
| 10 | `saderat` | بانک صادرات ایران | Saderat, B.Saderat, BSI, SaderatBank |
| 11 | `shahr` | بانک شهر | Shahr, B.Shahr, ShahrBank |
| 12 | `ayandeh` | بانک آینده | Ayandeh, B.Ayandeh, AyandehBank |
| 13 | `eghtesad_novin` | بانک اقتصاد نوین | ENBank, EghtesadNovin, Eghtesad_Novin, B.EghtesadNovin |
| 14 | `parsian` | بانک پارسیان | Parsian, B.Parsian, BPA, ParsianBank |
| 15 | `sina` | بانک سینا | Sina, B.Sina, SinaBank |
| 16 | `day` | بانک دی | Day, B.Day, DayBank |
| 17 | `iran_zamin` | بانک ایران زمین | IranZamin, Iran_Zamin, B.IranZamin |
| 18 | `tosee_taavon` | بانک توسعه تعاون | ToseeTaavon, Tosee_Taavon, B.ToseeTaavon |
| 19 | `tosee_saderat` | بانک توسعه صادرات | ToseeSaderat, Tosee_Saderat, B.ToseeSaderat, EDBI |
| 20 | `sanat_madan` | بانک صنعت و معدن | SanatMadan, Sanat_Madan, BIM, B.SanatMadan |
| 21 | `post_bank` | پست بانک ایران | PostBank, Post_Bank, B.PostBank |
| 22 | `mehr_iran` | بانک قرض‌الحسنه مهر ایران | MehrIran, Mehr_Iran, B.MehrIran, QZMehr |
| 23 | `resalat` | بانک قرض‌الحسنه رسالت | Resalat, B.Resalat, ResalatBank |
| 24 | `karafarin` | بانک کارآفرین | Karafarin, B.Karafarin, KarafarinBank |
| 25 | `khavarmianeh` | بانک خاورمیانه | Khavarmianeh, MiddleEastBank, MEB, B.Khavarmianeh |
| 26 | `gardeshgari` | بانک گردشگری | Gardeshgari, TourismBank, B.Gardeshgari |
| 27 | `blu_bank` | بلوبانک | BluBank, blubank, Blu, blu, Vandar |
| 28 | `bankino` | بانکینو | Bankino, bankino, Kino, kino |
| 29 | `ansar` | بانک انصار (قدیمی) | Ansar, ansar, AnsarBank, B.Ansar |
| 30 | `mehr_eqtesad` | بانک مهر اقتصاد (قدیمی) | MehrEqtesad, Mehr_Eqtesad, B.MehrEqtesad |
| 31 | `kosar` | موسسه اعتباری کوثر (قدیمی) | Kosar, KosarBank, B.Kosar |
| 32 | `hekmat` | بانک حکمت ایرانیان (قدیمی) | Hekmat, HekmatBank, B.Hekmat |

---

## 2. Message Classification System

Instead of a binary "parsed successfully" status, BankYar classifies SMS notifications into **11 precise types** defined by `SmsClassification` enum:

| Classification Enum Value | Localized Scope | Ledger Integration |
|---|---|---|
| `bank_transaction` | Deposits, withdrawals, purchases, standard card/account fund transfers. | **Allowed to enter the ledger.** |
| `bank_otp` | One-Time Passwords, dynamic transaction PINs (`رمز پویا`), verification or activation codes. | **NEVER enters the ledger.** |
| `bank_security` | Login notifications, internet/mobile banking credential updates, card locks. | **NEVER enters the ledger.** |
| `bank_information` | Branch hour changes, system maintenance updates, birth greeting cards, generic announcements. | **NEVER enters the ledger.** |
| `bank_promotional` | Bank lottery results, loan marketing offers, new digital branch launches. | **NEVER enters the ledger.** |
| `bank_statement` | Chronological summaries, monthly ledger round-ups, periodic card logs. | **NEVER enters the ledger.** |
| `bank_card_status` | Newly issued cards, replacements, activations, pin updates. | **NEVER enters the ledger.** |
| `bank_cheque` | Cheque registrations, clearances, or bounce notices (`چک صیاد`). | **NEVER enters the ledger.** |
| `bank_loan` | Monthly loan installments, repayment schedules, delays, or alerts. | **NEVER enters the ledger.** |
| `bank_unknown` | Unrecognized bank layouts or general non-financial alerts from a registered bank sender. | **NEVER enters the ledger.** |
| `non_bank` | Clearly non-banking text (e.g. Snapp, Hamrah Aval, Digikala, governmental portals, tax/insurance spam). | **NEVER enters the ledger.** |

---

## 3. False Positive Protection (snapp, bills, telecos, tax)

To eliminate false ledger insertions from services containing amounts (like Snapp or telco receipts), BankYar employs two levels of defensive filtering:

1. **Sender ID Blocking:**
   - Any message from `Snapp`, `SnappPay`, `Digikala`, `MCI`, `Hamrah Aval`, `Irancell`, `RighTel`, `Tapsi`, `Maxim`, `Sana`, `Sajam`, etc. is classified early as `non_bank` and rejected.
2. **Body Text Keyword Filtering:**
   - If a message sender is NOT verified as an official bank sender ID, and its text contains common transaction-lookalike spam terms (such as `اسنپ`, `ایرانسل`, `قبض تلفن`, `مالیات`, `بیمه`, etc.), it is marked as `non_bank` and ignored immediately.

---

## 4. Deterministic Scoring Model

To avoid heuristic mistakes, confidence scoring uses a strict, deterministic point-based metric:

| Criteria Element | Points Weight | Description |
|---|---|---|
| **Valid Sender** | `+50` | Sender ID is officially registered in the detected bank's sender ID list. |
| **Transaction Keywords** | `+20` | Contains credit/debit transaction verbs (e.g. `واریز`, `برداشت`). |
| **Amount Extracted** | `+10` | Successfully parsed a non-zero financial transaction figure. |
| **Card / Account** | `+10` | Successfully identified a card or account suffix. |
| **Post-Balance** | `+10` | Successfully identified post-transaction balance. |
| **Reference / Tracking Code** | `+5` | Successfully isolated a tracking code or tracking reference. |

### Rejection Rule:
If the calculated score is **`< 60`**, the transaction is **rejected** and never enters the ledger.

---

## 5. Architectural Design & Parser Registry

The Offline SMS Detection Engine strictly obeys **SOLID principles** and **Feature-First Clean Architecture**:

- `SmsPipelineEngine`: Orchestrates permission, deduplication, normalizations, registry lookups, classification, scoring, and validations.
- `ParserRegistry`: Central registry managing bank parsers, looking them up securely based on normalized sender IDs.
- `BankParser`: The abstract interface describing what each bank configuration must provide.
- `BaseBankParser`: Implements common, high-performance regex-based parsers for amount, card, balance, reference, and transaction types.
- Individual Bank Files (under `lib/core/sms_detection/banks/`): Standalone classes declaring identifying metadata for specific banks.

```
       [SmsReceiverService / SmsHistoryImporter]
                         │
                         ▼
             [ProcessIncomingSmsUseCase]
                         │
                         ▼
              [SmsParserRepository]
                         │
                         ▼
               [SmsPipelineEngine] ──► [FalsePositiveProtection]
                         │
                         ▼
                [ParserRegistry] ──► [MelliParser], [MellatParser], ...
                         │
                         ▼
                [BaseBankParser] (Scoring & Classification)
                         │
                         ▼
                  Parsed Ledger Tx
```

---

## 6. How to Add a New Bank in One Simple Step

Adding a new bank or custom financial provider requires **no modifications to the core engine**:

### Step 1: Create a single parser file
Create `lib/core/sms_detection/banks/bank_custom.dart` extending `BaseBankParser`:

```dart
import '../bank_parser.dart';

class CustomBankParser extends BaseBankParser {
  const CustomBankParser();

  @override
  String get bankId => 'custom_bank';

  @override
  String get bankName => 'Custom Bank Name';

  @override
  List<String> get senderIds => const [
        'CustomBank',
        'B.Custom',
        '9810009988'
      ];

  @override
  List<String> get keywords => const ['کوستوم', 'بانک کوستوم', 'custombank'];
}
```

### Step 2: Register it in the ParserRegistry
Open `lib/core/sms_detection/parser_registry.dart` and add `CustomBankParser()` to the list inside the `_registerAll()` method:

```dart
    _parsers.addAll(const [
      ...
      CustomBankParser(),
    ]);
```

That's it! The parser is now registered. All standard matching, classifications, deterministic scoring, and false positive protections are automatically available out-of-the-box.
