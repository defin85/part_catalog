import 'package:dio/dio.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart';

import 'base_supplier_api_client.dart';
// import 'implementations/autodoc_api_client.dart'; // Пример
// import 'implementations/exist_api_client.dart';  // Пример

class ApiClientManager {
  final _logger = AppLoggers.suppliers;
  ApiConnectionMode _currentMode = ApiConnectionMode.direct;
  String? _proxyUrl;

  // Экземпляр Dio. Может быть получен через конструктор или service_locator.
  // Для примера, предположим, что он получается из service_locator.
  // Если вы передаете его через конструктор, измените конструктор ApiClientManager.
  final Dio _dio = locator<
      Dio>(); // Предполагается, что Dio зарегистрирован в service_locator

  // Карты для кэширования созданных клиентов (опционально, для производительности)
  final Map<String, BaseSupplierApiClient> _cachedDirectClients = {};
  final Map<String, BaseSupplierApiClient> _cachedProxyClients = {};

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
    // TODO: Инициализировать или переконфигурировать клиентов на основе режима
    _updateClientConfigurations();
  }

  Future<void> switchMode(ApiConnectionMode newMode) async {
    if (_currentMode == newMode) return;
    _logger.i('Switching API connection mode from $_currentMode to $newMode');
    _currentMode = newMode;
    // TODO: Пересоздать/переконфигурировать клиентов
    _updateClientConfigurations();
  }

  Future<void> setProxyUrl(String? url) async {
    if (_proxyUrl == url) return;
    _logger.i('Setting proxy URL to: $url');
    _proxyUrl = url;
    if (_currentMode == ApiConnectionMode.proxy) {
      // TODO: Пересоздать/переконфигурировать клиентов, использующих прокси
      _updateClientConfigurations();
    }
  }

  Future<BaseSupplierApiClient?> getClient({
    required String supplierCode,
    String? username, // Для прямого режима
    String? password, // Для прямого режима
    // String? proxyAuthToken, // Можно добавить для прокси, если требуется
  }) async {
    _logger.d(
        'Getting client for supplier: $supplierCode, mode: $_currentMode, username: $username');

    // Пример для Armtek
    // В реальном приложении здесь может быть фабрика или switch по supplierCode
    if (supplierCode.toLowerCase() == SupplierCode.armtek.code) {
      // Используем константу
      if (_currentMode == ApiConnectionMode.direct) {
        // Для прямого режима, если переданы учетные данные, создаем новый экземпляр.
        // Это полезно для экрана настроек, чтобы проверить новые учетные данные.
        if (username != null && password != null) {
          _logger.i(
              'Creating new ArmtekApiClient (direct) with provided credentials for $supplierCode.');
          return ArmtekApiClient(_dio, username: username, password: password);
        } else {
          // Если учетные данные не переданы, можно вернуть кэшированный/стандартный клиент
          // или создать клиент без учетных данных, если это поддерживается.
          _logger.i(
              'Creating/getting default ArmtekApiClient (direct) for $supplierCode.');
          if (_cachedDirectClients[supplierCode] == null) {
            // Создаем и кэшируем клиент без специфичных учетных данных (если применимо)
            // или с учетными данными, загруженными из настроек по умолчанию.
            // В данном случае, для Armtek обычно требуются учетные данные.
            // Если логика требует всегда передавать username/password для Armtek в direct режиме:
            _logger.w(
                'ArmtekApiClient in direct mode requires username and password.');
            return null; // или выбросить исключение
          }
          return _cachedDirectClients[supplierCode];
        }
      } else if (_currentMode == ApiConnectionMode.proxy) {
        _logger.i(
            'Creating/getting ArmtekApiClient (proxy) for $supplierCode, proxy URL: $_proxyUrl');
        if (_proxyUrl == null || _proxyUrl!.isEmpty) {
          _logger.e('Proxy URL is not set for proxy mode.');
          return null; // Или выбросить исключение
        }
        // Кэшируем прокси-клиент по комбинации supplierCode и _proxyUrl, если URL может меняться
        // Для простоты, кэшируем только по supplierCode, предполагая, что _proxyUrl глобален для режима
        if (_cachedProxyClients[supplierCode] == null) {
          _cachedProxyClients[supplierCode] =
              ArmtekApiClient(_dio, baseUrl: _proxyUrl);
        }
        // Если _proxyUrl мог измениться с момента кэширования, нужно пересоздать клиент
        final cachedClient =
            _cachedProxyClients[supplierCode] as ArmtekApiClient?;
        if (cachedClient?.baseUrl != _proxyUrl) {
          _cachedProxyClients[supplierCode] =
              ArmtekApiClient(_dio, baseUrl: _proxyUrl);
        }
        return _cachedProxyClients[supplierCode];
      }
    }

    _logger.w(
        'Client factory not implemented for supplier: $supplierCode with mode: $_currentMode');
    return null; // Клиент для данного поставщика или режима не найден/не реализован
  }

  /// Возвращает список всех доступных клиентов API в зависимости от текущего режима.
  List<BaseSupplierApiClient> getAllAvailableClients() {
    _logger.d('Getting all available clients for mode: $_currentMode');
    if (_currentMode == ApiConnectionMode.direct) {
      return _cachedDirectClients.values.toList();
    } else if (_currentMode == ApiConnectionMode.proxy) {
      return _cachedProxyClients.values.toList();
    }
    _logger.w('No clients available for mode: $_currentMode');
    return [];
  }

  void _updateClientConfigurations() {
    _logger.i(
        'Updating client configurations for mode: $_currentMode. Clearing caches.');
    // При смене режима или URL прокси, кэшированные клиенты могут стать невалидными
    _cachedDirectClients.clear();
    _cachedProxyClients.clear();

    // Здесь может быть логика предварительного создания "стандартных" клиентов
    // для всех известных поставщиков, если это необходимо.
    // Например, на основе списка `supportedSuppliers` из `supported_suppliers.dart`.
  }

  // TODO: Добавить методы для создания конкретных клиентов ( _createDirectClientFor, _createProxyClientFor)
  // TODO: Добавить метод для получения списка всех известных кодов поставщиков (_getAllKnownSupplierCodes)
}
