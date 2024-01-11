import 'package:connection_wrapper/src/providers/internet_provider_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ConnectionHelper {
  static InternetProvider provider(
    BuildContext context, {
    bool listen = false,
  }) {
    return Provider.of<InternetProvider>(
      context,
      listen: listen,
    );
  }
}
