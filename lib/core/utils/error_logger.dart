import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:part_catalog/core/service_locator.dart';

/// Утилита для обработки и отображения ошибок.
class ErrorLogger {
  final Logger _logger = locator<Logger>();

  /// Логирует ошибку и опционально показывает SnackBar.
  void logAndShowError({
    required BuildContext context,
    required Object error,
    StackTrace? stackTrace,
    String? userMessage,
  }) {
    _logger.e(
      userMessage ?? 'An error occurred',
      error: error,
      stackTrace: stackTrace,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMessage ?? 'Произошла непредвиденная ошибка'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
