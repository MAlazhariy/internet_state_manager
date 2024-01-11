import 'package:connection_wrapper/src/utils/color_manager.dart';
import 'package:flutter/material.dart';

// todo: handle hard-coded sizes
class SnkBar {
  static void showSuccess(
    BuildContext context,
    String msg, {
    int milliseconds = 1500,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: kSuccessColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

  static void showError(
    BuildContext context,
    String msg, {
    int milliseconds = 2500,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: kErrorColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

  static void showCustom(
      BuildContext context,
      String msg, {
        int milliseconds = 1500,
        Color? backgroundColor = kPrimaryLightColor,
        Color? textColor = kTitleColor,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
