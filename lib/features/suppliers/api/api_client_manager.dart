import 'package:part_catalog/core/utils/logger_config.dart'; // Используем общий логгер
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';

import 'base_supplier_api_client.dart';
// TODO: import 'implementations/armtek_api_client.dart'; // Будет создан позже
// import 'implementations/autodoc_api_client.dart'; // Пример
// import 'implementations/exist_api_client.dart';  // Пример

class ApiClientManager {
  final _logger = AppLoggers.suppliers;
  ApiConnectionMode _currentMode = ApiConnectionMode.direct;
  String? _proxyUrl;

  // TODO: Заменить на реальную логику получения клиентов
  final Map<String, BaseSupplierApiClient> _directClients = {};
  final Map<String, BaseSupplierApiClient> _proxyClients = {};

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

  BaseSupplierApiClient? getClient(String supplierCode) {
    _logger
        .d('Getting client for supplier: $supplierCode, mode: $_currentMode');
    if (_currentMode == ApiConnectionMode.direct) {
      return _directClients[
          supplierCode]; // TODO: Реализовать создание direct клиентов
    } else if (_currentMode == ApiConnectionMode.proxy) {
      // TODO: Реализовать создание proxy клиентов с использованием _proxyUrl
      return _proxyClients[supplierCode];
    }
    _logger.w(
        'Client not found for supplier: $supplierCode with mode: $_currentMode');
    return null;
  }

  /// Возвращает список всех доступных клиентов API в зависимости от текущего режима.
  List<BaseSupplierApiClient> getAllAvailableClients() {
    _logger.d('Getting all available clients for mode: $_currentMode');
    if (_currentMode == ApiConnectionMode.direct) {
      // Если клиенты еще не созданы, их нужно будет создать здесь или в _updateClientConfigurations
      // Пока просто возвращаем зарегистрированные
      if (_directClients.isEmpty) {
        _logger.w('No direct clients registered or created yet.');
        // Возможно, здесь стоит вызвать _updateClientConfigurations() или аналогичный метод,
        // который отвечает за инициализацию клиентов.
        // Для примера, если у вас есть список известных поставщиков:
        // _initializeDirectClientsIfNeeded();
      }
      return _directClients.values.toList();
    } else if (_currentMode == ApiConnectionMode.proxy) {
      // Аналогично для прокси клиентов
      if (_proxyClients.isEmpty) {
        _logger.w('No proxy clients registered or created yet.');
        // _initializeProxyClientsIfNeeded();
      }
      return _proxyClients.values.toList();
    }
    _logger.w('No clients available for mode: $_currentMode');
    return [];
  }

  void registerDirectClient(BaseSupplierApiClient client) {
    _logger.i('Registering direct client for: ${client.supplierCode}');
    _directClients[client.supplierCode] = client;
  }

  void registerProxyClient(BaseSupplierApiClient client) {
    _logger.i('Registering proxy client for: ${client.supplierCode}');
    _proxyClients[client.supplierCode] = client;
  }

  void _updateClientConfigurations() {
    _logger.i('Updating client configurations for mode: $_currentMode');
    // Здесь будет логика пересоздания или переконфигурации клиентов
    // Например, если у нас есть список всех зарегистрированных поставщиков,
    // мы можем пройтись по ним и создать/обновить их клиенты API.

    // Пример:
    // for (var supplierCode in _getAllKnownSupplierCodes()) {
    //   if (_currentMode == ApiConnectionMode.direct) {
    //     _directClients[supplierCode] = _createDirectClientFor(supplierCode);
    //   } else if (_currentMode == ApiConnectionMode.proxy) {
    //     _proxyClients[supplierCode] = _createProxyClientFor(supplierCode, _proxyUrl);
    //   }
    // }
  }

  // TODO: Добавить методы для создания конкретных клиентов ( _createDirectClientFor, _createProxyClientFor)
  // TODO: Добавить метод для получения списка всех известных кодов поставщиков (_getAllKnownSupplierCodes)
}
