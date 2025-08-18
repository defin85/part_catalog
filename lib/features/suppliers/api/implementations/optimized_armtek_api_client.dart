import 'package:part_catalog/core/api/optimized_api_client_factory.dart';
import 'package:part_catalog/core/api/resilient_api_client.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/api/api_connection_mode.dart';
import 'package:part_catalog/features/suppliers/api/base_supplier_api_client.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart';
import 'package:part_catalog/features/suppliers/models/armtek/armtek_message.dart';
import 'package:part_catalog/features/suppliers/models/armtek/armtek_response_wrapper.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/order_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/ping_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/price_status_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/search_result.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_vkorg.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';

const String armtekBaseUrl = "http://ws.armtek.ru/api";

/// Оптимизированный клиент Armtek API с отказоустойчивостью, кэшированием и мониторингом
class OptimizedArmtekApiClient implements BaseSupplierApiClient {
  final ResilientApiClient _resilientClient;
  final _logger = AppLoggers.suppliers;
  final String? _vkorg;
  // final String? _username; // Сохранено для будущего использования
  // final String? _password; // Сохранено для будущего использования

  OptimizedArmtekApiClient._({
    required ResilientApiClient resilientClient,
    String? vkorg,
  })  : _resilientClient = resilientClient,
        _vkorg = vkorg;

  /// Фабричный метод для создания оптимизированного Armtek API клиента
  static Future<OptimizedArmtekApiClient> create({
    required ApiConnectionMode connectionMode,
    String? username,
    String? password,
    String? vkorg,
    String? proxyUrl,
    String? proxyAuthToken,
  }) async {
    final resilientClient = OptimizedApiClientFactory.createSupplierClient(
      supplierCode: 'armtek',
      baseUrl: armtekBaseUrl,
      connectionMode: connectionMode,
      username: username,
      password: password,
      proxyUrl: proxyUrl,
      proxyAuthToken: proxyAuthToken,
      additionalHeaders: vkorg != null ? {'X-Default-VKORG': vkorg} : null,
    );

    return OptimizedArmtekApiClient._(
      resilientClient: resilientClient,
      vkorg: vkorg,
      // username: username,
      // password: password,
    );
  }

  @override
  String get supplierName => SupplierCode.armtek.name;

  @override
  String get supplierCode => SupplierCode.armtek.code;

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

  @override
  Future<bool> checkConnection() async {
    try {
      final response = await pingService();

      if (response.status == 200 && response.responseData != null) {
        _logger.i('API Armtek доступно. IP: ${response.responseData?.ip}, '
            'Время выполнения: ${response.responseData?.time}');
        return true;
      } else {
        _logger.w('API Armtek недоступно. Статус ответа: ${response.status}');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('Ошибка при проверке доступности API Armtek',
          error: e, stackTrace: stackTrace);
      return false;
    }
  }

  @override
  Future<List<PartPriceModel>> getPricesByArticle(String articleNumber,
      {String? brand}) async {
    if (_vkorg == null) {
      throw Exception('VKORG not configured for Armtek API client');
    }

    _logger.i(
        'Поиск цен на запчасть: $articleNumber (бренд: ${brand ?? "любой"})');

    try {
      final response = await _resilientClient.post(
        '/ws_search/getPrice',
        data: {
          'VKORG': _vkorg,
          'PIN': articleNumber,
          if (brand != null) 'BRAND': brand,
          'format': 'json',
        },
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        _logger.w('Неожиданный формат ответа от Armtek API');
        return [];
      }

      final status = data['STATUS'] as int? ?? 500;
      if (status != 200) {
        _logger.w('Armtek API вернул ошибку: $status');
        return [];
      }

      final respData = data['RESP'] as List<dynamic>? ?? [];
      _logger.i(
          'Получено ${respData.length} предложений для артикула $articleNumber');

      return respData.map<PartPriceModel>((item) {
        if (item is Map<String, dynamic>) {
          final searchResult = SearchResult.fromJson(item);
          return PartPriceModel(
            article: searchResult.articleNumber ?? articleNumber,
            brand: searchResult.brand ?? brand ?? '',
            name: searchResult.name ?? '',
            price: searchResult.price ?? 0.0,
            quantity: searchResult.quantity ?? 0,
            deliveryDays: searchResult.deliveryTime ?? 0,
            supplierName: supplierName,
            originalArticle:
                searchResult.additionalData?['originalNumber'] as String?,
            comment: searchResult.additionalData?['comment'] as String?,
            priceUpdatedAt:
                _parseDateTime(searchResult.additionalData?['priceDate']),
            additionalProperties: {
              'store': searchResult.additionalData?['store'],
              'availability': searchResult.additionalData?['availability'],
              'manager': searchResult.additionalData?['manager'],
              'currency': searchResult.additionalData?['currency'] ?? 'RUB',
              'supplier': searchResult.supplier,
            },
          );
        }
        return PartPriceModel(
          article: articleNumber,
          brand: brand ?? '',
          name: '',
          price: 0.0,
          quantity: 0,
          deliveryDays: 0,
          supplierName: supplierName,
        );
      }).toList();
    } catch (e, stackTrace) {
      _logger.e(
          'Ошибка при получении цен от Armtek для артикула $articleNumber',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Проверяет доступность сервиса Armtek
  Future<ArmtekResponseWrapper<PingResponse>> pingService() async {
    _logger.i('Проверка доступности сервиса Armtek...');

    try {
      final response = await _resilientClient.get(
        '/ws_ping/index',
        queryParameters: {'format': 'json'},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception('Неожиданный формат ответа от ping service');
      }

      final status = data['STATUS'] as int? ?? 500;
      final respData = data['RESP'] as Map<String, dynamic>? ?? {};
      final messages = (data['MESSAGES'] as List? ?? [])
          .map((e) => e is Map<String, dynamic>
              ? ArmtekMessage.fromJson(e)
              : ArmtekMessage(
                  type: 'INFO',
                  text: e.toString(),
                  date: DateTime.now().toIso8601String()))
          .toList();

      final pingResponse =
          respData.isNotEmpty ? PingResponse.fromJson(respData) : null;

      if (pingResponse != null) {
        _logger.i('Сервис Armtek доступен. IP: ${pingResponse.ip}, '
            'Время выполнения: ${pingResponse.time}');
      }

      return ArmtekResponseWrapper<PingResponse>(
        status: status,
        responseData: pingResponse,
        messages: messages,
      );
    } catch (e, stackTrace) {
      _logger.e('Ошибка при проверке сервиса Armtek',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список VKORG для пользователя
  Future<ArmtekResponseWrapper<List<UserVkorg>>> getUserVkorgList() async {
    _logger.i('Получение списка VKORG');

    try {
      final response = await _resilientClient.get(
        '/ws_user/getUserVkorgList',
        queryParameters: {'format': 'json'},
      );

      return _parseArmtekResponse<List<UserVkorg>>(
        response.data,
        (data) => (data as List).map((e) => UserVkorg.fromJson(e)).toList(),
      );
    } catch (e, stackTrace) {
      _logger.e('Ошибка при получении списка VKORG',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает информацию о пользователе
  Future<ArmtekResponseWrapper<UserInfoResponse>> getUserInfo(
      UserInfoRequest request) async {
    _logger.i('Getting user info for VKORG: ${request.vkorg}');

    try {
      final response = await _resilientClient.post(
        '/ws_user/getUserInfo',
        data: {
          'VKORG': request.vkorg,
          if (request.structure != null) 'STRUCTURE': request.structure,
          if (request.ftpData != null) 'FTPDATA': request.ftpData,
          'format': 'json',
        },
      );

      return _parseArmtekResponse<UserInfoResponse>(
        response.data,
        (data) => UserInfoResponse.fromJson(data),
      );
    } catch (e, stackTrace) {
      _logger.e('Error in getUserInfo', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает список брендов
  Future<ArmtekResponseWrapper<List<BrandItem>>> getBrandList(
      String vkorg) async {
    _logger.i('Getting brand list for VKORG: $vkorg');

    try {
      final response = await _resilientClient.get(
        '/ws_user/getBrandList',
        queryParameters: {
          'VKORG': vkorg,
          'format': 'json',
        },
      );

      return _parseArmtekResponse<List<BrandItem>>(
        response.data,
        (data) {
          final List<BrandItem> brandItems = [];
          final respData = data;

          for (var item in respData) {
            try {
              if (item is String) {
                brandItems.add(BrandItem.fromString(item));
              } else if (item is Map<String, dynamic>) {
                brandItems.add(BrandItem.fromJson(item));
              } else if (item != null) {
                brandItems.add(BrandItem.fromString(item.toString()));
              }
            } catch (e) {
              _logger.w('Error parsing brand item: $item, error: $e');
              continue;
            }
          }

          _logger.i('Successfully parsed ${brandItems.length} brands');
          return brandItems;
        },
      );
    } catch (e, stackTrace) {
      _logger.e('Error in getBrandList', error: e, stackTrace: stackTrace);

      return ArmtekResponseWrapper<List<BrandItem>>(
        status: 500,
        responseData: <BrandItem>[],
        messages: [
          ArmtekMessage(
              type: 'ERROR',
              text: 'Error: ${e.toString()}',
              date: DateTime.now().toIso8601String())
        ],
      );
    }
  }

  /// Получает список складов
  Future<ArmtekResponseWrapper<List<StoreItem>>> getStoreList(
      String vkorg) async {
    _logger.i('Getting store list for VKORG: $vkorg');

    try {
      final vkorgNum = int.parse(vkorg);
      final response = await _resilientClient.post(
        '/ws_user/getStoreList',
        data: {'VKORG': vkorgNum},
      );

      return _parseArmtekResponse<List<StoreItem>>(
        response.data,
        (data) {
          final List<StoreItem> storeItems = [];
          final respData = data;

          for (var item in respData) {
            try {
              if (item is String) {
                storeItems.add(StoreItem.fromString(item));
              } else if (item is Map<String, dynamic>) {
                storeItems.add(StoreItem.fromJson(item));
              } else if (item != null) {
                storeItems.add(StoreItem.fromString(item.toString()));
              }
            } catch (e) {
              _logger.w('Error parsing store item: $item, error: $e');
              continue;
            }
          }

          _logger.i('Successfully parsed ${storeItems.length} stores');
          return storeItems;
        },
      );
    } catch (e, stackTrace) {
      _logger.e('Error in getStoreList', error: e, stackTrace: stackTrace);

      return ArmtekResponseWrapper<List<StoreItem>>(
        status: 500,
        responseData: <StoreItem>[],
        messages: [
          ArmtekMessage(
              type: 'ERROR',
              text: 'Error: ${e.toString()}',
              date: DateTime.now().toIso8601String())
        ],
      );
    }
  }

  /// Получает статус обработки прайса по ключу
  Future<ArmtekResponseWrapper<PriceStatusResponse>> getPriceStatusByKey(
      String key) async {
    _logger.i('Getting price status for key: $key');

    try {
      final response = await _resilientClient.post(
        '/ws_user/getPriceStatusByKey',
        data: {
          'KEY': key,
          'format': 'json',
        },
      );

      return _parseArmtekResponse<PriceStatusResponse>(
        response.data,
        (data) => PriceStatusResponse.fromJson(data),
      );
    } catch (e, stackTrace) {
      _logger.e('Error in getPriceStatusByKey',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Поиск запчастей по артикулу
  Future<List<PartPriceModel>> searchPartsByArticle(String articleNumber,
      {String? brand}) async {
    if (_vkorg == null) {
      throw Exception('VKORG not configured for Armtek API client');
    }

    _logger.i('Поиск запчастей: $articleNumber (бренд: ${brand ?? "любой"})');

    try {
      final response = await _resilientClient.post(
        '/ws_search/search',
        data: {
          'VKORG': _vkorg,
          'PIN': articleNumber,
          if (brand != null) 'BRAND': brand,
          'format': 'json',
        },
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        _logger.w('Неожиданный формат ответа от Armtek search API');
        return [];
      }

      final status = data['STATUS'] as int? ?? 500;
      if (status != 200) {
        _logger.w('Armtek search API вернул ошибку: $status');
        return [];
      }

      final respData = data['RESP'] as List<dynamic>? ?? [];
      _logger.i(
          'Найдено ${respData.length} вариантов для артикула $articleNumber');

      return respData.map<PartPriceModel>((item) {
        if (item is Map<String, dynamic>) {
          final searchResult = SearchResult.fromJson(item);
          return PartPriceModel(
            article: searchResult.articleNumber ?? articleNumber,
            brand: searchResult.brand ?? brand ?? '',
            name: searchResult.name ?? '',
            price: searchResult.price ?? 0.0,
            quantity: searchResult.quantity ?? 0,
            deliveryDays: searchResult.deliveryTime ?? 0,
            supplierName: supplierName,
            originalArticle:
                searchResult.additionalData?['originalNumber'] as String?,
            comment: searchResult.additionalData?['comment'] as String?,
            priceUpdatedAt:
                _parseDateTime(searchResult.additionalData?['priceDate']),
            additionalProperties: {
              'store': searchResult.additionalData?['store'],
              'availability': searchResult.additionalData?['availability'],
              'manager': searchResult.additionalData?['manager'],
              'currency': searchResult.additionalData?['currency'] ?? 'RUB',
              'supplier': searchResult.supplier,
            },
          );
        }
        return PartPriceModel(
          article: articleNumber,
          brand: brand ?? '',
          name: '',
          price: 0.0,
          quantity: 0,
          deliveryDays: 0,
          supplierName: supplierName,
        );
      }).toList();
    } catch (e, stackTrace) {
      _logger.e(
          'Ошибка при поиске запчастей Armtek для артикула $articleNumber',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создает тестовый заказ
  Future<ArmtekResponseWrapper<OrderResponse>> createTestOrder({
    required String vkorg,
    required String kunnrRg,
    String? kunnrWe,
    String? kunnrZa,
    String? incoterms,
    String? parnr,
    String? vbeln,
    String? textOrd,
    String? textExp,
    String? dbtyp,
    required String items,
  }) async {
    _logger.i('Creating test order for VKORG: $vkorg');

    try {
      final response = await _resilientClient.post(
        '/ws_order/createTestOrder',
        data: {
          'VKORG': vkorg,
          'KUNRG': kunnrRg,
          if (kunnrWe != null) 'KUNWE': kunnrWe,
          if (kunnrZa != null) 'KUNZA': kunnrZa,
          if (incoterms != null) 'INCOTERMS': incoterms,
          if (parnr != null) 'PARNR': parnr,
          if (vbeln != null) 'VBELN': vbeln,
          if (textOrd != null) 'TEXT_ORD': textOrd,
          if (textExp != null) 'TEXT_EXP': textExp,
          if (dbtyp != null) 'DBTYP': dbtyp,
          'ITEMS': items,
          'format': 'json',
        },
      );

      return _parseArmtekResponse<OrderResponse>(
        response.data,
        (data) => OrderResponse.fromJson(data),
      );
    } catch (e, stackTrace) {
      _logger.e('Error in createTestOrder', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Освобождает ресурсы клиента
  void dispose() {
    _resilientClient.dispose();
  }

  // Вспомогательные методы

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  ArmtekResponseWrapper<T> _parseArmtekResponse<T>(
    dynamic responseData,
    T Function(dynamic) dataParser,
  ) {
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Неожиданный формат ответа от Armtek API');
    }

    final data = responseData;
    final status = data['STATUS'] as int? ?? 500;
    final respData = data['RESP'];
    final messages = (data['MESSAGES'] as List? ?? [])
        .map((e) => e is Map<String, dynamic>
            ? ArmtekMessage.fromJson(e)
            : ArmtekMessage(
                type: 'INFO',
                text: e.toString(),
                date: DateTime.now().toIso8601String()))
        .toList();

    T? parsedData;
    if (respData != null) {
      try {
        parsedData = dataParser(respData);
      } catch (e) {
        _logger.w('Error parsing response data: $e');
        // parsedData остается null
      }
    }

    return ArmtekResponseWrapper<T>(
      status: status,
      responseData: parsedData,
      messages: messages,
    );
  }
}
