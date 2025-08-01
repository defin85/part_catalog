import 'dart:convert';

import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для управления конфигурациями поставщиков
class SupplierConfigService {
  static const String _storageKey = 'supplier_configs';
  final SharedPreferences _prefs;
  final _logger = AppLoggers.suppliers;
  
  // Кеш конфигураций в памяти
  final Map<String, SupplierConfig> _configCache = {};

  SupplierConfigService(this._prefs) {
    _loadConfigs();
  }

  /// Загрузить все конфигурации из хранилища
  void _loadConfigs() {
    try {
      final String? configsJson = _prefs.getString(_storageKey);
      if (configsJson != null) {
        final Map<String, dynamic> configsMap = json.decode(configsJson);
        configsMap.forEach((key, value) {
          _configCache[key] = SupplierConfig.fromJson(value);
        });
        _logger.i('Loaded ${_configCache.length} supplier configurations');
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to load supplier configurations', 
          error: e, stackTrace: stackTrace);
    }
  }

  /// Сохранить все конфигурации в хранилище
  Future<void> _saveConfigs() async {
    try {
      final Map<String, dynamic> configsMap = {};
      _configCache.forEach((key, config) {
        configsMap[key] = config.toJson();
      });
      await _prefs.setString(_storageKey, json.encode(configsMap));
      _logger.d('Saved ${_configCache.length} supplier configurations');
    } catch (e, stackTrace) {
      _logger.e('Failed to save supplier configurations', 
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получить конфигурацию поставщика
  SupplierConfig? getConfig(String supplierCode) {
    return _configCache[supplierCode];
  }

  /// Получить все конфигурации
  List<SupplierConfig> getAllConfigs() {
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
    final updatedConfig = config.copyWith(
      updatedAt: DateTime.now(),
      createdAt: config.createdAt ?? DateTime.now(),
    );
    
    _configCache[config.supplierCode] = updatedConfig;
    await _saveConfigs();
    
    _logger.i('Saved configuration for supplier: ${config.supplierCode}');
  }

  /// Удалить конфигурацию
  Future<void> deleteConfig(String supplierCode) async {
    _configCache.remove(supplierCode);
    await _saveConfigs();
    _logger.i('Deleted configuration for supplier: $supplierCode');
  }

  /// Проверить подключение для конфигурации
  Future<bool> testConnection(SupplierConfig config) async {
    _logger.i('Testing connection for supplier: ${config.supplierCode}');
    
    // TODO: Использовать ApiClientManager для создания клиента и проверки подключения
    // Это требует интеграции с существующей системой
    
    return false;
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
      
      await _saveConfigs();
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