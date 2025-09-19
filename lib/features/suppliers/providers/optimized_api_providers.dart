import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/api/optimized_api_client_factory.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/optimized_armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/utils/user_friendly_exception.dart';
import 'package:part_catalog/features/suppliers/providers/supplier_config_provider.dart';
import 'package:part_catalog/features/suppliers/utils/user_info_helper.dart';

part 'optimized_api_providers.g.dart';

/// Получить правильный KUNNR_RG для заданного VKORG
String? _getKunnrRgForVkorg(SupplierConfig config) {
  // Сначала пытаемся получить из сохраненной userInfo
  final defaultPayer = UserInfoHelper.getDefaultPayer(config);
  if (defaultPayer?.kunnr != null) {
    return defaultPayer!.kunnr;
  }

  // Fallback: используем customerCode как KUNAG (если нет сохраненных данных)
  return config.businessConfig?.customerCode;
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
    // Не даём провайдеру схлопываться во время загрузки/использования
    ref.keepAlive();
    // Получаем конфигурацию поставщика
    final configAsync = ref.watch(supplierConfigProvider(supplierCode));

    return configAsync.when(
      data: (config) {
        if (config == null || !config.isEnabled || supplierCode != 'armtek') {
          return null;
        }
        try {
          // Создаем оптимизированный клиент
          return OptimizedArmtekApiClient.create(
            connectionMode:
                config.apiConfig.connectionMode ?? ApiConnectionMode.direct,
            username: config.apiConfig.credentials?.username,
            password: config.apiConfig.credentials?.password,
            vkorg: config.apiConfig.credentials?.additionalParams?['VKORG'],
            kunnrRg: _getKunnrRgForVkorg(config),
            proxyUrl: config.apiConfig.proxyUrl,
            proxyAuthToken: config.apiConfig.proxyAuthToken,
            searchWithCross: config.businessConfig?.searchWithCross ?? true,
            exactSearch: config.businessConfig?.exactSearch ?? false,
          );
        } catch (e) {
          // Логируем ошибку и возвращаем null
          return null;
        }
      },
      loading: () => null,
      error: (err, stack) => null,
    );
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

/// Провайдер для поиска запчастей
@riverpod
class PartsSearch extends _$PartsSearch {
  final _logger = AppLoggers.suppliers;

  @override
  Future<List<PartPriceModel>> build(PartsSearchParams params) async {
    // Сохраняем инстанс провайдера между переходами экранов,
    // чтобы при возврате не выполнять запрос заново
    ref.keepAlive();
    _logger.i(
        'Optimized search started for article: ${params.articleNumber}, brand: ${params.brand}');

    if (params.articleNumber.isEmpty) {
      return [];
    }

    return _searchWithSuppliers(params);
  }

  /// Поиск запчастей у поставщиков
  Future<List<PartPriceModel>> _searchWithSuppliers(
    PartsSearchParams params,
  ) async {
    // Дожидаемся загрузки конфигураций из БД и фильтруем включённых поставщиков
    final allConfigs = await ref.watch(supplierConfigsProvider.future);
    final configs = allConfigs.where((c) => c.isEnabled).toList();
    _logger
        .d('Searching with ${configs.length} enabled suppliers (after load).');

    final searchFutures =
        configs.map<Future<List<PartPriceModel>>>((config) async {
      _logger.d('Querying supplier: ${config.supplierCode}');
      try {
        switch (config.supplierCode) {
          case 'armtek':
            final client = await ref.watch(
              optimizedArmtekClientProvider(config.supplierCode).future,
            );

            if (client != null) {
              final prices = await client.getPricesByArticle(
                params.articleNumber,
                brand: params.brand,
              );
              _logger.d(
                  'Found ${prices.length} offers from ${config.supplierCode}');
              return prices;
            } else {
              _logger.w(
                  'Optimized client for ${config.supplierCode} is null. Skipping search.');
            }
            break;

          // TODO: Добавить другие поставщики
          default:
            _logger.w(
                'No search implementation for supplier: ${config.supplierCode}');
            break;
        }
      } catch (e, stackTrace) {
        // Для дружественных пользователю ошибок пробрасываем дальше, чтобы UI показал их
        if (e is UserFriendlyException) {
          rethrow;
        }
        _logger.e(
          'Failed to get prices from supplier: ${config.supplierCode}',
          error: e,
          stackTrace: stackTrace,
        );
      }
      return <PartPriceModel>[]; // Return empty list on error or if no client
    }).toList();

    final resultsOfLists = await Future.wait(searchFutures);
    final results = resultsOfLists.expand((list) => list).toList();

    // Сортируем по цене
    results.sort((a, b) => a.price.compareTo(b.price));
    _logger.i('Search finished. Found ${results.length} total offers.');

    return results;
  }


  /// Обновляет поиск с новыми параметрами
  void updateSearch(PartsSearchParams newParams) {
    ref.invalidate(partsSearchProvider(newParams));
  }
}

/// Параметры для поиска запчастей
class PartsSearchParams {
  final String articleNumber;
  final String? brand;
  final List<String>? supplierCodes; // Фильтр по поставщикам
  final bool useCache; // Использовать кеш

  const PartsSearchParams({
    required this.articleNumber,
    this.brand,
    this.supplierCodes,
    this.useCache = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartsSearchParams &&
          runtimeType == other.runtimeType &&
          articleNumber == other.articleNumber &&
          brand == other.brand &&
          _listEquals(supplierCodes, other.supplierCodes) &&
          useCache == other.useCache;

  @override
  int get hashCode =>
      articleNumber.hashCode ^
      (brand?.hashCode ?? 0) ^
      (supplierCodes?.hashCode ?? 0) ^
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
    final factoryDiagnostics =
        await OptimizedApiClientFactory.getAllDiagnostics();
    diagnostics.addAll(factoryDiagnostics);

    // Добавляем информацию о статусе системы
    diagnostics['system_status'] = {
      'optimized_enabled': true, // Всегда используем оптимизированную систему
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
  final client = await ref.watch(
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

  // Запускаем все проверки параллельно
  final results = await Future.wait([
    client.performHealthCheck(),
    client.getMetrics(),
    client.getCacheStats(),
    client.getCircuitBreakerStatus(),
  ]);

  final isHealthy = results[0] as bool;
  final metrics = results[1] as Map<String, dynamic>?;
  final cacheStats = results[2] as Map<String, dynamic>?;
  final circuitBreakerStatus = results[3] as Map<String, dynamic>;

  return {
    'status': isHealthy ? 'healthy' : 'unhealthy',
    'healthy': isHealthy,
    'metrics': metrics,
    'cache': cacheStats,
    'circuit_breaker': circuitBreakerStatus,
    'timestamp': DateTime.now().toIso8601String(),
  };
}
