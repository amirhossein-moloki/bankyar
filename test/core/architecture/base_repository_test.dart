import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bankyar/core/architecture/base_repository.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/errors/exceptions.dart';
import 'package:bankyar/core/errors/failures.dart';

class TestRepository extends BaseRepository {
  const TestRepository();

  Future<Result<String>> testExecuteSafe(Future<String> Function() action) {
    return executeSafe(action);
  }

  Stream<Result<String>> testPipeSafeStream(Stream<String> stream) {
    return pipeSafeStream(stream);
  }
}

void main() {
  const repository = TestRepository();

  group('BaseRepository Tests', () {
    test('executeSafe returns Success when operation succeeds', () async {
      final result = await repository.testExecuteSafe(() async => 'success');
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'success');
    });

    test(
      'executeSafe returns FailureResult when operation throws AppException',
      () async {
        final result = await repository.testExecuteSafe(() async {
          throw const DatabaseException(
            code: 'BY_INF_DB_CORRUPTED',
            message: 'Database corrupted exception',
          );
        });

        expect(result, isA<FailureResult<String>>());
        final failure = (result as FailureResult<String>).failure;
        expect(failure, isA<DatabaseCorruptionFailure>());
      },
    );

    test(
      'pipeSafeStream yields Success events and catches exceptions',
      () async {
        final inputController = StreamController<String>();
        final resultStream = repository.testPipeSafeStream(
          inputController.stream,
        );

        final events = <Result<String>>[];
        final completer = Completer<void>();

        final subscription = resultStream.listen(
          (event) {
            events.add(event);
            if (events.length == 2) {
              completer.complete();
            }
          },
          onError: (_) {},
          onDone: () {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );

        inputController.add('first');
        await Future<void>.delayed(const Duration(milliseconds: 10));

        inputController.addError(
          const SecureStorageException(
            code: 'BY_INF_KEYSTORE_LOST',
            message: 'Keystore lost',
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await inputController.close();
        await completer.future;
        await subscription.cancel();

        expect(events.length, 2);
        expect(events[0], isA<Success<String>>());
        expect((events[0] as Success<String>).data, 'first');

        expect(events[1], isA<FailureResult<String>>());
        final failure = (events[1] as FailureResult<String>).failure;
        expect(failure, isA<KeystoreLostFailure>());
      },
    );
  });
}
