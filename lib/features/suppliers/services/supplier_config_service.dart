import 'dart:convert';

import 'package:part_catalog/core/database/daos/supplier_settings_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/services/armtek_data_loader.dart';
import 'package:part_catalog/features/suppliers/utils/connection_error_handler.dart';
import 'package:part_catalog/features/suppliers/utils/supplier_config_converter.dart';

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
  // Armtek загрузчик данных (для тестирования подключения)
  late final ArmtekDataLoader _armtekDataLoader;

  SupplierConfigService(this._supplierSettingsDao) {
    _logger.i('SupplierConfigService created, initializing...');
    _armtekDataLoader = ArmtekDataLoader();
    _loadConfigs();
  }

  /// Очистить поврежденные данные из базы
  Future<void> cleanupCorruptedData() async {
    try {
      final settings = await _supplierSettingsDao.getAllSupplierSettings();
      for (final setting in settings) {
        if (setting.encryptedCredentials != null &&
            !SupplierConfigConverter.isValidBase64(setting.encryptedCredentials!)) {
          _logger.w('Removing corrupted setting for ${setting.supplierCode}');
          await _supplierSettingsDao
              .deleteSupplierSettingByCode(setting.supplierCode);
        }
      }
      await _loadConfigs(); // Перезагружаем конфигурации
    } catch (e, stackTrace) {
      _logger.e('Failed to cleanup corrupted data',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Загрузить конфигурации
  Future<void> _loadConfigs() async {
    try {
      await _loadFromDatabase();
      _logger.i(
          'Loaded ${_configCache.length} supplier configurations from database');
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

        final config = SupplierConfigConverter.settingToConfig(setting);
        if (config != null) {
          _configCache[config.supplierCode] = config;
          _logger.d('Successfully cached config for: ${config.supplierCode}');
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
  static SupplierSettingsItemsCompanion _convertConfigToSetting(
      SupplierConfig config) {
    return SupplierConfigConverter.configToSettingCompanion(config);
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
      _logger.e('DAO upsertSupplierSetting failed',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получить конфигурацию поставщика
  SupplierConfig? getConfig(String supplierCode) {
    final config = _configCache[supplierCode];
    _logger
        .d('getConfig for $supplierCode: ${config != null ? 'found' : 'null'}');
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
    return _configCache.values.where((config) => config.isEnabled).toList();
  }

  /// Сохранить или обновить конфигурацию
  Future<void> saveConfig(SupplierConfig config) async {
    _logger.i('Starting saveConfig for: ${config.supplierCode}');
    _logger.d('Config summary: enabled=${config.isEnabled}, '
        'brands=${config.businessConfig?.brandList?.length ?? 0}, '
        'stores=${config.businessConfig?.storeList?.length ?? 0}, '
        'hasAdditionalParams=${config.businessConfig?.additionalParams?.isNotEmpty ?? false}');

    final updatedConfig = config.copyWith(
      updatedAt: DateTime.now(),
      createdAt: config.createdAt ?? DateTime.now(),
    );

    _logger.d('Config updated with timestamps');

    try {
      // Сохраняем в БД
      _logger.d('Saving to database...');
      await _saveConfigToDatabase(updatedConfig);
      _logger.d('Database save completed');

      // Проверяем, что данные действительно сохранились
      _logger.d('Verifying save by reading from database...');
      final savedSetting = await _supplierSettingsDao
          .getSupplierSettingByCode(config.supplierCode);
      if (savedSetting != null) {
        _logger.d(
            'Verification successful - found saved setting with ID: ${savedSetting.id}');

        // Попробуем сконвертировать обратно в config для проверки
        _logger.d('Testing conversion back to config...');
        final reconvertedConfig = SupplierConfigConverter.settingToConfig(savedSetting);
        if (reconvertedConfig != null) {
          _logger
              .d('Verification successful - conversion back to config works');
          // Обновляем кеш проверенным объектом
          _configCache[config.supplierCode] = reconvertedConfig;
          _logger.d('Cache updated with verified config');
        } else {
          _logger
              .e('Verification failed - cannot convert setting back to config');
          // Все равно обновляем кеш исходным объектом
          _configCache[config.supplierCode] = updatedConfig;
          _logger
              .d('Cache updated with original config despite conversion issue');
        }
      } else {
        _logger.e(
            'Verification failed - setting not found in database after save');
        // Обновляем кеш в любом случае
        _configCache[config.supplierCode] = updatedConfig;
        _logger.d('Cache updated despite database verification failure');
      }

      _logger.i(
          'Successfully saved configuration for supplier: ${config.supplierCode}');
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
          _logger
              .w('No test implementation for supplier: ${config.supplierCode}');
          return ConnectionTestResult(
            success: false,
            errorMessage:
                'Тестирование подключения не поддерживается для поставщика ${config.supplierCode}',
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
  Future<ConnectionTestResult> _testArmtekConnection(
      SupplierConfig config) async {
    try {
      _logger.d('Testing Armtek connection to: ${config.apiConfig.baseUrl}');

      final result = await _armtekDataLoader.testConnection(config);

      if (result.success) {
        _logger.i('Armtek connection test successful');
        return ConnectionTestResult.success(
            'Подключение к Armtek API успешно установлено');
      } else {
        _logger.w('Armtek connection test failed: ${result.errorMessage}');
        return ConnectionTestResult.failure(
          result.errorMessage ?? 'Неизвестная ошибка сервера',
        );
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
