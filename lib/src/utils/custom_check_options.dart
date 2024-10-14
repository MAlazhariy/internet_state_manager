import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';

final _addresses = [
  'https://one.one.one.one/',
  'https://icanhazip.com/',
  'https://jsonplaceholder.typicode.com/todos/1',
  'https://reqres.in/api/users/1',
];

final customCheckOptions = List<AddressCheckOption>.generate(
  _addresses.length,
  (i) => AddressCheckOption(
    uri: Uri.parse(_addresses[i]),
    timeout: getOptions.checkConnectionTimeout,
  ),
);
