import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';
import 'package:internet_state_manager/src/utils/internet_state_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetStateManagerInitializer extends StatelessWidget {
  const InternetStateManagerInitializer._({
    required this.child,
  }) : options = const InternetStateOptions();

  /// Initialize [InternetStateManagerInitializer]
  ///
  /// This should to be called in `main` function to initialize the package.
  ///
  ///  example:
  ///  ```
  ///  void main() {
  ///
  ///   runApp(
  ///     InternetStateManagerInitializer.init(
  ///       child: const MyApp(),
  ///     ),
  ///   );
  /// }
  ///  ```
  InternetStateManagerInitializer.init({
    required this.child,
    this.options = const InternetStateOptions(),
    super.key,
  }) {
    InternetStateManagerController.init(options: options);
  }

  /// Place for your main page widget.
  final Widget child;

  final InternetStateOptions options;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InternetManagerCubit(),
      child: child,
    );
  }
}
