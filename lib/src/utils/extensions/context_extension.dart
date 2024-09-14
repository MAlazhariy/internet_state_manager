import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/enums/internet_state_enum.dart';

/// Get current connection status from [context]
extension ConncectionStatus on BuildContext {
  InternetState get internetState => read<InternetManagerCubit>().state.status;
  bool get isLoading => read<InternetManagerCubit>().state.loading;
  bool get isConnectionRestored => read<InternetManagerCubit>().connectionRestored;

  /// Stream to listen for internet connection changes.
  ///
  /// You can use this stream logic directly on your code to listen to
  /// internet connection changes only (**without listening to loading states**)
  Stream<InternetState> get internetStateStream => read<InternetManagerCubit>().internetStateStream;
  Future<void> get internetCheck => read<InternetManagerCubit>().checkConnection();
}
