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
      _instance ??= InternetStateManagerController._createInstance(options: options);

  /// Returns an instance of [InternetStateManagerController].
  ///
  /// This is a singleton class, meaning that there is only one instance of it.
  factory InternetStateManagerController() => _instance!;

  /// Get instance of [InternetStateManagerController].
  static InternetStateManagerController get instance {
    checkInstanceIsCreated();
    return _instance!;
  }

  static void checkInstanceIsCreated() {
    if (_instance == null) {
      throw Exception(
        '''InternetStateManagerInitializer has not been initialized before using `InternetStateManager`.
Your widget must be wrapped by `InternetStateManagerInitializer.init` first before using the package.\n\n
Please ensure you have initialized the package and your `main` should be like:
```
     runApp(
       InternetStateManagerInitializer.init(
         child: const MyApp(),
       ),
     );
```
''',
      );
    }
  }
}
