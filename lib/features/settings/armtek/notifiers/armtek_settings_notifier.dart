import 'dart:convert';
import 'package:drift/drift.dart' hide JsonKey;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/daos/supplier_settings_dao.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/settings/armtek/state/armtek_settings_state.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart'; // Предполагается наличие
import 'package:part_catalog/core/service_locator.dart'; // Для ApiClientManager
import 'package:part_catalog/features/suppliers/models/armtek/armtek_response_wrapper.dart';

import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';

const String armtekSupplierCode = 'armtek';

final armtekSettingsNotifierProvider = StateNotifierProvider.autoDispose<
    ArmtekSettingsNotifier, ArmtekSettingsState>((ref) {
  final supplierSettingsDao = ref.watch(supplierSettingsDaoProvider);
  // ApiClientManager должен быть зарегистрирован в service_locator
  final apiClientManager = locator<ApiClientManager>();
  return ArmtekSettingsNotifier(supplierSettingsDao, apiClientManager);
});

class ArmtekSettingsNotifier extends StateNotifier<ArmtekSettingsState> {
  final SupplierSettingsDao _supplierSettingsDao;
  final ApiClientManager _apiClientManager;
  final _logger = appLogger('ArmtekSettingsNotifier');

  ArmtekSettingsNotifier(this._supplierSettingsDao, this._apiClientManager)
      : super(ArmtekSettingsState.initial()) {
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final setting = await _supplierSettingsDao
          .getSupplierSettingByCode(armtekSupplierCode);
      String initialLogin = '';
      String initialPassword = '';
      String? initialSelectedVkorg;

      if (setting != null && setting.encryptedCredentials != null) {
        try {
          // Пока без шифрования, просто парсим JSON
          final credentialsMap =
              jsonDecode(setting.encryptedCredentials!) as Map<String, dynamic>;
          initialLogin = credentialsMap['username'] as String? ?? '';
          initialPassword = credentialsMap['password'] as String? ?? '';
          _logger.i('Loaded credentials: login=${initialLogin.isNotEmpty ? "***" : "empty"}, password=${initialPassword.isNotEmpty ? "***" : "empty"}');
        } catch (e) {
          _logger.w(
              'Could not parse credentials from DB for $armtekSupplierCode',
              error: e);
        }
      }
      if (setting != null && setting.additionalConfig != null) {
        try {
          final additionalConfigMap =
              jsonDecode(setting.additionalConfig!) as Map<String, dynamic>;
          initialSelectedVkorg =
              additionalConfigMap['selectedVkorg'] as String?;
        } catch (e) {
          _logger.w(
              'Could not parse additionalConfig from DB for $armtekSupplierCode',
              error: e);
        }
      }

      state = state.copyWith(
        isLoading: false,
        currentSetting: setting,
        loginInput: initialLogin,
        passwordInput: initialPassword, // Загружаем пароль для корректного отображения
        isConnected: setting?.lastCheckStatus == 'success',
        connectionStatusMessage: setting?.lastCheckMessage,
        selectedVkorg: initialSelectedVkorg,
      );

      // Важно: передаем initialPassword, даже если не отображаем его в UI,
      // так как он нужен для запросов к API, если соединение было успешным ранее.
      if (state.isConnected &&
          initialLogin.isNotEmpty &&
          initialPassword.isNotEmpty) {
        await _fetchUserVkorgList(initialLogin, initialPassword);
        if (initialSelectedVkorg != null &&
            state.userVkorgList != null &&
            state.userVkorgList!.any((v) => v.vkorg == initialSelectedVkorg)) {
          await _fetchArmtekSpecificData(
              initialLogin, initialPassword, initialSelectedVkorg);
        } else if (initialSelectedVkorg != null) {
          // Если сохраненный VKORG не найден в списке, сбрасываем его
          _logger.w(
              'Previously selected VKORG "$initialSelectedVkorg" not found in the fetched list. Resetting.');
          await selectVkorg(
              null); // Это очистит selectedVkorg и связанные данные
        }
      }
    } catch (e, s) {
      _logger.e('Error loading initial Armtek settings',
          error: e, stackTrace: s);
      state = state.copyWith(
          isLoading: false, errorMessage: 'Ошибка загрузки начальных настроек');
    }
  }

  void updateLogin(String login) {
    state = state.copyWith(loginInput: login);
  }

  void updatePassword(String password) {
    state = state.copyWith(passwordInput: password);
  }

  Future<void> checkAndSaveConnection() async {
    if (state.loginInput.isEmpty || state.passwordInput.isEmpty) {
      state = state.copyWith(
          connectionStatusMessage: 'Логин и пароль не могут быть пустыми');
      return;
    }
    state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        connectionStatusMessage: 'Проверка подключения...');

    // Пока без шифрования
    final credentialsJson = jsonEncode({
      'username': state.loginInput,
      'password': state.passwordInput,
    });

    final companion = SupplierSettingsItemsCompanion(
      supplierCode: const Value(armtekSupplierCode),
      isEnabled: const Value(true),
      encryptedCredentials: Value(credentialsJson),
      updatedAt: Value(DateTime.now()),
    );

    try {
      // Сначала сохраняем учетные данные, чтобы ApiClientManager мог их подхватить,
      // если он читает их из настроек для "стандартного" клиента.
      // Однако, для проверки мы передаем их явно.
      await _supplierSettingsDao.upsertSupplierSetting(companion);

      final armtekClient = await _apiClientManager.getClient(
        supplierCode: armtekSupplierCode,
        username: state.loginInput,
        password: state.passwordInput,
      );

      if (armtekClient == null || armtekClient is! ArmtekApiClient) {
        _logger.e(
            'Не удалось получить или создать ArmtekApiClient через ApiClientManager.');
        throw Exception('Ошибка конфигурации клиента API.');
      }

      final connectionOk = await armtekClient.checkConnection();

      if (connectionOk) {
        await _supplierSettingsDao.upsertSupplierSetting(
          companion.copyWith(
            lastCheckStatus: const Value('success'),
            lastCheckMessage: const Value('Подключение успешно'),
            lastSuccessfulCheckAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()), // Добавлено/обновлено
          ),
        );
        // Получаем обновленные настройки после успешной проверки
        final finalSetting = await _supplierSettingsDao
            .getSupplierSettingByCode(armtekSupplierCode);
        state = state.copyWith(
          isLoading: false,
          isConnected: true,
          connectionStatusMessage: 'Подключение успешно',
          currentSetting: finalSetting, // Используем самые свежие настройки
        );
        await _fetchUserVkorgList(state.loginInput, state.passwordInput);
      } else {
        throw Exception('Ошибка проверки подключения к Armtek');
      }
    } catch (e, s) {
      _logger.e('Error checking/saving Armtek connection',
          error: e, stackTrace: s);
      await _supplierSettingsDao.upsertSupplierSetting(
        companion.copyWith(
          lastCheckStatus: const Value('error_auth'),
          lastCheckMessage: Value('Ошибка подключения: ${e.toString()}'),
          updatedAt: Value(DateTime.now()), // Добавлено/обновлено
        ),
      );
      final updatedSetting = await _supplierSettingsDao
          .getSupplierSettingByCode(armtekSupplierCode);
      state = state.copyWith(
        isLoading: false,
        isConnected: false,
        connectionStatusMessage: 'Ошибка подключения: ${e.toString()}',
        currentSetting: updatedSetting,
        errorMessage: 'Не удалось подключиться к Armtek.',
      );
    }
  }

  Future<void> _fetchUserVkorgList(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      _logger.w('Login or password is empty, skipping VKORG list fetch.');
      state = state.copyWith(
          userVkorgList: [],
          isLoadingArmtekData: false); // Очищаем список или оставляем старый
      return;
    }
    state = state.copyWith(isLoadingArmtekData: true);
    try {
      final armtekClient = await _apiClientManager.getClient(
        supplierCode: armtekSupplierCode,
        username: login,
        password: password,
      );

      if (armtekClient == null || armtekClient is! ArmtekApiClient) {
        throw Exception(
            'Не удалось получить Armtek API клиент для загрузки VKORG.');
      }

      final response = await armtekClient.getUserVkorgList();
      if (response.status == 200 && response.responseData != null) {
        state = state.copyWith(
            userVkorgList: response.responseData, isLoadingArmtekData: false);
      } else {
        _logger.w(
            'Ошибка ответа API при загрузке VKORG: ${response.status} - ${response.messages}');
        throw Exception(
            'Ошибка API: ${response.messages?.map((m) => m.text).join(', ') ?? "Неизвестная ошибка API"}');
      }
    } catch (e, s) {
      _logger.e('Error fetching Armtek VKORG list', error: e, stackTrace: s);
      state = state.copyWith(
          isLoadingArmtekData: false,
          // Очищаем список VKORG при ошибке, чтобы пользователь мог выбрать заново или чтобы не было неактуальных данных
          userVkorgList: null,
          selectedVkorg: null, // Также сбрасываем выбранный VKORG
          connectionStatusMessage:
              'Ошибка загрузки списка VKORG: ${e.toString()}');
    }
  }

  Future<void> selectVkorg(String? vkorg) async {
    // Если vkorg сбрасывается на null или логин/пароль пусты
    if (vkorg == null ||
        state.loginInput.isEmpty ||
        state.passwordInput.isEmpty) {
      state = state.copyWith(
        selectedVkorg: null,
        userInfo: null,
        storeList: null,
        brandList: null,
        isLoadingArmtekData: false, // Убедимся, что загрузка остановлена
      );
      // Очистить selectedVkorg в additionalConfig в БД
      if (state.currentSetting != null) {
        final currentAdditionalConfig = state.currentSetting!.additionalConfig;
        Map<String, dynamic> configMap = {};
        if (currentAdditionalConfig != null &&
            currentAdditionalConfig.isNotEmpty) {
          try {
            configMap =
                jsonDecode(currentAdditionalConfig) as Map<String, dynamic>;
          } catch (e) {
            _logger.w(
                'Failed to parse existing additionalConfig, creating new one.',
                error: e);
            configMap = {};
          }
        }
        if (configMap.containsKey('selectedVkorg')) {
          configMap.remove('selectedVkorg');
          final newConfigJson =
              configMap.isEmpty ? null : jsonEncode(configMap);

          await _supplierSettingsDao.upsertSupplierSetting(
            SupplierSettingsItemsCompanion(
              supplierCode: const Value(armtekSupplierCode),
              additionalConfig: Value(newConfigJson),
              updatedAt: Value(DateTime.now()),
            ),
          );
          final updatedSetting = await _supplierSettingsDao
              .getSupplierSettingByCode(armtekSupplierCode);
          state = state.copyWith(currentSetting: updatedSetting);
        }
      }
      return;
    }

    state = state.copyWith(selectedVkorg: vkorg, isLoadingArmtekData: true);

    // Сохраняем выбранный VKORG в additionalConfig
    if (state.currentSetting != null) {
      final currentAdditionalConfig = state.currentSetting!.additionalConfig;
      Map<String, dynamic> configMap = {};
      if (currentAdditionalConfig != null &&
          currentAdditionalConfig.isNotEmpty) {
        try {
          configMap =
              jsonDecode(currentAdditionalConfig) as Map<String, dynamic>;
        } catch (e) {
          _logger.w(
              'Failed to parse existing additionalConfig, creating new one.',
              error: e);
          configMap = {};
        }
      }
      configMap['selectedVkorg'] = vkorg;
      final newConfigJson = jsonEncode(configMap);

      await _supplierSettingsDao.upsertSupplierSetting(
        SupplierSettingsItemsCompanion(
          supplierCode: const Value(armtekSupplierCode),
          additionalConfig: Value(newConfigJson),
          updatedAt: Value(DateTime.now()),
        ),
      );
      final updatedSetting = await _supplierSettingsDao
          .getSupplierSettingByCode(armtekSupplierCode);
      state = state.copyWith(currentSetting: updatedSetting);
    }

    await _fetchArmtekSpecificData(
        state.loginInput, state.passwordInput, vkorg);
  }

  Future<void> _fetchArmtekSpecificData(
      String login, String password, String vkorg) async {
    if (login.isEmpty || password.isEmpty) {
      _logger.w(
          'Login or password is empty, skipping specific Armtek data fetch.');
      state = state.copyWith(isLoadingArmtekData: false);
      return;
    }
    state = state.copyWith(isLoadingArmtekData: true);
    try {
      _logger.i('Getting Armtek client with login: $login, vkorg: $vkorg');
      
      final armtekClient = await _apiClientManager.getClient(
        supplierCode: armtekSupplierCode,
        username: login,
        password: password,
      );

      if (armtekClient == null || armtekClient is! ArmtekApiClient) {
        throw Exception(
            'Не удалось получить Armtek API клиент для загрузки специфичных данных.');
      }
      final client = armtekClient;
      
      _logger.i('Armtek client created with base URL: ${client.baseUrl}');

      // Сначала загружаем только getUserInfo
      final userInfoResponse = await client.getUserInfo(
          UserInfoRequest(vkorg: vkorg, structure: '1', ftpData: '1'));

      UserInfoResponse? userInfoResult;
      if (userInfoResponse.status == 200 &&
          userInfoResponse.responseData != null) {
        userInfoResult = userInfoResponse.responseData;
        final clientIdentifier = userInfoResult?.structure?.kunag;
        if (clientIdentifier != null &&
            state.currentSetting?.clientIdentifierAtSupplier !=
                clientIdentifier) {
          await _supplierSettingsDao.upsertSupplierSetting(
            SupplierSettingsItemsCompanion(
              // Используем Companion напрямую
              supplierCode: const Value(armtekSupplierCode),
              clientIdentifierAtSupplier: Value(clientIdentifier),
              updatedAt: Value(DateTime.now()),
            ),
          );
          final updatedSetting = await _supplierSettingsDao
              .getSupplierSettingByCode(armtekSupplierCode);
          state = state.copyWith(currentSetting: updatedSetting);
        }
      } else {
        _logger.w(
            'Ошибка при получении UserInfo: ${userInfoResponse.status} - ${userInfoResponse.messages?.map((m) => m.text).join(', ')}');
        // Можно решить, нужно ли сбрасывать userInfo в state или показывать ошибку
      }

      // Обработка storeList и brandList перенесена в _loadAdditionalData

      // Обновляем state с информацией о пользователе
      state = state.copyWith(
        userInfo: userInfoResult,
        isLoadingArmtekData: false,
      );
      
      // Теперь загружаем остальные данные в фоне
      _loadAdditionalData(client, vkorg);
    } catch (e, s) {
      _logger.e('Error fetching Armtek specific data for VKORG $vkorg',
          error: e, stackTrace: s);
      
      // Добавим более детальный вывод ошибки
      if (e is TypeError) {
        _logger.e('Type error details: ${e.toString()}');
      }
      
      state = state.copyWith(
          isLoadingArmtekData: false,
          connectionStatusMessage:
              'Ошибка загрузки данных для VKORG: ${e.toString()}');
    }
  }

  /// Загружает дополнительные данные в фоне после успешного получения getUserInfo
  Future<void> _loadAdditionalData(ArmtekApiClient client, String vkorg) async {
    try {
      _logger.i('Loading additional data (storeList and brandList) for VKORG: $vkorg');
      
      // Загружаем дополнительные данные параллельно
      final results = await Future.wait([
        client.getStoreList(vkorg),
        client.getBrandList(vkorg),
      ]);

      final storeListResponse = results[0] as ArmtekResponseWrapper<List<StoreItem>>;
      final brandListResponse = results[1] as ArmtekResponseWrapper<List<BrandItem>>;

      List<StoreItem>? storeListResult;
      if (storeListResponse.status == 200 && storeListResponse.responseData != null) {
        storeListResult = storeListResponse.responseData;
        _logger.i('StoreList loaded successfully, items count: ${storeListResult!.length}');
        if (storeListResult.isNotEmpty) {
          final firstStore = storeListResult.first;
          _logger.d('First store: keyzak=${firstStore.keyzak}, sklCode=${firstStore.sklCode}, sklName=${firstStore.sklName}');
        }
      } else {
        _logger.w('Ошибка при получении StoreList: ${storeListResponse.status} - ${storeListResponse.messages?.map((m) => m.text).join(', ')}');
      }

      List<BrandItem>? brandListResult;
      if (brandListResponse.status == 200 && brandListResponse.responseData != null) {
        brandListResult = brandListResponse.responseData;
      } else {
        _logger.w('Ошибка при получении BrandList: ${brandListResponse.status} - ${brandListResponse.messages?.map((m) => m.text).join(', ')}');
      }

      // Обновляем state с дополнительными данными
      state = state.copyWith(
        storeList: storeListResult,
        brandList: brandListResult,
      );
      
      _logger.i('Additional data loaded successfully');
    } catch (e, s) {
      _logger.w('Error loading additional data for VKORG $vkorg', error: e, stackTrace: s);
      // Не показываем ошибку пользователю, так как основные данные уже загружены
    }
  }

  Future<void> clearSettings() async {
    state = state.copyWith(isLoading: true);
    try {
      await _supplierSettingsDao.upsertSupplierSetting(
        SupplierSettingsItemsCompanion(
          supplierCode: const Value(armtekSupplierCode),
          isEnabled: const Value(false), // Можно отключать, а не удалять все
          encryptedCredentials: const Value(null),
          lastCheckStatus: const Value(null),
          lastCheckMessage: const Value(null),
          lastSuccessfulCheckAt: const Value(null),
          clientIdentifierAtSupplier: const Value(null),
          additionalConfig: const Value(null),
          updatedAt: Value(DateTime.now()),
        ),
      );
      state = ArmtekSettingsState.initial()
          .copyWith(connectionStatusMessage: 'Настройки Armtek очищены.');
    } catch (e, s) {
      _logger.e('Error clearing Armtek settings', error: e, stackTrace: s);
      state = state.copyWith(
          isLoading: false, errorMessage: 'Ошибка очистки настроек');
    }
  }
}
