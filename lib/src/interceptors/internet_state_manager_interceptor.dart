import 'dart:async';

import 'package:dio/dio.dart';
import 'package:internet_state_manager/src/internet_state_manager_app.dart';

/// An optional Dio interceptor that triggers connectivity checks with each request.
///
/// This interceptor integrates with [InternetStateManager] to keep the
/// connectivity state fresh by triggering a check on every HTTP request.
/// The check runs asynchronously without blocking the request.
///
/// **Note:** This is completely optional. The package works perfectly without it.
///
/// **Important:** Requires [InternetStateManagerInitializer.initialize()] to be
/// called before using this interceptor.
///
/// ## Usage
///
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(InternetStateManagerInterceptor());
/// ```
///
/// ## How It Works
///
/// - Triggers a connectivity check on each request (non-blocking)
/// - Updates the internet state for UI widgets automatically
/// - Does NOT block or reject requests - lets Dio handle failures naturally
/// - Works seamlessly with [InternetStateManager] widgets
class InternetStateManagerInterceptor extends Interceptor {
  /// Creates an [InternetStateManagerInterceptor].
  InternetStateManagerInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Trigger connectivity check without blocking the request
    unawaited(InternetStateManagerInitializer.checkConnection());

    handler.next(options);
  }
}
