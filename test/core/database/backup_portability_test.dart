import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bankyar/core/database/backup_portability.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/errors/failures.dart';

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockAppLogger mockLogger;
  late BackupPortabilityImpl backupPortability;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    backupPortability = BackupPortabilityImpl(mockLogger);
  });

  group('BackupPortability Tests', () {
    final Map<String, List<Map<String, dynamic>>> testTablesData = {
      'categories': [
        {'id': 'cat1', 'name': 'Food', 'color_hex': '#FF5733'},
      ],
      'transactions': [
        {'id': 'tx1', 'amount': 15000.0, 'currency': 'IRR'},
      ],
    };

    test(
      'exportBackup and importBackup succeed with correct password',
      () async {
        // Export
        final exportResult = await backupPortability.exportBackup(
          password: 'secure_password_123',
          tablesData: testTablesData,
        );

        expect(exportResult, isA<Success<List<int>>>());
        final backupBytes = (exportResult as Success<List<int>>).data;
        expect(backupBytes, isNotEmpty);

        // Import
        final importResult = await backupPortability.importBackup(
          password: 'secure_password_123',
          backupBytes: backupBytes,
        );

        expect(
          importResult,
          isA<Success<Map<String, List<Map<String, dynamic>>>>>(),
        );
        final importedData =
            (importResult as Success<Map<String, List<Map<String, dynamic>>>>)
                .data;

        expect(importedData.containsKey('categories'), isTrue);
        expect(importedData['categories']?[0]['name'], 'Food');
        expect(importedData['transactions']?[0]['id'], 'tx1');
      },
    );

    test(
      'importBackup fails with incorrect password yielding BiometricMismatchFailure',
      () async {
        // Export
        final exportResult = await backupPortability.exportBackup(
          password: 'correct_password',
          tablesData: testTablesData,
        );
        final backupBytes = (exportResult as Success<List<int>>).data;

        // Import with wrong password
        final importResult = await backupPortability.importBackup(
          password: 'wrong_password',
          backupBytes: backupBytes,
        );

        expect(
          importResult,
          isA<FailureResult<Map<String, List<Map<String, dynamic>>>>>(),
        );
        final failure =
            (importResult
                    as FailureResult<Map<String, List<Map<String, dynamic>>>>)
                .failure;
        expect(failure, isA<BiometricMismatchFailure>());
      },
    );

    test(
      'importBackup fails with malformed header yielding BiometricMismatchFailure',
      () async {
        // Create some junk bytes (must be at least 17 bytes)
        final malformedBytes = List<int>.generate(40, (i) => i);

        final importResult = await backupPortability.importBackup(
          password: 'any_password',
          backupBytes: malformedBytes,
        );

        expect(
          importResult,
          isA<FailureResult<Map<String, List<Map<String, dynamic>>>>>(),
        );
        final failure =
            (importResult
                    as FailureResult<Map<String, List<Map<String, dynamic>>>>)
                .failure;
        expect(failure, isA<BiometricMismatchFailure>());
      },
    );
  });
}
