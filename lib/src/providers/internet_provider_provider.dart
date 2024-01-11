import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetProvider with ChangeNotifier {
  final _networkConnectivity = Connectivity();
  final _internetConnectionChecker = InternetConnectionChecker();
  late StreamSubscription<ConnectivityResult> _streamSubscription;
  bool _hasInternet = true;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  bool _loading = false;
  bool _initialized = false;
  bool _connectionChanged = false;

  /// returns [TRUE] if has not internet connection and has been initialized
  bool get noInternetConnection => !_hasInternet && _initialized;

  // bool get hasInternet => _hasInternet;
  bool get loading => _loading;

  ConnectivityResult get connectionStatus => _connectionStatus;
  /// returns [TRUE] If there is an Internet connection
  /// after the Internet connection was offline
  bool get connectionRestored => _initialized && _connectionChanged && _hasInternet;

  Future<void> init([bool mounted = true]) async {
    // init connection status
    _connectionStatus = await _networkConnectivity.checkConnectivity();
    // check connection in init if not already loading
    if (!_loading) {
      await checkConnection();
    }

    // set connection stream to check connection when status changes
    _streamSubscription = _networkConnectivity.onConnectivityChanged.listen((result) {
      _connectionStatus = result;
      checkConnection();
    });

    if (!mounted) {
      return Future.value(null);
    }
  }

  Future<bool> checkConnection() async {
    _loading = true;
    _connectionChanged = false;
    notifyListeners();

    bool connectionResult = false;

    // check internet connection if there status connection
    if (_connectionStatus != ConnectivityResult.none) {
      connectionResult = await _internetConnectionChecker.hasConnection;
    }

    // update _hasInternet var if the result changed
    if (connectionResult != _hasInternet) {
      _connectionChanged = true;
      _hasInternet = connectionResult;
    }

    // set initialized to true if isn't
    if (!_initialized) {
      _initialized = true;
    }

    _loading = false;
    notifyListeners();

    debugPrint('--------------');
    debugPrint('connection: ${_connectionStatus.name} - ${_hasInternet ? "connected ✅" : "not connected ❌"}');
    debugPrint('--------------');
    return connectionResult;
  }

  void onRestoreInternetConnectionCalled() {
    _connectionChanged = false;
  }

  Future<void> disposeStream() async {
    await _streamSubscription.cancel();
  }
}
