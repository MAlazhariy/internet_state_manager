/// A Flutter package for seamless internet connection management.
///
/// This package provides widgets and utilities to easily manage internet
/// connectivity states across your Flutter application.
///
/// ## Quick Start
///
/// 1. Initialize the package before `runApp`:
/// ```dart
/// await InternetStateManagerInitializer.initialize();
/// ```
///
/// 2. Wrap your app with `InternetStateManagerInitializer`:
/// ```dart
/// runApp(InternetStateManagerInitializer(child: MyApp()));
/// ```
///
/// 3. Wrap screens with `InternetStateManager`:
/// ```dart
/// InternetStateManager(child: MyScreen())
/// ```
library;

export 'src/widgets/internet_state_manager_widget.dart';
export 'src/widgets/no_internet_screen.dart';
export 'src/utils/internet_state_options.dart';
export 'src/internet_state_manager_app.dart';
export 'src/utils/enums/internet_state_enum.dart';
export 'src/utils/extensions/context_extension.dart';
export 'src/interceptors/internet_state_manager_interceptor.dart';
