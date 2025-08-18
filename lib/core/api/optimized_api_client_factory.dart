import 'package:part_catalog/core/api/cache/api_cache.dart';
import 'package:part_catalog/core/api/resilience/circuit_breaker.dart';
import 'package:part_catalog/core/api/resilience/retry_policy.dart';
import 'package:part_catalog/core/api/resilient_api_client.dart';
import 'package:part_catalog/core/utils/context_logger.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';

/// Фабрика для создания оптимизированных API клиентов
/// с поддержкой отказоустойчивости, кэширования и мониторинга
class OptimizedApiClientFactory {
  static final ContextLogger _logger =
      ContextLogger(context: 'OptimizedApiClientFactory');
  static ResilientApiClientManager? _clientManager;

  /// Получает менеджер клиентов (singleton)
  static ResilientApiClientManager get clientManager {
    return _clientManager ??= ResilientApiClientManager(logger: _logger);
  }

  /// Создает оптимизированный Dio клиент для поставщика
  static ResilientApiClient createSupplierClient({
    required String supplierCode,
    required String baseUrl,
    required ApiConnectionMode connectionMode,
    String? username,
    String? password,
    String? proxyUrl,
    String? proxyAuthToken,
    Map<String, String>? additionalHeaders,
  }) {
    final clientName = 'supplier_${supplierCode.toLowerCase()}';

    // Определяем эффективный URL в зависимости от режима
    String effectiveBaseUrl;
    Map<String, String> headers = {};

    switch (connectionMode) {
      case ApiConnectionMode.direct:
        effectiveBaseUrl = baseUrl;
        if (username != null && password != null) {
          // Будет добавлен через HeadersInterceptor
          headers['x-api-username'] = username;
          headers['x-api-password'] = password;
        }
        break;

      case ApiConnectionMode.proxy:
        effectiveBaseUrl = proxyUrl ?? baseUrl;
        if (proxyAuthToken != null) {
          headers['X-Proxy-Auth-Token'] = proxyAuthToken;
        }
        headers['X-Target-Service'] = supplierCode.toLowerCase();
        break;

      // case ApiConnectionMode.hybrid:
      //   // В гибридном режиме начинаем с прокси, fallback на direct
      //   effectiveBaseUrl = proxyUrl ?? baseUrl;
      //   if (proxyAuthToken != null) {
      //     headers['X-Proxy-Auth-Token'] = proxyAuthToken;
      //   }
      //   headers['X-Target-Service'] = supplierCode.toLowerCase();
      //   headers['X-Fallback-Mode'] = 'direct';
      //   break;
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    // Специфичные настройки для разных поставщиков
    RetryConfig retryConfig;
    CircuitBreakerConfig circuitBreakerConfig;
    CacheConfig cacheConfig;

    switch (supplierCode.toLowerCase()) {
      case 'armtek':
        retryConfig = const RetryConfig(
          maxAttempts: 4,
          initialDelay: Duration(milliseconds: 500),
          maxDelay: Duration(seconds: 30),
          backoffMultiplier: 2.0,
          useJitter: true,
          retryableStatusCodes: {408, 429, 500, 502, 503, 504},
        );
        circuitBreakerConfig = const CircuitBreakerConfig(
          failureThreshold: 5,
          timeout: Duration(minutes: 2),
          healthCheckInterval: Duration(seconds: 30),
          successThreshold: 3,
        );
        cacheConfig = const CacheConfig(
          defaultTtl: CachePolicies.pricesAndStock,
          keySpecificTtl: {
            'search': CachePolicies.searchResults,
            'brands': CachePolicies.staticData,
            'stores': CachePolicies.staticData,
            'ping': Duration(minutes: 1),
          },
        );
        break;

      default:
        retryConfig = RetryConfig.networkOptimized;
        circuitBreakerConfig = CircuitBreakerConfig.networkOptimized;
        cacheConfig = const CacheConfig(
          defaultTtl: CachePolicies.pricesAndStock,
          keySpecificTtl: {
            'search': CachePolicies.searchResults,
            'catalog': CachePolicies.productCatalog,
          },
        );
    }

    final config = ResilientApiClientConfig(
      baseUrl: effectiveBaseUrl,
      circuitBreakerName: clientName,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'PartCatalog/1.0 (${supplierCode.toUpperCase()})',
        ...headers,
      },
      retryConfig: retryConfig,
      circuitBreakerConfig: circuitBreakerConfig,
      cacheConfig: cacheConfig,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
    );

    _logger.i('Creating optimized API client for supplier', metadata: {
      'supplierCode': supplierCode,
      'connectionMode': connectionMode.name,
      'baseUrl': effectiveBaseUrl,
      'clientName': clientName,
    });

    return clientManager.getOrCreate(clientName, config);
  }

  /// Создает оптимизированный клиент для каталогов запчастей
  static ResilientApiClient createPartsCatalogClient({
    String baseUrl = 'https://api.parts-catalogs.com/v1',
    String? apiKey,
  }) {
    const clientName = 'parts_catalog';

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'PartCatalog/1.0 (PartsCatalog)',
    };

    if (apiKey != null) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    final config = ResilientApiClientConfig(
      baseUrl: baseUrl,
      circuitBreakerName: clientName,
      defaultHeaders: headers,
      retryConfig: RetryConfig.conservative,
      circuitBreakerConfig: CircuitBreakerConfig.conservative,
      cacheConfig: const CacheConfig(
        defaultTtl: CachePolicies.productCatalog,
        keySpecificTtl: {
          'catalogs': CachePolicies.staticData,
          'models': CachePolicies.staticData,
          'car-info': Duration(hours: 2),
          'groups': Duration(hours: 1),
          'parts': Duration(minutes: 30),
          'prices': CachePolicies.pricesAndStock,
        },
      ),
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 20),
    );

    _logger.i('Creating optimized parts catalog client', metadata: {
      'baseUrl': baseUrl,
      'clientName': clientName,
    });

    return clientManager.getOrCreate(clientName, config);
  }

  /// Создает клиент для внутренних API
  static ResilientApiClient createInternalApiClient({
    required String baseUrl,
    String? authToken,
  }) {
    const clientName = 'internal_api';

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'PartCatalog/1.0 (Internal)',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    final config = ResilientApiClientConfig(
      baseUrl: baseUrl,
      circuitBreakerName: clientName,
      defaultHeaders: headers,
      retryConfig: RetryConfig.aggressive,
      circuitBreakerConfig: CircuitBreakerConfig.aggressive,
      enableCache: false, // Внутренний API обычно не кешируется
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 15),
    );

    _logger.i('Creating optimized internal API client', metadata: {
      'baseUrl': baseUrl,
      'clientName': clientName,
    });

    return clientManager.getOrCreate(clientName, config);
  }

  /// Получает существующий клиент по имени
  static ResilientApiClient? getClient(String clientName) {
    return clientManager.get(clientName);
  }

  /// Получает клиент поставщика по коду
  static ResilientApiClient? getSupplierClient(String supplierCode) {
    final clientName = 'supplier_${supplierCode.toLowerCase()}';
    return clientManager.get(clientName);
  }

  /// Получает клиент каталогов
  static ResilientApiClient? getPartsCatalogClient() {
    return clientManager.get('parts_catalog');
  }

  /// Получает клиент внутренних API
  static ResilientApiClient? getInternalApiClient() {
    return clientManager.get('internal_api');
  }

  /// Выполняет health check для всех клиентов
  static Future<Map<String, bool>> performHealthCheckAll() async {
    _logger.i('Performing health check for all API clients');
    return await clientManager.performHealthCheckAll();
  }

  /// Получает диагностику всех клиентов
  static Map<String, Map<String, dynamic>> getAllDiagnostics() {
    return clientManager.getAllDiagnostics();
  }

  /// Сбрасывает все circuit breakers
  static void resetAllCircuitBreakers() {
    _logger.i('Resetting all circuit breakers');
    clientManager.resetAllCircuitBreakers();
  }

  /// Принудительно закрывает все circuit breakers
  static Future<void> forceCloseAllCircuitBreakers() async {
    _logger.i('Force closing all circuit breakers');
    await clientManager.forceCloseAllCircuitBreakers();
  }

  /// Очищает кеш всех клиентов
  static Future<void> clearAllCaches() async {
    _logger.i('Clearing all caches');
    await clientManager.clearAllCaches();
  }

  /// Создает кастомный клиент с пользовательской конфигурацией
  static ResilientApiClient createCustomClient({
    required String clientName,
    required ResilientApiClientConfig config,
  }) {
    _logger.i('Creating custom API client', metadata: {
      'clientName': clientName,
      'baseUrl': config.baseUrl,
    });

    return clientManager.getOrCreate(clientName, config);
  }

  /// Удаляет клиент
  static void removeClient(String clientName) {
    _logger.i('Removing API client', metadata: {
      'clientName': clientName,
    });

    clientManager.remove(clientName);
  }

  /// Освобождает ресурсы всех клиентов
  static void dispose() {
    _logger.i('Disposing all API clients');
    clientManager.dispose();
    _clientManager = null;
  }

  /// Получает статистику производительности
  static Map<String, dynamic> getPerformanceStats() {
    final diagnostics = getAllDiagnostics();
    final stats = <String, dynamic>{
      'totalClients': diagnostics.length,
      'timestamp': DateTime.now().toIso8601String(),
      'clients': <String, dynamic>{},
    };

    for (final entry in diagnostics.entries) {
      final clientName = entry.key;
      final clientDiagnostics = entry.value;

      stats['clients'][clientName] = {
        'circuitBreakerState': clientDiagnostics['circuitBreaker']?['state'],
        'metrics': clientDiagnostics['metrics'],
        'cacheStats': clientDiagnostics['cache'],
      };
    }

    return stats;
  }

  /// Создает отчет о состоянии API
  static Map<String, dynamic> generateHealthReport() {
    final diagnostics = getAllDiagnostics();
    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'summary': <String, dynamic>{
        'totalClients': diagnostics.length,
        'healthyClients': 0,
        'unhealthyClients': 0,
        'openCircuitBreakers': 0,
      },
      'clients': <String, dynamic>{},
    };

    for (final entry in diagnostics.entries) {
      final clientName = entry.key;
      final clientDiagnostics = entry.value;
      final circuitBreakerState = clientDiagnostics['circuitBreaker']?['state'];

      final isHealthy = circuitBreakerState == 'closed';
      if (isHealthy) {
        report['summary']['healthyClients']++;
      } else {
        report['summary']['unhealthyClients']++;
        if (circuitBreakerState == 'open') {
          report['summary']['openCircuitBreakers']++;
        }
      }

      report['clients'][clientName] = {
        'healthy': isHealthy,
        'circuitBreakerState': circuitBreakerState,
        'baseUrl': clientDiagnostics['config']?['baseUrl'],
        'metrics': clientDiagnostics['metrics'],
      };
    }

    return report;
  }
}
