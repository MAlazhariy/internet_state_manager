import 'package:connection_wrapper/connection_wrapper.dart';
import 'package:connection_wrapper/src/widgets/no_internet_screen.dart';
import 'package:connection_wrapper/src/providers/internet_provider_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ConnectionWrapperWidget extends StatefulWidget {
  const ConnectionWrapperWidget({
    super.key,
    required this.child,
    this.onRestoreInternetConnection,
    this.noInternetScreen,
    this.customOptions,
  }) : builder = null;

  const ConnectionWrapperWidget.builder({
    super.key,
    required this.builder,
    this.onRestoreInternetConnection,
    this.noInternetScreen,
    this.customOptions,
  }) : child = null;

  final Widget? child;
  final DisconnectionOptions? customOptions;
  final Widget Function(
    BuildContext context,
    InternetProvider internetProvider,
  )? builder;

  /// This method called when internet connection is restored after it was disconnected
  final void Function()? onRestoreInternetConnection;

  /// This widget shown when internet connection is offline.
  ///
  /// If [noInternetScreen] is null, the default widget will be shown
  final Widget Function(
    BuildContext context,
    InternetProvider internetProvider,
  )? noInternetScreen;

  @override
  State<ConnectionWrapperWidget> createState() => _ConnectionWrapperWidgetState();
}

class _ConnectionWrapperWidgetState extends State<ConnectionWrapperWidget> {
  late final InternetProvider _internetProvider;

  @override
  void initState() {
    super.initState();

    debugPrint('wrapper builder initState');
    _internetProvider = Provider.of<InternetProvider>(context, listen: false);
    _internetProvider.init(mounted);
  }

  @override
  void dispose() {
    _internetProvider.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, _) {
        if (internetProvider.noInternetConnection) {
          return _DisconnectedWidget(
            widget,
            internetProvider: internetProvider,
          );
        } else if (internetProvider.connectionRestored && widget.onRestoreInternetConnection != null) {
          debugPrint("internet connection restored ..");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            internetProvider.onRestoreInternetConnectionCalled();
            widget.onRestoreInternetConnection?.call();
          });
        }

        return widget.builder?.call(context, internetProvider) ?? widget.child!;
      },
    );
  }
}

class _DisconnectedWidget extends StatelessWidget {
  const _DisconnectedWidget(
    this.parent, {
    required this.internetProvider,
  });

  final ConnectionWrapperWidget parent;
  final InternetProvider internetProvider;

  @override
  Widget build(BuildContext context) {
    if(parent.child!=null){
      return Column(
        children: [
          // show child
          Expanded(child: parent.child!),
          // show no internet widget
          NoInternetScreen(customOptions: parent.customOptions),
        ],
      );
    }

    return parent.builder!(context, internetProvider);
  }
}

