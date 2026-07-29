import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/feedback/custom_bottom_sheet.dart';
import '../../../../core/presentation/widgets/buttons/primary_button.dart';
import '../../../../core/presentation/widgets/inputs/amount_input_field.dart';
import '../../../../core/presentation/widgets/inputs/text_input_field.dart';
import '../../../../core/presentation/widgets/inputs/dropdown_field.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/result.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';
import '../../../sms_detection/data/parser/regex_patterns.dart';
import '../../domain/entities/transaction_details.dart';
import '../state/home_notifier.dart';
import '../state/transaction_details_notifier.dart';
import '../state/transactions_notifier.dart';
import '../../../analytics/presentation/state/analytics_notifier.dart';

/// Modal sheet to edit/update an existing transaction.
/// Built with Material Design 3, RTL Persian layout compliance.
class EditTransactionBottomSheet extends ConsumerStatefulWidget {
  /// Constructor.
  const EditTransactionBottomSheet({
    required this.details,
    super.key,
  });

  /// The current transaction details.
  final TransactionDetails details;

  @override
  ConsumerState<EditTransactionBottomSheet> createState() =>
      _EditTransactionBottomSheetState();
}

class _EditTransactionBottomSheetState
    extends ConsumerState<EditTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Form State Values
  late SmsTransactionType _transactionType;
  late final TextEditingController _amountController;
  late final TextEditingController _bankController;
  late final TextEditingController _accountController;
  late final TextEditingController _merchantController;
  late final TextEditingController _tagsController;
  late final TextEditingController _noteController;
  late final TextEditingController _referenceController;

  late DateTime _selectedDateTime;
  String? _selectedCategoryId;

  // Error String Fields
  String? _amountError;
  String? _bankError;
  String? _merchantError;

  @override
  void initState() {
    super.initState();
    final tx = widget.details.transaction;

    _transactionType = tx.transactionType;
    _amountController = TextEditingController(text: tx.amount.toStringAsFixed(0));
    _bankController = TextEditingController(text: tx.cardIdentifier ?? '');
    _accountController = TextEditingController(text: tx.cardIdentifier ?? '');
    _merchantController = TextEditingController(text: tx.normalizedMerchant);
    _tagsController = TextEditingController(text: widget.details.tags.join(', '));
    _noteController = TextEditingController(text: widget.details.note ?? '');
    _referenceController = TextEditingController(text: tx.referenceNumber ?? '');

    _selectedDateTime = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
    _selectedCategoryId = tx.categoryId;
  }

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
      _bankError = 'نام بانک یا کارت الزامی است';
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

    final repo = ref.read(transactionRepositoryProvider);
    final tx = widget.details.transaction;
    final timestamp = _selectedDateTime.millisecondsSinceEpoch;

    final updatedTx = tx.copyWith(
      amount: amount!,
      transactionType: _transactionType,
      rawMerchant: merchant,
      normalizedMerchant: merchant,
      cardIdentifier: bank,
      timestamp: timestamp,
      categoryId: _selectedCategoryId,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      referenceNumber: _referenceController.text.trim().isEmpty
          ? null
          : _referenceController.text.trim(),
    );

    // Save transaction to DB (updates via conflict algorithm replace)
    final saveResult = await repo.saveTransaction(updatedTx);

    if (saveResult is Success<void>) {
      // Save/Delete Notes
      final noteText = _noteController.text.trim();
      if (noteText.isNotEmpty) {
        await repo.saveNote(tx.id, noteText);
      } else {
        await repo.deleteNote(tx.id);
      }

      // Save/Delete Tags
      final tagsText = _tagsController.text.trim();
      final tagsList = tagsText
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      await repo.assignTags(tx.id, tagsList);

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تغییرات تراکنش با موفقیت ذخیره شد.',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh all related state
      ref.invalidate(homeViewModelProvider);
      ref.invalidate(transactionsViewModelProvider);
      ref.invalidate(transactionDetailsViewModelProvider(tx.id));
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
              'خطا در ذخیره تغییرات: ${failure.message}',
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
    final double maxScrollHeight = screenHeight - keyboardHeight - 160;

    return CustomBottomSheet(
      title: 'ویرایش جزئیات تراکنش',
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
                Wrap(
                  spacing: spacing.s,
                  runSpacing: spacing.s,
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
                  label: 'نام بانک یا شماره کارت',
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

                // Merchant/Payer Field
                TextInputField(
                  label: 'پذیرنده / مبدأ تراکنش',
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
                  hintText: 'مثلا: خرید ناهار دیروز',
                ),
                SizedBox(height: spacing.xl),

                // Submit Button
                PrimaryButton(
                  label: 'ذخیره تغییرات تراکنش',
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
