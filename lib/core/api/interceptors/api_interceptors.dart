import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:part_catalog/core/api/cache/api_cache.dart';
import 'package:part_catalog/core/api/cache/memory_cache.dart';
import 'package:part_catalog/core/api/exceptions.dart';
import 'package:part_catalog/core/utils/context_logger.dart';

/// Интерсептор для логирования API запросов и ответов
class LoggingInterceptor extends Interceptor {
  final ContextLogger _logger;
  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final int maxBodyLogLength;

  LoggingInterceptor({
    ContextLogger? logger,
    this.logRequestHeaders = false,
    this.logRequestBody = true,
    this.logResponseHeaders = false,
    this.logResponseBody = true,
    this.maxBodyLogLength = 1000,
  }) : _logger = logger ?? ContextLogger(context: 'ApiClient');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();
    options.extra['request_start_time'] = startTime;

    _logger.i('→ ${options.method} ${options.uri}', metadata: {
      'method': options.method,
      'url': options.uri.toString(),
    });

    if (logRequestHeaders && options.headers.isNotEmpty) {
      _logger.d('Request Headers:', metadata: {
        'headers': _sanitizeHeaders(options.headers),
      });
    }

    if (logRequestBody && options.data != null) {
      final bodyStr = _formatData(options.data);
      if (bodyStr.isNotEmpty) {
        _logger.d('Request Body:', metadata: {
          'body': _truncateString(bodyStr, maxBodyLogLength),
        });
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime =
        response.requestOptions.extra['request_start_time'] as DateTime?;
    final duration =
        startTime != null ? DateTime.now().difference(startTime) : null;

    _logger.i(
        '← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
        metadata: {
          'statusCode': response.statusCode,
          'method': response.requestOptions.method,
          'url': response.requestOptions.uri.toString(),
          if (duration != null) 'duration': '${duration.inMilliseconds}ms',
        });

    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      _logger.d('Response Headers:', metadata: {
        'headers': response.headers.map,
      });
    }

    if (logResponseBody && response.data != null) {
      final bodyStr = _formatData(response.data);
      if (bodyStr.isNotEmpty) {
        _logger.d('Response Body:', metadata: {
          'body': _truncateString(bodyStr, maxBodyLogLength),
        });
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime =
        err.requestOptions.extra['request_start_time'] as DateTime?;
    final duration =
        startTime != null ? DateTime.now().difference(startTime) : null;

    _logger.e(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri}',
      metadata: {
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'errorType': err.type.toString(),
        if (err.response?.statusCode != null)
          'statusCode': err.response!.statusCode,
        if (duration != null) 'duration': '${duration.inMilliseconds}ms',
      },
      error: err.message,
    );

    if (err.response?.data != null) {
      final errorBody = _formatData(err.response!.data);
      if (errorBody.isNotEmpty) {
        _logger.e('Error Response:', metadata: {
          'body': _truncateString(errorBody, maxBodyLogLength),
        });
      }
    }

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = <String, dynamic>{};
    const sensitiveHeaders = {
      'authorization',
      'x-api-key',
      'cookie',
      'set-cookie'
    };

    for (final entry in headers.entries) {
      final key = entry.key.toLowerCase();
      if (sensitiveHeaders.contains(key)) {
        sanitized[entry.key] = '[REDACTED]';
      } else {
        sanitized[entry.key] = entry.value;
      }
    }

    return sanitized;
  }

  String _formatData(dynamic data) {
    if (data == null) return '';

    try {
      if (data is String) return data;
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      }
      return data.toString();
    } catch (e) {
      return '[Unable to format data: $e]';
    }
  }

  String _truncateString(String str, int maxLength) {
    if (str.length <= maxLength) return str;
    return '${str.substring(0, maxLength)}... [truncated ${str.length - maxLength} chars]';
  }
}

/// Интерсептор для кеширования API ответов
class CacheInterceptor extends Interceptor {
  final ApiCache _cache;
  final CacheConfig _config;
  final ContextLogger _logger;
  late final CacheMiddleware _middleware;

  CacheInterceptor({
    ApiCache? cache,
    CacheConfig? config,
    ContextLogger? logger,
  })  : _cache = cache ?? MemoryCache(config ?? const CacheConfig()),
        _config = config ?? const CacheConfig(),
        _logger = logger ?? ContextLogger(context: 'CacheInterceptor') {
    _middleware = CacheMiddleware(cache: _cache, config: _config);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Кешируем только GET запросы
    if (options.method.toUpperCase() != 'GET' || !_config.enabled) {
      handler.next(options);
      return;
    }

    // Проверяем, есть ли директива no-cache
    if (_hasNoCacheDirective(options)) {
      handler.next(options);
      return;
    }

    final cacheKey = _buildCacheKey(options);

    try {
      final cachedResponse =
          await _middleware.getCachedResponse<Map<String, dynamic>>(
        cacheKey,
        (json) => json,
      );

      if (cachedResponse != null) {
        _logger.d('Cache HIT for ${options.method} ${options.path}', metadata: {
          'cacheKey': cacheKey,
        });

        // Создаем ответ из кеша
        final response = Response<dynamic>(
          data: cachedResponse['data'],
          statusCode: cachedResponse['statusCode'] ?? 200,
          statusMessage: cachedResponse['statusMessage'] ?? 'OK',
          headers: Headers.fromMap(
              Map<String, List<String>>.from(cachedResponse['headers'] ?? {})),
          requestOptions: options,
          extra: {'from_cache': true},
        );

        handler.resolve(response);
        return;
      }

      _logger.d('Cache MISS for ${options.method} ${options.path}', metadata: {
        'cacheKey': cacheKey,
      });
    } catch (e) {
      _logger.w('Cache error', error: e);
    }

    // Сохраняем ключ кеша для использования в onResponse
    options.extra['cache_key'] = cacheKey;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final cacheKey = response.requestOptions.extra['cache_key'] as String?;

    if (cacheKey != null && _shouldCacheResponse(response)) {
      try {
        final cacheData = {
          'data': response.data,
          'statusCode': response.statusCode,
          'statusMessage': response.statusMessage,
          'headers': response.headers.map,
        };

        await _middleware.cacheResponse(
          cacheKey,
          cacheData,
          (data) => data,
        );

        _logger.d(
            'Cached response for ${response.requestOptions.method} ${response.requestOptions.path}',
            metadata: {
              'cacheKey': cacheKey,
            });
      } catch (e) {
        _logger.w('Failed to cache response', error: e);
      }
    }

    handler.next(response);
  }

  String _buildCacheKey(RequestOptions options) {
    return CacheKeyBuilder.forApiRequest(
      endpoint: options.path,
      method: options.method,
      queryParams: options.queryParameters,
      headers: _getRelevantHeaders(options.headers),
    );
  }

  Map<String, String> _getRelevantHeaders(Map<String, dynamic> headers) {
    const relevantHeaders = {'accept-language', 'x-api-version'};
    final result = <String, String>{};

    for (final entry in headers.entries) {
      if (relevantHeaders.contains(entry.key.toLowerCase())) {
        result[entry.key] = entry.value.toString();
      }
    }

    return result;
  }

  bool _hasNoCacheDirective(RequestOptions options) {
    return options.headers['cache-control']?.toString().contains('no-cache') ==
            true ||
        options.extra['no_cache'] == true;
  }

  bool _shouldCacheResponse(Response response) {
    // Не кешируем ошибки
    if (response.statusCode == null || response.statusCode! >= 400) {
      return false;
    }

    // Проверяем заголовки cache-control
    final cacheControl = response.headers.value('cache-control');
    if (cacheControl != null &&
        (cacheControl.contains('no-cache') ||
            cacheControl.contains('no-store'))) {
      return false;
    }

    return true;
  }
}

/// Интерсептор для обработки ошибок и их преобразования
class ErrorHandlingInterceptor extends Interceptor {
  final ContextLogger _logger;

  ErrorHandlingInterceptor({
    ContextLogger? logger,
  }) : _logger = logger ?? ContextLogger(context: 'ErrorHandlingInterceptor');

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = ApiExceptionMapper.fromDioException(err);

    _logger.e(
      'API Error: ${apiException.message}',
      metadata: {
        'type': apiException.runtimeType.toString(),
        'statusCode': apiException.statusCode,
        'url': err.requestOptions.uri.toString(),
        'method': err.requestOptions.method,
      },
      error: apiException,
    );

    // Создаем новое DioException с нашим типизированным исключением
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiException,
      message: apiException.message,
      stackTrace: err.stackTrace,
    );

    handler.next(newError);
  }
}

/// Интерсептор для добавления общих заголовков
class HeadersInterceptor extends Interceptor {
  final Map<String, String> _defaultHeaders;
  final String Function()? _getAuthToken;
  final String Function()? _getUserAgent;

  HeadersInterceptor({
    Map<String, String>? defaultHeaders,
    String Function()? getAuthToken,
    String Function()? getUserAgent,
  })  : _defaultHeaders = defaultHeaders ?? {},
        _getAuthToken = getAuthToken,
        _getUserAgent = getUserAgent;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Добавляем базовые заголовки
    for (final entry in _defaultHeaders.entries) {
      options.headers[entry.key] = entry.value;
    }

    // Добавляем User-Agent
    final userAgent = _getUserAgent?.call();
    if (userAgent != null) {
      options.headers[HttpHeaders.userAgentHeader] = userAgent;
    }

    // Добавляем токен авторизации
    final authToken = _getAuthToken?.call();
    if (authToken != null) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $authToken';
    }

    // Добавляем стандартные заголовки если их нет
    options.headers
        .putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');
    options.headers
        .putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');

    handler.next(options);
  }
}

/// Интерсептор для метрик производительности
class MetricsInterceptor extends Interceptor {
  final ContextLogger _logger;
  final Map<String, List<Duration>> _requestTimes = {};
  final Map<String, int> _requestCounts = {};
  final Map<String, int> _errorCounts = {};

  MetricsInterceptor({
    ContextLogger? logger,
  }) : _logger = logger ?? ContextLogger(context: 'MetricsInterceptor');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['metrics_start_time'] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _recordMetrics(response.requestOptions, response.statusCode ?? 0);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _recordMetrics(err.requestOptions, err.response?.statusCode ?? 0,
        isError: true);
    handler.next(err);
  }

  void _recordMetrics(RequestOptions options, int statusCode,
      {bool isError = false}) {
    final startTime = options.extra['metrics_start_time'] as DateTime?;
    if (startTime == null) return;

    final duration = DateTime.now().difference(startTime);
    final endpoint = '${options.method} ${options.path}';

    // Записываем время ответа
    _requestTimes.putIfAbsent(endpoint, () => []).add(duration);

    // Записываем количество запросов
    _requestCounts[endpoint] = (_requestCounts[endpoint] ?? 0) + 1;

    // Записываем количество ошибок
    if (isError || statusCode >= 400) {
      _errorCounts[endpoint] = (_errorCounts[endpoint] ?? 0) + 1;
    }

    // Логируем медленные запросы
    if (duration.inMilliseconds > 5000) {
      // > 5 секунд
      _logger.w('Slow API request detected', metadata: {
        'endpoint': endpoint,
        'duration': '${duration.inMilliseconds}ms',
        'statusCode': statusCode,
      });
    }
  }

  /// Получает статистику по всем endpoint'ам
  Map<String, dynamic> getMetrics() {
    final metrics = <String, dynamic>{};

    for (final endpoint in _requestTimes.keys) {
      final times = _requestTimes[endpoint]!;
      final totalRequests = _requestCounts[endpoint] ?? 0;
      final totalErrors = _errorCounts[endpoint] ?? 0;

      times.sort();
      final avgTime = times.isEmpty
          ? 0
          : times.map((t) => t.inMilliseconds).reduce((a, b) => a + b) /
              times.length;
      final medianTime =
          times.isEmpty ? 0 : times[times.length ~/ 2].inMilliseconds;
      final p95Time = times.isEmpty
          ? 0
          : times[(times.length * 0.95).floor()].inMilliseconds;

      metrics[endpoint] = {
        'totalRequests': totalRequests,
        'totalErrors': totalErrors,
        'errorRate': totalRequests > 0
            ? (totalErrors / totalRequests * 100).toStringAsFixed(2)
            : '0.00',
        'avgResponseTime': '${avgTime.toStringAsFixed(0)}ms',
        'medianResponseTime': '${medianTime}ms',
        'p95ResponseTime': '${p95Time}ms',
        'minResponseTime':
            '${times.isEmpty ? 0 : times.first.inMilliseconds}ms',
        'maxResponseTime': '${times.isEmpty ? 0 : times.last.inMilliseconds}ms',
      };
    }

    return metrics;
  }

  /// Сбрасывает все метрики
  void resetMetrics() {
    _requestTimes.clear();
    _requestCounts.clear();
    _errorCounts.clear();
  }
}