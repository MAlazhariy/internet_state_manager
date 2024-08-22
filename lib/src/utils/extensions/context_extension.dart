import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/enums/internet_state_enum.dart';

/// Get current connection status from [context]
extension ConncectionStatus on BuildContext {
  InternetState get internetState => read<InternetManagerCubit>().state.status;
  bool get isLoading => read<InternetManagerCubit>().state.loading;
  bool get isConnectionRestored => read<InternetManagerCubit>().connectionRestored;
}
