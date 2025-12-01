# Dio Interceptor Test App

This is a test app to demonstrate the `InternetStateManagerInterceptor` feature.

## Features

- Tests the optional Dio interceptor
- Fetches data from JSONPlaceholder API
- Shows real-time connection status
- Displays request count
- Demonstrates how the interceptor triggers connectivity checks on each request

## Running

```bash
cd example/testing_interceptor_package
flutter run
```

For iOS Simulator:
```bash
flutter run -d ios
```

## How It Works

1. The app initializes `InternetStateManager`
2. Creates a Dio instance with `InternetStateManagerInterceptor`
3. Each HTTP request triggers a non-blocking connectivity check
4. The UI updates automatically based on connection state
