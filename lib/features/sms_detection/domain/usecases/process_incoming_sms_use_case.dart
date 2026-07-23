import '../../../../core/architecture/use_case.dart';
import '../../../../core/utils/result_extensions.dart';
import '../entities/parsed_transaction.dart';
import '../repository/sms_parser_repository.dart';

/// Parameters object for [ProcessIncomingSmsUseCase].
class ProcessIncomingSmsParams {
  /// Constructor defining SMS ingestion parameters.
  const ProcessIncomingSmsParams({
    required this.rawText,
    required this.senderId,
    required this.receivedAt,
  });

  /// Raw body text of the SMS.
  final String rawText;

  /// Standard SMS sender code ID.
  final String senderId;

  /// Millennium epoch received timestamp.
  final int receivedAt;
}

/// Use case that orchestrates the entire processing pipeline of incoming financial SMS messages.
class ProcessIncomingSmsUseCase
    extends UseCase<ParsedTransaction?, ProcessIncomingSmsParams> {
  /// Constructor injecting abstract repository.
  ProcessIncomingSmsUseCase(this._repository);

  final SmsParserRepository _repository;

  @override
  AsyncResult<ParsedTransaction?> call(ProcessIncomingSmsParams params) {
    return _repository.processAndSaveSms(
      rawText: params.rawText,
      senderId: params.senderId,
      receivedAt: params.receivedAt,
    );
  }
}
