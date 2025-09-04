import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/config/global_api_settings_service.dart';
import 'package:part_catalog/core/database/daos/supplier_settings_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/settings/api_control_center/state/api_control_center_state.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart';

final apiControlCenterNotifierProvider =
    StateNotifierProvider<ApiControlCenterNotifier, ApiControlCenterState>(
        (ref) {
  return ApiControlCenterNotifier(
    ref.watch(globalApiSettingsServiceProvider),
    ref
        .watch(appDatabaseProvider)
        .supplierSettingsDao, // Получаем DAO из провайдера БД
    ref.watch(appDatabaseProvider), // Передаем AppDatabase
  );
});

class ApiControlCenterNotifier extends StateNotifier<ApiControlCenterState> {
  final GlobalApiSettingsService _settingsService;
  final SupplierSettingsDao _supplierSettingsDao;
  final AppDatabase _appDatabase; // Добавляем AppDatabase
  final _logger = appLogger('ApiControlCenterNotifier');

  ApiControlCenterNotifier(
    this._settingsService,
    this._supplierSettingsDao,
    this._appDatabase, // Инициализируем AppDatabase
  ) : super(ApiControlCenterState.initial()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final mode = await _settingsService.getApiConnectionMode();
      final url = await _settingsService.getProxyUrl();

      // Загружаем все настройки поставщиков
      final allSettings = await _supplierSettingsDao.getAllSupplierSettings();
      final Map<String, SupplierSettingsItem> settingsMap = {
        for (var s in allSettings) s.supplierCode: s
      };

      final List<SupplierDisplayInfo> supplierInfos = [];
      for (var supportedSupplier in allSupportedSuppliers) {
        final setting = settingsMap[supportedSupplier.code];
        supplierInfos.add(SupplierDisplayInfo(
          code: supportedSupplier.code,
          displayName: supportedSupplier.displayName,
          // TODO: Улучшить логику определения статуса
          status: setting?.lastCheckStatus ?? 'Не настроен',
          isConfigured: setting != null &&
              (setting.encryptedCredentials?.isNotEmpty ?? false),
          // icon: supportedSupplier.icon, // Если добавили иконки в enum
        ));
      }

      state = state.copyWith(
        apiMode: mode,
        proxyUrl: url ?? '',
        suppliers: supplierInfos,
        isLoading: false,
      );
      _logger.i(
          'Initial data loaded: mode=$mode, suppliers=${supplierInfos.length}');
    } catch (e, s) {
      _logger.e('Error loading initial data', error: e, stackTrace: s);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setApiConnectionMode(ApiConnectionMode mode) async {
    state = state.copyWith(apiMode: mode, isLoading: true);
    try {
      await _settingsService.setApiConnectionMode(mode);
      // TODO: Уведомить ApiClientManager об изменении режима
      _logger.i('API connection mode set to: ${mode.name}');
      state = state.copyWith(isLoading: false);
    } catch (e, s) {
      _logger.e('Error setting API connection mode', error: e, stackTrace: s);
      state = state.copyWith(isLoading: false, error: e.toString());
      // Можно откатить изменение state.apiMode, если сохранение не удалось
    }
  }

  Future<void> setProxyUrl(String url) async {
    state = state.copyWith(proxyUrl: url, isLoading: true);
    try {
      await _settingsService.setProxyUrl(url);
      // TODO: Уведомить ApiClientManager об изменении URL
      _logger.i('Proxy URL set to: $url');
      state = state.copyWith(isLoading: false);
    } catch (e, s) {
      _logger.e('Error setting proxy URL', error: e, stackTrace: s);
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Метод для добавления/обновления настроек поставщика (заглушка для демонстрации)
  // В реальности это будет происходить на экране настроек конкретного поставщика
  Future<void> addOrUpdateTestSupplierSetting(
      SupplierCode supplierCode, bool configured) async {
    _logger.i(
        'Attempting to update test setting for ${supplierCode.code}, configured: $configured');
    try {
      final companion = SupplierSettingsItemsCompanion(
        supplierCode: Value(supplierCode.code),
        isEnabled: const Value(true),
        encryptedCredentials:
            Value(configured ? 'test_encrypted_data' : null), // Заглушка
        lastCheckStatus:
            Value(configured ? 'success' : 'not_configured'), // Заглушка
        additionalConfig:
            Value(configured ? '{"some_config":"value"}' : null), // Заглушка
        updatedAt: Value(DateTime.now()),
      );

      // Используем транзакцию для атомарности, если нужно несколько операций
      await _appDatabase.transaction(() async {
        await _supplierSettingsDao.upsertSupplierSetting(companion);
      });

      _logger.i('Test setting for ${supplierCode.code} updated in DB.');
      await loadInitialData(); // Перезагружаем данные, чтобы обновить UI
    } catch (e, s) {
      _logger.e('Error updating test supplier setting for ${supplierCode.code}',
          error: e, stackTrace: s);
      // Обработка ошибки (например, показать SnackBar)
    }
  }
}
