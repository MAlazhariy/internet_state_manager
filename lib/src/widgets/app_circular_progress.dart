import 'dart:io';
import 'package:flutter/material.dart';

class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({
    super.key,
    this.color,
    this.strokeWidth = 4,
    this.size,
  });

  final Color? color;
  final double strokeWidth;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator.adaptive(
        valueColor:
            color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
        backgroundColor: Platform.isIOS ? color : null,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
