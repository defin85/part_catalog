import 'package:logger/logger.dart';

/// Утилита для единообразной обработки ошибок в сервисах.
/// Обеспечивает стандартизированное логирование и обработку исключений.
class ErrorHandler {
  ErrorHandler._(); // Приватный конструктор

  /// Выполняет операцию с автоматическим логированием начала, конца и ошибок.
  ///
  /// [operation] - асинхронная операция для выполнения
  /// [logger] - экземпляр логгера для записи событий
  /// [operationName] - имя операции для логирования
  /// [defaultValue] - значение по умолчанию при ошибке (опционально)
  /// [rethrowError] - перебрасывать ли ошибку после логирования (по умолчанию true)
  ///
  /// Возвращает результат операции или defaultValue при ошибке.
  static Future<T> executeWithLogging<T>({
    required Future<T> Function() operation,
    required Logger logger,
    required String operationName,
    T? defaultValue,
    bool rethrowError = true,
  }) async {
    try {
      logger.i('🚀 Starting $operationName');
      final stopwatch = Stopwatch()..start();

      final result = await operation();

      stopwatch.stop();
      logger.i(
          '✅ Completed $operationName in ${stopwatch.elapsedMilliseconds}ms');

      return result;
    } catch (error, stackTrace) {
      logger.e(
        '❌ Error in $operationName',
        error: error,
        stackTrace: stackTrace,
      );

      if (rethrowError) {
        rethrow;
      }

      if (defaultValue != null) {
        logger.w('⚠️ Returning default value for $operationName');
        return defaultValue;
      }

      throw Exception('Operation $operationName failed: $error');
    }
  }

  /// Выполняет синхронную операцию с логированием.
  ///
  /// [operation] - синхронная операция для выполнения
  /// [logger] - экземпляр логгера для записи событий
  /// [operationName] - имя операции для логирования
  /// [defaultValue] - значение по умолчанию при ошибке (опционально)
  /// [rethrowError] - перебрасывать ли ошибку после логирования (по умолчанию true)
  ///
  /// Возвращает результат операции или defaultValue при ошибке.
  static T executeSync<T>({
    required T Function() operation,
    required Logger logger,
    required String operationName,
    T? defaultValue,
    bool rethrowError = true,
  }) {
    try {
      logger.i('🚀 Starting $operationName');
      final stopwatch = Stopwatch()..start();

      final result = operation();

      stopwatch.stop();
      logger.i(
          '✅ Completed $operationName in ${stopwatch.elapsedMilliseconds}ms');

      return result;
    } catch (error, stackTrace) {
      logger.e(
        '❌ Error in $operationName',
        error: error,
        stackTrace: stackTrace,
      );

      if (rethrowError) {
        rethrow;
      }

      if (defaultValue != null) {
        logger.w('⚠️ Returning default value for $operationName');
        return defaultValue;
      }

      throw Exception('Operation $operationName failed: $error');
    }
  }

  /// Выполняет операцию с повторными попытками при ошибке.
  ///
  /// [operation] - асинхронная операция для выполнения
  /// [logger] - экземпляр логгера для записи событий
  /// [operationName] - имя операции для логирования
  /// [maxAttempts] - максимальное количество попыток (по умолчанию 3)
  /// [retryDelay] - задержка между попытками (по умолчанию 1 секунда)
  /// [shouldRetry] - функция для определения, нужна ли повторная попытка
  ///
  /// Возвращает результат операции.
  static Future<T> executeWithRetry<T>({
    required Future<T> Function() operation,
    required Logger logger,
    required String operationName,
    int maxAttempts = 3,
    Duration retryDelay = const Duration(seconds: 1),
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempt = 0;

    while (attempt < maxAttempts) {
      attempt++;

      try {
        logger.i('🔄 Attempt $attempt/$maxAttempts for $operationName');
        return await executeWithLogging(
          operation: operation,
          logger: logger,
          operationName: '$operationName (attempt $attempt)',
        );
      } catch (error) {
        final shouldRetryError = shouldRetry?.call(error) ?? true;

        if (attempt >= maxAttempts || !shouldRetryError) {
          logger.e('❌ All attempts failed for $operationName');
          rethrow;
        }

        logger.w(
          '⚠️ Attempt $attempt failed for $operationName, '
          'retrying in ${retryDelay.inSeconds}s...',
        );

        await Future.delayed(retryDelay);
      }
    }

    throw Exception('All retry attempts failed for $operationName');
  }

  /// Группирует несколько операций и выполняет их параллельно.
  ///
  /// [operations] - карта операций (имя -> операция)
  /// [logger] - экземпляр логгера для записи событий
  /// [stopOnError] - остановить выполнение при первой ошибке (по умолчанию false)
  ///
  /// Возвращает карту результатов (имя -> результат или ошибка).
  static Future<Map<String, dynamic>> executeBatch({
    required Map<String, Future<dynamic> Function()> operations,
    required Logger logger,
    bool stopOnError = false,
  }) async {
    logger
        .i('🚀 Starting batch execution with ${operations.length} operations');
    final results = <String, dynamic>{};

    if (stopOnError) {
      // Последовательное выполнение с остановкой при ошибке
      for (final entry in operations.entries) {
        try {
          results[entry.key] = await executeWithLogging(
            operation: entry.value,
            logger: logger,
            operationName: entry.key,
          );
        } catch (error) {
          results[entry.key] = error;
          logger.e('❌ Batch execution stopped due to error in ${entry.key}');
          break;
        }
      }
    } else {
      // Параллельное выполнение всех операций
      final futures = operations.entries.map((entry) async {
        try {
          final result = await executeWithLogging(
            operation: entry.value,
            logger: logger,
            operationName: entry.key,
            rethrowError: false,
          );
          return MapEntry(entry.key, result);
        } catch (error) {
          return MapEntry(entry.key, error);
        }
      });

      final entries = await Future.wait(futures);
      results.addEntries(entries);
    }

    final successCount = results.values.where((v) => v is! Exception).length;
    logger.i(
        '✅ Batch execution completed: $successCount/${operations.length} succeeded');

    return results;
  }
}

/// Расширение для Logger для добавления специализированных методов логирования.
extension LoggerExtensions on Logger {
  /// Логирует начало операции.
  void logStart(String operation) => i('🚀 Starting $operation');

  /// Логирует успешное завершение операции.
  void logSuccess(String operation, {Duration? duration}) {
    final durationStr =
        duration != null ? ' in ${duration.inMilliseconds}ms' : '';
    i('✅ Completed $operation$durationStr');
  }

  /// Логирует ошибку операции.
  void logError(String operation, dynamic error, [StackTrace? stackTrace]) {
    e('❌ Error in $operation', error: error, stackTrace: stackTrace);
  }

  /// Логирует предупреждение.
  void logWarning(String message) => w('⚠️ $message');

  /// Логирует метрику производительности.
  void logPerformance(String operation, Duration duration) {
    d('⏱️ $operation took ${duration.inMilliseconds}ms');
  }
}
