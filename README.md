[![Stand With Palestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/banner-no-action.svg)](https://thebsd.github.io/StandWithPalestine)


<!-- [![pub package](https://img.shields.io/pub/v/requests_inspector.svg)](https://pub.dev/packages/requests_inspector) -->


# Internet State Manager

## Overview

A Flutter package designed to manage internet connection states seamlessly within applications. It ensures an uninterrupted user experience by implementing a reliable mechanism to handle internet connectivity issues and automatically restore the application state once the connection is reestablished.

## Features

- **Accurate Internet Connection Detection:** The package accurately checks for an actual internet connection beyond verifying a Wi-Fi connection.
- **Ease of Use:** Simplifies the process by reducing the code needed to manage internet connectivity on different screens within your app.
- **Customizable Widgets:** Automatically displays either the package's built-in widget or a custom widget when the internet connection is lost, and periodically checks to update the connection status.
- **Builder Widget:** Provides a `builder` widget that allows for extensive customization. You can use this widget to build a custom interface based on the internet connection status. This feature gives you full control over what to display depending on whether the internet is connected or not. The `builder` widget provides access to the current `InternetManagerState`, which you can use to check the connection status via `state.status`.
- **Automatic Data Fetching:** Executes custom functions once the internet connection is restored, ensuring a smooth user experience without the need to reload or reopen the app.

## Getting Started

### 🔩 Installation

Add the package to your `pubspec.yaml` under `dependencies:`:

```yaml
internet_state_manager:
  git:
    url: https://github.com/MAlazhariy/internet_state_manager.git
    ref: v1.7.0
```

#### Android Configuration

To ensure proper functionality on Android, especially in release mode, you need to add `INTERNET` and `ACCESS_NETWORK_STATE` permissions to your `AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Permissions for internet_state_manager -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    
    <application
        ...
```

----

### Usage

1. **Initialization**

   Wrap your app's root widget with `InternetStateManagerInitializer.init` in the `main()` function:

   ```dart
   void main() {
     runApp(
       InternetStateManagerInitializer.init(
         child: const MyApp(),
       ),
     );
   }
   ```

2. **Wrap your Screens**

   To handle the internet connection state on your screens, wrap the desired screen with `InternetStateManager`, like:

   ```dart
   return InternetStateManager(
     child: Scaffold(
       body: Center(
         child: Text('Content of the screen'),
       ),
     ),
   );
   ```
----


<!-- **Use in global App**

   If you want to manage the internet connection state across the entire app without wrapping each screen individually, you can wrap the `MaterialApp` with `InternetStateManager` like this:

   ```dart
   return MaterialApp(
     // other properties...
     home: const InternetStateManager(
       child: HomeScreen(),
     ),
   );
   ```

   By wrapping the MaterialApp, you ensure that the InternetStateManager monitors the internet connection for the entire application. This means that any screen within your app will automatically respond to internet connectivity changes without the need to wrap each screen individually.
-->   

## Customizing with Builder Widget

   You can use `InternetStateManager.builder` widget to customize how your app handles internet connection states. This widget allows you to build the UI based on the **internet connection status**.

   Here's an example:

   ```dart
   return InternetStateManager.builder(
     builder: (context, state) {
       // Access the connection status through state.status
       return Scaffold(
         body: Center(
           child: state.status.isConnected
               ? Text('You are connected to the internet')
               : Text('No internet connection'),
         ),
       );
     },
   );
   ```

   In this example, you can customize the UI according to whether the internet is connected or not. The `state.status` provides the current internet connection status, allowing you to display different content based on the connection state.


## Handling Connection Restoration

The `InternetStateManager` provides a callback for when the internet connection is restored after being disconnected. Use the `onRestoreInternetConnection` property to execute logic or update the UI when the connection is re-established.

Here's an example:
   
   ```dart
   return InternetStateManager(
     onRestoreInternetConnection: () {
       // Your custom logic here to execute when the internet connection is restored.
       setState(() {
         initData(); 
       });
     },
     child: // your widget
   );
   ```
   In this example, the onRestoreInternetConnection callback is used to reinitialize data or update the UI when the internet connection is restored. This allows you to handle any necessary updates or actions that should occur once connectivity is regained.


----

For instance, if the connection is lost, the package will display a custom or default widget across the app, and once the connection is restored, it will seamlessly return to the previous state.


<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).


TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

-->
