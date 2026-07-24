import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/cards/transaction_card.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../sms_detection/domain/entities/parsed_transaction.dart';

/// Scrollable and grouped transactions list with infinite scroll pagination.
class TransactionsListView extends StatefulWidget {
  /// Constructor.
  const TransactionsListView({
    required this.transactions,
    required this.groupBy,
    required this.isLoadingMore,
    required this.onLoadMore,
    super.key,
  });

  /// Flat list of transaction entities.
  final List<ParsedTransaction> transactions;

  /// Current active grouping option.
  final String groupBy;

  /// Loading more state.
  final bool isLoadingMore;

  /// Callback to fetch next page.
  final VoidCallback onLoadMore;

  @override
  State<TransactionsListView> createState() => _TransactionsListViewState();
}

class _TransactionsListViewState extends State<TransactionsListView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    final grouped = _groupTransactions(widget.transactions, widget.groupBy);
    final groupKeys = grouped.keys.toList();

    // Flatten group elements into a list of items/headers
    final List<_ListItem> flatList = [];
    for (final key in groupKeys) {
      flatList.add(_ListItem.header(key));
      for (final tx in grouped[key]!) {
        flatList.add(_ListItem.transaction(tx));
      }
    }

    if (widget.isLoadingMore) {
      flatList.add(_ListItem.loadingIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: spacing.m, vertical: spacing.s),
      itemCount: flatList.length,
      itemBuilder: (context, index) {
        final item = flatList[index];
        if (item.isHeader) {
          return _buildHeader(context, item.headerText!);
        } else if (item.isLoadingIndicator) {
          return _buildLoadingIndicator(context);
        } else {
          return _buildTransactionCard(context, item.transaction!);
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context, String text) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;

    return Padding(
      padding: EdgeInsets.only(top: spacing.m, bottom: spacing.s),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: spacing.xs),
          Text(
            text,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, ParsedTransaction tx) {
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>()!;
    final isCredit = tx.transactionType == SmsTransactionType.credit;
    final amountText = CurrencyFormatter.formatToman(tx.amount);

    final dt = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
    final formattedTime = DateFormatter.toPersianDigits(
      DateFormatter.format(dt, pattern: 'HH:mm'),
    );

    final cardLabel = tx.cardIdentifier != null
        ? 'کارت *${DateFormatter.toPersianDigits(tx.cardIdentifier!)}'
        : 'بانک‌یار';

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.xs),
      child: TransactionCard(
        amount: amountText,
        timestamp: formattedTime,
        category: tx.normalizedMerchant,
        accountLabel: cardLabel,
        isCredit: isCredit,
        onTap: () => context.push('/transactions/${tx.id}'),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Map<String, List<ParsedTransaction>> _groupTransactions(
    List<ParsedTransaction> txs,
    String groupBy,
  ) {
    final groups = <String, List<ParsedTransaction>>{};
    for (final tx in txs) {
      final date = DateTime.fromMillisecondsSinceEpoch(tx.timestamp);
      String key;
      if (groupBy == 'Day') {
        key = DateFormatter.formatFriendly(date);
      } else if (groupBy == 'Week') {
        final dayOffset = date.weekday % 7;
        final weekStart = date.subtract(Duration(days: dayOffset));
        key = 'هفته منتهی به ${DateFormatter.formatFriendly(weekStart)}';
      } else if (groupBy == 'Month') {
        key = DateFormatter.format(date, pattern: 'yyyy MMMM');
      } else {
        key = 'همه تراکنش‌ها';
      }
      groups.putIfAbsent(key, () => []).add(tx);
    }
    return groups;
  }
}

class _ListItem {
  _ListItem({
    required this.isHeader,
    required this.isLoadingIndicator,
    this.headerText,
    this.transaction,
  });

  factory _ListItem.header(String text) {
    return _ListItem(
      isHeader: true,
      isLoadingIndicator: false,
      headerText: text,
    );
  }

  factory _ListItem.transaction(ParsedTransaction tx) {
    return _ListItem(
      isHeader: false,
      isLoadingIndicator: false,
      transaction: tx,
    );
  }

  factory _ListItem.loadingIndicator() {
    return _ListItem(isHeader: false, isLoadingIndicator: true);
  }

  final bool isHeader;
  final bool isLoadingIndicator;
  final String? headerText;
  final ParsedTransaction? transaction;
}
