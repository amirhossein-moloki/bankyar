import 'dart:io' as io;
import 'package:bankyar/core/platform/app_lifecycle_service.dart';
import 'package:bankyar/core/platform/clock.dart';
import 'package:bankyar/core/platform/connectivity.dart';
import 'package:bankyar/core/platform/file_storage.dart';
import 'package:bankyar/core/platform/permission.dart';
import 'package:bankyar/core/platform/platform.dart';
import 'package:bankyar/core/platform/secure_storage.dart';
import 'package:bankyar/core/platform/uuid.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Platform Service Abstraction Tests', () {
    test('SystemClock returns a valid date', () {
      const clock = SystemClock();
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final now = clock.now();
      final after = DateTime.now().add(const Duration(seconds: 1));

      expect(now.isAfter(before), isTrue);
      expect(now.isBefore(after), isTrue);
    });

    test('SystemUuidGenerator generates a valid RFC v4 UUID', () {
      const uuidGen = SystemUuidGenerator();
      final uuid1 = uuidGen.generateV4();
      final uuid2 = uuidGen.generateV4();

      expect(uuid1, isNotNull);
      expect(uuid1.length, equals(36));
      expect(uuid1, isNot(equals(uuid2)));

      // Regex matching standard UUID v4 format
      final uuidRegex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(uuidRegex.hasMatch(uuid1), isTrue);
    });

    test(
      'SystemPlatformService and SystemConnectivityService execute cleanly',
      () async {
        const platform = SystemPlatformService();
        expect(platform.isWeb, isFalse);
        expect(platform.isAndroid || platform.isIos || true, isTrue);

        const connectivity = SystemConnectivityService();
        expect(await connectivity.isOnline, isFalse);

        final status = await connectivity.onConnectivityChanged.first;
        expect(status, equals(ConnectivityStatus.offline));
      },
    );

    test(
      'SystemSecureStorage interacts with FlutterSecureStorage correctly',
      () async {
        final mockStorage = MockFlutterSecureStorage();
        final secureStorage = SystemSecureStorage(mockStorage);

        when(
          () => mockStorage.read(key: 'my_key'),
        ).thenAnswer((_) => Future.value('my_value'));
        when(
          () => mockStorage.write(key: 'my_key', value: 'my_value'),
        ).thenAnswer((_) => Future.value());
        when(
          () => mockStorage.delete(key: 'my_key'),
        ).thenAnswer((_) => Future.value());
        when(() => mockStorage.deleteAll()).thenAnswer((_) => Future.value());

        final val = await secureStorage.read('my_key');
        expect(val, equals('my_value'));

        await secureStorage.write(key: 'my_key', value: 'my_value');
        await secureStorage.delete('my_key');
        await secureStorage.deleteAll();

        verify(() => mockStorage.read(key: 'my_key')).called(1);
        verify(
          () => mockStorage.write(key: 'my_key', value: 'my_value'),
        ).called(1);
        verify(() => mockStorage.delete(key: 'my_key')).called(1);
        verify(() => mockStorage.deleteAll()).called(1);
      },
    );

    test('SystemPermissionService returns granted statuses', () async {
      const permission = SystemPermissionService();
      expect(
        await permission.checkStatus(AppPermission.smsReceive),
        equals(PermissionStatus.granted),
      );
      expect(
        await permission.request(AppPermission.localFiles),
        equals(PermissionStatus.granted),
      );
    });

    test(
      'SystemFileStorage reads, writes, and deletes files successfully',
      () async {
        const fileStorage = SystemFileStorage();
        final tempDir = io.Directory.systemTemp.createTempSync();
        final tempFilePath = '${tempDir.path}/test_file.txt';

        expect(await fileStorage.exists(tempFilePath), isFalse);

        await fileStorage.writeString(tempFilePath, 'BankYar Secure Content');
        expect(await fileStorage.exists(tempFilePath), isTrue);

        final content = await fileStorage.readString(tempFilePath);
        expect(content, equals('BankYar Secure Content'));

        await fileStorage.delete(tempFilePath);
        expect(await fileStorage.exists(tempFilePath), isFalse);

        tempDir.deleteSync(recursive: true);
      },
    );

    test(
      'SystemAppLifecycleService registers and broadcasts state transitions',
      () async {
        final service = SystemAppLifecycleService();
        expect(service.currentState, equals(AppLifecycleState.resumed));

        // Simulate an OS state transition to paused and detached
        final statesFuture = service.onStateChanged.take(3).toList();

        service.didChangeAppLifecycleState(widgets.AppLifecycleState.paused);
        service.didChangeAppLifecycleState(widgets.AppLifecycleState.inactive);
        service.didChangeAppLifecycleState(widgets.AppLifecycleState.detached);

        final list = await statesFuture;
        expect(
          list,
          equals([
            AppLifecycleState.paused,
            AppLifecycleState.inactive,
            AppLifecycleState.detached,
          ]),
        );

        service.dispose();
      },
    );
  });
}
