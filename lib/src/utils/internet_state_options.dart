import 'package:flutter/material.dart';

class InternetStateOptions {
  /// ## Title shown when internet disconnected.
  ///
  /// Default is `"No internet connection"`.
  /// If equals null it return default value.
  final String noInternetTitle;

  /// Description shown when internet disconnected.
  ///
  /// Default is `"Check the internet connection".
  final String descriptionText;

  /// ## Title shown in button when internet disconnected to try checking the internet again.
  ///
  /// Default is `"Try again"`.
  final String tryAgainText;

  /// ## The duration periodic between each auto internet check.
  ///
  /// If null it returns `1 min` Duration.
  final Duration checkConnectionPeriodic;

  final Color? backgroundColor;
  final Color? textColor;

  const InternetStateOptions({
    this.noInternetTitle = "No internet connection",
    this.descriptionText = "Check the internet connection",
    this.tryAgainText = "Try again",
    this.textColor,
    this.backgroundColor,
    this.checkConnectionPeriodic = const Duration(minutes: 1),
  });
}
