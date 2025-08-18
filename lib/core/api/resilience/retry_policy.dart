import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

import 'package:part_catalog/core/api/exceptions.dart';
import 'package:part_catalog/core/utils/context_logger.dart';

/// Конфигурация политики повторных попыток
class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final bool useJitter;
  final Set<int> retryableStatusCodes;
  final Set<Type> retryableExceptions;
  final bool Function(DioException)? shouldRetry;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.useJitter = true,
    this.retryableStatusCodes = const {408, 429, 500, 502, 503, 504},
    this.retryableExceptions = const {
      SocketException,
      TimeoutException,
      NetworkException,
      ServiceUnavailableException,
    },
    this.shouldRetry,
  });

  /// Предустановленные конфигурации
  static const RetryConfig conservative = RetryConfig(
    maxAttempts: 2,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 10),
    backoffMultiplier: 1.5,
  );

  static const RetryConfig aggressive = RetryConfig(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 200),
    maxDelay: Duration(minutes: 1),
    backoffMultiplier: 2.5,
  );

  static const RetryConfig networkOptimized = RetryConfig(
    maxAttempts: 4,
    initialDelay: Duration(milliseconds: 300),
    maxDelay: Duration(seconds: 20),
    backoffMultiplier: 2.0,
    useJitter: true,
    retryableStatusCodes: {
      408,
      429,
      500,
      502,
      503,
      504,
      520,
      521,
      522,
      523,
      524
    },
  );
}

/// Стратегии задержки между попытками
enum BackoffStrategy {
  fixed, // Фиксированная задержка
  linear, // Линейное увеличение
  exponential, // Экспоненциальное увеличение
  fibonacci, // Последовательность Фибоначчи
}

/// Калькулятор задержек для повторных попыток
class DelayCalculator {
  final BackoffStrategy strategy;
  final Duration initialDelay;
  final Duration maxDelay;
  final double multiplier;
  final bool useJitter;
  final Random _random = Random();

  DelayCalculator({
    required this.strategy,
    required this.initialDelay,
    required this.maxDelay,
    required this.multiplier,
    required this.useJitter,
  });

  Duration calculateDelay(int attemptNumber) {
    Duration baseDelay;

    switch (strategy) {
      case BackoffStrategy.fixed:
        baseDelay = initialDelay;
        break;
      case BackoffStrategy.linear:
        baseDelay = Duration(
          milliseconds: (initialDelay.inMilliseconds * attemptNumber).round(),
        );
        break;
      case BackoffStrategy.exponential:
        baseDelay = Duration(
          milliseconds:
              (initialDelay.inMilliseconds * pow(multiplier, attemptNumber - 1))
                  .round(),
        );
        break;
      case BackoffStrategy.fibonacci:
        baseDelay = Duration(
          milliseconds:
              (initialDelay.inMilliseconds * _fibonacci(attemptNumber)).round(),
        );
        break;
    }

    // Ограничиваем максимальной задержкой
    if (baseDelay > maxDelay) {
      baseDelay = maxDelay;
    }

    // Добавляем jitter для избежания thundering herd
    if (useJitter) {
      final jitterAmount = baseDelay.inMilliseconds * 0.1; // 10% jitter
      final jitter = (_random.nextDouble() - 0.5) * 2 * jitterAmount;
      baseDelay = Duration(
        milliseconds: (baseDelay.inMilliseconds + jitter)
            .round()
            .clamp(0, maxDelay.inMilliseconds),
      );
    }

    return baseDelay;
  }

  int _fibonacci(int n) {
    if (n <= 1) return 1;
    if (n == 2) return 2;

    int a = 1, b = 2;
    for (int i = 3; i <= n; i++) {
      int temp = a + b;
      a = b;
      b = temp;
    }
    return b;
  }
}

/// Политика повторных попыток
class RetryPolicy {
  final RetryConfig config;
  final DelayCalculator _delayCalculator;
  final ContextLogger _logger;

  RetryPolicy({
    required this.config,
    BackoffStrategy backoffStrategy = BackoffStrategy.exponential,
    ContextLogger? logger,
  })  : _delayCalculator = DelayCalculator(
          strategy: backoffStrategy,
          initialDelay: config.initialDelay,
          maxDelay: config.maxDelay,
          multiplier: config.backoffMultiplier,
          useJitter: config.useJitter,
        ),
        _logger = logger ?? ContextLogger(context: 'RetryPolicy');

  /// Выполняет операцию с повторными попытками
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
    Map<String, dynamic>? metadata,
  }) async {
    final opName = operationName ?? 'operation';
    dynamic lastException;

    for (int attempt = 1; attempt <= config.maxAttempts; attempt++) {
      try {
        _logger.d('Executing $opName (attempt $attempt/${config.maxAttempts})',
            metadata: {
              'attempt': attempt,
              'maxAttempts': config.maxAttempts,
              ...?metadata,
            });

        final result = await operation();

        if (attempt > 1) {
          _logger.i('$opName succeeded after $attempt attempts', metadata: {
            'attempt': attempt,
            'totalAttempts': attempt,
            ...?metadata,
          });
        }

        return result;
      } catch (e) {
        lastException = e;

        if (attempt == config.maxAttempts || !_shouldRetry(e)) {
          _logger.e(
            '$opName failed permanently',
            metadata: {
              'attempt': attempt,
              'maxAttempts': config.maxAttempts,
              'reason': _shouldRetry(e)
                  ? 'max_attempts_reached'
                  : 'non_retryable_error',
              ...?metadata,
            },
            error: e,
          );
          rethrow;
        }

        final delay = _delayCalculator.calculateDelay(attempt);

        _logger.w(
          '$opName failed, retrying in ${delay.inMilliseconds}ms',
          metadata: {
            'attempt': attempt,
            'nextAttempt': attempt + 1,
            'maxAttempts': config.maxAttempts,
            'delayMs': delay.inMilliseconds,
            'error': e.toString(),
            ...?metadata,
          },
          error: e,
        );

        await Future.delayed(delay);
      }
    }

    throw lastException;
  }

  bool _shouldRetry(dynamic exception) {
    // Пользовательская логика имеет приоритет
    if (config.shouldRetry != null && exception is DioException) {
      return config.shouldRetry!(exception);
    }

    // Проверяем тип исключения
    if (config.retryableExceptions.contains(exception.runtimeType)) {
      return true;
    }

    // Проверяем DioException
    if (exception is DioException) {
      return _shouldRetryDioException(exception);
    }

    // Проверяем наши типизированные исключения
    if (exception is ApiException) {
      return _shouldRetryApiException(exception);
    }

    return false;
  }

  bool _shouldRetryDioException(DioException e) {
    // Таймауты и сетевые ошибки всегда можно повторить
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return true;
    }

    // Проверяем HTTP статус коды
    if (e.response?.statusCode != null) {
      return config.retryableStatusCodes.contains(e.response!.statusCode);
    }

    return false;
  }

  bool _shouldRetryApiException(ApiException e) {
    // Сетевые ошибки
    if (e is NetworkException || e is TimeoutException) {
      return true;
    }

    // Ошибки сервера
    if (e is ServiceUnavailableException) {
      return true;
    }

    // Rate limiting
    if (e is RateLimitException) {
      return true;
    }

    // Проверяем статус код
    if (e.statusCode != null) {
      return config.retryableStatusCodes.contains(e.statusCode);
    }

    return false;
  }
}

/// Интерсептор для автоматических повторных попыток
class RetryInterceptor extends Interceptor {
  final RetryPolicy _retryPolicy;
  final ContextLogger _logger;

  RetryInterceptor({
    required RetryPolicy retryPolicy,
    ContextLogger? logger,
  })  : _retryPolicy = retryPolicy,
        _logger = logger ?? ContextLogger(context: 'RetryInterceptor');

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Проверяем, нужно ли повторить запрос
    if (!_retryPolicy._shouldRetry(err)) {
      handler.next(err);
      return;
    }

    // Извлекаем информацию о попытке
    final currentAttempt =
        (err.requestOptions.extra['retry_attempt'] as int?) ?? 1;

    if (currentAttempt >= _retryPolicy.config.maxAttempts) {
      handler.next(err);
      return;
    }

    final nextAttempt = currentAttempt + 1;
    final delay = _retryPolicy._delayCalculator.calculateDelay(nextAttempt);

    _logger.w(
        'Retrying request ${err.requestOptions.method} ${err.requestOptions.path}',
        metadata: {
          'attempt': nextAttempt,
          'maxAttempts': _retryPolicy.config.maxAttempts,
          'delayMs': delay.inMilliseconds,
          'error': err.message,
        });

    await Future.delayed(delay);

    // Обновляем номер попытки
    err.requestOptions.extra['retry_attempt'] = nextAttempt;

    try {
      // Повторяем запрос
      final dio = Dio();
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: e,
          message: e.toString(),
        ));
      }
    }
  }
}

/// Адаптивная политика повторных попыток
class AdaptiveRetryPolicy extends RetryPolicy {
  final Map<String, _EndpointStats> _endpointStats = {};
  final Duration _statsWindow = const Duration(minutes: 5);

  AdaptiveRetryPolicy({
    required super.config,
    super.backoffStrategy,
    super.logger,
  });

  @override
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
    Map<String, dynamic>? metadata,
  }) async {
    final endpoint = metadata?['endpoint'] as String?;

    // Адаптируем конфигурацию на основе статистики
    if (endpoint != null) {
      _adaptConfigForEndpoint(endpoint);
    }

    final startTime = DateTime.now();

    try {
      final result = await super.execute(
        operation,
        operationName: operationName,
        metadata: metadata,
      );

      // Записываем успешную попытку
      if (endpoint != null) {
        _recordSuccess(endpoint, DateTime.now().difference(startTime));
      }

      return result;
    } catch (e) {
      // Записываем неудачную попытку
      if (endpoint != null) {
        _recordFailure(endpoint, e);
      }
      rethrow;
    }
  }

  void _adaptConfigForEndpoint(String endpoint) {
    final stats = _endpointStats[endpoint];
    if (stats == null) return;

    // Увеличиваем количество попыток для ненадежных endpoint'ов
    if (stats.errorRate > 0.3) {
      // Если error rate > 30%
      // Временно увеличиваем maxAttempts
      // Это требует создания нового config, так как текущий immutable
    }
  }

  void _recordSuccess(String endpoint, Duration responseTime) {
    final stats = _endpointStats.putIfAbsent(endpoint, () => _EndpointStats());
    stats.recordSuccess(responseTime);
    _cleanupOldStats();
  }

  void _recordFailure(String endpoint, dynamic error) {
    final stats = _endpointStats.putIfAbsent(endpoint, () => _EndpointStats());
    stats.recordFailure(error);
    _cleanupOldStats();
  }

  void _cleanupOldStats() {
    final cutoff = DateTime.now().subtract(_statsWindow);
    for (final stats in _endpointStats.values) {
      stats.cleanup(cutoff);
    }
  }
}

class _EndpointStats {
  final List<DateTime> _successTimes = [];
  final List<DateTime> _failureTimes = [];
  final List<Duration> _responseTimes = [];

  void recordSuccess(Duration responseTime) {
    final now = DateTime.now();
    _successTimes.add(now);
    _responseTimes.add(responseTime);
  }

  void recordFailure(dynamic error) {
    _failureTimes.add(DateTime.now());
  }

  double get errorRate {
    final totalRequests = _successTimes.length + _failureTimes.length;
    return totalRequests > 0 ? _failureTimes.length / totalRequests : 0.0;
  }

  Duration get averageResponseTime {
    if (_responseTimes.isEmpty) return Duration.zero;
    final totalMs =
        _responseTimes.map((d) => d.inMilliseconds).reduce((a, b) => a + b);
    return Duration(milliseconds: totalMs ~/ _responseTimes.length);
  }

  void cleanup(DateTime cutoff) {
    _successTimes.removeWhere((time) => time.isBefore(cutoff));
    _failureTimes.removeWhere((time) => time.isBefore(cutoff));

    // Для response times нам нужно сохранить соответствие с success times
    if (_responseTimes.length > _successTimes.length) {
      _responseTimes.removeRange(
          0, _responseTimes.length - _successTimes.length);
    }
  }
}