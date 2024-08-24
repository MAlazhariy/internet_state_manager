import 'package:flutter/material.dart';

class InternetStateOptions {
  /// ### The duration periodic between each auto internet check.
  ///
  /// The default is `12 seconds` Duration.
  final Duration checkConnectionPeriodic;

  /// ### The duration periodic between each auto internet check when disconnected state.
  ///
  /// Used when internet connection is lost, the check periodic will be set to this value
  /// otherwise if null it will be set to [checkConnectionPeriodic].
  final Duration? disconnectionCheckPeriodic;

  /// ### Set to [TRUE] to auto check internet connection periodically.
  ///
  /// If set to [FALSE] it will check the internet connection only
  /// when calling [InternetStateManager] widget on a new screen in your widget tree.
  ///
  /// In other words, it will check the internet connection
  /// every time navigating to a new screen wrapped by [InternetStateManager] widget.
  final bool autoCheckConnection;

  /// ### Color of the background when internet disconnected.
  ///
  /// If [Null] it returns the default color of [colorScheme.error].
  final Color? errorBackgroundColor;

  /// ### Color of the text on background when internet disconnected.
  ///
  /// If [NULL] it returns the default color of [colorScheme.onError].
  final Color? onBackgroundColor;

  /// ### The labels shown when internet disconnected.
  ///
  /// If [NULL] it returns default values.
  late final InternetStateLabels labels;

  /// ### Show logs.
  ///
  /// Default is [FALSE].
  final bool showLogs;

  InternetStateOptions({
    /// ### The labels shown when internet disconnected.
    ///
    /// If [NULL] it returns default values.
    InternetStateLabels? labels,
    this.errorBackgroundColor,
    this.onBackgroundColor,
    this.checkConnectionPeriodic = const Duration(seconds: 12),
    this.autoCheckConnection = true,
    this.showLogs = false,
    this.disconnectionCheckPeriodic,
  }) {
    this.labels = labels ?? InternetStateLabels.defaultValues;
  }
}

class InternetStateLabels {
  /// ### Title shown when internet disconnected.
  ///
  /// Default is `"No internet connection"`.
  final String Function() noInternetTitle;

  /// Description shown when internet disconnected.
  ///
  /// Default is `"Check your internet connection".
  final String Function() descriptionText;

  /// ### Title shown in button when internet disconnected to try checking the internet again.
  ///
  /// Default is `"Try again"`.
  final String Function() tryAgainText;

  InternetStateLabels({
    required this.noInternetTitle,
    required this.descriptionText,
    required this.tryAgainText,
  });

  static InternetStateLabels get defaultValues => InternetStateLabels(
        noInternetTitle: () => 'No internet connection',
        descriptionText: () => 'Check your internet connection.',
        tryAgainText: () => 'Try again',
      );
}
