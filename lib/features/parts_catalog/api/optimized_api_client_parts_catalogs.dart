import 'package:dio/dio.dart';

import 'package:part_catalog/core/api/optimized_api_client_factory.dart';
import 'package:part_catalog/core/api/resilient_api_client.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/parts_catalog/models/car2.dart';
import 'package:part_catalog/features/parts_catalog/models/car_info.dart';
import 'package:part_catalog/features/parts_catalog/models/car_parameter_info.dart';
import 'package:part_catalog/features/parts_catalog/models/catalog.dart';
import 'package:part_catalog/features/parts_catalog/models/example_prices_response.dart';
import 'package:part_catalog/features/parts_catalog/models/group.dart';
import 'package:part_catalog/features/parts_catalog/models/groups_tree_response.dart';
import 'package:part_catalog/features/parts_catalog/models/model.dart';
import 'package:part_catalog/features/parts_catalog/models/parts.dart';
import 'package:part_catalog/features/parts_catalog/models/schemas_response.dart';
import 'package:part_catalog/features/parts_catalog/models/suggest.dart';

/// Оптимизированный клиент для API каталогов запчастей
/// с отказоустойчивостью, кэшированием и мониторингом
class OptimizedApiClientPartsCatalogs {
  final ResilientApiClient _resilientClient;
  final _logger = AppLoggers.suppliers; // Используем suppliers logger
  final String? _apiKey;
  final String _language;

  OptimizedApiClientPartsCatalogs._({
    required ResilientApiClient resilientClient,
    String? apiKey,
    String language = 'ru',
  })  : _resilientClient = resilientClient,
        _apiKey = apiKey,
        _language = language;

  /// Фабричный метод для создания оптимизированного клиента каталогов
  static OptimizedApiClientPartsCatalogs create({
    String baseUrl = 'https://api.parts-catalogs.com/v1',
    String? apiKey,
    String language = 'ru',
  }) {
    final resilientClient = OptimizedApiClientFactory.createPartsCatalogClient(
      baseUrl: baseUrl,
      apiKey: apiKey,
    );

    return OptimizedApiClientPartsCatalogs._(
      resilientClient: resilientClient,
      apiKey: apiKey,
      language: language,
    );
  }

  /// Получает базовый URL клиента
  String get baseUrl => _resilientClient.config.baseUrl;

  /// Получает статистику производительности
  Map<String, dynamic>? getMetrics() => _resilientClient.getMetrics();

  /// Получает статистику кеша
  Map<String, dynamic>? getCacheStats() => _resilientClient.getCacheStats();

  /// Получает статус circuit breaker
  Map<String, dynamic> getCircuitBreakerStatus() =>
      _resilientClient.getCircuitBreakerStatus();

  /// Выполняет health check
  Future<bool> performHealthCheck() => _resilientClient.performHealthCheck();

  /// Сбрасывает circuit breaker
  void resetCircuitBreaker() => _resilientClient.resetCircuitBreaker();

  /// Очищает кеш
  Future<void> clearCache() => _resilientClient.clearCache();

  /// Получает список доступных каталогов
  Future<List<Catalog>> getCatalogs({
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting catalogs list');

    try {
      final response = await _resilientClient.get(
        '/catalogs/',
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => Catalog.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getCatalogs');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting catalogs', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список моделей автомобилей для указанного каталога
  Future<List<Model>> getModels(
    String catalogId, {
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting models for catalog: $catalogId');

    try {
      final response = await _resilientClient.get(
        '/catalogs/$catalogId/models/',
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => Model.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getModels');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting models for catalog $catalogId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список автомобилей для указанного каталога и модели
  Future<List<Car2>> getCars2(
    String catalogId, {
    required String modelId,
    List<List<String>>? parameter,
    int? page,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting cars for catalog: $catalogId, model: $modelId');

    try {
      final queryParams = <String, dynamic>{
        'modelId': modelId,
        if (parameter != null) 'parameter': parameter,
        if (page != null) 'page': page,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/cars2/',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => Car2.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getCars2');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting cars for catalog $catalogId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает информацию об автомобиле по ID
  Future<Car2> getCarsById2(
    String catalogId,
    String carId, {
    String? criteria,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting car by ID: $carId in catalog: $catalogId');

    try {
      final queryParams = <String, dynamic>{
        if (criteria != null) 'criteria': criteria,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/cars2/$carId',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      return Car2.fromJson(response.data);
    } catch (e, stackTrace) {
      _logger.e('Error getting car by ID $carId',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает параметры фильтрации автомобилей для указанного каталога
  Future<List<CarParameterInfo>> getCarsParameters(
    String catalogId, {
    required String modelId,
    List<List<String>>? parameter,
    String? apiKey,
    String? language,
  }) async {
    _logger
        .i('Getting car parameters for catalog: $catalogId, model: $modelId');

    try {
      final queryParams = <String, dynamic>{
        'modelId': modelId,
        if (parameter != null) 'parameter': parameter,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/cars-parameters/',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => CarParameterInfo.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getCarsParameters');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting car parameters',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список групп для указанного каталога и автомобиля
  Future<List<Group>> getGroups(
    String catalogId, {
    required String carId,
    String? groupId,
    String? criteria,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting groups for catalog: $catalogId, car: $carId');

    try {
      final queryParams = <String, dynamic>{
        'carId': carId,
        if (groupId != null) 'groupId': groupId,
        if (criteria != null) 'criteria': criteria,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/groups2/',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => Group.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getGroups');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting groups', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает информацию об автомобиле по VIN или FRAME
  Future<List<CarInfo>> getCarInfo(
    String q, {
    String? catalogs,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting car info for: $q');

    try {
      final queryParams = <String, dynamic>{
        'q': q,
        if (catalogs != null) 'catalogs': catalogs,
      };

      final response = await _resilientClient.get(
        '/car/info',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => CarInfo.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getCarInfo');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting car info for $q',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список запчастей для указанного каталога, автомобиля и группы
  Future<Parts> getParts2(
    String catalogId, {
    required String carId,
    required String groupId,
    String? criteria,
    String? xRedirectTemplate,
    String? apiKey,
    String? language,
  }) async {
    _logger.i(
        'Getting parts for catalog: $catalogId, car: $carId, group: $groupId');

    try {
      final queryParams = <String, dynamic>{
        'carId': carId,
        'groupId': groupId,
        if (criteria != null) 'criteria': criteria,
      };

      final headers = <String, String>{
        if (xRedirectTemplate != null) 'x-redirect-template': xRedirectTemplate,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/parts2',
        queryParameters: queryParams,
        options: Options(
            headers: _buildHeaders(
          apiKey: apiKey,
          language: language,
          additionalHeaders: headers,
        )),
      );

      return Parts.fromJson(response.data);
    } catch (e, stackTrace) {
      _logger.e('Error getting parts', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список предложений для поиска групп
  Future<List<Suggest>> getGroupsSuggest(
    String catalogId, {
    required String q,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting groups suggestions for: $q');

    try {
      final queryParams = <String, dynamic>{
        'q': q,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/groups-suggest',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => Suggest.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getGroupsSuggest');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting groups suggestions',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список групп по ID поиска
  Future<List<Group>> getGroupsBySid(
    String catalogId, {
    required String sid,
    required String carId,
    String? criteria,
    String? text,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting groups by SID: $sid');

    try {
      final queryParams = <String, dynamic>{
        'sid': sid,
        'carId': carId,
        if (criteria != null) 'criteria': criteria,
        if (text != null) 'text': text,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/groups-by-sid',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => Group.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getGroupsBySid');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting groups by SID',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает пример цен на запчасти
  Future<List<ExamplePricesResponse>> getExamplePrices(
    String code,
    String brand, {
    String? apiKey,
  }) async {
    _logger.i('Getting example prices for: $code, brand: $brand');

    try {
      final queryParams = <String, dynamic>{
        'code': code,
        'brand': brand,
      };

      final response = await _resilientClient.get(
        '/example/prices',
        queryParameters: queryParams,
        options: Options(headers: _buildHeaders(apiKey: apiKey)),
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((item) => ExamplePricesResponse.fromJson(item))
            .toList();
      }

      _logger.w('Unexpected response format for getExamplePrices');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting example prices',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает дерево групп
  Future<List<GroupsTreeResponse>> getGroupsTree(
    String catalogId, {
    String? carId,
    String? criteria,
    bool? cached,
    String? apiKey,
  }) async {
    _logger.i('Getting groups tree for catalog: $catalogId');

    try {
      final queryParams = <String, dynamic>{
        if (carId != null) 'carId': carId,
        if (criteria != null) 'criteria': criteria,
        if (cached != null) 'cached': cached,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/groups-tree',
        queryParameters: queryParams,
        options: Options(headers: _buildHeaders(apiKey: apiKey)),
      );

      final data = response.data;
      if (data is List) {
        return data.map((item) => GroupsTreeResponse.fromJson(item)).toList();
      }

      _logger.w('Unexpected response format for getGroupsTree');
      return [];
    } catch (e, stackTrace) {
      _logger.e('Error getting groups tree', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает схемы, ведущие к страницам деталей
  Future<SchemasResponse> getSchemas(
    String catalogId, {
    required String carId,
    String? branchId,
    String? criteria,
    int? page,
    String? partNameIds,
    String? partName,
    String? apiKey,
    String? language,
  }) async {
    _logger.i('Getting schemas for catalog: $catalogId, car: $carId');

    try {
      final queryParams = <String, dynamic>{
        'carId': carId,
        if (branchId != null) 'branchId': branchId,
        if (criteria != null) 'criteria': criteria,
        if (page != null) 'page': page,
        if (partNameIds != null) 'partNameIds': partNameIds,
        if (partName != null) 'partName': partName,
      };

      final response = await _resilientClient.get(
        '/catalogs/$catalogId/schemas',
        queryParameters: queryParams,
        options:
            Options(headers: _buildHeaders(apiKey: apiKey, language: language)),
      );

      return SchemasResponse.fromJson(response.data);
    } catch (e, stackTrace) {
      _logger.e('Error getting schemas', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Освобождает ресурсы клиента
  void dispose() {
    _resilientClient.dispose();
  }

  // Вспомогательные методы

  Map<String, String> _buildHeaders({
    String? apiKey,
    String? language,
    Map<String, String>? additionalHeaders,
  }) {
    final headers = <String, String>{};

    final effectiveApiKey = apiKey ?? _apiKey;
    if (effectiveApiKey != null) {
      headers['Authorization'] = 'Bearer $effectiveApiKey';
    }

    final effectiveLanguage = language ?? _language;
    headers['Accept-Language'] = effectiveLanguage;

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }
}