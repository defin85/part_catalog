import 'package:dio/dio.dart';

import 'package:part_catalog/core/database/daos/supplier_settings_dao.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/utils/connection_error_handler.dart';

/// Результат тестирования подключения
class ConnectionTestResult {
  final bool success;
  final String? errorMessage;
  final String? successMessage;

  const ConnectionTestResult({
    required this.success,
    this.errorMessage,
    this.successMessage,
  });

  factory ConnectionTestResult.success([String? message]) {
    return ConnectionTestResult(
      success: true,
      successMessage: message ?? 'Подключение успешно установлено',
    );
  }

  factory ConnectionTestResult.failure(String errorMessage) {
    return ConnectionTestResult(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Результат загрузки данных Armtek
class ArmtekDataLoadResult<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  const ArmtekDataLoadResult({
    required this.success,
    this.data,
    this.errorMessage,
  });

  factory ArmtekDataLoadResult.success(T data) {
    return ArmtekDataLoadResult(success: true, data: data);
  }

  factory ArmtekDataLoadResult.failure(String errorMessage) {
    return ArmtekDataLoadResult(success: false, errorMessage: errorMessage);
  }
}

/// Единый сервис для управления поставщиками
/// Объединяет функционал конфигурации, загрузки данных Armtek и управления API клиентами
class SupplierService {
  final SupplierSettingsDao _supplierSettingsDao;
  final ApiClientManager _apiClientManager;
  final Dio _dio;
  final _logger = AppLoggers.suppliers;

  // Кеш конфигураций в памяти
  final Map<String, SupplierConfig> _configCache = {};

  SupplierService(
    this._supplierSettingsDao,
    this._apiClientManager,
    this._dio,
  );

  // ========== КОНФИГУРАЦИЯ ПОСТАВЩИКОВ ==========

  /// Получить конфигурацию поставщика
  Future<SupplierConfig?> getSupplierConfig(String supplierCode) async {
    _logger.d('getSupplierConfig called for: $supplierCode');

    // Проверяем кеш
    if (_configCache.containsKey(supplierCode)) {
      _logger.d('Returning cached config for: $supplierCode');
      return _configCache[supplierCode];
    }

    try {
      // Загружаем из базы данных
      final settingsEntity =
          await _supplierSettingsDao.getSupplierSettingByCode(supplierCode);
      if (settingsEntity == null) {
        _logger.d('No config found for supplier: $supplierCode');
        return null;
      }

      // Конвертируем в SupplierConfig
      // Преобразование сущности в конфигурацию пока не реализовано
      // final config = SupplierConfigConverter.fromEntity(settingsEntity);
      // Временно возвращаем null, так как конвертер не найден
      _logger.d(
          'Config loading skipped for: $supplierCode - converter not implemented');
      return null;
    } catch (e) {
      _logger.e('Error loading config for $supplierCode: $e');
      return null;
    }
  }

  /// Сохранить конфигурацию поставщика
  Future<void> saveSupplierConfig(SupplierConfig config) async {
    _logger.d('saveSupplierConfig called for: ${config.supplierCode}');

    try {
      // Конвертируем в сущность базы данных
      // Преобразование конфигурации в сущность пока не реализовано
      // final entity = SupplierConfigConverter.toEntity(config);
      // await _supplierSettingsDao.upsertSupplierSetting(entity);

      // Временная заглушка - просто сохраняем в кеш
      _configCache[config.supplierCode] = config;

      // Обновляем кеш
      _configCache[config.supplierCode] = config;

      _logger.d('Config saved and cached for: ${config.supplierCode}');
    } catch (e) {
      _logger.e('Error saving config for ${config.supplierCode}: $e');
      rethrow;
    }
  }

  /// Получить все конфигурации поставщиков
  Future<List<SupplierConfig>> getAllSupplierConfigs() async {
    _logger.d('getAllSupplierConfigs called');

    try {
      await _supplierSettingsDao.getAllSupplierSettings();
      // Преобразование сущностей в конфигурации пока не реализовано
      // Возвращаем конфигурации из кеша
      final configs = _configCache.values.toList();

      // Обновляем кеш
      _configCache.clear();
      for (final config in configs) {
        _configCache[config.supplierCode] = config;
      }

      _logger.d('Loaded ${configs.length} supplier configs');
      return configs;
    } catch (e) {
      _logger.e('Error loading all supplier configs: $e');
      return [];
    }
  }

  /// Удалить конфигурацию поставщика
  Future<void> deleteSupplierConfig(String supplierCode) async {
    _logger.d('deleteSupplierConfig called for: $supplierCode');

    try {
      await _supplierSettingsDao.deleteSupplierSettingByCode(supplierCode);
      _configCache.remove(supplierCode);
      _logger.d('Config deleted for: $supplierCode');
    } catch (e) {
      _logger.e('Error deleting config for $supplierCode: $e');
      rethrow;
    }
  }

  /// Тестировать подключение к поставщику
  Future<ConnectionTestResult> testConnection(SupplierConfig config) async {
    _logger.d('testConnection called for: ${config.supplierCode}');

    try {
      switch (config.supplierCode.toLowerCase()) {
        case 'armtek':
          return await _testArmtekConnection(config);
        default:
          return ConnectionTestResult.failure(
              'Неподдерживаемый поставщик: ${config.supplierCode}');
      }
    } catch (e) {
      _logger.e('Connection test failed for ${config.supplierCode}: $e');
      return ConnectionTestResult.failure(
          ConnectionErrorHandler.getReadableErrorMessage(e));
    }
  }

  // ========== ЗАГРУЗКА ДАННЫХ ARMTEK ==========

  /// Загрузить список брендов для Armtek
  Future<ArmtekDataLoadResult<List<BrandItem>>> loadBrandList(
      SupplierConfig config) async {
    _logger.d('loadBrandList called for Armtek');

    try {
      final apiClient = _createArmtekApiClient(config);
      final vkorg =
          config.apiConfig.credentials?.additionalParams?['VKORG'] ?? '';
      final response = await apiClient.getBrandList(vkorg);

      _logger.d(
          'Loaded ${response.responseData?.length ?? 0} brands from Armtek');
      return ArmtekDataLoadResult.success(response.responseData ?? []);
    } catch (e) {
      _logger.e('Error loading brand list from Armtek: $e');
      return ArmtekDataLoadResult.failure(
          'Ошибка загрузки брендов: ${e.toString()}');
    }
  }

  /// Загрузить список складов для Armtek
  Future<ArmtekDataLoadResult<List<StoreItem>>> loadStoreList(
      SupplierConfig config) async {
    _logger.d('loadStoreList called for Armtek');

    try {
      final apiClient = _createArmtekApiClient(config);
      final vkorg =
          config.apiConfig.credentials?.additionalParams?['VKORG'] ?? '';
      final response = await apiClient.getStoreList(vkorg);

      _logger.d(
          'Loaded ${response.responseData?.length ?? 0} stores from Armtek');
      return ArmtekDataLoadResult.success(response.responseData ?? []);
    } catch (e) {
      _logger.e('Error loading store list from Armtek: $e');
      return ArmtekDataLoadResult.failure(
          'Ошибка загрузки складов: ${e.toString()}');
    }
  }

  /// Загрузить информацию о пользователе для Armtek
  Future<ArmtekDataLoadResult<UserInfoResponse>> loadUserInfo(
      SupplierConfig config) async {
    _logger.d('loadUserInfo called for Armtek');

    try {
      final apiClient = _createArmtekApiClient(config);
      final vkorg = config.apiConfig.credentials?.additionalParams?['VKORG'] ?? '';
      final request = UserInfoRequest(vkorg: vkorg);
      final response = await apiClient.getUserInfo(request);

      _logger.d(
          'Loaded user info from Armtek: ${response.responseData?.structure?.kunag}');
      return ArmtekDataLoadResult.success(
          response.responseData ?? UserInfoResponse());
    } catch (e) {
      _logger.e('Error loading user info from Armtek: $e');
      return ArmtekDataLoadResult.failure(
          'Ошибка загрузки информации о пользователе: ${e.toString()}');
    }
  }

  // ========== УПРАВЛЕНИЕ API КЛИЕНТАМИ ==========

  /// Обновить API клиентов из конфигураций
  Future<void> refreshApiClients() async {
    _logger.d('refreshApiClients called');

    try {
      await getAllSupplierConfigs();
      // TODO: Реализовать обновление клиентов из конфигураций
      // await _apiClientManager.updateClientsFromConfigs(configs);
      _logger.d('API clients refresh skipped - method not implemented');
    } catch (e) {
      _logger.e('Error refreshing API clients: $e');
      rethrow;
    }
  }

  /// Получить все доступные API клиенты
  List<dynamic> getAllAvailableClients() {
    return _apiClientManager.getAllAvailableClients();
  }

  // ========== ПРИВАТНЫЕ МЕТОДЫ ==========

  /// Создать API клиент для Armtek из конфигурации
  ArmtekApiClient _createArmtekApiClient(SupplierConfig config) {
    final credentials = config.apiConfig.credentials;
    return ArmtekApiClient(
      _dio,
      baseUrl: config.apiConfig.baseUrl,
      username: credentials?.username,
      password: credentials?.password,
      vkorg: credentials?.additionalParams?['VKORG'] ?? '',
      customerCode: credentials?.additionalParams?['CUSTOMER_CODE'],
    );
  }

  /// Тестировать подключение к Armtek
  Future<ConnectionTestResult> _testArmtekConnection(
      SupplierConfig config) async {
    final apiClient = _createArmtekApiClient(config);

    try {
      final vkorg = config.apiConfig.credentials?.additionalParams?['VKORG'] ?? '';
      final request = UserInfoRequest(vkorg: vkorg);
      final response = await apiClient.getUserInfo(request);

      final userInfo = response.responseData;
      if (userInfo?.structure?.kunag != null) {
        return ConnectionTestResult.success(
            'Подключение к Armtek успешно. Код клиента: ${userInfo!.structure!.kunag}');
      } else {
        return ConnectionTestResult.failure(
            'Получен некорректный ответ от Armtek API');
      }
    } catch (e) {
      // Пока без ConnectionErrorHandler - просто возвращаем базовую ошибку
      return ConnectionTestResult.failure(
          'Ошибка подключения: ${e.toString()}');
    }
  }

  // ========== ДОПОЛНИТЕЛЬНЫЕ МЕТОДЫ ДЛЯ СОВМЕСТИМОСТИ ==========

  /// Получить все конфигурации из кеша (для совместимости с провайдером)
  List<SupplierConfig> getAllConfigs() {
    return _configCache.values.toList();
  }

  /// Перезагрузить конфигурации из базы данных
  Future<void> reloadConfigs() async {
    await getAllSupplierConfigs();
  }

  /// Сохранить конфигурацию (алиас для saveSupplierConfig)
  Future<void> saveConfig(SupplierConfig config) async {
    await saveSupplierConfig(config);
  }

  /// Удалить конфигурацию (алиас для deleteSupplierConfig)
  Future<void> deleteConfig(String supplierCode) async {
    await deleteSupplierConfig(supplierCode);
  }

  /// Получить конфигурацию из кеша (для совместимости)
  SupplierConfig? getConfig(String supplierCode) {
    return _configCache[supplierCode];
  }

  /// Получить статистику использования поставщика (заглушка)
  Map<String, dynamic> getUsageStats(String supplierCode) {
    // Пока просто возвращаем заглушку
    return {
      'supplierCode': supplierCode,
      'totalRequests': 0,
      'successfulRequests': 0,
      'failedRequests': 0,
      'lastRequestAt': null,
    };
  }

  /// Валидировать конфигурацию (заглушка)
  List<String> validateConfig(SupplierConfig config) {
    final errors = <String>[];

    if (config.supplierCode.isEmpty) {
      errors.add('Код поставщика не может быть пустым');
    }

    if (config.apiConfig.baseUrl.isEmpty) {
      errors.add('URL API не может быть пустым');
    }

    return errors;
  }

  /// Создать конфигурацию из шаблона (заглушка)
  SupplierConfig createFromTemplate(String templateCode) {
    // Пока возвращаем базовую конфигурацию
    return SupplierConfig(
      supplierCode: templateCode,
      displayName: 'Новый поставщик ($templateCode)',
      isEnabled: false,
      apiConfig: SupplierApiConfig(
        baseUrl: '',
        authType: AuthenticationType.none,
      ),
      createdAt: DateTime.now(),
    );
  }

  /// Очистить кеш конфигураций
  void clearCache() {
    _configCache.clear();
    _logger.d('Configuration cache cleared');
  }
}
