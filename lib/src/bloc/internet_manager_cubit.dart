import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_state_manager/src/utils/enums/internet_state_enum.dart';
import 'package:internet_state_manager/internet_state_manager.dart';

part 'internet_manager_state.dart';

class InternetManagerCubit extends Cubit<InternetManagerState> {
  InternetManagerCubit() : super(const InternetManagerState.init()) {
    _initCheckLocalNetworkConnection();
  }

  List<ConnectivityResult> _localConnectionResult = [];
  late final StreamSubscription<List<ConnectivityResult>> _localNetworkSubscription;

  bool _connectionChanged = false;

  /// returns [TRUE] If there is an Internet connection
  /// after the Internet connection was offline
  bool get connectionRestored => _connectionChanged && state.status.isConnected;

  /// Return [TRUE] if the device disconnected to any local network
  /// like **wifi** or **mobile data**.
  bool get disconnectedToLocalNetwork => _localConnectionResult.isEmpty || _localConnectionResult.contains(ConnectivityResult.none);

  Future<void> _initCheckLocalNetworkConnection() async {
    // start stream on local network connection
    _localConnectionResult = await Connectivity().checkConnectivity();
    checkConnection();

    // init stream on local network
    _localNetworkSubscription = Connectivity().onConnectivityChanged.listen((result) {
      _localConnectionResult = result;
      checkConnection();
    });
  }

  Future<void> checkConnection() async {
    if (state.loading) return;
    debugPrint('>> Checking for connection...');

    _connectionChanged = false;
    emit(state._loading());

    bool result = false;

    // check internet connection if there status connection
    if (!disconnectedToLocalNetwork) {
      result = await InternetConnectionChecker().hasConnection;
      debugPrint('> connection result: $result');
    }

    // update state var if the result changed
    if (result != state.status.isConnected) {
      _connectionChanged = true;
    }

    /*
    // set initialized to true if isn't
    if (!_initialized) {
      _initialized = true;
    }
    */

    emit(
      state._setState(
        result ? InternetState.connected : InternetState.disconnected,
      ),
    );

    debugPrint('--------------');
    debugPrint(
        'connection: ${_localConnectionResult.map((e) => e.name).join(', ')} - ${state.status.isConnected ? "connected ✅" : "not connected ❌"}');
    debugPrint('--------------');
  }

  void onRestoreInternetConnectionCalled() {
    _connectionChanged = false;
  }

  @override
  Future<void> close() async {
    await _localNetworkSubscription.cancel();
    return super.close();
  }
}
