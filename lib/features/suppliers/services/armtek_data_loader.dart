import 'package:dio/dio.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/implementations/armtek_api_client.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_vkorg.dart';
import 'package:part_catalog/features/suppliers/models/supplier_config.dart';

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

/// Сервис для загрузки данных специфичных для Armtek API
class ArmtekDataLoader {
  final _logger = AppLoggers.suppliers;
  final Dio _dio;

  ArmtekDataLoader(this._dio);

  /// Создать API клиент из конфигурации
  ArmtekApiClient _createApiClient(SupplierConfig config) {
    final credentials = config.apiConfig.credentials;
    return ArmtekApiClient(
      _dio,
      baseUrl: config.apiConfig.baseUrl,
      username: credentials?.username,
      password: credentials?.password,
      vkorg: credentials?.additionalParams?['VKORG'],
    );
  }

  /// Валидация базовых параметров для Armtek API
  String? _validateBasicParams(SupplierConfig config) {
    if (config.apiConfig.baseUrl.isEmpty) {
      return 'Введите URL API';
    }

    final credentials = config.apiConfig.credentials;
    if (credentials == null ||
        (credentials.username?.isEmpty ?? true) ||
        (credentials.password?.isEmpty ?? true)) {
      return 'Введите логин и пароль для подключения';
    }

    return null;
  }

  /// Валидация параметров для операций, требующих VKORG
  String? _validateVkorgParams(SupplierConfig config) {
    final basicValidation = _validateBasicParams(config);
    if (basicValidation != null) return basicValidation;

    final vkorg = config.apiConfig.credentials?.additionalParams?['VKORG'];
    if (vkorg == null || vkorg.isEmpty) {
      return 'Необходимо выбрать VKORG';
    }

    return null;
  }

  /// Загрузить список доступных VKORG
  Future<ArmtekDataLoadResult<List<UserVkorg>>> loadVkorgList(
    SupplierConfig config,
  ) async {
    final validationError = _validateBasicParams(config);
    if (validationError != null) {
      return ArmtekDataLoadResult.failure(validationError);
    }

    try {
      final apiClient = _createApiClient(config);
      final response = await apiClient.getUserVkorgList();

      if (response.status == 200 && response.responseData != null) {
        _logger.d('Successfully loaded ${response.responseData!.length} VKORG items');
        return ArmtekDataLoadResult.success(response.responseData!);
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить список VKORG';
        _logger.w('Failed to load VKORG list: $errorMessage');
        return ArmtekDataLoadResult.failure(errorMessage);
      }
    } catch (e, stackTrace) {
      _logger.e('Error loading VKORG list', error: e, stackTrace: stackTrace);
      return ArmtekDataLoadResult.failure(
        'Ошибка при загрузке списка VKORG: ${e.toString()}',
      );
    }
  }

  /// Загрузить список брендов
  Future<ArmtekDataLoadResult<List<BrandItem>>> loadBrandList(
    SupplierConfig config,
  ) async {
    final validationError = _validateVkorgParams(config);
    if (validationError != null) {
      return ArmtekDataLoadResult.failure(validationError);
    }

    try {
      final apiClient = _createApiClient(config);
      final vkorg = config.apiConfig.credentials!.additionalParams!['VKORG']!;
      final response = await apiClient.getBrandList(vkorg);

      if (response.status == 200 && response.responseData != null) {
        _logger.d('Successfully loaded ${response.responseData!.length} brands');
        return ArmtekDataLoadResult.success(response.responseData!);
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить список брендов';
        _logger.w('Failed to load brand list: $errorMessage');
        return ArmtekDataLoadResult.failure(errorMessage);
      }
    } catch (e, stackTrace) {
      _logger.e('Error loading brand list', error: e, stackTrace: stackTrace);
      return ArmtekDataLoadResult.failure(
        'Ошибка при загрузке списка брендов: ${e.toString()}',
      );
    }
  }

  /// Загрузить список складов
  Future<ArmtekDataLoadResult<List<StoreItem>>> loadStoreList(
    SupplierConfig config,
  ) async {
    final validationError = _validateVkorgParams(config);
    if (validationError != null) {
      return ArmtekDataLoadResult.failure(validationError);
    }

    try {
      final apiClient = _createApiClient(config);
      final vkorg = config.apiConfig.credentials!.additionalParams!['VKORG']!;
      final response = await apiClient.getStoreList(vkorg);

      if (response.status == 200 && response.responseData != null) {
        _logger.d('Successfully loaded ${response.responseData!.length} stores');
        return ArmtekDataLoadResult.success(response.responseData!);
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить список складов';
        _logger.w('Failed to load store list: $errorMessage');
        return ArmtekDataLoadResult.failure(errorMessage);
      }
    } catch (e, stackTrace) {
      _logger.e('Error loading store list', error: e, stackTrace: stackTrace);
      return ArmtekDataLoadResult.failure(
        'Ошибка при загрузке списка складов: ${e.toString()}',
      );
    }
  }

  /// Загрузить информацию о пользователе
  Future<ArmtekDataLoadResult<UserInfoResponse>> loadUserInfo(
    SupplierConfig config,
  ) async {
    final validationError = _validateVkorgParams(config);
    if (validationError != null) {
      return ArmtekDataLoadResult.failure(validationError);
    }

    try {
      final apiClient = _createApiClient(config);
      final vkorg = config.apiConfig.credentials!.additionalParams!['VKORG']!;

      final request = UserInfoRequest(
        vkorg: vkorg,
        structure: '1',
        ftpData: '1',
      );

      final response = await apiClient.getUserInfo(request);

      if (response.status == 200 && response.responseData != null) {
        _logger.d('Successfully loaded user info');
        return ArmtekDataLoadResult.success(response.responseData!);
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Не удалось получить информацию о пользователе';
        _logger.w('Failed to load user info: $errorMessage');
        return ArmtekDataLoadResult.failure(errorMessage);
      }
    } catch (e, stackTrace) {
      _logger.e('Error loading user info', error: e, stackTrace: stackTrace);
      return ArmtekDataLoadResult.failure(
        'Ошибка при загрузке информации о пользователе: ${e.toString()}',
      );
    }
  }

  /// Проверить подключение к Armtek API
  Future<ArmtekDataLoadResult<void>> testConnection(
    SupplierConfig config,
  ) async {
    final validationError = _validateBasicParams(config);
    if (validationError != null) {
      return ArmtekDataLoadResult.failure(validationError);
    }

    try {
      final apiClient = _createApiClient(config);
      final response = await apiClient.pingService();

      if (response.status == 200) {
        _logger.i('Armtek connection test successful');
        return ArmtekDataLoadResult.success(null);
      } else {
        final errorMessage = response.messages?.isNotEmpty == true
            ? response.messages!.first.text
            : 'Неизвестная ошибка сервера';
        _logger.w('Armtek connection test failed: $errorMessage');
        return ArmtekDataLoadResult.failure(errorMessage);
      }
    } catch (e, stackTrace) {
      _logger.e('Armtek connection test error', error: e, stackTrace: stackTrace);
      return ArmtekDataLoadResult.failure(e.toString());
    }
  }
}