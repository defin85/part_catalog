import 'package:dio/dio.dart';
import 'package:part_catalog/core/api/cache/api_cache.dart';
import 'package:part_catalog/core/api/cache/memory_cache.dart';
import 'package:part_catalog/core/api/interceptors/api_interceptors.dart';
import 'package:part_catalog/core/api/resilience/circuit_breaker.dart';
import 'package:part_catalog/core/api/resilience/retry_policy.dart';
import 'package:part_catalog/core/utils/context_logger.dart';

/// Конфигурация для создания resilient API client
class ResilientApiClientConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;
  
  // Retry configuration
  final RetryConfig retryConfig;
  final BackoffStrategy backoffStrategy;
  
  // Circuit breaker configuration
  final CircuitBreakerConfig circuitBreakerConfig;
  final String circuitBreakerName;
  
  // Cache configuration
  final CacheConfig cacheConfig;
  final bool enableCache;
  
  // Logging configuration
  final bool enableLogging;
  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final int maxBodyLogLength;
  
  // Metrics configuration
  final bool enableMetrics;

  const ResilientApiClientConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 60),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.retryConfig = const RetryConfig(),
    this.backoffStrategy = BackoffStrategy.exponential,
    this.circuitBreakerConfig = const CircuitBreakerConfig(),
    required this.circuitBreakerName,
    this.cacheConfig = const CacheConfig(),
    this.enableCache = true,
    this.enableLogging = true,
    this.logRequestHeaders = false,
    this.logRequestBody = true,
    this.logResponseHeaders = false,
    this.logResponseBody = true,
    this.maxBodyLogLength = 1000,
    this.enableMetrics = true,
  });

  /// Предустановленные конфигурации для разных сценариев
  static ResilientApiClientConfig forSupplier({
    required String baseUrl,
    required String supplierName,
  }) {
    return ResilientApiClientConfig(
      baseUrl: baseUrl,
      circuitBreakerName: 'supplier_$supplierName',
      retryConfig: RetryConfig.networkOptimized,
      circuitBreakerConfig: CircuitBreakerConfig.networkOptimized,
      cacheConfig: CacheConfig(
        defaultTtl: CachePolicies.pricesAndStock,
        keySpecificTtl: {
          'products': CachePolicies.productCatalog,
          'search': CachePolicies.searchResults,
        },
      ),
    );
  }

  static ResilientApiClientConfig forPartsCatalog({
    required String baseUrl,
  }) {
    return ResilientApiClientConfig(
      baseUrl: baseUrl,
      circuitBreakerName: 'parts_catalog',
      retryConfig: RetryConfig.conservative,
      circuitBreakerConfig: CircuitBreakerConfig.conservative,
      cacheConfig: CacheConfig(
        defaultTtl: CachePolicies.productCatalog,
        keySpecificTtl: {
          'reference': CachePolicies.staticData,
        },
      ),
    );
  }

  static ResilientApiClientConfig forInternalApi({
    required String baseUrl,
  }) {
    return ResilientApiClientConfig(
      baseUrl: baseUrl,
      circuitBreakerName: 'internal_api',
      retryConfig: RetryConfig.aggressive,
      circuitBreakerConfig: CircuitBreakerConfig.aggressive,
      enableCache: false, // Внутренний API обычно не кешируется
    );
  }
}

/// Resilient API client с интегрированными паттернами отказоустойчивости
class ResilientApiClient {
  final ResilientApiClientConfig config;
  final Dio _dio;
  final RetryPolicy _retryPolicy;
  final CircuitBreaker _circuitBreaker;
  final ApiCache? _cache;
  // final ContextLogger _logger; // Used for creation but not instance methods
  final MetricsInterceptor? _metricsInterceptor;

  ResilientApiClient._({
    required this.config,
    required Dio dio,
    required RetryPolicy retryPolicy,
    required CircuitBreaker circuitBreaker,
    // required ContextLogger logger,
    ApiCache? cache,
    MetricsInterceptor? metricsInterceptor,
  }) : _dio = dio,
       _retryPolicy = retryPolicy,
       _circuitBreaker = circuitBreaker,
       _cache = cache,
       // _logger = logger,
       _metricsInterceptor = metricsInterceptor;

  /// Фабричный метод для создания resilient API client
  static ResilientApiClient create(ResilientApiClientConfig config) {
    final logger = ContextLogger(context: 'ResilientApiClient[${config.circuitBreakerName}]');
    
    // Создаем Dio с базовой конфигурацией
    final dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: config.defaultHeaders,
    ));

    // Создаем компоненты отказоустойчивости
    final retryPolicy = RetryPolicy(
      config: config.retryConfig,
      backoffStrategy: config.backoffStrategy,
      logger: logger,
    );

    final circuitBreaker = CircuitBreaker(
      name: config.circuitBreakerName,
      config: config.circuitBreakerConfig,
      logger: logger,
    );

    final cache = config.enableCache ? MemoryCache(config.cacheConfig) : null;

    // Создаем интерсепторы
    final interceptors = <Interceptor>[];

    // Добавляем заголовки
    interceptors.add(HeadersInterceptor(
      defaultHeaders: config.defaultHeaders,
    ));

    // Добавляем кеширование
    if (config.enableCache && cache != null) {
      interceptors.add(CacheInterceptor(
        cache: cache,
        config: config.cacheConfig,
        logger: logger,
      ));
    }

    // Добавляем логирование
    if (config.enableLogging) {
      interceptors.add(LoggingInterceptor(
        logger: logger,
        logRequestHeaders: config.logRequestHeaders,
        logRequestBody: config.logRequestBody,
        logResponseHeaders: config.logResponseHeaders,
        logResponseBody: config.logResponseBody,
        maxBodyLogLength: config.maxBodyLogLength,
      ));
    }

    // Добавляем метрики
    MetricsInterceptor? metricsInterceptor;
    if (config.enableMetrics) {
      metricsInterceptor = MetricsInterceptor(logger: logger);
      interceptors.add(metricsInterceptor);
    }

    // Добавляем обработку ошибок
    interceptors.add(ErrorHandlingInterceptor(logger: logger));

    // Добавляем retry интерсептор
    interceptors.add(RetryInterceptor(
      retryPolicy: retryPolicy,
      logger: logger,
    ));

    // Устанавливаем интерсепторы в Dio
    dio.interceptors.addAll(interceptors);

    return ResilientApiClient._(
      config: config,
      dio: dio,
      retryPolicy: retryPolicy,
      circuitBreaker: circuitBreaker,
      // logger: logger,
      cache: cache,
      metricsInterceptor: metricsInterceptor,
    );
  }

  /// Выполняет GET запрос с отказоустойчивостью
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _executeWithResilience(
      () => _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
      operationName: 'GET $path',
      metadata: {
        'method': 'GET',
        'path': path,
        'endpoint': '${config.baseUrl}$path',
      },
    );
  }

  /// Выполняет POST запрос с отказоустойчивостью
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _executeWithResilience(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      operationName: 'POST $path',
      metadata: {
        'method': 'POST',
        'path': path,
        'endpoint': '${config.baseUrl}$path',
      },
    );
  }

  /// Выполняет PUT запрос с отказоустойчивостью
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _executeWithResilience(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
      operationName: 'PUT $path',
      metadata: {
        'method': 'PUT',
        'path': path,
        'endpoint': '${config.baseUrl}$path',
      },
    );
  }

  /// Выполняет DELETE запрос с отказоустойчивостью
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _executeWithResilience(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      operationName: 'DELETE $path',
      metadata: {
        'method': 'DELETE',
        'path': path,
        'endpoint': '${config.baseUrl}$path',
      },
    );
  }

  /// Выполняет операцию с применением всех паттернов отказоустойчивости
  Future<T> _executeWithResilience<T>(
    Future<T> Function() operation, {
    required String operationName,
    required Map<String, dynamic> metadata,
  }) {
    return _circuitBreaker.execute(
      () => _retryPolicy.execute(
        operation,
        operationName: operationName,
        metadata: metadata,
      ),
      operationName: operationName,
      metadata: metadata,
    );
  }

  /// Получает статус circuit breaker
  Map<String, dynamic> getCircuitBreakerStatus() {
    return _circuitBreaker.getStatus();
  }

  /// Получает метрики производительности
  Map<String, dynamic>? getMetrics() {
    return _metricsInterceptor?.getMetrics();
  }

  /// Получает статистику кеша
  Map<String, dynamic>? getCacheStats() {
    final cache = _cache;
    if (cache is MemoryCache) {
      return cache.getStats();
    }
    return null;
  }

  /// Очищает кеш
  Future<void> clearCache() async {
    await _cache?.clear();
  }

  /// Сбрасывает circuit breaker
  void resetCircuitBreaker() {
    _circuitBreaker.reset();
  }

  /// Сбрасывает метрики
  void resetMetrics() {
    _metricsInterceptor?.resetMetrics();
  }

  /// Принудительно закрывает circuit breaker
  Future<void> forceCloseCircuitBreaker() async {
    await _circuitBreaker.forceState(CircuitBreakerState.closed, reason: 'manual_close');
  }

  /// Принудительно открывает circuit breaker
  Future<void> forceOpenCircuitBreaker() async {
    await _circuitBreaker.forceState(CircuitBreakerState.open, reason: 'manual_open');
  }

  /// Выполняет health check для circuit breaker
  Future<bool> performHealthCheck({
    String? testEndpoint,
  }) async {
    final endpoint = testEndpoint ?? '/health';
    
    return _circuitBreaker.healthCheck(() async {
      final response = await _dio.get(endpoint);
      if (response.statusCode != 200) {
        throw Exception('Health check failed with status ${response.statusCode}');
      }
    });
  }

  /// Получает полную диагностическую информацию
  Map<String, dynamic> getDiagnostics() {
    return {
      'config': {
        'baseUrl': config.baseUrl,
        'circuitBreakerName': config.circuitBreakerName,
        'enableCache': config.enableCache,
        'enableLogging': config.enableLogging,
        'enableMetrics': config.enableMetrics,
      },
      'circuitBreaker': getCircuitBreakerStatus(),
      'metrics': getMetrics(),
      'cache': getCacheStats(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Освобождает ресурсы
  void dispose() {
    _circuitBreaker.dispose();
    _dio.close();
  }
}

/// Менеджер для управления несколькими resilient API clients
class ResilientApiClientManager {
  final Map<String, ResilientApiClient> _clients = {};
  final ContextLogger _logger;

  ResilientApiClientManager({
    ContextLogger? logger,
  }) : _logger = logger ?? ContextLogger(context: 'ResilientApiClientManager');

  /// Создает или получает API client
  ResilientApiClient getOrCreate(
    String name,
    ResilientApiClientConfig config,
  ) {
    return _clients.putIfAbsent(name, () {
      _logger.d('Creating new resilient API client', metadata: {
        'name': name,
        'baseUrl': config.baseUrl,
      });
      
      return ResilientApiClient.create(config);
    });
  }

  /// Получает существующий API client
  ResilientApiClient? get(String name) {
    return _clients[name];
  }

  /// Удаляет API client
  void remove(String name) {
    final client = _clients.remove(name);
    client?.dispose();
    
    _logger.d('Removed resilient API client', metadata: {
      'name': name,
    });
  }

  /// Получает диагностику всех clients
  Map<String, Map<String, dynamic>> getAllDiagnostics() {
    final result = <String, Map<String, dynamic>>{};
    
    for (final entry in _clients.entries) {
      result[entry.key] = entry.value.getDiagnostics();
    }
    
    return result;
  }

  /// Выполняет health check для всех clients
  Future<Map<String, bool>> performHealthCheckAll() async {
    final result = <String, bool>{};
    
    for (final entry in _clients.entries) {
      try {
        result[entry.key] = await entry.value.performHealthCheck();
      } catch (e) {
        result[entry.key] = false;
      }
    }
    
    return result;
  }

  /// Сбрасывает все circuit breakers
  void resetAllCircuitBreakers() {
    _logger.i('Resetting all circuit breakers');
    
    for (final client in _clients.values) {
      client.resetCircuitBreaker();
    }
  }

  /// Принудительно закрывает все circuit breakers
  Future<void> forceCloseAllCircuitBreakers() async {
    _logger.i('Force closing all circuit breakers');
    
    for (final client in _clients.values) {
      await client.forceCloseCircuitBreaker();
    }
  }

  /// Очищает кеш всех clients
  Future<void> clearAllCaches() async {
    _logger.i('Clearing all caches');
    
    for (final client in _clients.values) {
      await client.clearCache();
    }
  }

  /// Освобождает ресурсы всех clients
  void dispose() {
    for (final client in _clients.values) {
      client.dispose();
    }
    _clients.clear();
  }
}