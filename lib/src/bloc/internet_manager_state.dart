part of 'internet_manager_cubit.dart';

@immutable
class InternetManagerState extends Equatable {
  const InternetManagerState._({
    this.status = InternetState.init,
    this.loading = false,
  });

  /// #### This enum is used to show the current state of internet connection.
  ///
  /// * `init`: Initial state of the internet connection.
  /// * `connected`: App is connected to the internet.
  /// * `disconnected`: App is not connected to the internet.
  ///
  /// You can use get the current state of the internet connection
  /// by calling `status.isChecking`, `status.isConnected`, and `status.isDisconnected` ...etc
  final InternetState status;

  /// Return [TRUE] if the app is currently checking the internet connection.
  final bool loading;

  const InternetManagerState.init() : this._();

  InternetManagerState _copyWith({
    InternetState? status,
    bool? loading,
  }) {
    return InternetManagerState._(
      status: status ?? this.status,
      loading: loading ?? this.loading,
    );
  }

  InternetManagerState _loading() => _copyWith(loading: true);

  InternetManagerState _setState(InternetState status) => _copyWith(loading: false, status: status);

  @override
  List<Object> get props => [status, loading];
}
