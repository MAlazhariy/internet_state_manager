import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class _Logger {
  // ANSI color codes
  static const String _reset = '\x1B[0m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _blue = '\x1B[34m';

  void debug(String message) {
    _log('🔍 DEBUG', message, _cyan);
  }

  void info(String message) {
    // Color based on message content
    String color = _blue;
    String emoji = '💡';

    if (message.contains('connected ✅') || message.contains('restored')) {
      color = _green;
      emoji = '✅';
    } else if (message.contains('not connected ❌')) {
      color = _red;
      emoji = '❌';
    } else if (message.contains('Checking')) {
      color = _yellow;
      emoji = '🔄';
    }

    _log('$emoji INFO', message, color);
  }

  void warn(String message) {
    _log('⚠️  WARN', message, _yellow);
  }

  void error(String message) {
    _log('❌ ERROR', message, _red);
  }

  void _log(String level, String message, String color) {
    final output = '$color[$level]$_reset $color$message$_reset';
    developer.log(
      message,
      name: 'InternetStateManager',
      level: 800,
    );
    // Also print to console with colors
    debugPrint(output);
  }
}

final logger = _Logger();
