/// Enum of states that internet can be in.
///
/// This enum is used to manage
/// the state of the internet connection.
///
/// The states are:
///   - [init]: Initial state of the internet connection.
///   - [connected]: The internet connection is connected.
///   - [disconnected]: The internet connection is disconnected.
///
/// You can get the current state of the internet connection
/// by calling `isChecking`, `isConnected`, or `isDisconnected` ...etc
enum InternetState {
  /// Initial state of the internet connection.
  /// This state is used when the internet connection is **NOT INITIALIZED** yet.
  init,

  /// The internet connection is connected.
  connected,

  /// The internet connection is disconnected.
  disconnected,
}

extension GetInternetState on InternetState {
  bool get isInitialized => this != InternetState.init;

  bool get isConnected => this == InternetState.connected;

  bool get isDisconnected => this == InternetState.disconnected;
}
