import 'package:internet_state_manager/src/bloc/internet_manager_cubit.dart';
import 'package:internet_state_manager/src/not_initialized_exception.dart';
import 'package:internet_state_manager/src/utils/internet_state_manager_controller.dart';
import 'package:internet_state_manager/src/utils/internet_state_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetStateManagerInitializer extends StatelessWidget {
  /// The root widget of your application.
  final Widget child;

  /// Initializes and provides the necessary context for managing internet connection states.
  ///
  /// This widget must wrap your app’s root widget (usually inside `runApp`) to ensure that
  /// `InternetStateManager` works correctly throughout the app.
  ///
  /// Example usage in `main()`:
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   // Required initialization before runApp
  ///   await InternetStateManagerInitializer.initialize();
  ///
  ///   runApp(
  ///     InternetStateManagerInitializer(
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// }
  /// ```
  InternetStateManagerInitializer({
    super.key,
    required this.child,
    InternetStateOptions? options,
  }) {
    _checkIsInitialized();
    InternetStateManagerController.init(
      options: options ?? InternetStateOptions(),
    );
  }

  static final InternetManagerCubit _cubit = InternetManagerCubit();

  /// Must be called before using [InternetStateManagerInitializer].
  ///
  /// This sets up internal connectivity checks and prepares the state manager.
  static Future<void> initialize() async =>
      await _cubit.initCheckLocalNetworkConnection();

  /// Ensures that the package has been initialized before proceeding.
  void _checkIsInitialized() {
    if (!_cubit.state.status.isInitialized) {
      throw NotInitializedException();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: child,
    );
  }
}
