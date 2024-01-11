import 'package:flutter/material.dart';

class DisconnectionOptions {
  /// Title shown when internet disconnected.
  ///
  /// Default is `"No internet connection"`.
  /// If equals null it return default value.
  final String? title;
  /// Description shown when internet disconnected.
  ///
  /// Default is [Null].
  final String? description;
  /// Title shown in button when internet disconnected to try checking the internet again.
  ///
  /// Default is `"Try again"`.
  /// If equals null it return default value.
  final String? tryAgain;
  /// The duration periodic between each auto internet check.
  ///
  /// If null it returns `2 mins` Duration.
  final Duration? checkInternetPeriodic;

  final Color? backgroundColor;
  final Color? textColor;

  const DisconnectionOptions({
    this.title,
    this.description,
    this.tryAgain,
    this.textColor,
    this.backgroundColor,
    this.checkInternetPeriodic,
  });
}
