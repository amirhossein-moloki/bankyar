import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../core/theme/spacing_tokens.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../secure_auth/presentation/state/permission_notifier.dart';
import '../../domain/entities/payment_request_log.dart';
import '../../domain/entities/system_log_entry.dart';
import '../state/payment_monitor_notifier.dart';

/// Screen for configuring and monitoring automatic payment verification requests.
class PaymentMonitorScreen extends ConsumerStatefulWidget {
  /// Constructor.
  const PaymentMonitorScreen({super.key});

  @override
  ConsumerState<PaymentMonitorScreen> createState() =>
      _PaymentMonitorScreenState();
}

class _PaymentMonitorScreenState extends ConsumerState<PaymentMonitorScreen> {
  final _domainController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isEditingToken = false;

  @override
  void dispose() {
    _domainController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  static const _defaultSpacing = SpacingExtension(
    xxs: SpacingTokens.xxs,
    xs: SpacingTokens.xs,
    s: SpacingTokens.s,
    m: SpacingTokens.m,
    l: SpacingTokens.l,
    xl: SpacingTokens.xl,
    xxl: SpacingTokens.xxl,
    xxxl: SpacingTokens.xxxl,
    giant: SpacingTokens.giant,
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentMonitorNotifierProvider);
    final notifier = ref.read(paymentMonitorNotifierProvider.notifier);
    final theme = Theme.of(context);
    final spacing = theme.extension<SpacingExtension>() ?? _defaultSpacing;

    // Keep domain controller in sync with config domain
    if (!_domainController.text.startsWith(state.config.domain) &&
        state.config.domain.isNotEmpty &&
        _domainController.text.isEmpty) {
      _domainController.text = state.config.domain;
    }

    ref.listen<PaymentMonitorState>(paymentMonitorNotifierProvider, (
      prev,
      next,
    ) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.successMessage!,
              style: const TextStyle(fontFamily: 'Vazirmatn'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        notifier.clearMessages();
      }
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage!,
              style: const TextStyle(fontFamily: 'Vazirmatn'),
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        notifier.clearMessages();
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'پایش پرداخت (Payment Monitor)',
          showBackButton: true,
        ),
        body: RefreshIndicator(
          onRefresh: notifier.loadData,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildApiConnectionCard(
                  context,
                  ref,
                  state,
                  notifier,
                  spacing,
                ),
                SizedBox(height: spacing.m),
                _buildUploadSettingsCard(context, state, notifier, spacing),
                SizedBox(height: spacing.m),
                _buildQueueStatusCard(context, state, notifier, spacing),
                SizedBox(height: spacing.m),
                _buildPaymentHistorySection(context, state, spacing),
                SizedBox(height: spacing.m),
                _buildServiceStatusCard(context, ref, state, spacing),
                SizedBox(height: spacing.m),
                _buildLogsSection(context, state, spacing),
                SizedBox(height: spacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApiConnectionCard(
    BuildContext context,
    WidgetRef ref,
    PaymentMonitorState state,
    PaymentMonitorNotifier notifier,
    SpacingExtension spacing,
  ) {
    final theme = Theme.of(context);

    return BaseCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lan_outlined,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: spacing.s),
                Text(
                  'API Connection',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.m),
            // Domain Input
            Text(
              'Server Domain',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.xs),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _domainController,
                    decoration: const InputDecoration(
                      hintText: 'https://example.com',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.s),
                ElevatedButton(
                  onPressed: () {
                    notifier.saveDomain(_domainController.text);
                  },
                  child: const Text('ذخیره'),
                ),
              ],
            ),
            SizedBox(height: spacing.m),
            // API Token Input
            Text(
              'API Token',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.xs),
            if (!_isEditingToken && state.config.maskedToken.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        state.config.maskedToken,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.s),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isEditingToken = true;
                        _tokenController.text = state.config.apiToken;
                      });
                    },
                    child: const Text('تغییر توکن'),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tokenController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'ورود توکن جدید API',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.s),
                  ElevatedButton(
                    onPressed: () {
                      notifier.saveApiToken(_tokenController.text);
                      setState(() {
                        _isEditingToken = false;
                        _tokenController.clear();
                      });
                    },
                    child: const Text('ذخیره'),
                  ),
                ],
              ),
            SizedBox(height: spacing.m),
            // Test Connection Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.isTestingConnection
                    ? null
                    : () => notifier.testConnection(),
                icon: state.isTestingConnection
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_rounded),
                label: const Text(
                  'Test Connection',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (state.testMessage != null) ...[
              SizedBox(height: spacing.m),
              Container(
                padding: EdgeInsets.all(spacing.s),
                decoration: BoxDecoration(
                  color: state.testMessage!.startsWith('Connection successful')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        state.testMessage!.startsWith('Connection successful')
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
                child: Text(
                  state.testMessage!,
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    color: state.testMessage!.startsWith(
                      'Connection successful',
                    )
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (state.config.lastConnectionTestAt != null) ...[
              SizedBox(height: spacing.s),
              Text(
                'آخرین بررسی: ${DateFormatter.format(state.config.lastConnectionTestAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSettingsCard(
    BuildContext context,
    PaymentMonitorState state,
    PaymentMonitorNotifier notifier,
    SpacingExtension spacing,
  ) {
    final theme = Theme.of(context);

    return BaseCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Payment Upload',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  state.config.isAutoUploadEnabled ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                    color: state.config.isAutoUploadEnabled
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            Switch(
              value: state.config.isAutoUploadEnabled,
              onChanged: (val) => notifier.toggleAutoUpload(val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueStatusCard(
    BuildContext context,
    PaymentMonitorState state,
    PaymentMonitorNotifier notifier,
    SpacingExtension spacing,
  ) {
    final theme = Theme.of(context);

    return BaseCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Queue Status',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQueueMetricTile(
                  context,
                  'Pending Requests',
                  state.pendingCount.toString(),
                  Colors.orange,
                ),
                _buildQueueMetricTile(
                  context,
                  'Failed Requests',
                  state.failedCount.toString(),
                  Colors.red,
                ),
              ],
            ),
            SizedBox(height: spacing.m),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: state.isRetrying
                    ? null
                    : () => notifier.retryFailedRequests(),
                icon: state.isRetrying
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: const Text(
                  'Retry Failed Requests',
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueMetricTile(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Vazirmatn',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistorySection(
    BuildContext context,
    PaymentMonitorState state,
    SpacingExtension spacing,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xs),
          child: Text(
            'Payment Request History',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ),
        SizedBox(height: spacing.s),
        if (state.requests.isEmpty)
          const BaseCard(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'هیچ درخواست تایید پرداختی ثبت نشده است.',
                  style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.grey),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.requests.length,
            separatorBuilder: (ctx, idx) => SizedBox(height: spacing.s),
            itemBuilder: (ctx, idx) {
              final req = state.requests[idx];
              return _buildRequestHistoryCard(context, req, spacing);
            },
          ),
      ],
    );
  }

  Widget _buildRequestHistoryCard(
    BuildContext context,
    PaymentRequestLog req,
    SpacingExtension spacing,
  ) {
    final theme = Theme.of(context);
    final formattedTime =
        '${req.detectedAt.hour.toString().padLeft(2, '0')}:${req.detectedAt.minute.toString().padLeft(2, '0')}';

    Color statusColor;
    switch (req.status) {
      case PaymentRequestStatus.success:
        statusColor = Colors.green;
        break;
      case PaymentRequestStatus.failed:
        statusColor = Colors.red;
        break;
      case PaymentRequestStatus.duplicate:
        statusColor = Colors.purple;
        break;
      case PaymentRequestStatus.sending:
      case PaymentRequestStatus.sent:
        statusColor = Colors.blue;
        break;
      case PaymentRequestStatus.waitingUpload:
      case PaymentRequestStatus.detected:
      case PaymentRequestStatus.parsed:
        statusColor = Colors.orange;
        break;
    }

    return BaseCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showRequestDetailsModal(context, req),
        child: Padding(
          padding: EdgeInsets.all(spacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      req.status.toCode(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bank: ${req.bankName}',
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Amount: ${req.amount.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card: ${req.cardLastFour.isNotEmpty ? req.cardLastFour : '----'}',
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Ref: ${req.referenceNumber}',
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRequestDetailsModal(BuildContext context, PaymentRequestLog req) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Request Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const Divider(height: 24),
              _buildDetailRow('Bank:', req.bankName),
              _buildDetailRow('Amount:', '${req.amount.toInt()} Rials'),
              _buildDetailRow(
                'Card:',
                req.cardLastFour.isNotEmpty ? req.cardLastFour : '----',
              ),
              _buildDetailRow('Reference:', req.referenceNumber),
              _buildDetailRow('Status:', req.status.toCode()),
              _buildDetailRow('Original SMS:', req.smsRaw),
              _buildDetailRow(
                'Detected At:',
                DateFormatter.format(req.detectedAt),
              ),
              _buildDetailRow(
                'Sent At:',
                req.sentAt != null
                    ? DateFormatter.format(req.sentAt!)
                    : 'Not sent yet',
              ),
              _buildDetailRow(
                'API Response:',
                req.apiResponse ?? req.errorMessage ?? 'N/A',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(modalCtx),
                  child: const Text('بستن'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'Vazirmatn',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Vazirmatn',
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildServiceStatusCard(
    BuildContext context,
    WidgetRef ref,
    PaymentMonitorState state,
    SpacingExtension spacing,
  ) {
    final permState = ref.watch(permissionNotifierProvider);
    final isSmsRunning = permState.isSmsReceiveGranted;
    final isApiConnected =
        state.config.lastConnectionTestSuccess ?? (state.config.domain.isNotEmpty);

    return BaseCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Vazirmatn',
              ),
            ),
            SizedBox(height: spacing.m),
            _buildStatusIndicatorRow(
              'SMS Listener',
              isSmsRunning ? '🟢 Running' : '🔴 Stopped',
            ),
            const SizedBox(height: 8),
            _buildStatusIndicatorRow(
              'Background Sync',
              '🟢 Active',
            ),
            const SizedBox(height: 8),
            _buildStatusIndicatorRow(
              'API Connection',
              isApiConnected ? '🟢 Connected' : '🔴 Disconnected',
            ),
            if (state.config.lastConnectionTestAt != null) ...[
              const Divider(height: 20),
              Text(
                'آخرین همگام‌سازی: ${DateFormatter.format(state.config.lastConnectionTestAt!)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
            if (state.config.lastConnectionTestMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                'وضعیت API: ${state.config.lastConnectionTestMessage}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicatorRow(String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          status,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLogsSection(
    BuildContext context,
    PaymentMonitorState state,
    SpacingExtension spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xs),
          child: const Text(
            'System Logs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ),
        SizedBox(height: spacing.s),
        BaseCard(
          child: Padding(
            padding: EdgeInsets.all(spacing.m),
            child: state.systemLogs.isEmpty
                ? const Center(
                    child: Text(
                      'هیچ رویدادی ثبت نشده است.',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.systemLogs.length,
                    separatorBuilder: (ctx, idx) => const Divider(height: 12),
                    itemBuilder: (ctx, idx) {
                      final log = state.systemLogs[idx];
                      return _buildLogTile(log);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogTile(SystemLogEntry log) {
    final timeStr =
        '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              timeStr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.blue,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 8),
            Text(
              log.event,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
        if (log.details != null && log.details!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            log.details!,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ],
      ],
    );
  }
}
