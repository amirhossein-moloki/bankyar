import 'package:flutter/services.dart';

/// Representation of basic Android system properties and properties.
class AndroidDeviceInfo {
  /// Constructor for Android device info.
  const AndroidDeviceInfo({
    required this.manufacturer,
    required this.model,
    required this.brand,
    required this.sdkVersion,
    required this.releaseVersion,
  });

  /// Hardware manufacturer (e.g., "Xiaomi", "Samsung", "Huawei").
  final String manufacturer;

  /// Hardware model identifier (e.g., "Redmi Note 10").
  final String model;

  /// Brand name.
  final String brand;

  /// Android target SDK version.
  final int sdkVersion;

  /// Android OS user-visible release version.
  final String releaseVersion;
}

/// Abstraction representing core system properties and manufacturer compatibility hooks.
abstract class DeviceInfoService {
  /// Fetches standard hardware properties of the active executing device.
  Future<AndroidDeviceInfo> getAndroidInfo();

  /// Resolves the manufacturer-specific compatibility recommendations or instruction guides
  /// to assist users with battery saver configurations.
  String getManufacturerTroubleshootingGuide(String manufacturer);

  /// Returns deep link intents to trigger manufacturer-specific settings screens (autostart, battery saver).
  String? getManufacturerSettingsIntent(String manufacturer);
}

/// Concrete Android implementation of [DeviceInfoService] utilizing native method channels.
class AndroidDeviceInfoService implements DeviceInfoService {
  /// Constructor injecting standard MethodChannel.
  AndroidDeviceInfoService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.bankyar.app/platform');

  final MethodChannel _channel;

  @override
  Future<AndroidDeviceInfo> getAndroidInfo() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel
          .invokeMethod<Map<dynamic, dynamic>>('getDeviceInfo');

      if (result != null) {
        return AndroidDeviceInfo(
          manufacturer: (result['manufacturer'] as String?) ?? 'Unknown',
          model: (result['model'] as String?) ?? 'Unknown',
          brand: (result['brand'] as String?) ?? 'Unknown',
          sdkVersion: (result['sdkVersion'] as int?) ?? 30,
          releaseVersion: (result['releaseVersion'] as String?) ?? '11',
        );
      }
    } catch (_) {
      // Fallback in case of platform channel failures or other platforms
    }

    return const AndroidDeviceInfo(
      manufacturer: 'Google',
      model: 'Pixel',
      brand: 'Google',
      sdkVersion: 33,
      releaseVersion: '13',
    );
  }

  @override
  String getManufacturerTroubleshootingGuide(String manufacturer) {
    final lower = manufacturer.toLowerCase();
    if (lower.contains('xiaomi') ||
        lower.contains('redmi') ||
        lower.contains('poco')) {
      return 'در گوشی‌های شیائومی، برای جلوگیری از توقف تحلیل خودکار، به بخش «مدیریت برنامه‌ها»، بانک‌یار، رفته و گزینه «شروع خودکار (Autostart)» را فعال کنید و حالت ذخیره باتری را روی «بدون محدودیت» قرار دهید.';
    }
    if (lower.contains('huawei') || lower.contains('honor')) {
      return 'در گوشی‌های هوآوی، به تنظیمات، بخش باتری، «راه‌اندازی برنامه (App Launch)» رفته و بانک‌یار را در حالت مدیریت دستی قرار دهید تا در پس‌زمینه فعال بماند.';
    }
    if (lower.contains('samsung')) {
      return 'در گوشی‌های سامسونگ، به تنظیمات، مراقبت دستگاه، باتری، رفته و بانک‌یار را به لیست «برنامه‌هایی که هرگز غیرفعال نمی‌شوند» اضافه کنید.';
    }
    return 'جهت پایش بدون وقفه پیامک‌ها در پس‌زمینه، لطفاً تنظیمات بهینه‌سازی باتری این برنامه را خاموش نگه دارید.';
  }

  @override
  String? getManufacturerSettingsIntent(String manufacturer) {
    final lower = manufacturer.toLowerCase();
    if (lower.contains('xiaomi') ||
        lower.contains('redmi') ||
        lower.contains('poco')) {
      return 'com.miui.securitycenter/com.miui.permcenter.autostart.AutoStartManagementActivity';
    }
    if (lower.contains('huawei') || lower.contains('honor')) {
      return 'com.huawei.systemmanager/.startupmgr.ui.StartupNormalAppListActivity';
    }
    return null;
  }
}
