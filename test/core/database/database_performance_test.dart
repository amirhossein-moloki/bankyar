import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/logging/logger.dart';

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockAppLogger mockLogger;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockLogger = MockAppLogger();
  });

  group('Database Performance and Logging Tests', () {
    test('PerformanceTracker logs start and stop events', () {
      final tracker = PerformanceTracker(
        mockLogger,
        LogCategories.database,
        'test_query',
      );
      tracker.start();
      tracker.stop();

      verify(
        () => mockLogger.log(
          LogLevel.debug,
          LogCategories.database,
          'BY_PERF_START',
          any(),
        ),
      ).called(1);
      verify(
        () => mockLogger.log(
          LogLevel.info,
          LogCategories.database,
          'BY_PERF_DURATION',
          any(),
          metadata: any(named: 'metadata'),
        ),
      ).called(1);
    });

    test(
      'tracePerformance extension tracks synchronous execution correctly',
      () {
        final result = mockLogger.tracePerformance<String>(
          category: LogCategories.database,
          operationName: 'sync_compute',
          computation: () => 'done',
        );

        expect(result, 'done');
        verify(
          () => mockLogger.log(
            LogLevel.debug,
            LogCategories.database,
            'BY_PERF_START',
            any(),
          ),
        ).called(1);
        verify(
          () => mockLogger.log(
            LogLevel.info,
            LogCategories.database,
            'BY_PERF_DURATION',
            any(),
            metadata: any(named: 'metadata'),
          ),
        ).called(1);
      },
    );
  });
}
