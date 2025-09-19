import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config_form_state.dart';
import 'package:part_catalog/features/suppliers/services/supplier_service.dart';
import 'package:part_catalog/features/suppliers/services/armtek_data_loader.dart';

part 'supplier_config_provider.g.dart';

/// Провайдер для сервиса управления поставщиками
@riverpod
SupplierService supplierService(Ref ref) {
  return locator<SupplierService>();
}

/// Провайдер для списка всех конфигураций поставщиков
@riverpod
class SupplierConfigs extends _$SupplierConfigs {
  late final SupplierService _service;

  @override
  Future<List<SupplierConfig>> build() async {
    // Делаем провайдер долгоживущим, чтобы не перезагружать конфиги при каждом входе в экран
    ref.keepAlive();
    _service = ref.watch(supplierServiceProvider);

    // Не перезагружаем из БД без необходимости: если кэш уже есть — используем его
    final cached = _service.getAllConfigs();
    if (cached.isNotEmpty) {
      return cached;
    }

    // Иначе — одна инициализирующая загрузка
    await _service.reloadConfigs();
    return _service.getAllConfigs();
  }

  /// Добавить или обновить конфигурацию
  Future<void> saveConfig(SupplierConfig config) async {
    state = const AsyncValue.loading();

    try {
      await _service.saveConfig(config);
      // Сначала принудительно перезагружаем данные из базы
      await _service.reloadConfigs();
      // Затем обновляем состояние провайдера
      state = AsyncValue.data(_service.getAllConfigs());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Удалить конфигурацию
  Future<void> deleteConfig(String supplierCode) async {
    state = const AsyncValue.loading();

    try {
      await _service.deleteConfig(supplierCode);
      state = AsyncValue.data(_service.getAllConfigs());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Переключить состояние активности поставщика
  Future<void> toggleEnabled(String supplierCode) async {
    final config = _service.getConfig(supplierCode);
    if (config != null) {
      await saveConfig(config.copyWith(isEnabled: !config.isEnabled));
    }
  }

  /// Проверить подключение
  Future<bool> testConnection(SupplierConfig config) async {
    try {
      final result = await _service.testConnection(config);
      return result.success;
    } catch (e) {
      return false;
    }
  }
}

/// Провайдер для получения конфигурации конкретного поставщика
@riverpod
Future<SupplierConfig?> supplierConfig(
  Ref ref,
  String supplierCode,
) async {
  // Ждем загрузки всех конфигураций
  final configs = await ref.watch(supplierConfigsProvider.future);
  try {
    return configs.firstWhere(
      (config) => config.supplierCode == supplierCode,
    );
  } catch (e) {
    // Конфигурация не найдена
    return null;
  }
}

/// Провайдер для списка активных конфигураций
@riverpod
List<SupplierConfig> enabledSupplierConfigs(Ref ref) {
  final configs = ref.watch(supplierConfigsProvider);

  return configs.when(
    data: (configs) => configs.where((c) => c.isEnabled).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Провайдер для статистики использования API
@riverpod
Map<String, dynamic> supplierUsageStats(
  Ref ref,
  String supplierCode,
) {
  final service = ref.watch(supplierServiceProvider);
  return service.getUsageStats(supplierCode);
}

/// Провайдер для управления формой конфигурации
@riverpod
class SupplierConfigForm extends _$SupplierConfigForm {
  @override
  SupplierConfigFormState build(String? supplierCode) {
    if (supplierCode != null) {
      final asyncConfig = ref.watch(supplierConfigProvider(supplierCode));
      return asyncConfig.when(
        data: (config) {
          if (config != null) {
            return SupplierConfigFormState(
              config: config,
              userInfo: null,
            );
          }
          return SupplierConfigFormState(config: config);
        },
        loading: () => const SupplierConfigFormState(),
        error: (error, stackTrace) => SupplierConfigFormState(
          error: error.toString(),
        ),
      );
    }
    return const SupplierConfigFormState();
  }

  /// Обновить конфигурацию в форме
  void updateConfig(SupplierConfig config) {
    final logger = AppLoggers.suppliers;
    logger.d('updateConfig called with config for: ${config.supplierCode}');

    // Мерж конфигурации с приоритетом incoming данных
    final mergedConfig = state.config != null
        ? config.copyWith(
            businessConfig: _mergeBusinessConfigs(
              state.config!.businessConfig,
              config.businessConfig,
            ),
            // Сохраняем временные метки из current, если они не заданы в incoming
            createdAt: config.createdAt ?? state.config!.createdAt,
            lastSuccessfulCheckAt: config.lastSuccessfulCheckAt ??
                                 state.config!.lastSuccessfulCheckAt,
          )
        : config;

    logger.d('Config merged successfully: brands=${mergedConfig.businessConfig?.brandList?.length ?? 0}, '
             'stores=${mergedConfig.businessConfig?.storeList?.length ?? 0}');

    state = state.copyWith(
      config: mergedConfig,
      error: null,
    );
  }

  /// Валидировать конфигурацию
  bool validate() {
    if (state.config == null) {
      state = state.copyWith(
        validationErrors: ['Конфигурация не задана'],
      );
      return false;
    }

    final service = ref.read(supplierServiceProvider);
    final errors = service.validateConfig(state.config!);

    state = state.copyWith(validationErrors: errors);
    return errors.isEmpty;
  }

  /// Сохранить конфигурацию
  Future<bool> save() async {
    if (!validate()) {
      return false;
    }

    final logger = AppLoggers.suppliers;
    logger.d('Saving config for: ${state.config?.supplierCode}');

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(supplierConfigsProvider.notifier)
          .saveConfig(state.config!);
      logger.d('Config saved successfully');
      return true;
    } catch (e) {
      logger.e('Failed to save config', error: e);
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Проверить подключение
  Future<bool> testConnection() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isTesting: true, error: null);

    try {
      final service = ref.read(supplierServiceProvider);
      final result = await service.testConnection(state.config!);

      if (result.success) {
        // Очищаем ошибки при успешном подключении
        state = state.copyWith(error: null);
        return true;
      } else {
        state = state.copyWith(
          error:
              result.errorMessage ?? 'Не удалось подключиться к API поставщика',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Ошибка при тестировании подключения: ${e.toString()}',
      );
      return false;
    } finally {
      state = state.copyWith(isTesting: false);
    }
  }

  /// Создать конфигурацию из шаблона
  void createFromTemplate(String templateCode) {
    final service = ref.read(supplierServiceProvider);
    final config = service.createFromTemplate(templateCode);

    if (config != null) {
      state = SupplierConfigFormState(config: config);
    } else {
      state = state.copyWith(
        error: 'Неизвестный шаблон: $templateCode',
      );
    }
  }

  /// Загрузить список доступных VKORG для Armtek
  Future<void> loadVkorgList() async {
    if (state.config == null) {
      state = state.copyWith(
        error: 'Сначала настройте базовые параметры подключения',
      );
      return;
    }

    state = state.copyWith(isLoadingVkorgList: true, error: null);

    try {
      // Используем ArmtekDataLoader для загрузки VKORG
      final armtekDataLoader = locator<ArmtekDataLoader>();
      final result = await armtekDataLoader.loadVkorgList(state.config!);

      if (result.success && result.data != null) {
        state = state.copyWith(
          availableVkorgList: result.data!,
          isLoadingVkorgList: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoadingVkorgList: false,
          error: result.errorMessage ?? 'Не удалось загрузить список VKORG',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingVkorgList: false,
        error: 'Ошибка при загрузке списка VKORG: ${e.toString()}',
      );
    }
  }

  /// Выбрать VKORG из списка
  void selectVkorg(String vkorg) {
    if (state.config != null) {
      final updatedCredentials = state.config!.apiConfig.credentials?.copyWith(
        additionalParams: {
          ...?state.config!.apiConfig.credentials?.additionalParams,
          'VKORG': vkorg,
        },
      );

      final updatedConfig = state.config!.copyWith(
        apiConfig: state.config!.apiConfig.copyWith(
          credentials: updatedCredentials,
        ),
      );

      state = state.copyWith(config: updatedConfig);
    }
  }

  /// Загрузить список брендов для Armtek
  Future<void> loadBrandList() async {
    if (state.config == null) {
      state = state.copyWith(
        error: 'Сначала настройте базовые параметры подключения',
      );
      return;
    }

    // Защита от повторного вызова во время выполнения
    if (state.isLoadingBrandList) {
      return;
    }

    state = state.copyWith(isLoadingBrandList: true, error: null);

    try {
      // Используем единый сервис для загрузки данных Armtek
      final service = ref.read(supplierServiceProvider);
      final result = await service.loadBrandList(state.config!);

      if (result.success) {
        final updatedConfig = state.config!.copyWith(
          businessConfig: (state.config!.businessConfig ?? const SupplierBusinessConfig()).copyWith(
            brandList: result.data!,
          ),
          updatedAt: DateTime.now(),
        );

        state = state.copyWith(
          config: updatedConfig,
          isLoadingBrandList: false,
          error: null,
        );

        // Автоматически сохраняем в БД
        final service = ref.read(supplierServiceProvider);
        await service.saveConfig(updatedConfig);
      } else {
        state = state.copyWith(
          isLoadingBrandList: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingBrandList: false,
        error: 'Ошибка при загрузке списка брендов: ${e.toString()}',
      );
    }
  }

  /// Загрузить список складов для Armtek
  Future<void> loadStoreList() async {
    if (state.config == null) {
      state = state.copyWith(
        error: 'Сначала настройте базовые параметры подключения',
      );
      return;
    }

    // Защита от повторного вызова во время выполнения
    if (state.isLoadingStoreList) {
      return;
    }

    state = state.copyWith(isLoadingStoreList: true, error: null);

    try {
      // Используем единый сервис для загрузки данных Armtek
      final service = ref.read(supplierServiceProvider);
      final result = await service.loadStoreList(state.config!);

      if (result.success) {
        final updatedConfig = state.config!.copyWith(
          businessConfig: (state.config!.businessConfig ?? const SupplierBusinessConfig()).copyWith(
            storeList: result.data!,
          ),
          updatedAt: DateTime.now(),
        );

        state = state.copyWith(
          config: updatedConfig,
          isLoadingStoreList: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoadingStoreList: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingStoreList: false,
        error: 'Ошибка при загрузке списка складов: ${e.toString()}',
      );
    }
  }

  /// Загрузить информацию о пользователе
  Future<void> loadUserInfo() async {
    if (state.config == null) {
      state = state.copyWith(
        error: 'Сначала настройте базовые параметры подключения',
      );
      return;
    }

    state = state.copyWith(isLoadingUserInfo: true, error: null);

    try {
      // Используем единый сервис для загрузки данных Armtek
      final service = ref.read(supplierServiceProvider);
      final result = await service.loadUserInfo(state.config!);

      if (result.success) {
        final currentBusinessConfig = state.config!.businessConfig ?? const SupplierBusinessConfig();
        final currentAdditionalParams = currentBusinessConfig.additionalParams ?? {};

        final updatedConfig = state.config!.copyWith(
          businessConfig: currentBusinessConfig.copyWith(
            customerCode: result.data!.structure?.kunag ?? currentBusinessConfig.customerCode,
            additionalParams: {
              ...currentAdditionalParams,
              'userInfo': result.data!.toJson(),
              'lastUserInfoUpdateAt': DateTime.now().toIso8601String(),
            },
          ),
          updatedAt: DateTime.now(),
        );

        state = state.copyWith(
          config: updatedConfig,
          userInfo: result.data,
          isLoadingUserInfo: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoadingUserInfo: false,
          error: result.errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingUserInfo: false,
        error: 'Ошибка при загрузке информации о пользователе: ${e.toString()}',
      );
    }
  }

  /// Мерж двух SupplierBusinessConfig, сохраняя приоритет данных из incoming
  SupplierBusinessConfig? _mergeBusinessConfigs(
    SupplierBusinessConfig? current,
    SupplierBusinessConfig? incoming,
  ) {
    if (current == null && incoming == null) {
      return null;
    }
    if (current == null) return incoming!;
    if (incoming == null) return current;

    return incoming.copyWith(
      // Для списков сохраняем существующие из current, если они есть
      brandList: current.brandList ?? incoming.brandList,
      storeList: current.storeList ?? incoming.storeList,

      // Мержим additionalParams
      additionalParams: _mergeAdditionalParams(
        current.additionalParams,
        incoming.additionalParams,
      ),
    );
  }

  /// Приватный метод для мержинга additionalParams
  Map<String, dynamic>? _mergeAdditionalParams(
    Map<String, dynamic>? current,
    Map<String, dynamic>? incoming,
  ) {
    if (current == null && incoming == null) return null;
    if (current == null) return Map<String, dynamic>.from(incoming!);
    if (incoming == null) return Map<String, dynamic>.from(current);

    // Мержим с приоритетом incoming, но сохраняем ключи из current, которых нет в incoming
    return {
      ...current,
      ...incoming,
    };
  }
}
