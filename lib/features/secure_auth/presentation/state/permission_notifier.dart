import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/platform/permission.dart';

/// State of the Permission Management System.
class PermissionState {
  /// Constructor.
  const PermissionState({
    required this.statuses,
    this.isLoading = false,
  });

  /// Factory for initial state.
  factory PermissionState.initial() {
    return const PermissionState(statuses: {});
  }

  /// Status of each permission.
  final Map<AppPermission, PermissionStatus> statuses;

  /// Whether active loading/checks are in progress.
  final bool isLoading;

  /// Copy helper.
  PermissionState copyWith({
    Map<AppPermission, PermissionStatus>? statuses,
    bool? isLoading,
  }) {
    return PermissionState(
      statuses: statuses ?? this.statuses,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Number of granted permissions.
  int get grantedCount =>
      statuses.values.where((s) => s == PermissionStatus.granted).length;

  /// Total permissions tracked.
  int get totalCount => statuses.length;

  /// Percentage of granted permissions.
  int get percentage =>
      totalCount == 0 ? 0 : ((grantedCount / totalCount) * 100).round();

  /// Whether READ_SMS is granted.
  bool get isSmsReadGranted =>
      statuses[AppPermission.smsRead] == PermissionStatus.granted;

  /// Whether RECEIVE_SMS is granted.
  bool get isSmsReceiveGranted =>
      statuses[AppPermission.smsReceive] == PermissionStatus.granted;

  /// Whether notifications permission is granted.
  bool get isNotificationsGranted =>
      statuses[AppPermission.notifications] == PermissionStatus.granted;

  /// Whether any critical permission is missing.
  bool get isAnyCriticalMissing =>
      !isSmsReadGranted || !isSmsReceiveGranted || !isNotificationsGranted;
}

/// Orchestrates permission updates, real-time sync streams, and deep links.
class PermissionNotifier extends StateNotifier<PermissionState>
    with WidgetsBindingObserver {
  /// Constructor.
  PermissionNotifier(this._permissionService)
    : super(PermissionState.initial()) {
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  final PermissionService _permissionService;
  StreamSubscription<Map<AppPermission, PermissionStatus>>? _subscription;

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    await refresh();
    _subscription = _permissionService.onStatusesChanged.listen((updated) {
      state = state.copyWith(statuses: Map.from(updated));
    });
  }

  /// Checks the current status of every tracked permission.
  Future<void> refresh() async {
    final Map<AppPermission, PermissionStatus> current = {};
    for (final perm in AppPermission.values) {
      current[perm] = await _permissionService.checkStatus(perm);
    }
    state = state.copyWith(statuses: current, isLoading: false);
  }

  /// Prompts standard system authorization dialogs or triggers Settings fallback.
  Future<PermissionStatus> requestPermission(AppPermission perm) async {
    final currentStatus = state.statuses[perm] ?? PermissionStatus.denied;
    if (currentStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      return PermissionStatus.permanentlyDenied;
    }

    final result = await _permissionService.request(perm);
    final updated = Map<AppPermission, PermissionStatus>.from(state.statuses);
    updated[perm] = result;
    state = state.copyWith(statuses: updated);
    return result;
  }

  /// Opens the device application-specific settings screen.
  Future<void> openAppSettings() async {
    await _permissionService.openSettings();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-query permission statuses on app resume to reactively capture changes made in Settings
      refresh();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Global provider for the permission management notifier.
final permissionNotifierProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
      final permService = ref.watch(permissionServiceProvider);
      return PermissionNotifier(permService);
    });
