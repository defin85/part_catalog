import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/api/optimized_api_client_factory.dart';
import 'package:part_catalog/core/config/global_api_settings_service.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/optimized_armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/providers/parts_search_providers.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimized_api_providers.g.dart';

/// Провайдер для проверки доступности оптимизированной системы
@riverpod
Future<bool> isOptimizedSystemEnabled(Ref ref) async {
  final settingsService = ref.watch(globalApiSettingsServiceProvider);
  return settingsService.getUseOptimizedSystem();
}

/// Провайдер для оптимизированного API менеджера
@riverpod
ApiClientManager optimizedApiClientManager(Ref ref) {
  return locator<ApiClientManager>();
}

/// Провайдер для оптимизированного Armtek клиента
@riverpod
class OptimizedArmtekClient extends _$OptimizedArmtekClient {
  @override
  Future<OptimizedArmtekApiClient?> build(String supplierCode) async {
    // Получаем конфигурацию поставщика
    final config = ref.watch(supplierConfigProvider(supplierCode));
    
    if (config == null || !config.isEnabled || supplierCode != 'armtek') {
      return null;
    }

    try {
      // Создаем оптимизированный клиент
      return await OptimizedArmtekApiClient.create(
        connectionMode: config.apiConfig.connectionMode ?? ApiConnectionMode.direct,
        username: config.apiConfig.credentials?.username,
        password: config.apiConfig.credentials?.password,
        vkorg: config.apiConfig.credentials?.additionalParams?['VKORG'],
        proxyUrl: config.apiConfig.proxyUrl,
        proxyAuthToken: config.apiConfig.proxyAuthToken,
      );
    } catch (e) {
      // Логируем ошибку и возвращаем null
      return null;
    }
  }

  /// Проверяет подключение к API
  Future<bool> testConnection() async {
    final client = await future;
    if (client == null) return false;
    
    try {
      return await client.checkConnection();
    } catch (e) {
      return false;
    }
  }

  /// Выполняет health check
  Future<bool> performHealthCheck() async {
    final client = await future;
    if (client == null) return false;
    
    try {
      return await client.performHealthCheck();
    } catch (e) {
      return false;
    }
  }

  /// Получает метрики производительности
  Future<Map<String, dynamic>?> getMetrics() async {
    final client = await future;
    return client?.getMetrics();
  }

  /// Получает статистику кеша
  Future<Map<String, dynamic>?> getCacheStats() async {
    final client = await future;
    return client?.getCacheStats();
  }

  /// Сбрасывает circuit breaker
  Future<void> resetCircuitBreaker() async {
    final client = await future;
    client?.resetCircuitBreaker();
  }

  /// Очищает кеш
  Future<void> clearCache() async {   
    final client = await future;
    await client?.clearCache();
  }
}

/// Провайдер для поиска запчастей с использованием оптимизированных клиентов
@riverpod
class OptimizedPartsSearch extends _$OptimizedPartsSearch {
  @override
  Future<List<PartPriceModel>> build(OptimizedPartsSearchParams params) async {
    if (params.articleNumber.isEmpty) {
      return [];
    }

    final isOptimizedEnabled = await ref.watch(isOptimizedSystemEnabledProvider.future);
    
    if (!isOptimizedEnabled) {
      // Fallback к старой системе
      return _searchWithLegacySystem(params);
    }

    return _searchWithOptimizedSystem(params);
  }

  /// Поиск с использованием оптимизированной системы
  Future<List<PartPriceModel>> _searchWithOptimizedSystem(
    OptimizedPartsSearchParams params,
  ) async {
    final results = <PartPriceModel>[];
    
    // Получаем активные конфигурации поставщиков
    final configs = ref.read(enabledSupplierConfigsProvider);
    
    for (final config in configs) {
      try {
        switch (config.supplierCode) {
          case 'armtek':
            final client = await ref.read(
              optimizedArmtekClientProvider(config.supplierCode).future,
            );
            
            if (client != null) {
              final prices = await client.getPricesByArticle(
                params.articleNumber,
                brand: params.brand,
              );
              results.addAll(prices);
            }
            break;
          
          // TODO: Добавить другие поставщики
          default:
            // Пропускаем неизвестных поставщиков
            break;
        }
      } catch (e) {
        // Логируем ошибку но продолжаем с другими поставщиками
        continue;
      }
    }

    // Сортируем по цене
    results.sort((a, b) => a.price.compareTo(b.price));
    
    return results;
  }

  /// Fallback к старой системе поиска
  Future<List<PartPriceModel>> _searchWithLegacySystem(
    OptimizedPartsSearchParams params,
  ) async {
    // Используем существующий провайдер
    final legacyParams = PartsSearchParams(
      articleNumber: params.articleNumber,
      brand: params.brand,
    );
    
    return ref.read(partsSearchProvider(legacyParams).future);
  }

  /// Обновляет поиск с новыми параметрами
  void updateSearch(OptimizedPartsSearchParams newParams) {
    ref.invalidate(optimizedPartsSearchProvider(newParams));
  }
}

/// Параметры для оптимизированного поиска запчастей
class OptimizedPartsSearchParams {
  final String articleNumber;
  final String? brand;
  final List<String>? supplierCodes; // Фильтр по поставщикам
  final bool useCache; // Использовать кеш
  
  const OptimizedPartsSearchParams({
    required this.articleNumber,
    this.brand,
    this.supplierCodes,
    this.useCache = true,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptimizedPartsSearchParams &&
          runtimeType == other.runtimeType &&
          articleNumber == other.articleNumber &&
          brand == other.brand &&
          _listEquals(supplierCodes, other.supplierCodes) &&
          useCache == other.useCache;

  @override
  int get hashCode => 
      articleNumber.hashCode ^ 
      brand.hashCode ^ 
      supplierCodes.hashCode ^ 
      useCache.hashCode;
}

/// Утилита для сравнения списков
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null) return false;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Провайдер для системной диагностики
@riverpod
class SystemDiagnostics extends _$SystemDiagnostics {
  @override
  Future<Map<String, dynamic>> build() async {
    final diagnostics = <String, dynamic>{};
    
    // Получаем диагностику от фабрики
    final factoryDiagnostics = OptimizedApiClientFactory.getAllDiagnostics();
    diagnostics.addAll(factoryDiagnostics);
    
    // Добавляем информацию о статусе системы
    final isOptimizedEnabled = await ref.watch(isOptimizedSystemEnabledProvider.future);
    diagnostics['system_status'] = {
      'optimized_enabled': isOptimizedEnabled,
      'active_suppliers': ref.watch(enabledSupplierConfigsProvider).length,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    return diagnostics;
  }

  /// Обновляет диагностику
  void refresh() {
    ref.invalidateSelf();
  }

  /// Получает отчет о состоянии системы
  Future<Map<String, dynamic>> getHealthReport() async {
    return OptimizedApiClientFactory.generateHealthReport();
  }

  /// Получает статистику производительности
  Future<Map<String, dynamic>> getPerformanceStats() async {
    return OptimizedApiClientFactory.getPerformanceStats();
  }

  /// Сбрасывает все circuit breakers
  void resetAllCircuitBreakers() {
    OptimizedApiClientFactory.resetAllCircuitBreakers();
  }

  /// Очищает все кеши
  Future<void> clearAllCaches() async {
    await OptimizedApiClientFactory.clearAllCaches();
  }

  /// Принудительно закрывает все circuit breakers
  Future<void> forceCloseAllCircuitBreakers() async {
    await OptimizedApiClientFactory.forceCloseAllCircuitBreakers();
  }
}

/// Провайдер для мониторинга состояния конкретного поставщика
@riverpod
Future<Map<String, dynamic>> supplierHealthStatus(
  Ref ref,
  String supplierCode,
) async {
  switch (supplierCode) {
    case 'armtek':
      final client = await ref.read(
        optimizedArmtekClientProvider(supplierCode).future,
      );
      
      if (client == null) {
        return {
          'status': 'unavailable',
          'healthy': false,
          'message': 'Client not configured or disabled',
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      final isHealthy = await client.performHealthCheck();
      final metrics = client.getMetrics();
      final cacheStats = client.getCacheStats();
      final circuitBreakerStatus = client.getCircuitBreakerStatus();

      return {
        'status': isHealthy ? 'healthy' : 'unhealthy',
        'healthy': isHealthy,
        'metrics': metrics,
        'cache': cacheStats,
        'circuit_breaker': circuitBreakerStatus,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
    default:
      return {
        'status': 'unknown',
        'healthy': false,
        'message': 'Unknown supplier: $supplierCode',
        'timestamp': DateTime.now().toIso8601String(),
      };
  }
}