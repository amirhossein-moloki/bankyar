import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/presentation/widgets/feedback/custom_bottom_sheet.dart';
import 'package:bankyar/core/presentation/widgets/buttons/primary_button.dart';
import 'package:bankyar/core/presentation/widgets/inputs/amount_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/text_input_field.dart';
import 'package:bankyar/core/presentation/widgets/inputs/dropdown_field.dart';
import 'package:bankyar/core/theme/spacing_tokens.dart';
import 'package:bankyar/core/utils/date_formatter.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/features/sms_detection/domain/entities/parsed_transaction.dart';
import 'package:bankyar/features/sms_detection/data/parser/regex_patterns.dart';
import 'package:bankyar/features/transactions/presentation/state/home_notifier.dart';
import 'package:bankyar/features/transactions/presentation/state/transactions_notifier.dart';
import 'package:bankyar/features/analytics/presentation/state/analytics_notifier.dart';

/// Interactive modal sheet that presents the high-fidelity Manual Transaction Form.
/// Built fully with Material Design 3, RTL Persian layout compliance, and zero fake generation.
class ManualTransactionBottomSheet extends ConsumerStatefulWidget {
  /// Constructor.
  const ManualTransactionBottomSheet({super.key});

  @override
  ConsumerState<ManualTransactionBottomSheet> createState() =>
      _ManualTransactionBottomSheetState();
}

class _ManualTransactionBottomSheetState
    extends ConsumerState<ManualTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Form State Values
  SmsTransactionType _transactionType = SmsTransactionType.debit;
  final _amountController = TextEditingController();
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _tagsController = TextEditingController();
  final _noteController = TextEditingController();
  final _referenceController = TextEditingController();

  DateTime _selectedDateTime = DateTime.now();
  String? _selectedCategoryId;

  // Error String Fields
  String? _amountError;
  String? _bankError;
  String? _merchantError;

  @override
  void dispose() {
    _amountController.dispose();
    _bankController.dispose();
    _accountController.dispose();
    _merchantController.dispose();
    _tagsController.dispose();
    _noteController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _validateAndSubmit() async {
    setState(() {
      _amountError = null;
      _bankError = null;
      _merchantError = null;
    });

    final amountRaw = _amountController.text.trim();
    final bank = _bankController.text.trim();
    final merchant = _merchantController.text.trim();

    bool isValid = true;

    // Normalize amount digits from Persian/Arabic if any
    final normalizedAmountText = RegexPatterns.normalizeNumerals(
      amountRaw,
    ).replaceAll(',', '');
    final amount = double.tryParse(normalizedAmountText);

    if (amountRaw.isEmpty) {
      _amountError = 'مبلغ تراکنش الزامی است';
      isValid = false;
    } else if (amount == null || amount <= 0) {
      _amountError = 'مبلغ تراکنش باید بزرگتر از صفر باشد';
      isValid = false;
    }

    if (bank.isEmpty) {
      _bankError = 'نام بانک الزامی است';
      isValid = false;
    }

    if (merchant.isEmpty) {
      _merchantError = 'نام پذیرنده الزامی است';
      isValid = false;
    }

    if (!isValid) {
      setState(() {});
      return;
    }

    // Process valid manual transaction submission
    final uuidGen = ref.read(uuidGeneratorProvider);
    final repo = ref.read(transactionRepositoryProvider);

    final transactionId = uuidGen.generateV4();
    final timestamp = _selectedDateTime.millisecondsSinceEpoch;

    final tx = ParsedTransaction(
      id: transactionId,
      amount: amount!,
      currency: 'IRR',
      transactionType: _transactionType,
      rawMerchant: merchant,
      normalizedMerchant: merchant,
      cardIdentifier: _accountController.text.trim().isEmpty
          ? bank
          : _accountController.text.trim(),
      timestamp: timestamp,
      categoryId: _selectedCategoryId,
      confidenceScore: 1.0,
      parsingMethod: 'manual',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      referenceNumber: _referenceController.text.trim().isEmpty
          ? null
          : _referenceController.text.trim(),
    );

    // Save transaction to DB
    final saveResult = await repo.saveTransaction(tx);

    if (saveResult is Success<void>) {
      // Save Notes if any
      if (_noteController.text.trim().isNotEmpty) {
        await repo.saveNote(transactionId, _noteController.text.trim());
      }

      // Save Tags if any
      if (_tagsController.text.trim().isNotEmpty) {
        final tagsList = _tagsController.text
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();
        await repo.assignTags(transactionId, tagsList);
      }

      // Show localized success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تراکنش با موفقیت به صورت دستی ثبت شد.',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      // State update - immediately refresh providers
      ref.invalidate(homeViewModelProvider);
      ref.invalidate(transactionsViewModelProvider);
      ref.invalidate(analyticsViewModelProvider);

      if (mounted) {
        Navigator.pop(context);
      }
    } else if (saveResult is FailureResult<void>) {
      final failure = saveResult.failure;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطا در ثبت تراکنش: ${failure.message}',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final categoriesAsync = ref.watch(categoriesListProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    // Limit scroll height to leave safe spacing for header/margins and allow scroll behavior
    final double maxScrollHeight = screenHeight - keyboardHeight - 160;

    return CustomBottomSheet(
      title: 'ثبت دستی تراکنش جدید',
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxScrollHeight > 100 ? maxScrollHeight : 100,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Transaction Type Choice Chips Row
                Text(
                  'نوع تراکنش',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: spacing.xs),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    ChoiceChip(
                      label: const Text('هزینه / برداشت (کاهش)'),
                      selected: _transactionType == SmsTransactionType.debit,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _transactionType = SmsTransactionType.debit;
                          });
                        }
                      },
                    ),
                    SizedBox(width: spacing.s),
                    ChoiceChip(
                      label: const Text('درآمد / واریز (افزایش)'),
                      selected: _transactionType == SmsTransactionType.credit,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _transactionType = SmsTransactionType.credit;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: spacing.m),

                // Amount Input Field
                AmountInputField(
                  label: 'مبلغ تراکنش',
                  controller: _amountController,
                  currencySymbol: 'ریال',
                  errorText: _amountError,
                  onChanged: (val) {
                    if (_amountError != null) {
                      setState(() {
                        _amountError = null;
                      });
                    }
                  },
                ),
                SizedBox(height: spacing.m),

                // Bank Name Field
                TextInputField(
                  label: 'نام بانک',
                  controller: _bankController,
                  errorText: _bankError,
                  onChanged: (val) {
                    if (_bankError != null) {
                      setState(() {
                        _bankError = null;
                      });
                    }
                  },
                ),
                SizedBox(height: spacing.m),

                // Account / Card Suffix Suffix Field
                TextInputField(
                  label: 'شماره کارت یا حساب (اختیاری)',
                  controller: _accountController,
                  hintText: 'مثلا ۱۲۳۴',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: spacing.m),

                // Merchant/Payer Field
                TextInputField(
                  label: 'پذیرنده / پرداخت‌کننده',
                  controller: _merchantController,
                  errorText: _merchantError,
                  onChanged: (val) {
                    if (_merchantError != null) {
                      setState(() {
                        _merchantError = null;
                      });
                    }
                  },
                ),
                SizedBox(height: spacing.m),

                // Category Selector
                categoriesAsync.when(
                  data: (categories) => DropdownField<String>(
                    label: 'دسته‌بندی تراکنش',
                    value: _selectedCategoryId,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('بدون دسته‌بندی'),
                      ),
                      ...categories.map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedCategoryId = val;
                      });
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const SizedBox(),
                ),
                SizedBox(height: spacing.m),

                // Date & Time Picker buttons row
                Text(
                  'تاریخ و زمان تراکنش',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: spacing.xs),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          'تاریخ: ${DateFormatter.formatFriendly(_selectedDateTime, locale: 'fa')}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.s),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _selectTime,
                        icon: const Icon(Icons.access_time_outlined),
                        label: Text(
                          'ساعت: ${TimeOfDay.fromDateTime(_selectedDateTime).format(context)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.m),

                // Reference Code Suffix Field
                TextInputField(
                  label: 'شماره پیگیری / مرجع (اختیاری)',
                  controller: _referenceController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: spacing.m),

                // Tags Field
                TextInputField(
                  label: 'برچسب‌ها (با کاما جدا کنید)',
                  controller: _tagsController,
                  hintText: 'مثال: ناهار, بنزین, سفر',
                ),
                SizedBox(height: spacing.m),

                // Note Field
                TextInputField(
                  label: 'یادداشت (اختیاری)',
                  controller: _noteController,
                  hintText: 'مثلا: خرید کادوی تولد سهراب',
                ),
                SizedBox(height: spacing.xl),

                // Submit Button
                PrimaryButton(
                  label: 'ثبت و ذخیره تراکنش',
                  onPressed: _validateAndSubmit,
                ),
                SizedBox(height: spacing.m),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
