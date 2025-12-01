import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/enums/internet_state_enum.dart';

/// Extension on [BuildContext] to easily access internet connection status.
///
/// These extensions provide convenient access to the internet state
/// without manually reading the cubit.
///
/// ## Example
///
/// ```dart
/// if (context.internetState.isConnected) {
///   // Do something when connected
/// }
///
/// // Manual check
/// await context.internetCheck();
/// ```
extension ConncectionStatus on BuildContext {
  /// Returns the current [InternetState] (connected, disconnected, or init).
  InternetState get internetState => read<InternetManagerCubit>().state.status;

  /// Returns `true` if currently checking the internet connection.
  bool get isLoading => read<InternetManagerCubit>().state.loading;

  /// Returns `true` if the connection was just restored after being disconnected.
  bool get isConnectionRestored =>
      read<InternetManagerCubit>().connectionRestored;

  /// Stream to listen for internet connection changes.
  ///
  /// You can use this stream logic directly on your code to listen to
  /// internet connection changes only (**without listening to loading states**)
  Stream<InternetState> get internetStateStream =>
      read<InternetManagerCubit>().internetStateStream;

  /// Manually triggers an internet connection check.
  ///
  /// Returns `true` if connected, `false` otherwise.
  Future<bool> internetCheck() =>
      read<InternetManagerCubit>().checkConnection();
}
