import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_state_manager/internet_state_manager.dart';
import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';
import 'package:internet_state_manager/src/widgets/no_internet_screen.dart';
import 'package:flutter/material.dart';

class InternetStateManager extends StatefulWidget {
  const InternetStateManager({
    super.key,
    required this.child,
    this.onRestoreInternetConnection,
    this.noInternetScreen,
  }) : builder = null;

  const InternetStateManager.builder({
    super.key,
    required this.builder,
    this.onRestoreInternetConnection,
  })  : child = null,
        noInternetScreen = null;

  final Widget? child;
  final Widget Function(
    BuildContext context,
    InternetManagerState state,
  )? builder;

  /// ### This method called when internet connection is restored after it was disconnected.
  ///
  /// Use [onRestoreInternetConnection] to execute some logic or update the UI
  /// when the internet connection is restored.
  ///
  /// example:
  /// ```
  /// onRestoreInternetConnection: () {
  ///    setState((){
  ///      initData();
  ///    });
  ///  }
  /// ```
  final void Function()? onRestoreInternetConnection;

  /// This widget shown when internet connection is offline.
  ///
  /// If [noInternetScreen] is null, the default widget will be shown
  final Widget? noInternetScreen;

  @override
  State<InternetStateManager> createState() => _InternetStateManagerState();
}

class _InternetStateManagerState extends State<InternetStateManager> {
  int counter = 0;

  @override
  void initState() {
    InternetStateManagerController.checkInstanceIsCreated();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InternetManagerCubit>().checkConnection();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetManagerCubit, InternetManagerState>(
      builder: (context, state) {
        if (getOptions.showLogs) {
          debugPrint('> state changed: $state - ${counter++}');
        }
        if (state.status.isDisconnected) {
          return widget.noInternetScreen ?? _DisconnectedWidget(parent: widget);
        } else if (context.read<InternetManagerCubit>().connectionRestored && widget.onRestoreInternetConnection != null) {
          if (getOptions.showLogs) {
            debugPrint("internet connection restored ..");
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onRestoreInternetConnection?.call();
            context.read<InternetManagerCubit>().onRestoreInternetConnectionCalled();
          });
        }

        return widget.builder?.call(context, state) ?? widget.child!;
      },
    );
  }
}

class _DisconnectedWidget extends StatelessWidget {
  final InternetStateManager parent;

  const _DisconnectedWidget({
    required this.parent,
  });

  @override
  Widget build(BuildContext context) {
    if (parent.child != null) {
      return Column(
        children: [
          // show child
          Expanded(child: parent.child!),
          // show no internet widget
          const NoInternetBottomWidget(),
        ],
      );
    }

    return BlocBuilder<InternetManagerCubit, InternetManagerState>(
      builder: (context, state) => parent.builder!(context, state),
    );
  }
}
