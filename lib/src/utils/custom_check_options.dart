import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';

final _addresses = [
  'https://www.google.com/',
  'https://www.apple.com/',
  'https://one.one.one.one/',
  'https://icanhazip.com/',
];

final customCheckOptions = List<InternetCheckOption>.generate(
  _addresses.length,
  (i) => InternetCheckOption(
    uri: Uri.parse(_addresses[i]),
    timeout: getOptions.checkConnectionTimeout,
  ),
);
