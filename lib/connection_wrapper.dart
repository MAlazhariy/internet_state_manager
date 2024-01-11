library connection_wrapper;

import 'package:connection_wrapper/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/models/disconnection_oprions_model.dart';
import 'src/providers/internet_provider_provider.dart';

export 'src/widgets/connection_wrapper_widget.dart';
export 'src/models/disconnection_oprions_model.dart';
export 'src/helper/connection_helper.dart';

class ConnectionWrapper extends StatelessWidget {
  const ConnectionWrapper.init({
    required this.child,
    this.disconnectionOptions,
    super.key,
  });

  final Widget child;
  final DisconnectionOptions? disconnectionOptions;

  @override
  Widget build(BuildContext context) {
    debugPrint('ConnectionWrapper PROVIDER created');
    // set options
    Constants.setDisconnectionOptions(disconnectionOptions);
    // create provider
    return ListenableProvider(
      create: (_) => InternetProvider(),
      child: child,
    );
  }
}
