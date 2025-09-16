import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

/// Оптимизированный конвертер для SupplierConfig с кешированием результатов
class SupplierConfigConverter {
  static final _logger = AppLoggers.suppliers;

  // Кеш для конверсий из БД в модели
  static final Map<String, SupplierConfig> _conversionCache = {};

  // Кеш для валидации base64
  static final Map<String, bool> _base64ValidationCache = {};

  /// Очистить кеши (например, при изменении данных)
  static void clearCaches() {
    _conversionCache.clear();
    _base64ValidationCache.clear();
    _logger.d('Conversion caches cleared');
  }

  /// Конвертировать SupplierConfig в SupplierSettingsItem для БД
  static SupplierSettingsItemsCompanion configToSettingCompanion(
    SupplierConfig config,
  ) {
    return SupplierSettingsItemsCompanion(
      supplierCode: Value(config.supplierCode),
      isEnabled: Value(config.isEnabled),
      encryptedCredentials: Value(_encryptCredentials(config.apiConfig.credentials)),
      lastCheckStatus: Value(config.lastCheckStatus),
      lastCheckMessage: Value(config.lastCheckMessage),
      lastSuccessfulCheckAt: Value(config.lastSuccessfulCheckAt),
      clientIdentifierAtSupplier: Value(config.clientIdentifierAtSupplier),
      additionalConfig: Value(_serializeAdditionalConfig(config)),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Конвертировать SupplierSettingsItem из БД в SupplierConfig с кешированием
  static SupplierConfig? settingToConfig(SupplierSettingsItem setting) {
    // Создаем уникальный ключ для кеша
    final cacheKey = '${setting.id}_${setting.updatedAt.millisecondsSinceEpoch}';

    // Проверяем кеш
    if (_conversionCache.containsKey(cacheKey)) {
      _logger.d('Using cached conversion for: ${setting.supplierCode}');
      return _conversionCache[cacheKey];
    }

    try {
      final config = _convertSettingToConfig(setting);
      if (config != null) {
        _conversionCache[cacheKey] = config;
        _logger.d('Cached conversion result for: ${setting.supplierCode}');
      }
      return config;
    } catch (e, stackTrace) {
      _logger.e('Failed to convert setting to config for ${setting.supplierCode}',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Приватная реализация конверсии
  static SupplierConfig? _convertSettingToConfig(SupplierSettingsItem setting) {
    // Парсинг дополнительной конфигурации
    final additionalConfig = _parseAdditionalConfig(setting.additionalConfig);
    if (additionalConfig == null) return null;

    final apiConfigData = additionalConfig['apiConfig'] as Map<String, dynamic>? ?? {};
    final businessConfigData = additionalConfig['businessConfig'] as Map<String, dynamic>? ?? {};

    // Расшифровка учетных данных
    final credentials = _decryptCredentials(setting.encryptedCredentials);

    // Создание API конфигурации
    final apiConfig = _buildApiConfig(apiConfigData, credentials);
    if (apiConfig == null) return null;

    // Создание бизнес-конфигурации
    final businessConfig = businessConfigData.isNotEmpty
        ? _buildBusinessConfig(businessConfigData)
        : null;

    // Создание финальной конфигурации
    return SupplierConfig(
      supplierCode: setting.supplierCode,
      displayName: additionalConfig['displayName'] as String? ?? setting.supplierCode,
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
  }

  /// Парсинг дополнительной конфигурации
  static Map<String, dynamic>? _parseAdditionalConfig(String? additionalConfigJson) {
    if (additionalConfigJson == null || additionalConfigJson.isEmpty) {
      return {};
    }

    try {
      return json.decode(additionalConfigJson) as Map<String, dynamic>;
    } catch (e) {
      _logger.e('Failed to parse additionalConfig JSON', error: e);
      return {};
    }
  }

  /// Построение API конфигурации
  static SupplierApiConfig? _buildApiConfig(
    Map<String, dynamic> apiConfigData,
    SupplierCredentials? credentials,
  ) {
    try {
      final baseUrl = apiConfigData['baseUrl'] as String? ?? '';
      final authTypeName = apiConfigData['authType'] as String? ?? 'none';

      final authType = AuthenticationType.values.firstWhere(
        (e) => e.name == authTypeName,
        orElse: () => AuthenticationType.none,
      );

      return SupplierApiConfig(
        baseUrl: baseUrl,
        authType: authType,
        credentials: credentials,
        connectionMode: _parseConnectionMode(apiConfigData['connectionMode'] as String?),
        timeout: _parseDuration(apiConfigData['timeout'] as int?),
        retryAttempts: apiConfigData['retryAttempts'] as int?,
        proxyUrl: apiConfigData['proxyUrl'] as String?,
        proxyAuthToken: apiConfigData['proxyAuthToken'] as String?,
        rateLimit: _parseRateLimit(apiConfigData['rateLimit']),
      );
    } catch (e) {
      _logger.e('Failed to build SupplierApiConfig', error: e);
      return null;
    }
  }

  /// Построение бизнес-конфигурации
  static SupplierBusinessConfig? _buildBusinessConfig(
    Map<String, dynamic> businessConfigData,
  ) {
    try {
      return SupplierBusinessConfig.fromJson(businessConfigData);
    } catch (e) {
      _logger.w('Failed to build SupplierBusinessConfig', error: e);
      return null;
    }
  }

  /// Парсинг режима подключения
  static ApiConnectionMode? _parseConnectionMode(String? connectionMode) {
    if (connectionMode == null) return null;
    try {
      return ApiConnectionMode.values.firstWhere(
        (e) => e.name == connectionMode,
      );
    } catch (e) {
      _logger.w('Invalid connectionMode: $connectionMode');
      return ApiConnectionMode.direct;
    }
  }

  /// Парсинг продолжительности
  static Duration? _parseDuration(int? milliseconds) {
    return milliseconds != null ? Duration(milliseconds: milliseconds) : null;
  }

  /// Парсинг лимитов скорости
  static RateLimitConfig? _parseRateLimit(dynamic rateLimitData) {
    if (rateLimitData == null) return null;
    try {
      return RateLimitConfig.fromJson(rateLimitData as Map<String, dynamic>);
    } catch (e) {
      _logger.w('Failed to parse rateLimit', error: e);
      return null;
    }
  }

  /// Сериализация дополнительной конфигурации
  static String _serializeAdditionalConfig(SupplierConfig config) {
    return json.encode({
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
        if (config.apiConfig.rateLimit != null)
          'rateLimit': config.apiConfig.rateLimit!.toJson(),
      },
      'businessConfig': config.businessConfig?.toJson() ?? {},
    });
  }

  /// Шифрование учетных данных
  static String? _encryptCredentials(SupplierCredentials? credentials) {
    if (credentials == null) return null;

    try {
      final credentialsJson = json.encode(credentials.toJson());
      return base64Encode(utf8.encode(credentialsJson));
    } catch (e) {
      _logger.w('Failed to encrypt credentials', error: e);
      return null;
    }
  }

  /// Расшифровка учетных данных с кешированием валидации
  static SupplierCredentials? _decryptCredentials(String? encryptedCredentials) {
    if (encryptedCredentials == null || encryptedCredentials.isEmpty) {
      return null;
    }

    // Проверяем кеш валидации base64
    if (!_base64ValidationCache.containsKey(encryptedCredentials)) {
      _base64ValidationCache[encryptedCredentials] = _isValidBase64(encryptedCredentials);
    }

    if (!_base64ValidationCache[encryptedCredentials]!) {
      _logger.w('Invalid base64 format in encrypted credentials');
      return null;
    }

    try {
      final credentialsJson = utf8.decode(base64Decode(encryptedCredentials));
      final credentialsMap = json.decode(credentialsJson) as Map<String, dynamic>;
      return SupplierCredentials.fromJson(credentialsMap);
    } catch (e) {
      _logger.w('Failed to decrypt credentials', error: e);
      return null;
    }
  }

  /// Проверка валидности base64 (публичный метод)
  static bool isValidBase64(String str) => _isValidBase64(str);

  /// Проверка валидности base64
  static bool _isValidBase64(String str) {
    try {
      if (str.length % 4 != 0) return false;
      if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(str)) return false;
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}