import 'dart:io' as io;
import 'package:flutter/foundation.dart';

/// Abstraction representing the platform environment on which the app executes.
/// Avoids tight coupling to raw platform bindings during testing.
abstract class PlatformService {
  /// Returns true if executing on Android.
  bool get isAndroid;

  /// Returns true if executing on iOS.
  bool get isIos;

  /// Returns true if executing inside a web browser container.
  bool get isWeb;
}

/// Real implementation of [PlatformService] querying native system properties.
class SystemPlatformService implements PlatformService {
  /// Constructor constructing system platform service.
  const SystemPlatformService();

  @override
  bool get isAndroid => !kIsWeb && io.Platform.isAndroid;

  @override
  bool get isIos => !kIsWeb && io.Platform.isIOS;

  @override
  bool get isWeb => kIsWeb;
}
