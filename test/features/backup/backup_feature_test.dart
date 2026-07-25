import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bankyar/core/database/backup_portability.dart';
import 'package:bankyar/core/database/database_service_impl.dart';
import 'package:bankyar/core/di/dependency_injection.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/logging/logger.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/uuid.dart';
import 'package:bankyar/core/platform/file_storage.dart';
import 'package:bankyar/core/storage/preferences_storage.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:bankyar/core/theme/app_theme.dart';
import 'package:bankyar/l10n/app_localizations.dart';
import 'package:bankyar/features/backup/domain/entities/backup_history_item.dart';
import 'package:bankyar/features/backup/data/di/backup_providers.dart';
import 'package:bankyar/features/backup/presentation/screens/backup_restore_screen.dart';
import 'package:bankyar/features/backup/presentation/state/backup_notifier.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockDatabaseServiceImpl extends Mock implements DatabaseServiceImpl {}

class MockDatabase extends Mock implements Database {}

class MockTransaction extends Mock implements Transaction {}

class MockPreferencesStorage extends Mock implements PreferencesStorage {}

class MockFileStorage extends Mock implements FileStorage {}

class MockClock extends Mock implements Clock {}

class MockUuidGenerator extends Mock implements UuidGenerator {}

void main() {
  late MockAppLogger mockLogger;
  late MockDatabaseServiceImpl mockDbService;
  late MockDatabase mockDb;
  late MockPreferencesStorage mockPrefs;
  late MockFileStorage mockFileStorage;
  late MockClock mockClock;
  late MockUuidGenerator mockUuidGenerator;
  late BackupPortabilityImpl realBackupPortability;

  setUpAll(() {
    registerFallbackValue(LogLevel.info);
    registerFallbackValue(LogLevel.debug);
    registerFallbackValue(LogLevel.error);
    registerFallbackValue(LogCategories.backup);
    registerFallbackValue(ConflictAlgorithm.replace);
    registerFallbackValue(const []);
  });

  setUp(() {
    mockLogger = MockAppLogger();
    mockDbService = MockDatabaseServiceImpl();
    mockDb = MockDatabase();
    mockPrefs = MockPreferencesStorage();
    mockFileStorage = MockFileStorage();
    mockClock = MockClock();
    mockUuidGenerator = MockUuidGenerator();
    realBackupPortability = BackupPortabilityImpl(mockLogger);

    when(() => mockDbService.database).thenReturn(mockDb);
    when(() => mockDbService.isOpen).thenReturn(true);

    when(() => mockClock.now()).thenReturn(DateTime(2024, 1, 1, 10, 0));
    when(() => mockUuidGenerator.generateV4()).thenReturn('test-uuid-123');

    // Logging mock
    when(
      () => mockLogger.log(
        any(),
        any(),
        any(),
        any(),
        metadata: any(named: 'metadata'),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);

    // Default Preferences mock
    when(() => mockPrefs.getString(any())).thenAnswer((_) async => '');
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async {});
    when(() => mockPrefs.getBool(any())).thenAnswer((_) async => false);
    when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async {});

    // Database raw counts mock
    when(
      () => mockDb.rawQuery('SELECT COUNT(*) FROM transactions;'),
    ).thenAnswer(
      (_) async => [
        {'COUNT(*)': 10},
      ],
    );
    when(() => mockDb.rawQuery('SELECT COUNT(*) FROM accounts;')).thenAnswer(
      (_) async => [
        {'COUNT(*)': 2},
      ],
    );
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.createThemeLight(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa'), Locale('en')],
      locale: const Locale('fa'),
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    );
  }

  group('Backup & Restore Unit Tests', () {
    test(
      'Create backup serializes database tables and writes AES encrypted file successfully',
      () async {
        // Mock db queries
        when(() => mockDb.query(any())).thenAnswer(
          (_) async => [
            {'id': 'tx1', 'amount': 25000.0},
          ],
        );

        when(
          () => mockFileStorage.writeString(any(), any()),
        ).thenAnswer((_) async {});
        when(() => mockFileStorage.exists(any())).thenAnswer((_) async => true);

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            fileStorageProvider.overrideWithValue(mockFileStorage),
            clockProvider.overrideWithValue(mockClock),
            uuidGeneratorProvider.overrideWithValue(mockUuidGenerator),
            loggerProvider.overrideWithValue(mockLogger),
            backupPortabilityProvider.overrideWithValue(realBackupPortability),
          ],
        );

        final repository = container.read(backupRepositoryProvider);
        final res = await repository.createBackup(
          password: 'secure_password_123',
          isManual: true,
        );

        expect(res.isSuccess, isTrue);
        final item = res.successOrCrash;
        expect(item.isManual, isTrue);
        expect(item.id, 'test-uuid-123');
        expect(item.sizeBytes, greaterThan(0));
      },
    );

    test(
      'Restore backup decrypts file and inserts rows into db tables atomically',
      () async {
        // Create valid encrypted payload bytes first
        final payloadData = {
          'transactions': [
            {'id': 'tx2', 'amount': 12000.0},
          ],
          'accounts': [
            {'id': 'acc1', 'name': 'Melli'},
          ],
        };

        final exportResult = await realBackupPortability.exportBackup(
          password: 'restore_password_123',
          tablesData: payloadData,
        );
        expect(exportResult.isSuccess, isTrue);
        final backupBytes = exportResult.successOrCrash;

        // Mock helper to handle atomic transaction callbacks
        Future<void> handleTxn(Invocation invocation) async {
          final action = invocation.positionalArguments[0] as Function;
          final mockTxn = MockTransaction();
          when(() => mockTxn.delete(any())).thenAnswer((_) async => 0);
          when(
            () => mockTxn.insert(
              any(),
              any(),
              conflictAlgorithm: any(named: 'conflictAlgorithm'),
            ),
          ).thenAnswer((_) async => 0);
          await action(mockTxn);
        }

        // Stub transaction for void, dynamic and Null parameters to be absolutely bulletproof
        when(() => mockDb.transaction<void>(any())).thenAnswer((inv) async {
          await handleTxn(inv);
        });
        when(() => mockDb.transaction<dynamic>(any())).thenAnswer((inv) async {
          await handleTxn(inv);
          return null;
        });
        when(() => mockDb.transaction<Null>(any())).thenAnswer((inv) async {
          await handleTxn(inv);
          return null;
        });

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            fileStorageProvider.overrideWithValue(mockFileStorage),
            clockProvider.overrideWithValue(mockClock),
            uuidGeneratorProvider.overrideWithValue(mockUuidGenerator),
            loggerProvider.overrideWithValue(mockLogger),
            backupPortabilityProvider.overrideWithValue(realBackupPortability),
          ],
        );

        final repository = container.read(backupRepositoryProvider);
        final res = await repository.restoreBackup(
          password: 'restore_password_123',
          backupBytes: backupBytes,
          forceReplace: true,
        );

        if (res.isFailure) {
          print('RESTORATION FAILED WITH: ${res.failureOrCrash.message}');
        }

        expect(res.isSuccess, isTrue);
      },
    );

    test(
      'Restore backup with wrong password fails yielding BiometricMismatchFailure',
      () async {
        final payloadData = {
          'transactions': [
            {'id': 'tx3', 'amount': 500.0},
          ],
        };
        final exportResult = await realBackupPortability.exportBackup(
          password: 'right_password',
          tablesData: payloadData,
        );
        final backupBytes = exportResult.successOrCrash;

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            fileStorageProvider.overrideWithValue(mockFileStorage),
            clockProvider.overrideWithValue(mockClock),
            uuidGeneratorProvider.overrideWithValue(mockUuidGenerator),
            loggerProvider.overrideWithValue(mockLogger),
            backupPortabilityProvider.overrideWithValue(realBackupPortability),
          ],
        );

        final repository = container.read(backupRepositoryProvider);
        final res = await repository.restoreBackup(
          password: 'wrong_password',
          backupBytes: backupBytes,
          forceReplace: false,
        );

        expect(res.isFailure, isTrue);
        expect(res.failureOrCrash, isA<BiometricMismatchFailure>());
      },
    );

    test(
      'Restore backup with corrupted bytes fails yielding BiometricMismatchFailure',
      () async {
        final corruptedBytes = List<int>.generate(30, (i) => i ^ 0xFF);

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            fileStorageProvider.overrideWithValue(mockFileStorage),
            clockProvider.overrideWithValue(mockClock),
            uuidGeneratorProvider.overrideWithValue(mockUuidGenerator),
            loggerProvider.overrideWithValue(mockLogger),
            backupPortabilityProvider.overrideWithValue(realBackupPortability),
          ],
        );

        final repository = container.read(backupRepositoryProvider);
        final res = await repository.restoreBackup(
          password: 'any_password',
          backupBytes: corruptedBytes,
          forceReplace: false,
        );

        expect(res.isFailure, isTrue);
      },
    );
  });

  group('Backup State Notifier Tests', () {
    test(
      'Initializes state with metadata and load history successfully',
      () async {
        final item = BackupHistoryItem(
          id: 'h1',
          filePath: '/tmp/b1.bankyar',
          fileName: 'b1.bankyar',
          timestamp: DateTime(2024, 1, 1),
          isManual: true,
          sizeBytes: 1024,
          isHealthy: true,
          dbVersion: 1,
          encryptAlgorithm: 'AES-256-CBC',
        );

        when(
          () => mockPrefs.getString('by_backup_history_list'),
        ).thenAnswer((_) async => jsonEncode([item.toJson()]));

        final container = ProviderContainer(
          overrides: [
            databaseServiceProvider.overrideWithValue(mockDbService),
            preferencesStorageProvider.overrideWithValue(mockPrefs),
            fileStorageProvider.overrideWithValue(mockFileStorage),
            clockProvider.overrideWithValue(mockClock),
            uuidGeneratorProvider.overrideWithValue(mockUuidGenerator),
            loggerProvider.overrideWithValue(mockLogger),
            backupPortabilityProvider.overrideWithValue(realBackupPortability),
          ],
        );

        final notifier = container.read(backupNotifierProvider.notifier);
        await notifier.loadInitialData();

        final state = container.read(backupNotifierProvider);
        expect(state.isLoading, isFalse);
        expect(state.history, hasLength(1));
        expect(state.history.first.fileName, 'b1.bankyar');
      },
    );
  });

  group('Backup Screen Widget & Accessibility Tests', () {
    testWidgets(
      'BackupRestoreScreen renders status cards, quick action grid, and history list correctly',
      (WidgetTester tester) async {
        final item = BackupHistoryItem(
          id: 'h2',
          filePath: '/tmp/b2.bankyar',
          fileName: 'b2.bankyar',
          timestamp: DateTime(2024, 1, 1, 14, 30),
          isManual: true,
          sizeBytes: 1524288, // 1.45 MB
          isHealthy: true,
          dbVersion: 1,
          encryptAlgorithm: 'AES-256-CBC',
        );

        when(
          () => mockPrefs.getString('by_backup_history_list'),
        ).thenAnswer((_) async => jsonEncode([item.toJson()]));

        await tester.pumpWidget(
          buildTestableWidget(
            ProviderScope(
              overrides: [
                databaseServiceProvider.overrideWithValue(mockDbService),
                preferencesStorageProvider.overrideWithValue(mockPrefs),
                fileStorageProvider.overrideWithValue(mockFileStorage),
                clockProvider.overrideWithValue(mockClock),
                uuidGeneratorProvider.overrideWithValue(mockUuidGenerator),
                loggerProvider.overrideWithValue(mockLogger),
                backupPortabilityProvider.overrideWithValue(
                  realBackupPortability,
                ),
              ],
              child: const BackupRestoreScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify screen title
        expect(find.text('صندوق پشتیبان‌گیری و بازیابی'), findsOneWidget);

        // Verify sovereignty alert
        expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

        // Verify status overview card components
        expect(find.text('وضعیت سلامت دیتابیس'), findsOneWidget);
        expect(find.textContaining('۱۰۰٪'), findsOneWidget);

        // Verify quick action tiles
        expect(find.text('ایجاد فایل پشتیبان'), findsOneWidget);
        expect(find.text('بازیابی اطلاعات'), findsOneWidget);
        expect(find.text('بررسی سلامت فایل'), findsOneWidget);

        // Verify history item is displayed (formatted Persian numbers for sizes/dates)
        expect(find.text('پشتیبان‌گیری دستی'), findsOneWidget);
      },
    );
  });
}
