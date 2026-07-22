/// Supported connectivity states of the application.
enum ConnectivityStatus {
  /// Active internet socket is reachable.
  online,

  /// No network reachability.
  offline,
}

/// Abstraction representing the network connectivity state.
/// Conforms to BankYar zero-network constraint guidelines.
abstract class ConnectivityService {
  /// Returns true if the device is currently online.
  Future<bool> get isOnline;

  /// Stream of network connectivity status transitions.
  Stream<ConnectivityStatus> get onConnectivityChanged;
}

/// Concrete implementation enforcing BankYar's strict offline-only bounds.
class SystemConnectivityService implements ConnectivityService {
  /// Constructor constructing connectivity service.
  const SystemConnectivityService();

  @override
  Future<bool> get isOnline => Future.value(false); // Enforce zero-network policy

  @override
  Stream<ConnectivityStatus> get onConnectivityChanged =>
      Stream.value(ConnectivityStatus.offline);
}
