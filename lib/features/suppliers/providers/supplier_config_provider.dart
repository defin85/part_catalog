import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config_form_state.dart';
import 'package:part_catalog/features/suppliers/services/supplier_config_service.dart';

part 'supplier_config_provider.g.dart';

/// Провайдер для сервиса конфигурации поставщиков
@riverpod
SupplierConfigService supplierConfigService(Ref ref) {
  final database = locator<AppDatabase>();
  return SupplierConfigService(database.supplierSettingsDao);
}

/// Провайдер для списка всех конфигураций поставщиков
@riverpod
class SupplierConfigs extends _$SupplierConfigs {
  late final SupplierConfigService _service;

  @override
  Future<List<SupplierConfig>> build() async {
    // Делаем провайдер долгоживущим, чтобы не перезагружать конфиги при каждом входе в экран
    ref.keepAlive();
    _service = ref.watch(supplierConfigServiceProvider);

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
  final service = ref.watch(supplierConfigServiceProvider);
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
    print('=== updateConfig ВЫЗВАН ===');
    print(
        'Входящая config.businessConfig.brandList: ${config.businessConfig?.brandList?.length ?? 0}');
    print(
        'Входящая config.businessConfig.storeList: ${config.businessConfig?.storeList?.length ?? 0}');
    print(
        'Текущий state.config.businessConfig.brandList: ${state.config?.businessConfig?.brandList?.length ?? 0}');
    print(
        'Текущий state.config.businessConfig.storeList: ${state.config?.businessConfig?.storeList?.length ?? 0}');
    print('STACK TRACE:');
    print(StackTrace.current);

    // ВАЖНО: Мержим данные вместо полной замены!
    if (state.config != null) {
      // Сохраняем загруженные бренды и склады из текущего состояния
      final currentBusinessConfig = state.config!.businessConfig;
      final incomingBusinessConfig = config.businessConfig;

      SupplierBusinessConfig? mergedBusinessConfig;
      if (currentBusinessConfig != null || incomingBusinessConfig != null) {
        mergedBusinessConfig =
            (incomingBusinessConfig ?? const SupplierBusinessConfig()).copyWith(
          // Сохраняем загруженные данные из текущего состояния
          brandList: currentBusinessConfig?.brandList ??
              incomingBusinessConfig?.brandList,
          storeList: currentBusinessConfig?.storeList ??
              incomingBusinessConfig?.storeList,
          additionalParams: currentBusinessConfig?.additionalParams ??
              incomingBusinessConfig?.additionalParams,
        );
      }

      final mergedConfig = config.copyWith(
        businessConfig: mergedBusinessConfig,
      );

      print(
          'После мержинга в updateConfig: бренды=${mergedConfig.businessConfig?.brandList?.length ?? 0}, склады=${mergedConfig.businessConfig?.storeList?.length ?? 0}');

      state = state.copyWith(
        config: mergedConfig,
        error: null,
        // Явно сохраняем userInfo, чтобы оно не терялось
      );

      print(
          'ФИНАЛЬНЫЙ STATE после updateConfig: бренды=${state.config?.businessConfig?.brandList?.length ?? 0}, склады=${state.config?.businessConfig?.storeList?.length ?? 0}');
    } else {
      state = state.copyWith(
        config: config,
        error: null,
      );
    }
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

    // Отладочный лог перед сохранением
    print('=== ПЕРЕД save() ===');
    print('state.config.businessConfig.additionalParams?.keys: ${state.config?.businessConfig?.additionalParams?.keys}');
    print('hasUserInfo в additionalParams: ${state.config?.businessConfig?.additionalParams?.containsKey("userInfo") ?? false}');

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref
          .read(supplierConfigsProvider.notifier)
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
  Future<bool> testConnection() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isTesting: true, error: null);

    try {
      final service = ref.read(supplierConfigServiceProvider);
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

  /// Загрузить список доступных VKORG для Armtek
  Future<void> loadVkorgList() async {
    if (state.config == null) {
      state = state.copyWith(
        error: 'Сначала настройте базовые параметры подключения',
      );
      return;
    }

    // Проверяем минимально необходимые поля
    final apiConfig = state.config!.apiConfig;
    final credentials = apiConfig.credentials;

    if (apiConfig.baseUrl.isEmpty) {
      state = state.copyWith(
        error: 'Введите URL API',
      );
      return;
    }

    if (credentials == null ||
        (credentials.username?.isEmpty ?? true) ||
        (credentials.password?.isEmpty ?? true)) {
      state = state.copyWith(
        error: 'Введите логин и пароль для подключения',
      );
      return;
    }

    state = state.copyWith(isLoadingVkorgList: true, error: null);

    try {
      // Создаем временный API клиент с текущими настройками
      final dio = Dio();
      final credentials = state.config!.apiConfig.credentials;

      final apiClient = ArmtekApiClient(
        dio,
        baseUrl: state.config!.apiConfig.baseUrl,
        username: credentials?.username,
        password: credentials?.password,
      );

      final response = await apiClient.getUserVkorgList();

      // ArmtekResponseWrapper имеет поле responseData, а не data
      if (response.status == 200 && response.responseData != null) {
        state = state.copyWith(
          availableVkorgList: response.responseData!,
          isLoadingVkorgList: false,
        );
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить список VKORG';
        state = state.copyWith(
          isLoadingVkorgList: false,
          error: errorMessage,
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
    File('debug_trace.log').writeAsStringSync(
      '‼️ TRACE: loadBrandList called!\n${StackTrace.current}\n\n',
      mode: FileMode.append,
    );
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

    final credentials = state.config!.apiConfig.credentials;
    final vkorg = credentials?.additionalParams?['VKORG'];

    if (vkorg == null || vkorg.isEmpty) {
      state = state.copyWith(
        error: 'Необходимо выбрать VKORG для загрузки списка брендов',
      );
      return;
    }

    if (state.config!.apiConfig.baseUrl.isEmpty) {
      state = state.copyWith(
        error: 'Введите URL API',
      );
      return;
    }

    if (credentials == null ||
        (credentials.username?.isEmpty ?? true) ||
        (credentials.password?.isEmpty ?? true)) {
      state = state.copyWith(
        error: 'Введите логин и пароль для подключения',
      );
      return;
    }

    state = state.copyWith(isLoadingBrandList: true, error: null);

    try {
      final dio = Dio();

      final apiClient = ArmtekApiClient(
        dio,
        baseUrl: state.config!.apiConfig.baseUrl,
        username: credentials.username,
        password: credentials.password,
        vkorg: vkorg,
      );

      final response = await apiClient.getBrandList(vkorg);

      if (response.status == 200 && response.responseData != null) {
        // Мержим с существующими данными в памяти (сохраняем склады из текущего state)
        final currentStateConfig = state.config!;
        final currentStateBusinessConfig =
            currentStateConfig.businessConfig ?? const SupplierBusinessConfig();

        print('=== ДЕБАГ МЕРЖИНГА БРЕНДОВ ===');
        print('currentStateConfig не null: ${currentStateConfig != null}');
        print(
            'currentStateBusinessConfig не null: ${currentStateBusinessConfig != null}');
        print(
            'currentStateBusinessConfig.brandList: ${currentStateBusinessConfig.brandList}');
        print(
            'currentStateBusinessConfig.storeList: ${currentStateBusinessConfig.storeList}');
        print(
            'Мержинг брендов: существующие склады=${currentStateBusinessConfig.storeList?.length ?? 0}, новые бренды=${response.responseData?.length ?? 0}');

        final updatedConfig = currentStateConfig.copyWith(
          businessConfig: currentStateBusinessConfig.copyWith(
            brandList: response.responseData,
            // Сохраняем существующие склады из текущего состояния
            storeList: currentStateBusinessConfig.storeList,
          ),
        );

        print(
            'После мержинга: бренды=${updatedConfig.businessConfig?.brandList?.length ?? 0}, склады=${updatedConfig.businessConfig?.storeList?.length ?? 0}');

        // Обновляем только состояние в памяти (БД не трогаем)
        state = state.copyWith(
          config: updatedConfig,
          isLoadingBrandList: false,
          error: null,
        );

        print('=== ПОСЛЕ ОБНОВЛЕНИЯ STATE В loadBrandList ===');
        print(
            'state.config.businessConfig.brandList: ${state.config?.businessConfig?.brandList?.length ?? 0}');
        print(
            'state.config.businessConfig.storeList: ${state.config?.businessConfig?.storeList?.length ?? 0}');

        // Автоматически сохраняем обновленную конфигурацию в БД
        // НО делаем это через отдельный сервис, чтобы избежать циклической зависимости
        Future.microtask(() async {
          try {
            final database = locator<AppDatabase>();
            final service = SupplierConfigService(database.supplierSettingsDao);
            await service.saveConfig(updatedConfig);
            print('Бренды автоматически сохранены в БД');
          } catch (e) {
            print('Ошибка сохранения брендов в БД: $e');
            // Не прерываем выполнение, данные остаются в памяти
          }
        });
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить список брендов';
        state = state.copyWith(
          isLoadingBrandList: false,
          error: errorMessage,
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
    debugPrint('‼️ TRACE: loadStoreList called!\n${StackTrace.current}');
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

    final credentials = state.config!.apiConfig.credentials;
    final vkorg = credentials?.additionalParams?['VKORG'];

    if (vkorg == null || vkorg.isEmpty) {
      state = state.copyWith(
        error: 'Необходимо выбрать VKORG для загрузки списка складов',
      );
      return;
    }

    if (state.config!.apiConfig.baseUrl.isEmpty) {
      state = state.copyWith(
        error: 'Введите URL API',
      );
      return;
    }

    if (credentials == null ||
        (credentials.username?.isEmpty ?? true) ||
        (credentials.password?.isEmpty ?? true)) {
      state = state.copyWith(
        error: 'Введите логин и пароль для подключения',
      );
      return;
    }

    state = state.copyWith(isLoadingStoreList: true, error: null);

    try {
      final dio = Dio();

      final apiClient = ArmtekApiClient(
        dio,
        baseUrl: state.config!.apiConfig.baseUrl,
        username: credentials.username,
        password: credentials.password,
        vkorg: vkorg,
      );

      final response = await apiClient.getStoreList(vkorg);

      // REST API результат не логируем чтобы не засорять терминал

      if (response.status == 200 && response.responseData != null) {
        // Мержим с существующими данными в памяти (сохраняем бренды из текущего state)
        final currentStateConfig = state.config!;
        final currentStateBusinessConfig =
            currentStateConfig.businessConfig ?? const SupplierBusinessConfig();

        final updatedConfig = currentStateConfig.copyWith(
          businessConfig: currentStateBusinessConfig.copyWith(
            storeList: response.responseData,
            // Сохраняем существующие бренды из текущего состояния
            brandList: currentStateBusinessConfig.brandList,
          ),
        );

        // Обновляем только состояние в памяти (БД не трогаем)
        state = state.copyWith(
          config: updatedConfig,
          isLoadingStoreList: false,
          error: null,
        );
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить список складов';
        state = state.copyWith(
          isLoadingStoreList: false,
          error: errorMessage,
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

    final credentials = state.config!.apiConfig.credentials;
    final vkorg = credentials?.additionalParams?['VKORG'];

    if (vkorg == null || vkorg.isEmpty) {
      state = state.copyWith(
        error:
            'Необходимо выбрать VKORG для загрузки информации о пользователе',
      );
      return;
    }

    if (state.config!.apiConfig.baseUrl.isEmpty) {
      state = state.copyWith(
        error: 'Введите URL API',
      );
      return;
    }

    if (credentials == null ||
        (credentials.username?.isEmpty ?? true) ||
        (credentials.password?.isEmpty ?? true)) {
      state = state.copyWith(
        error: 'Введите логин и пароль для подключения',
      );
      return;
    }

    state = state.copyWith(isLoadingUserInfo: true, error: null);

    try {
      // Создаем временный API клиент с текущими настройками
      final dio = Dio();

      final apiClient = ArmtekApiClient(
        dio,
        baseUrl: state.config!.apiConfig.baseUrl,
        username: credentials.username,
        password: credentials.password,
        vkorg: vkorg,
      );

      final request = UserInfoRequest(
        vkorg: vkorg,
        structure: '1',
        ftpData: '1',
      );
      final response = await apiClient.getUserInfo(request);

      if (response.status == 200 && response.responseData != null) {
        // Автоматически заполняем код клиента из KUNAG
        final kunag = response.responseData!.structure?.kunag;

        // Сохраняем полный ответ getUserInfo в additionalParams для будущего использования
        final currentBusinessConfig = state.config!.businessConfig ?? const SupplierBusinessConfig();
        final currentAdditionalParams = currentBusinessConfig.additionalParams ?? {};

        final updatedConfig = state.config!.copyWith(
          businessConfig: currentBusinessConfig.copyWith(
            customerCode: kunag, // Основной KUNAG
            additionalParams: {
              ...currentAdditionalParams,
              'userInfo': response.responseData!.toJson(), // Полный ответ getUserInfo
              'lastUserInfoUpdateAt': DateTime.now().toIso8601String(), // Время последнего обновления
            },
          ),
        );

        state = state.copyWith(
          config: updatedConfig,
          userInfo: response.responseData,
          isLoadingUserInfo: false,
          error: null,
        );

        // Отладочный лог
        print('=== ПОСЛЕ loadUserInfo ===');
        print('state.config.businessConfig.additionalParams?.keys: ${state.config?.businessConfig?.additionalParams?.keys}');
        print('hasUserInfo в additionalParams: ${state.config?.businessConfig?.additionalParams?.containsKey("userInfo") ?? false}');
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить информацию о пользователе';
        state = state.copyWith(
          isLoadingUserInfo: false,
          error: errorMessage,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingUserInfo: false,
        error: 'Ошибка при загрузке информации о пользователе: ${e.toString()}',
      );
    }
  }
}
