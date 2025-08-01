import 'package:part_catalog/core/api/optimized_api_client_factory.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/parts_catalog/api/optimized_api_client_parts_catalogs.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/optimized_armtek_api_client.dart';

/// Пример использования оптимизированного API клиента Armtek
class ArmtekApiExample {
  static final _logger = AppLoggers.suppliers;

  /// Демонстрирует создание и использование оптимизированного Armtek клиента
  static Future<void> demonstrateArmtekApiUsage() async {
    _logger.i('=== Пример использования оптимизированного Armtek API ===');

    try {
      // 1. Создание оптимизированного клиента через фабрику
      final armtekClient = await OptimizedArmtekApiClient.create(
        connectionMode: ApiConnectionMode.direct,
        username: 'your_username',
        password: 'your_password',
        vkorg: '1000',
      );

      _logger.i('✅ Оптимизированный Armtek клиент создан успешно');

      // 2. Проверка состояния клиента
      final circuitBreakerStatus = armtekClient.getCircuitBreakerStatus();
      _logger.i('Circuit breaker состояние: ${circuitBreakerStatus['state']}');

      // 3. Выполнение health check
      final isHealthy = await armtekClient.performHealthCheck();
      _logger.i('Health check результат: ${isHealthy ? "✅ Healthy" : "❌ Unhealthy"}');

      // 4. Ping сервиса (с автоматическим кэшированием)
      _logger.i('Выполнение ping сервиса...');
      final pingResponse = await armtekClient.pingService();
      
      if (pingResponse.status == 200) {
        _logger.i('✅ Ping успешен: IP ${pingResponse.responseData?.ip}');
      } else {
        _logger.w('❌ Ping неудачен: статус ${pingResponse.status}');
      }

      // 5. Получение списка брендов (с кэшированием на 24 часа)
      _logger.i('Получение списка брендов...');
      final brandsResponse = await armtekClient.getBrandList('1000');
      
      if (brandsResponse.status == 200) {
        final brands = brandsResponse.responseData ?? [];
        _logger.i('✅ Получено ${brands.length} брендов (кэшировано на 24 часа)');
      }

      // 6. Поиск запчастей с retry логикой
      _logger.i('Поиск запчастей с автоматическими повторами...');
      final parts = await armtekClient.getPricesByArticle(
        '1234567890',
        brand: 'BOSCH',
      );
      
      _logger.i('✅ Найдено ${parts.length} предложений');

      // 7. Получение метрик производительности
      final metrics = armtekClient.getMetrics();
      if (metrics != null) {
        _logger.i('📊 Метрики производительности:');
        metrics.forEach((endpoint, stats) {
          _logger.i('  $endpoint: ${stats['avgResponseTime']} avg, ${stats['errorRate']}% errors');
        });
      }

      // 8. Получение статистики кеша
      final cacheStats = armtekClient.getCacheStats();
      if (cacheStats != null) {
        _logger.i('💾 Статистика кэша: ${cacheStats['hitRate']}% hit rate, '
            '${cacheStats['itemCount']} элементов');
      }

      // 9. Освобождение ресурсов
      armtekClient.dispose();
      _logger.i('✅ Ресурсы освобождены');

    } catch (e, stackTrace) {
      _logger.e('❌ Ошибка в примере Armtek API', error: e, stackTrace: stackTrace);
    }
  }
}

/// Пример использования оптимизированного клиента каталогов запчастей
class PartsCatalogApiExample {
  static final _logger = AppLoggers.suppliers;

  /// Демонстрирует создание и использование оптимизированного клиента каталогов
  static Future<void> demonstratePartsCatalogUsage() async {
    _logger.i('=== Пример использования оптимизированного Parts Catalog API ===');

    try {
      // 1. Создание клиента через фабрику
      final catalogClient = OptimizedApiClientPartsCatalogs.create(
        apiKey: 'your_api_key',
        language: 'ru',
      );

      _logger.i('✅ Оптимизированный Parts Catalog клиент создан');

      // 2. Проверка health check
      final isHealthy = await catalogClient.performHealthCheck();
      _logger.i('Health check: ${isHealthy ? "✅ Healthy" : "❌ Unhealthy"}');

      // 3. Получение каталогов (кэшируется на 24 часа)
      _logger.i('Получение списка каталогов...');
      final catalogs = await catalogClient.getCatalogs();
      _logger.i('✅ Получено ${catalogs.length} каталогов (кэшировано на 24 часа)');

      // 4. Получение информации об автомобиле по VIN
      if (catalogs.isNotEmpty) {
        _logger.i('Поиск автомобиля по VIN...');
        final carInfo = await catalogClient.getCarInfo('WVWZZZ1JZ3W386752');
        _logger.i('✅ Найдено ${carInfo.length} автомобилей по VIN');
      }

      // 5. Получение статистики производительности
      final metrics = catalogClient.getMetrics();
      if (metrics != null) {
        _logger.i('📊 Метрики Parts Catalog:');
        metrics.forEach((endpoint, stats) {
          _logger.i('  $endpoint: ${stats['totalRequests']} запросов, '
              '${stats['errorRate']}% ошибок');
        });
      }

      // 6. Очистка кеша при необходимости
      await catalogClient.clearCache();
      _logger.i('🗑️ Кэш очищен');

      // 7. Освобождение ресурсов
      catalogClient.dispose();
      _logger.i('✅ Ресурсы освобождены');

    } catch (e, stackTrace) {
      _logger.e('❌ Ошибка в примере Parts Catalog API', error: e, stackTrace: stackTrace);
    }
  }
}

/// Пример использования ApiClientManager с новой системой
class ApiClientManagerExample {
  static final _logger = AppLoggers.suppliers;

  /// Демонстрирует работу с ApiClientManager
  static Future<void> demonstrateApiClientManager() async {
    _logger.i('=== Пример использования ApiClientManager ===');

    try {
      // 1. Создание менеджера
      final manager = ApiClientManager();
      
      // 2. Инициализация с прямым подключением
      await manager.initialize(
        mode: ApiConnectionMode.direct,
      );
      _logger.i('✅ ApiClientManager инициализирован в режиме direct');

      // 3. Получение оптимизированного клиента
      final optimizedClient = await manager.getOptimizedClient(
        supplierCode: 'armtek',
        username: 'test_user',
        password: 'test_password',
        vkorg: '1000',
      );

      if (optimizedClient != null) {
        _logger.i('✅ Получен оптимизированный клиент');

        // 4. Использование клиента для запроса
        final response = await optimizedClient.get('/ws_ping/index');
        _logger.i('✅ Тестовый запрос выполнен: статус ${response.statusCode}');
      }

      // 5. Получение отчета о состоянии всех API
      final healthReport = manager.generateHealthReport();
      _logger.i('📋 Отчет о состоянии API:');
      _logger.i('  Всего клиентов: ${healthReport['summary']['totalClients']}');
      _logger.i('  Здоровых: ${healthReport['summary']['healthyClients']}');
      _logger.i('  Нездоровых: ${healthReport['summary']['unhealthyClients']}');

      // 6. Выполнение health check для всех клиентов
      final healthResults = await manager.performHealthCheckAll();
      _logger.i('🏥 Результаты health check:');
      healthResults.forEach((clientName, isHealthy) {
        _logger.i('  $clientName: ${isHealthy ? "✅" : "❌"}');
      });

      // 7. Получение статистики производительности
      final performanceStats = manager.getPerformanceStats();
      _logger.i('📊 Статистика производительности:');
      _logger.i('  Всего клиентов: ${performanceStats['totalClients']}');

      // 8. Сброс всех circuit breakers при необходимости
      manager.resetAllCircuitBreakers();
      _logger.i('🔄 Все circuit breakers сброшены');

      // 9. Освобождение ресурсов
      manager.dispose();
      _logger.i('✅ Менеджер завершил работу');

    } catch (e, stackTrace) {
      _logger.e('❌ Ошибка в примере ApiClientManager', error: e, stackTrace: stackTrace);
    }
  }
}

/// Пример мониторинга и диагностики системы
class ApiMonitoringExample {
  static final _logger = AppLoggers.suppliers;

  /// Демонстрирует возможности мониторинга
  static Future<void> demonstrateMonitoring() async {
    _logger.i('=== Пример мониторинга и диагностики API ===');

    try {
      // 1. Получение общей диагностики всех клиентов
      final diagnostics = OptimizedApiClientFactory.getAllDiagnostics();
      _logger.i('🔍 Диагностика системы:');

      diagnostics.forEach((clientName, clientDiagnostics) {
        _logger.i('📋 Клиент: $clientName');
        _logger.i('  Circuit Breaker: ${clientDiagnostics['circuitBreaker']?['state']}');
        _logger.i('  Базовый URL: ${clientDiagnostics['config']?['baseUrl']}');
        
        final metrics = clientDiagnostics['metrics'];
        if (metrics != null) {
          _logger.i('  Метрики доступны: ${metrics.keys.length} endpoint(ов)');
        }

        final cache = clientDiagnostics['cache'];
        if (cache != null) {
          _logger.i('  Кэш: ${cache['hitRate']}% hit rate');
        }
      });

      // 2. Создание отчета о состоянии
      final healthReport = OptimizedApiClientFactory.generateHealthReport();
      _logger.i('📋 Отчет о состоянии системы:');
      _logger.i('  Время: ${healthReport['timestamp']}');
      _logger.i('  Всего клиентов: ${healthReport['summary']['totalClients']}');
      _logger.i('  Здоровых: ${healthReport['summary']['healthyClients']}');
      _logger.i('  Открытых circuit breakers: ${healthReport['summary']['openCircuitBreakers']}');

      // 3. Получение статистики производительности
      final performanceStats = OptimizedApiClientFactory.getPerformanceStats();
      _logger.i('📊 Статистика производительности системы:');
      _logger.i('  Время создания отчета: ${performanceStats['timestamp']}');
      _logger.i('  Всего активных клиентов: ${performanceStats['totalClients']}');

      // 4. Демонстрация экстренного управления
      _logger.i('🚨 Демонстрация экстренного управления:');
      
      // Принудительное закрытие всех circuit breakers
      await OptimizedApiClientFactory.forceCloseAllCircuitBreakers();
      _logger.i('  ✅ Все circuit breakers принудительно закрыты');

      // Очистка всех кешей
      await OptimizedApiClientFactory.clearAllCaches();
      _logger.i('  🗑️ Все кеши очищены');

      // Сброс всех circuit breakers
      OptimizedApiClientFactory.resetAllCircuitBreakers();
      _logger.i('  🔄 Все circuit breakers сброшены');

    } catch (e, stackTrace) {
      _logger.e('❌ Ошибка в примере мониторинга', error: e, stackTrace: stackTrace);
    }
  }
}

/// Главная функция для запуска всех примеров
class ApiOptimizationExamples {
  static final _logger = AppLoggers.suppliers;

  /// Запускает все примеры использования
  static Future<void> runAllExamples() async {
    _logger.i('🚀 Запуск примеров оптимизированной API системы');

    try {
      // 1. Пример Armtek API
      await ArmtekApiExample.demonstrateArmtekApiUsage();

      // 2. Пример Parts Catalog API
      await PartsCatalogApiExample.demonstratePartsCatalogUsage();

      // 3. Пример ApiClientManager
      await ApiClientManagerExample.demonstrateApiClientManager();

      // 4. Пример мониторинга
      await ApiMonitoringExample.demonstrateMonitoring();

      _logger.i('✅ Все примеры выполнены успешно');

    } catch (e, stackTrace) {
      _logger.e('❌ Ошибка при выполнении примеров', error: e, stackTrace: stackTrace);
    }
  }

  /// Пример обработки ошибок с retry и circuit breaker
  static Future<void> demonstrateErrorHandling() async {
    _logger.i('=== Демонстрация обработки ошибок ===');

    try {
      final client = OptimizedApiClientFactory.createSupplierClient(
        supplierCode: 'armtek',
        baseUrl: 'http://invalid-url.test', // Невалидный URL для демонстрации
        connectionMode: ApiConnectionMode.direct,
      );

      // Попытка запроса к недоступному сервису
      // Система автоматически выполнит несколько попыток,
      // а затем откроет circuit breaker
      await client.get('/test');

    } catch (e) {
      _logger.i('✅ Ошибка обработана корректно: ${e.toString()}');
      
      // Проверяем состояние circuit breaker
      final supplierClient = OptimizedApiClientFactory.getSupplierClient('armtek');
      if (supplierClient != null) {
        final status = supplierClient.getCircuitBreakerStatus();
        _logger.i('🔒 Circuit breaker состояние: ${status['state']}');
      }
    }
  }
}

/// Утилиты для тестирования и отладки
class ApiTestingUtils {
  static final _logger = AppLoggers.suppliers;

  /// Симулирует нагрузку на API
  static Future<void> simulateLoad(int requestCount) async {
    _logger.i('🔥 Симуляция нагрузки: $requestCount запросов');

    final client = OptimizedApiClientFactory.createSupplierClient(
      supplierCode: 'armtek',
      baseUrl: 'http://ws.armtek.ru/api',
      connectionMode: ApiConnectionMode.direct,
    );

    final futures = <Future>[];
    
    for (int i = 0; i < requestCount; i++) {
      futures.add(
        client.get('/ws_ping/index').then(
          (response) => response,
          onError: (e) {
            // Игнорируем ошибки для демонстрации
            return null;
          },
        ),
      );
    }

    await Future.wait(futures);
    
    final metrics = client.getMetrics();
    _logger.i('📊 Результаты нагрузочного тестирования:');
    if (metrics != null) {
      metrics.forEach((endpoint, stats) {
        _logger.i('  $endpoint: ${stats['totalRequests']} запросов, '
            '${stats['avgResponseTime']} среднее время');
      });
    }
  }

  /// Демонстрирует работу кеша
  static Future<void> demonstrateCaching() async {
    _logger.i('💾 Демонстрация работы кеша');

    final client = OptimizedApiClientFactory.createSupplierClient(
      supplierCode: 'armtek', 
      baseUrl: 'http://ws.armtek.ru/api',
      connectionMode: ApiConnectionMode.direct,
    );

    // Первый запрос - будет закеширован
    _logger.i('📥 Первый запрос (кэширование)...');
    final start1 = DateTime.now();
    await client.get('/ws_ping/index');
    final duration1 = DateTime.now().difference(start1);
    _logger.i('⏱️ Время первого запроса: ${duration1.inMilliseconds}ms');

    // Второй запрос - из кеша
    _logger.i('📤 Второй запрос (из кеша)...');
    final start2 = DateTime.now();
    await client.get('/ws_ping/index');
    final duration2 = DateTime.now().difference(start2);
    _logger.i('⏱️ Время второго запроса: ${duration2.inMilliseconds}ms');

    final cacheStats = client.getCacheStats();
    if (cacheStats != null) {
      _logger.i('💾 Статистика кеша: ${cacheStats['hitRate']}% hit rate');
    }
  }
}