import 'dart:convert';
import 'package:meta/meta.dart';

/// Supported log levels for the logging engine.
enum LogLevel {
  /// Verbose tracing details (automatically stripped from prod)
  trace,

  /// Developer debugging insights
  debug,

  /// General informative system transitions
  info,

  /// Non-fatal issues or performance alerts
  warn,

  /// Recoverable operation failures
  error,

  /// Critical/fatal connection corruptions
  fatal,
}

/// Abstract contract defining the core logging capability.
abstract class AppLogger {
  /// Write log records with explicit levels, taxonomy codes, and metadata.
  void log(
    LogLevel level,
    String category,
    String taxonomyCode,
    String message, {
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Consolidated PII-scrubbing logging engine.
/// Conforms to BankYar LOGGING_ARCHITECTURE.md specifications.
class AppLoggerImpl implements AppLogger {
  /// Constructor constructing complete logger bound to active environments.
  AppLoggerImpl({
    required this.isDiagnosticsEnabled,
    this.consoleOutput = true,
  });

  /// Compile-time switch controlling trace allocations
  final bool isDiagnosticsEnabled;

  /// Whether console printing is enabled (disabled in tests/prod releases)
  final bool consoleOutput;

  // Regular expression detecting general numeric amounts (e.g. 150000, 150,000.00)
  // Length is capped at 10 to avoid matching longer sequence structures like card numbers (typically 12-19 digits).
  static final RegExp _amountRegex = RegExp(r'\b\d{1,10}([.,]\d{2})?\b');

  // Regular expression capturing card references or account numbers
  static final RegExp _cardRegex = RegExp(r'\d(?=\d{4,}\b)');

  /// Processes text through masking regular expressions to redact PII.
  @visibleForTesting
  String sanitize(String input) {
    if (input.isEmpty) return input;

    // 1. Redact general numeric amounts first (excluding long card sequences)
    var result = input.replaceAll(_amountRegex, '[REDACTED_AMOUNT]');

    // 2. Mask card and account numbers (preserve final 4 digits)
    result = result.replaceAllMapped(_cardRegex, (match) => '*');

    return result;
  }

  @override
  void log(
    LogLevel level,
    String category,
    String taxonomyCode,
    String message, {
    Map<String, dynamic>? metadata,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!isDiagnosticsEnabled) return;

    // Enforce sanitization synchronously before constructing log records
    final sanitizedMessage = sanitize(message);
    final sanitizedMetadata = <String, dynamic>{};

    if (metadata != null) {
      for (final entry in metadata.entries) {
        if (entry.value is String) {
          sanitizedMetadata[entry.key] = sanitize(entry.value as String);
        } else {
          sanitizedMetadata[entry.key] = entry.value;
        }
      }
    }

    final logRecord = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'level': level.name.toUpperCase(),
      'category': category.toUpperCase(),
      'taxonomy_code': taxonomyCode,
      'message': sanitizedMessage,
      if (sanitizedMetadata.isNotEmpty) 'metadata': sanitizedMetadata,
      if (error != null)
        'exception': {
          'type': error.runtimeType.toString(),
          'message': sanitize(error.toString()),
          if (stackTrace != null) 'stack_trace': stackTrace.toString(),
        },
    };

    if (consoleOutput) {
      // In physical sandbox builds, output to system console
      // ignore: avoid_print
      print(jsonEncode(logRecord));
    }
  }
}
