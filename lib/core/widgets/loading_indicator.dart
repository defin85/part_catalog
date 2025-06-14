import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double strokeWidth;
  final Color? color;
  final double? value; // Для детерминированного индикатора

  const LoadingIndicator({
    super.key,
    this.strokeWidth = 4.0,
    this.color,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor:
            color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
        value: value,
      ),
    );
  }
}
