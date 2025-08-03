import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/daos/supplier_settings_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart';
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

/// Сервис для управления конфигурациями поставщиков
/// Использует базу данных для хранения настроек
class SupplierConfigService {
  final SupplierSettingsDao _supplierSettingsDao;
  final _logger = AppLoggers.suppliers;
  
  // Кеш конфигураций в памяти
  final Map<String, SupplierConfig> _configCache = {};

  SupplierConfigService(this._supplierSettingsDao) {
    _logger.i('SupplierConfigService created, initializing...');
    _loadConfigs();
  }
  
  /// Очистить поврежденные данные из базы
  Future<void> cleanupCorruptedData() async {
    try {
      final settings = await _supplierSettingsDao.getAllSupplierSettings();
      for (final setting in settings) {
        if (setting.encryptedCredentials != null && 
            !_isValidBase64(setting.encryptedCredentials!)) {
          _logger.w('Removing corrupted setting for ${setting.supplierCode}');
          await _supplierSettingsDao.deleteSupplierSettingByCode(setting.supplierCode);
        }
      }
      await _loadConfigs(); // Перезагружаем конфигурации
    } catch (e, stackTrace) {
      _logger.e('Failed to cleanup corrupted data', error: e, stackTrace: stackTrace);
    }
  }

  /// Загрузить конфигурации
  Future<void> _loadConfigs() async {
    try {
      await _loadFromDatabase();
      _logger.i('Loaded ${_configCache.length} supplier configurations from database');
    } catch (e, stackTrace) {
      _logger.e('Failed to load supplier configurations', 
          error: e, stackTrace: stackTrace);
    }
  }
  
  /// Принудительно перезагрузить конфигурации из базы данных
  Future<void> reloadConfigs() async {
    _logger.d('Manually reloading configurations from database...');
    await _loadConfigs();
  }

  /// Загрузить конфигурации из базы данных
  Future<void> _loadFromDatabase() async {
    try {
      _logger.d('Loading all settings from database...');
      final settings = await _supplierSettingsDao.getAllSupplierSettings();
      _logger.d('Found ${settings.length} settings in database');
      
      _configCache.clear();
      
      for (final setting in settings) {
        _logger.d('Processing setting: ${setting.supplierCode}');
        _logger.d('Setting data: id=${setting.id}, enabled=${setting.isEnabled}');
        _logger.d('Encrypted credentials length: ${setting.encryptedCredentials?.length ?? 0}');
        _logger.d('Additional config length: ${setting.additionalConfig?.length ?? 0}');
        
        final config = _convertSettingToConfig(setting);
        if (config != null) {
          _configCache[config.supplierCode] = config;
          _logger.d('Successfully converted and cached config for: ${config.supplierCode}');
        } else {
          _logger.w('Failed to convert setting to config for: ${setting.supplierCode}');
        }
      }
      
      _logger.d('Final cache size: ${_configCache.length}');
    } catch (e, stackTrace) {
      _logger.e('Failed to load configurations from database', 
          error: e, stackTrace: stackTrace);
    }
  }


  /// Конвертировать SupplierConfig в SupplierSettingsItem для БД
  SupplierSettingsItemsCompanion _convertConfigToSetting(SupplierConfig config) {
    return SupplierSettingsItemsCompanion(
      supplierCode: Value(config.supplierCode),
      isEnabled: Value(config.isEnabled),
      encryptedCredentials: Value(_encryptCredentials(config.apiConfig.credentials)),
      lastCheckStatus: Value(config.lastCheckStatus),
      lastCheckMessage: Value(config.lastCheckMessage),
      lastSuccessfulCheckAt: Value(config.lastSuccessfulCheckAt),
      clientIdentifierAtSupplier: Value(config.clientIdentifierAtSupplier),
      additionalConfig: Value(json.encode({
        'displayName': config.displayName,
        'description': config.description,
        'apiConfig': {
          'baseUrl': config.apiConfig.baseUrl,
          'authType': config.apiConfig.authType.name,
          'connectionMode': config.apiConfig.connectionMode?.name,
          'timeout': config.apiConfig.timeout?.inMilliseconds,
          'retryAttempts': config.apiConfig.retryAttempts,
          'proxyUrl': config.apiConfig.proxyUrl,
          'proxyAuthToken': config.apiConfig.proxyAuthToken,
          if (config.apiConfig.rateLimit != null) 'rateLimit': config.apiConfig.rateLimit!.toJson(),
        },
        'businessConfig': config.businessConfig?.toJson() ?? {},
      })),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Конвертировать SupplierSettingsItem из БД в SupplierConfig
  SupplierConfig? _convertSettingToConfig(SupplierSettingsItem setting) {
    try {
      _logger.d('Converting setting to config for: ${setting.supplierCode}');
      _logger.d('Setting ID: ${setting.id}, enabled: ${setting.isEnabled}');
      _logger.d('createdAt: ${setting.createdAt}, updatedAt: ${setting.updatedAt}');
      
      Map<String, dynamic> additionalConfig = {};
      if (setting.additionalConfig != null && setting.additionalConfig!.isNotEmpty) {
        _logger.d('Parsing additionalConfig JSON...');
        _logger.d('Raw additionalConfig: ${setting.additionalConfig}');
        try {
          additionalConfig = json.decode(setting.additionalConfig!) as Map<String, dynamic>;
          _logger.d('Parsed additionalConfig keys: ${additionalConfig.keys.toList()}');
        } catch (e) {
          _logger.e('Failed to parse additionalConfig JSON: $e');
          // Продолжаем с пустой конфигурацией
        }
      } else {
        _logger.d('No additionalConfig found, using defaults');
      }
      
      final apiConfigData = additionalConfig['apiConfig'] as Map<String, dynamic>? ?? {};
      final businessConfigData = additionalConfig['businessConfig'] as Map<String, dynamic>? ?? {};
      
      _logger.d('apiConfigData: $apiConfigData');
      _logger.d('businessConfigData: $businessConfigData');
      
      // Расшифровываем учетные данные
      _logger.d('Decrypting credentials...');
      _logger.d('Encrypted credentials: ${setting.encryptedCredentials}');
      SupplierCredentials? credentials;
      try {
        credentials = _decryptCredentials(setting.encryptedCredentials);
        _logger.d('Credentials decrypted successfully: ${credentials != null}');
        if (credentials != null) {
          _logger.d('Credentials username: ${credentials.username?.isNotEmpty}');
          _logger.d('Credentials additionalParams: ${credentials.additionalParams}');
        }
      } catch (e) {
        _logger.e('Failed to decrypt credentials: $e');
        credentials = null;
      }
      
      // Получаем базовые значения с fallback'ами
      final displayName = additionalConfig['displayName'] as String? ?? setting.supplierCode;
      final baseUrl = apiConfigData['baseUrl'] as String? ?? '';
      final authTypeName = apiConfigData['authType'] as String? ?? 'none';
      
      _logger.d('Using displayName: $displayName');
      _logger.d('Using baseUrl: $baseUrl');
      _logger.d('Using authType: $authTypeName');
      
      // Находим AuthenticationType
      AuthenticationType authType;
      try {
        authType = AuthenticationType.values.firstWhere(
          (e) => e.name == authTypeName,
          orElse: () => AuthenticationType.none,
        );
        _logger.d('Found authType: $authType');
      } catch (e) {
        _logger.w('Failed to find authType for $authTypeName, using none: $e');
        authType = AuthenticationType.none;
      }
      
      // Создаем SupplierApiConfig
      SupplierApiConfig apiConfig;
      try {
        apiConfig = SupplierApiConfig(
          baseUrl: baseUrl,
          authType: authType,
          credentials: credentials,
          connectionMode: apiConfigData['connectionMode'] != null
              ? (() {
                  try {
                    return ApiConnectionMode.values.firstWhere(
                      (e) => e.name == apiConfigData['connectionMode'],
                    );
                  } catch (e) {
                    _logger.w('Invalid connectionMode: ${apiConfigData['connectionMode']}');
                    return ApiConnectionMode.direct;
                  }
                })()
              : null,
          timeout: apiConfigData['timeout'] != null 
              ? Duration(milliseconds: apiConfigData['timeout'] as int) 
              : null,
          retryAttempts: apiConfigData['retryAttempts'] as int?,
          proxyUrl: apiConfigData['proxyUrl'] as String?,
          proxyAuthToken: apiConfigData['proxyAuthToken'] as String?,
          rateLimit: apiConfigData['rateLimit'] != null 
              ? (() {
                  try {
                    return RateLimitConfig.fromJson(apiConfigData['rateLimit'] as Map<String, dynamic>);
                  } catch (e) {
                    _logger.w('Failed to parse rateLimit: $e');
                    return null;
                  }
                })()
              : null,
        );
        _logger.d('Created apiConfig with baseUrl: ${apiConfig.baseUrl}');
      } catch (e) {
        _logger.e('Failed to create SupplierApiConfig: $e');
        return null;
      }
      
      // Создаем SupplierBusinessConfig
      SupplierBusinessConfig? businessConfig;
      if (businessConfigData.isNotEmpty) {
        try {
          businessConfig = SupplierBusinessConfig.fromJson(businessConfigData);
          _logger.d('Created businessConfig');
        } catch (e) {
          _logger.w('Failed to create SupplierBusinessConfig: $e');
          businessConfig = null;
        }
      }
      
      // Создаем финальный SupplierConfig
      final config = SupplierConfig(
        supplierCode: setting.supplierCode,
        displayName: displayName,
        description: additionalConfig['description'] as String?,
        isEnabled: setting.isEnabled,
        apiConfig: apiConfig,
        businessConfig: businessConfig,
        lastCheckStatus: setting.lastCheckStatus,
        lastCheckMessage: setting.lastCheckMessage,
        lastSuccessfulCheckAt: setting.lastSuccessfulCheckAt,
        clientIdentifierAtSupplier: setting.clientIdentifierAtSupplier,
        createdAt: setting.createdAt,
        updatedAt: setting.updatedAt,
      );
      
      _logger.d('Successfully created config: ${config.supplierCode}');
      _logger.d('Config displayName: ${config.displayName}');
      _logger.d('Config baseUrl: ${config.apiConfig.baseUrl}');
      _logger.d('Config authType: ${config.apiConfig.authType}');
      _logger.d('Config enabled: ${config.isEnabled}');
      
      return config;
    } catch (e, stackTrace) {
      _logger.e('Failed to convert setting to config for ${setting.supplierCode}', 
          error: e, stackTrace: stackTrace);
      _logger.e('Setting data: id=${setting.id}, supplierCode=${setting.supplierCode}');
      _logger.e('additionalConfig: ${setting.additionalConfig}');
      _logger.e('encryptedCredentials: ${setting.encryptedCredentials}');
      return null;
    }
  }

  /// Простое шифрование учетных данных (базовая реализация)
  String? _encryptCredentials(SupplierCredentials? credentials) {
    if (credentials == null) return null;
    
    try {
      // TODO: Заменить на реальное шифрование в production
      final credentialsJson = json.encode(credentials.toJson());
      return base64Encode(utf8.encode(credentialsJson));
    } catch (e) {
      _logger.w('Failed to encrypt credentials: $e');
      return null;
    }
  }

  /// Простая расшифровка учетных данных (базовая реализация)
  SupplierCredentials? _decryptCredentials(String? encryptedCredentials) {
    if (encryptedCredentials == null || encryptedCredentials.isEmpty) return null;
    
    try {
      // Проверяем, что строка является валидным base64
      if (!_isValidBase64(encryptedCredentials)) {
        _logger.w('Invalid base64 format in encrypted credentials, skipping decryption');
        return null;
      }
      
      // TODO: Заменить на реальную расшифровку в production
      final credentialsJson = utf8.decode(base64Decode(encryptedCredentials));
      final credentialsMap = json.decode(credentialsJson) as Map<String, dynamic>;
      return SupplierCredentials.fromJson(credentialsMap);
    } catch (e) {
      _logger.w('Failed to decrypt credentials: $e');
      return null;
    }
  }
  
  /// Проверяет, является ли строка валидным base64
  bool _isValidBase64(String str) {
    try {
      // base64 строка должна иметь длину, кратную 4
      if (str.length % 4 != 0) return false;
      
      // Проверяем, содержит ли только валидные base64 символы
      if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(str)) return false;
      
      // Пытаемся декодировать
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Сохранить конфигурацию в базу данных
  Future<void> _saveConfigToDatabase(SupplierConfig config) async {
    _logger.d('Converting config to database setting...');
    final setting = _convertConfigToSetting(config);
    _logger.d('Setting created: supplierCode=${setting.supplierCode.value}');
    
    try {
      _logger.d('Calling DAO upsertSupplierSetting...');
      await _supplierSettingsDao.upsertSupplierSetting(setting);
      _logger.d('DAO upsertSupplierSetting completed');
    } catch (e, stackTrace) {
      _logger.e('DAO upsertSupplierSetting failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получить конфигурацию поставщика
  SupplierConfig? getConfig(String supplierCode) {
    final config = _configCache[supplierCode];
    _logger.d('getConfig for $supplierCode: ${config != null ? 'found' : 'null'}');
    _logger.d('Current cache keys: ${_configCache.keys.toList()}');
    return config;
  }

  /// Получить все конфигурации
  List<SupplierConfig> getAllConfigs() {
    _logger.d('getAllConfigs called, cache size: ${_configCache.length}');
    _logger.d('Cache keys: ${_configCache.keys.toList()}');
    return _configCache.values.toList();
  }

  /// Получить только активные конфигурации
  List<SupplierConfig> getEnabledConfigs() {
    return _configCache.values
        .where((config) => config.isEnabled)
        .toList();
  }

  /// Сохранить или обновить конфигурацию
  Future<void> saveConfig(SupplierConfig config) async {
    _logger.i('Starting saveConfig for: ${config.supplierCode}');
    _logger.d('Config data: ${config.toJson()}');
    
    final updatedConfig = config.copyWith(
      updatedAt: DateTime.now(),
      createdAt: config.createdAt ?? DateTime.now(),
    );
    
    _logger.d('Updated config with timestamps: ${updatedConfig.toJson()}');
    
    try {
      // Сохраняем в БД
      _logger.d('Saving to database...');
      await _saveConfigToDatabase(updatedConfig);
      _logger.d('Database save completed');
      
      // Проверяем, что данные действительно сохранились
      _logger.d('Verifying save by reading from database...');
      final savedSetting = await _supplierSettingsDao.getSupplierSettingByCode(config.supplierCode);
      if (savedSetting != null) {
        _logger.d('Verification successful - found saved setting with ID: ${savedSetting.id}');
        
        // Попробуем сконвертировать обратно в config для проверки
        _logger.d('Testing conversion back to config...');
        final reconvertedConfig = _convertSettingToConfig(savedSetting);
        if (reconvertedConfig != null) {
          _logger.d('Verification successful - conversion back to config works');
          // Обновляем кеш проверенным объектом
          _configCache[config.supplierCode] = reconvertedConfig;
          _logger.d('Cache updated with verified config');
        } else {
          _logger.e('Verification failed - cannot convert setting back to config');
          // Все равно обновляем кеш исходным объектом
          _configCache[config.supplierCode] = updatedConfig;
          _logger.d('Cache updated with original config despite conversion issue');
        }
      } else {
        _logger.e('Verification failed - setting not found in database after save');
        // Обновляем кеш в любом случае
        _configCache[config.supplierCode] = updatedConfig;
        _logger.d('Cache updated despite database verification failure');
      }
      
      _logger.i('Successfully saved configuration for supplier: ${config.supplierCode}');
    } catch (e, stackTrace) {
      _logger.e('Failed to save configuration for ${config.supplierCode}', 
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Удалить конфигурацию
  Future<void> deleteConfig(String supplierCode) async {
    // Удаляем из БД
    await _supplierSettingsDao.deleteSupplierSettingByCode(supplierCode);
    
    // Удаляем из кеша
    _configCache.remove(supplierCode);
    
    _logger.i('Deleted configuration for supplier: $supplierCode');
  }

  /// Проверить подключение для конфигурации
  /// Возвращает результат тестирования с сообщением об ошибке
  Future<ConnectionTestResult> testConnection(SupplierConfig config) async {
    _logger.i('Testing connection for supplier: ${config.supplierCode}');
    
    try {
      switch (config.supplierCode.toLowerCase()) {
        case 'armtek':
          return await _testArmtekConnection(config);
        
        default:
          _logger.w('No test implementation for supplier: ${config.supplierCode}');
          return ConnectionTestResult(
            success: false,
            errorMessage: 'Тестирование подключения не поддерживается для поставщика ${config.supplierCode}',
          );
      }
    } catch (e, stackTrace) {
      _logger.e('Connection test failed for ${config.supplierCode}', 
          error: e, stackTrace: stackTrace);
      
      return ConnectionTestResult(
        success: false,
        errorMessage: ConnectionErrorHandler.getReadableErrorMessage(e),
      );
    }
  }

  /// Тестирование подключения к Armtek API
  Future<ConnectionTestResult> _testArmtekConnection(SupplierConfig config) async {
    try {
      final dio = Dio();
      final credentials = config.apiConfig.credentials;
      
      // Создаем API клиент с настройками из конфигурации
      final apiClient = ArmtekApiClient(
        dio,
        baseUrl: config.apiConfig.baseUrl,
        username: credentials?.username,
        password: credentials?.password,
        vkorg: credentials?.additionalParams?['VKORG'],
      );
      
      _logger.d('Testing Armtek connection to: ${config.apiConfig.baseUrl}');
      
      // Используем ping endpoint для проверки подключения
      final response = await apiClient.pingService();
      
      if (response.status == 200) {
        _logger.i('Armtek connection test successful');
        return ConnectionTestResult.success('Подключение к Armtek API успешно установлено');
      } else {
        final errorMessage = response.messages?.isNotEmpty == true 
            ? response.messages!.first.text
            : 'Неизвестная ошибка сервера';
        _logger.w('Armtek connection test failed: $errorMessage');
        return ConnectionTestResult.failure(errorMessage);
      }
    } catch (e) {
      _logger.e('Armtek connection test error: $e');
      return ConnectionTestResult.failure(
        ConnectionErrorHandler.getReadableErrorMessage(e),
      );
    }
  }

  /// Получить статистику использования API
  Map<String, dynamic> getUsageStats(String supplierCode) {
    // TODO: Реализовать отслеживание использования API
    return {
      'dailyUsed': 0,
      'dailyLimit': _configCache[supplierCode]?.apiConfig.rateLimit?.dailyLimit,
      'lastRequest': null,
    };
  }

  /// Экспортировать конфигурации в JSON
  String exportConfigs() {
    final Map<String, dynamic> exportData = {};
    _configCache.forEach((key, config) {
      // Удаляем чувствительные данные при экспорте
      final sanitizedConfig = config.copyWith(
        apiConfig: config.apiConfig.copyWith(
          credentials: const SupplierCredentials(),
        ),
      );
      exportData[key] = sanitizedConfig.toJson();
    });
    return json.encode(exportData);
  }

  /// Импортировать конфигурации из JSON
  Future<void> importConfigs(String jsonString, {bool merge = true}) async {
    try {
      final Map<String, dynamic> importData = json.decode(jsonString);
      
      if (!merge) {
        _configCache.clear();
      }
      
      importData.forEach((key, value) {
        final config = SupplierConfig.fromJson(value);
        if (!merge || !_configCache.containsKey(key)) {
          _configCache[key] = config;
        }
      });
      
      // Сохраняем все конфигурации в БД
      for (final config in _configCache.values) {
        await _saveConfigToDatabase(config);
      }
      _logger.i('Imported ${importData.length} supplier configurations');
    } catch (e, stackTrace) {
      _logger.e('Failed to import supplier configurations', 
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создать конфигурацию из шаблона
  SupplierConfig? createFromTemplate(String templateCode) {
    switch (templateCode) {
      case 'armtek':
        return SupplierConfigFactories.createArmtekConfig(
          username: '',
          password: '',
          vkorg: '',
        );
      case 'autotrade':
        return SupplierConfigFactories.createAutotradeConfig(
          apiKey: '',
        );
      default:
        return null;
    }
  }

  /// Валидация конфигурации
  List<String> validateConfig(SupplierConfig config) {
    final errors = <String>[];
    
    // Базовая валидация
    if (config.supplierCode.isEmpty) {
      errors.add('Код поставщика не может быть пустым');
    }
    if (config.displayName.isEmpty) {
      errors.add('Название поставщика не может быть пустым');
    }
    if (config.apiConfig.baseUrl.isEmpty) {
      errors.add('URL API не может быть пустым');
    }
    
    // Валидация учетных данных в зависимости от типа аутентификации
    final creds = config.apiConfig.credentials;
    switch (config.apiConfig.authType) {
      case AuthenticationType.basic:
        if (creds?.username?.isEmpty ?? true) {
          errors.add('Имя пользователя обязательно для Basic Auth');
        }
        if (creds?.password?.isEmpty ?? true) {
          errors.add('Пароль обязателен для Basic Auth');
        }
        break;
      case AuthenticationType.apiKey:
        if (creds?.apiKey?.isEmpty ?? true) {
          errors.add('API ключ обязателен');
        }
        break;
      case AuthenticationType.bearer:
        if (creds?.token?.isEmpty ?? true) {
          errors.add('Токен обязателен для Bearer Auth');
        }
        break;
      default:
        break;
    }
    
    // Специфичная валидация для поставщиков
    if (config.supplierCode == 'armtek') {
      final vkorg = creds?.additionalParams?['VKORG'];
      if (vkorg?.isEmpty ?? true) {
        errors.add('VKORG обязателен для Armtek');
      }
    }
    
    return errors;
  }
}