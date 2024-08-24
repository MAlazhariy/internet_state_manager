import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_state_manager/src/utils/enums/internet_state_enum.dart';
import 'package:internet_state_manager/internet_state_manager.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';

part 'internet_manager_state.dart';

class InternetManagerCubit extends Cubit<InternetManagerState> {
  InternetManagerCubit() : super(const InternetManagerState.init()) {
    _initCheckLocalNetworkConnection();
  }

  List<ConnectivityResult> _localConnectionResult = [];
  late final StreamSubscription<List<ConnectivityResult>> _localNetworkSubscription;
  final _internetConnectionChecker = InternetConnectionChecker.createInstance();

  Timer? _timer;

  bool _connectionChanged = false;
  bool _loading = false;

  /// Returns [TRUE] if there is an internet connection after the
  /// internet connection was offline. This means that the **connection
  /// was restored** after being disconnected.
  bool get connectionRestored => _connectionChanged && state.status.isConnected;

  /// Return [TRUE] if the device disconnected to any local network
  /// i.e: **wifi** or **mobile data**.
  bool get disconnectedToLocalNetwork =>
      state.status.isInitialized && (_localConnectionResult.isEmpty || _localConnectionResult.contains(ConnectivityResult.none));

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
    if (_loading) return;
    _timer?.cancel();
    _connectionChanged = false;
    _loading = true;
    if (state.status.isDisconnected && !disconnectedToLocalNetwork) {
      emit(state._loading());
    }

    if (getOptions.showLogs) debugPrint('>> Checking for connection...');

    // check internet connection if there status connection
    bool result = false;
    if (!disconnectedToLocalNetwork) {
      result = await _internetConnectionChecker.hasConnection;
    }

    // update state if the result changed
    if (result != state.status.isConnected) {
      _connectionChanged = true;
    }

    emit(
      state._setState(
        result ? InternetState.connected : InternetState.disconnected,
      ),
    );

    if (getOptions.showLogs) {
      debugPrint(
          'connection: ${_localConnectionResult.map((e) => e.name).join(', ')} - ${state.status.isConnected ? "connected ✅" : "not connected ❌"}');
    }
    _loading = false;
    _startTimer();
  }

  void _startTimer() {
    if (getOptions.autoCheckConnection) {
      final duration = state.status.isConnected || getOptions.disconnectionCheckPeriodic == null
          ? getOptions.checkConnectionPeriodic
          : getOptions.disconnectionCheckPeriodic!;
      _timer = Timer(
        duration,
        checkConnection,
      );
    }
  }

  void onRestoreInternetConnectionCalled() => _connectionChanged = false;

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _localNetworkSubscription.cancel();
    return super.close();
  }
}
