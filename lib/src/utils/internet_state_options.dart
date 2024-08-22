import 'package:flutter/material.dart';

class InternetStateOptions {
  /// ## Title shown when internet disconnected.
  ///
  /// Default is `"No internet connection"`.
  /// If equals null it return default value.
  final String Function() noInternetTitle;

  /// Description shown when internet disconnected.
  ///
  /// Default is `"Check the internet connection".
  final String Function() descriptionText;

  /// ## Title shown in button when internet disconnected to try checking the internet again.
  ///
  /// Default is `"Try again"`.
  final String Function() tryAgainText;

  /// ## The duration periodic between each auto internet check.
  ///
  /// If null it returns `1 min` Duration.
  final Duration checkConnectionPeriodic;

  // todo: add documentation
  final Color? errorBackgroundColor;
  final Color? onBackgroundColor;

  const InternetStateOptions({
    required this.noInternetTitle,
    required this.descriptionText,
    required this.tryAgainText,
    this.errorBackgroundColor,
    this.onBackgroundColor,
    this.checkConnectionPeriodic = const Duration(minutes: 1),
  });

  static InternetStateOptions get defaultOptions => InternetStateOptions(
        noInternetTitle: () => 'No internet connection',
        descriptionText: () => 'Check the internet connection',
        tryAgainText: () => 'Try again',
      );
}
