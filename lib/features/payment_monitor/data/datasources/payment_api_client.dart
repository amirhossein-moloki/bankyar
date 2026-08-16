import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';

/// Status outcomes from API auto_verify endpoint.
enum PaymentApiResponseType {
  /// Request verified successfully.
  verified,

  /// Payment credited to balance (amount mismatch or secondary balance).
  credited,

  /// Request already processed / duplicate.
  duplicate,

  /// API processing failed or unauthorized.
  failed,
}

/// Result object returned by [PaymentApiClient].
class PaymentApiResponse {
  /// Constructor.
  const PaymentApiResponse({
    required this.type,
    required this.rawResponseBody,
    this.statusCode = 200,
    this.errorMessage,
  });

  /// The interpreted outcome type.
  final PaymentApiResponseType type;

  /// Raw response string received from server.
  final String rawResponseBody;

  /// HTTP status code.
  final int statusCode;

  /// Optional error message.
  final String? errorMessage;

  /// Whether response indicates success.
  bool get isSuccess =>
      type == PaymentApiResponseType.verified ||
      type == PaymentApiResponseType.credited;

  /// Whether response indicates duplicate.
  bool get isDuplicate => type == PaymentApiResponseType.duplicate;
}

/// Client managing HTTP communication with the Payment Verification API.
class PaymentApiClient {
  /// Constructor allowing custom [HttpClient] injection for testing.
  PaymentApiClient({
    required AppLogger logger,
    HttpClient? httpClient,
  })  : _logger = logger,
        _client = httpClient;

  final AppLogger _logger;
  final HttpClient? _client;

  /// Format domain into complete API endpoint URL.
  String buildEndpointUrl(String domain) {
    var cleanDomain = domain.trim();
    if (!cleanDomain.startsWith('http://') &&
        !cleanDomain.startsWith('https://')) {
      cleanDomain = 'https://$cleanDomain';
    }
    if (cleanDomain.endsWith('/')) {
      cleanDomain = cleanDomain.substring(0, cleanDomain.length - 1);
    }
    return '$cleanDomain/api/auto_verify.php';
  }

  /// Sends payment verification payload to configured API.
  Future<Result<PaymentApiResponse>> sendPaymentVerification({
    required String domain,
    required String apiToken,
    required Map<String, dynamic> payload,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (domain.trim().isEmpty) {
      return Result.failure(
        const FileAccessFailure(
          code: 'BY_API_DOMAIN_EMPTY',
          message: 'Server domain is not configured.',
        ),
      );
    }

    if (apiToken.trim().isEmpty) {
      return Result.failure(
        const FileAccessFailure(
          code: 'BY_API_TOKEN_EMPTY',
          message: 'API token is not configured.',
        ),
      );
    }

    final endpointUrl = buildEndpointUrl(domain);
    final client = _client ?? HttpClient();

    try {
      _logger.log(
        LogLevel.info,
        LogCategories.platform,
        'BY_API_REQ_START',
        'Sending payment verification request to $endpointUrl',
      );

      final uri = Uri.parse(endpointUrl);
      final request = await client.postUrl(uri).timeout(timeout);

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final bodyBytes = utf8.encode(jsonEncode(payload));
      request.contentLength = bodyBytes.length;
      request.add(bodyBytes);

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      _logger.log(
        LogLevel.info,
        LogCategories.platform,
        'BY_API_RESP_RECV',
        'Received API response with code ${response.statusCode}',
        metadata: {'statusCode': response.statusCode.toString()},
      );

      if (response.statusCode != 200) {
        return Result.success(
          PaymentApiResponse(
            type: PaymentApiResponseType.failed,
            rawResponseBody: responseBody,
            statusCode: response.statusCode,
            errorMessage: 'HTTP ${response.statusCode}: $responseBody',
          ),
        );
      }

      final parsedResponse = _parseResponseBody(responseBody, response.statusCode);
      return Result.success(parsedResponse);
    } on SocketException catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_API_NET_ERR',
        'Network error connecting to API',
        error: e,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_API_NET_ERR',
          message: 'Connection failed: Host unreachable (${e.message})',
        ),
      );
    } on TimeoutException catch (e) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_API_TIMEOUT',
        'Request timed out connecting to API',
        error: e,
      );
      return Result.failure(
        const FileAccessFailure(
          code: 'BY_API_TIMEOUT',
          message: 'Connection timed out. Please check server availability.',
        ),
      );
    } catch (e, stack) {
      _logger.log(
        LogLevel.error,
        LogCategories.platform,
        'BY_API_REQ_ERR',
        'Unexpected error sending payment API request',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(
        FileAccessFailure(
          code: 'BY_API_REQ_ERR',
          message: 'Connection error: ${e.toString()}',
        ),
      );
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  /// Tests connectivity and token validity against configured API endpoint.
  Future<Result<String>> testConnection({
    required String domain,
    required String apiToken,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (domain.trim().isEmpty) {
      return Result.failure(
        const FileAccessFailure(
          code: 'BY_API_TEST_DOMAIN_EMPTY',
          message: 'Server domain cannot be empty.',
        ),
      );
    }

    if (apiToken.trim().isEmpty) {
      return Result.failure(
        const FileAccessFailure(
          code: 'BY_API_TEST_TOKEN_EMPTY',
          message: 'API token cannot be empty.',
        ),
      );
    }

    final testPayload = {
      'api_token': apiToken,
      'test_mode': true,
      'ping': 'bankyar_test',
      'timestamp': (DateTime.now().millisecondsSinceEpoch / 1000).round(),
    };

    final endpointUrl = buildEndpointUrl(domain);
    final client = _client ?? HttpClient();

    try {
      final uri = Uri.parse(endpointUrl);
      final request = await client.postUrl(uri).timeout(timeout);

      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      final bodyBytes = utf8.encode(jsonEncode(testPayload));
      request.contentLength = bodyBytes.length;
      request.add(bodyBytes);

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final lowerBody = responseBody.toLowerCase();
        if (lowerBody.contains('unauthorized') ||
            lowerBody.contains('invalid token') ||
            lowerBody.contains('token_error')) {
          return Result.failure(
            FileAccessFailure(
              code: 'BY_API_INVALID_TOKEN',
              message: 'Invalid API Token: $responseBody',
            ),
          );
        }
        return Result.success('Connection successful');
      } else {
        return Result.failure(
          FileAccessFailure(
            code: 'BY_API_TEST_HTTP_ERR',
            message: 'Server returned HTTP ${response.statusCode}: $responseBody',
          ),
        );
      }
    } on SocketException catch (e) {
      return Result.failure(
        FileAccessFailure(
          code: 'BY_API_TEST_SOCKET_ERR',
          message: 'Domain unavailable or network disconnected (${e.message})',
        ),
      );
    } on TimeoutException {
      return Result.failure(
        const FileAccessFailure(
          code: 'BY_API_TEST_TIMEOUT',
          message: 'Connection timed out. Domain availability check failed.',
        ),
      );
    } catch (e) {
      return Result.failure(
        FileAccessFailure(
          code: 'BY_API_TEST_ERR',
          message: 'Connection failed: ${e.toString()}',
        ),
      );
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  PaymentApiResponse _parseResponseBody(String body, int statusCode) {
    final lower = body.toLowerCase();
    if (body.contains('Payment verified') ||
        lower.contains('payment verified') ||
        lower.contains('verified')) {
      return PaymentApiResponse(
        type: PaymentApiResponseType.verified,
        rawResponseBody: body,
        statusCode: statusCode,
      );
    } else if (body.contains('Payment credited to balance') ||
        lower.contains('credited') ||
        lower.contains('balance')) {
      return PaymentApiResponse(
        type: PaymentApiResponseType.credited,
        rawResponseBody: body,
        statusCode: statusCode,
      );
    } else if (body.contains('Already processed') ||
        lower.contains('already processed') ||
        lower.contains('duplicate')) {
      return PaymentApiResponse(
        type: PaymentApiResponseType.duplicate,
        rawResponseBody: body,
        statusCode: statusCode,
      );
    } else {
      return PaymentApiResponse(
        type: PaymentApiResponseType.failed,
        rawResponseBody: body,
        statusCode: statusCode,
        errorMessage: body.isNotEmpty ? body : 'API verification failed',
      );
    }
  }
}
