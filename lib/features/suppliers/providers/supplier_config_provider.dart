import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config_form_state.dart';
import 'package:part_catalog/features/suppliers/services/supplier_config_service.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'supplier_config_provider.g.dart';

/// Провайдер для сервиса конфигурации поставщиков
@riverpod
SupplierConfigService supplierConfigService(SupplierConfigServiceRef ref) {
  final prefs = locator<SharedPreferences>();
  return SupplierConfigService(prefs);
}

/// Провайдер для списка всех конфигураций поставщиков
@riverpod
class SupplierConfigs extends _$SupplierConfigs {
  late final SupplierConfigService _service;

  @override
  Future<List<SupplierConfig>> build() async {
    _service = ref.watch(supplierConfigServiceProvider);
    return _service.getAllConfigs();
  }

  /// Добавить или обновить конфигурацию
  Future<void> saveConfig(SupplierConfig config) async {
    state = const AsyncValue.loading();
    
    try {
      await _service.saveConfig(config);
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
      return await _service.testConnection(config);
    } catch (e) {
      return false;
    }
  }
}

/// Провайдер для получения конфигурации конкретного поставщика
@riverpod
SupplierConfig? supplierConfig(
  SupplierConfigRef ref,
  String supplierCode,
) {
  final service = ref.watch(supplierConfigServiceProvider);
  return service.getConfig(supplierCode);
}

/// Провайдер для списка активных конфигураций
@riverpod
List<SupplierConfig> enabledSupplierConfigs(EnabledSupplierConfigsRef ref) {
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
  SupplierUsageStatsRef ref,
  String supplierCode,
) {
  final service = ref.watch(supplierConfigServiceProvider);
  return service.getUsageStats(supplierCode);
}

/// Провайдер для управления формой конфигурации
@riverpod
class SupplierConfigForm extends _$SupplierConfigForm {
  @override
  SupplierConfigFormState build(String? supplierCode) {
    if (supplierCode != null) {
      final config = ref.read(supplierConfigProvider(supplierCode));
      return SupplierConfigFormState(config: config);
    }
    return const SupplierConfigFormState();
  }

  /// Обновить конфигурацию в форме
  void updateConfig(SupplierConfig config) {
    state = state.copyWith(config: config, error: null);
  }

  /// Валидировать конфигурацию
  bool validate() {
    if (state.config == null) {
      state = state.copyWith(
        validationErrors: ['Конфигурация не задана'],
      );
      return false;
    }

    final service = ref.read(supplierConfigServiceProvider);
    final errors = service.validateConfig(state.config!);
    
    state = state.copyWith(validationErrors: errors);
    return errors.isEmpty;
  }

  /// Сохранить конфигурацию
  Future<bool> save() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await ref.read(supplierConfigsProvider.notifier)
          .saveConfig(state.config!);
      return true;
    } catch (e) {
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
  Future<void> testConnection() async {
    if (!validate()) {
      return;
    }

    state = state.copyWith(isTesting: true, error: null);
    
    try {
      final success = await ref.read(supplierConfigsProvider.notifier)
          .testConnection(state.config!);
      
      if (!success) {
        state = state.copyWith(
          error: 'Не удалось подключиться к API поставщика',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    } finally {
      state = state.copyWith(isTesting: false);
    }
  }

  /// Создать конфигурацию из шаблона
  void createFromTemplate(String templateCode) {
    final service = ref.read(supplierConfigServiceProvider);
    final config = service.createFromTemplate(templateCode);
    
    if (config != null) {
      state = SupplierConfigFormState(config: config);
    } else {
      state = state.copyWith(
        error: 'Неизвестный шаблон: $templateCode',
      );
    }
  }
}