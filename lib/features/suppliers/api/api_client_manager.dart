import 'package:part_catalog/core/api/optimized_api_client_factory.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/optimized_armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart';

import 'base_supplier_api_client.dart';

// import 'implementations/autodoc_api_client.dart'; // Пример
// import 'implementations/exist_api_client.dart';  // Пример

class ApiClientManager {
  final _logger = AppLoggers.suppliers;
  ApiConnectionMode _currentMode = ApiConnectionMode.direct;
  String? _proxyUrl;

  // Карта для кэширования оптимизированных клиентов
  final Map<String, OptimizedArmtekApiClient> _optimizedClients = {};

  ApiConnectionMode get currentMode => _currentMode;
  String? get proxyUrl => _proxyUrl;

  Future<void> initialize({
    required ApiConnectionMode mode,
    String? proxyUrl,
  }) async {
    _logger.i(
        'Initializing ApiClientManager with mode: $mode, proxyUrl: $proxyUrl');
    _currentMode = mode;
    _proxyUrl = proxyUrl;
    _updateClientConfigurations();
  }

  Future<void> switchMode(ApiConnectionMode newMode) async {
    if (_currentMode == newMode) return;
    _logger.i('Switching API connection mode from $_currentMode to $newMode');
    _currentMode = newMode;
    _updateClientConfigurations();
  }

  Future<void> setProxyUrl(String? url) async {
    if (_proxyUrl == url) return;
    _logger.i('Setting proxy URL to: $url');
    _proxyUrl = url;
    if (_currentMode == ApiConnectionMode.proxy) {
      _updateClientConfigurations();
    }
  }

  Future<BaseSupplierApiClient?> getClient({
    required String supplierCode,
    String? username,
    String? password,
    String? vkorg,
    String? kunnrRg,
    String? proxyAuthToken,
    bool searchWithCross = true,
    bool exactSearch = false,
  }) async {
    _logger.d(
        'Getting optimized client for supplier: $supplierCode, mode: $_currentMode, username: $username, vkorg: $vkorg');

    if (supplierCode.toLowerCase() == SupplierCode.armtek.code) {
      final clientKey = '${supplierCode.toLowerCase()}_${_currentMode.name}_${username ?? ''}_${vkorg ?? ''}';

      // Проверяем кэш
      if (_optimizedClients.containsKey(clientKey)) {
        return _optimizedClients[clientKey];
      }

      try {
        final optimizedClient = await OptimizedArmtekApiClient.create(
          connectionMode: _currentMode,
          username: username,
          password: password,
          vkorg: vkorg,
          kunnrRg: kunnrRg,
          proxyUrl: _proxyUrl,
          proxyAuthToken: proxyAuthToken,
          searchWithCross: searchWithCross,
          exactSearch: exactSearch,
        );

        // Кэшируем клиент
        _optimizedClients[clientKey] = optimizedClient;
        _logger.i('Created optimized Armtek client for mode: $_currentMode');
        return optimizedClient;
      } catch (e, stackTrace) {
        _logger.e('Failed to create optimized Armtek client',
            error: e, stackTrace: stackTrace);
        return null;
      }
    }

    _logger.w('Client factory not implemented for supplier: $supplierCode');
    return null;
  }

  /// Возвращает список всех доступных клиентов API
  List<BaseSupplierApiClient> getAllAvailableClients() {
    _logger.d('Getting all available clients for mode: $_currentMode');
    return _optimizedClients.values.toList();
  }

  void _updateClientConfigurations() {
    _logger.i(
        'Updating client configurations for mode: $_currentMode. Clearing caches.');
    // При смене режима или URL прокси, кэшированные клиенты могут стать невалидными
    _optimizedClients.clear();
  }


  /// Получает статистику производительности всех клиентов
  Future<Map<String, dynamic>> getPerformanceStats() async {
    return await OptimizedApiClientFactory.getPerformanceStats();
  }

  /// Выполняет health check для всех оптимизированных клиентов
  Future<Map<String, bool>> performHealthCheckAll() async {
    _logger.i('Performing health check for all optimized clients');
    return await OptimizedApiClientFactory.performHealthCheckAll();
  }

  /// Получает отчет о состоянии API
  Future<Map<String, dynamic>> generateHealthReport() async {
    return await OptimizedApiClientFactory.generateHealthReport();
  }

  /// Сбрасывает все circuit breakers
  void resetAllCircuitBreakers() {
    _logger.i('Resetting all circuit breakers');
    OptimizedApiClientFactory.resetAllCircuitBreakers();
  }

  /// Принудительно закрывает все circuit breakers
  Future<void> forceCloseAllCircuitBreakers() async {
    _logger.i('Force closing all circuit breakers');
    await OptimizedApiClientFactory.forceCloseAllCircuitBreakers();
  }

  /// Очищает кеш всех клиентов
  Future<void> clearAllCaches() async {
    _logger.i('Clearing all caches');
    await OptimizedApiClientFactory.clearAllCaches();
  }

  /// Получает диагностику всех клиентов
  Future<Map<String, Map<String, dynamic>>> getAllDiagnostics() async {
    return await OptimizedApiClientFactory.getAllDiagnostics();
  }

  /// Освобождает ресурсы при уничтожении менеджера
  void dispose() {
    _logger.i('Disposing ApiClientManager');
    // Вызываем dispose для всех кэшированных клиентов
    for (final client in _optimizedClients.values) {
      client.dispose();
    }
    _optimizedClients.clear();
  }

}
