import 'package:internet_state_manager/src/not_initialized_exception.dart' show NotInitializedException;
import 'package:internet_state_manager/src/utils/internet_state_options.dart';

InternetStateOptions get getOptions => InternetStateManagerController.instance.options;

class InternetStateManagerController {
  final InternetStateOptions options;
  static InternetStateManagerController? _instance;

  InternetStateManagerController._createInstance({required this.options});

  /// Used to initialize the [InternetStateManagerController].
  factory InternetStateManagerController.init({
    required InternetStateOptions options,
  }) =>
      _instance = InternetStateManagerController._createInstance(options: options);

  /// Returns an instance of [InternetStateManagerController].
  ///
  /// This is a singleton class, meaning that there is only one instance of it.
  factory InternetStateManagerController() => _instance!;

  /// Get instance of [InternetStateManagerController].
  static InternetStateManagerController get instance {
    return _instance ??= _defaultInstance();
  }

  static InternetStateManagerController _defaultInstance() {
    return InternetStateManagerController._createInstance(options: InternetStateOptions());
  }

  static void checkInstanceIsCreated() {
    if (_instance == null) {
      throw NotInitializedException();
    }
  }
}
