import 'dart:convert'; // For base64Encode

import 'package:dio/dio.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
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
import 'package:retrofit/retrofit.dart';

part 'armtek_api_client.g.dart';

const String armtekBaseUrl =
    "http://ws.armtek.ru/api"; // Можно вынести в конфигурацию



@RestApi(baseUrl: armtekBaseUrl)
abstract class ArmtekRestInterface {
  factory ArmtekRestInterface(Dio dio, {String baseUrl}) = _ArmtekRestInterface;

  // --- ServicePing ---
  @GET("/ws_ping/index")
  Future<ArmtekResponseWrapper<PingResponse>> pingService({
    @Query("format") String format = "json",
  });

  // --- ServiceUser ---
  @GET("/ws_user/getUserVkorgList")
  Future<ArmtekResponseWrapper<List<UserVkorg>>> getUserVkorgList({
    @Query("format") String format = "json",
  });

  @POST("/ws_user/getUserInfo")
  @FormUrlEncoded() // Armtek API может ожидать form-urlencoded для POST
  Future<ArmtekResponseWrapper<UserInfoResponse>> getUserInfo({
    @Field("VKORG") required String vkorg,
    @Field("STRUCTURE") String? structure, // '0' or '1'
    @Field("FTPDATA") String? ftpData, // '0' or '1'
    @Query("format") String format = "json",
  });

  /// Добавляем метод getBrandList
  @GET("/ws_user/getBrandList")
  Future<ArmtekResponseWrapper<List<BrandItem>>> getBrandList({
    @Query("VKORG") required String vkorg,
    @Query("format") String format = "json",
  });

  // getStoreList - получение списка складов (POST с JSON)
  @POST("/ws_user/getStoreList")
  Future<ArmtekResponseWrapper<List<StoreItem>>> getStoreList({
    @Body() required Map<String, dynamic> body,
  });

  /// Получение статуса обработки прайса по ключу
  @POST("/ws_user/getPriceStatusByKey")
  @FormUrlEncoded()
  Future<ArmtekResponseWrapper<PriceStatusResponse>> getPriceStatusByKey({
    @Field("KEY") required String key,
    @Field("format") String format = "json",
  });

  // --- ServiceSearch ---
  /// Поиск запчастей по артикулу и бренду
  @POST("/ws_search/search")
  @FormUrlEncoded()
  Future<ArmtekResponseWrapper<List<SearchResult>>> searchParts({
    @Field("VKORG") required String vkorg,
    @Field("PIN") required String articleNumber, // Артикул (в API используется PIN)
    @Field("BRAND") String? brand,
    @Field("format") String format = "json",
    @Field("KUNNR_RG") String? kunnrRg, // Код покупателя
    @Field("KUNNR_ZA") String? kunnrZa, // Код адреса доставки
    @Field("QUERY_TYPE") String? queryType, // Тип запроса
    @Field("INCOTERMS") String? incoterms, // Условия доставки
    @Field("VBELN") String? vbeln, // Номер договора
  });

  /// Получение цен и наличия для конкретной запчасти
  @POST("/ws_search/getPrice")
  @FormUrlEncoded()
  Future<ArmtekResponseWrapper<List<SearchResult>>> getPrices({
    @Field("VKORG") required String vkorg,
    @Field("PIN") required String articleNumber, // Артикул (в API используется PIN)
    @Field("BRAND") String? brand,
    @Field("format") String format = "json",
    @Field("KUNNR_RG") String? kunnrRg, // Код покупателя
    @Field("KUNNR_ZA") String? kunnrZa, // Код адреса доставки
    @Field("INCOTERMS") String? incoterms, // Условия доставки
    @Field("VBELN") String? vbeln, // Номер договора
  });

  // --- ServiceOrder ---
  /// Создание тестового заказа
  @POST("/ws_order/createTestOrder")
  @FormUrlEncoded()
  Future<ArmtekResponseWrapper<OrderResponse>> createTestOrder({
    @Field("VKORG") required String vkorg,
    @Field("KUNRG") required String kunnrRg, // Код покупателя (плательщика)
    @Field("KUNWE") String? kunnrWe, // Код грузополучателя
    @Field("KUNZA") String? kunnrZa, // Код адреса доставки
    @Field("INCOTERMS") String? incoterms, // Условия доставки
    @Field("PARNR") String? parnr, // Код контактного лица
    @Field("VBELN") String? vbeln, // Номер договора
    @Field("TEXT_ORD") String? textOrd, // Комментарий к заказу
    @Field("TEXT_EXP") String? textExp, // Комментарий к отгрузке
    @Field("DBTYP") String? dbtyp, // Тип базы данных
    @Field("ITEMS") required String items, // JSON массив позиций заказа
    @Field("format") String format = "json",
  });
}

class ArmtekApiClient implements BaseSupplierApiClient {
  final Dio _dio;
  final ArmtekRestInterface _client;
  final _logger = AppLoggers.suppliers;
  final String _effectiveBaseUrl;
  final String? _vkorg; // Идентификатор организации

  ArmtekApiClient(this._dio,
      {String? username,
      String? password,
      String? baseUrl,
      String? proxyAuthToken,
      String? vkorg})
      : _effectiveBaseUrl = baseUrl ?? armtekBaseUrl,
        _vkorg = vkorg,
        _client = ArmtekRestInterface(_dio, baseUrl: baseUrl ?? armtekBaseUrl) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // _logger.d('Interceptor onRequest: ${options.method} ${options.uri}');
        // _logger.d('Base URL: ${options.baseUrl}, Effective URL: $_effectiveBaseUrl');
        
        // Логируем тело запроса для POST
        // if (options.method == 'POST') {
        //   _logger.d('Request body: ${options.data}');
        // }
        
        // Используем _effectiveBaseUrl для проверки, так как options.baseUrl может быть изменен Dio
        if (_effectiveBaseUrl == armtekBaseUrl ||
            _effectiveBaseUrl.contains('ws.armtek.ru')) {
          // Если это прямой запрос к Armtek
          if (username != null && password != null) {
            final basicAuth =
                'Basic ${base64Encode(utf8.encode('$username:$password'))}';
            options.headers['Authorization'] = basicAuth;
            // _logger.d('Added Authorization header for direct Armtek request');
          } else if (proxyAuthToken == null) {
            // Логика для случая, когда это прямой запрос, но нет username/password
            // Возможно, здесь стоит выбросить ошибку конфигурации, если они ожидаются
            // _logger.w('ArmtekApiClient: Direct request but no credentials provided.');
          }
        }
        // Если это запрос к прокси и есть токен для прокси
        // Сравниваем options.baseUrl с _effectiveBaseUrl, который был использован для создания клиента
        if (proxyAuthToken != null &&
            options.baseUrl == _effectiveBaseUrl &&
            _effectiveBaseUrl !=
                armtekBaseUrl /* Убедимся, что это действительно прокси URL */) {
          options.headers['X-Proxy-Auth-Token'] =
              proxyAuthToken; // Пример заголовка для прокси
          // _logger.d('Added X-Proxy-Auth-Token header for proxy request');
        }
        
        // _logger.d('Final headers: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
    ));
  }

  /// Возвращает базовый URL, с которым был сконфигурирован этот клиент.
  String get baseUrl => _effectiveBaseUrl; // Добавлен геттер

  @override
  String get supplierName => SupplierCode.armtek.name;

  @override
  String get supplierCode => SupplierCode.armtek.code;

  // --- Реализация методов BaseSupplierApiClient ---

  @override
  Future<List<PartPriceModel>> getPricesByArticle(String articleNumber,
      {String? brand}) async {
    if (_vkorg == null) {
      throw Exception('VKORG not configured for Armtek API client');
    }

    _logger.i('Поиск цен на запчасть: $articleNumber (бренд: ${brand ?? "любой"})');
    
    try {
      // Используем метод getPrices для получения цен
      final response = await _client.getPrices(
        vkorg: _vkorg,
        articleNumber: articleNumber,
        brand: brand,
      );

      if (response.status != 200 || response.responseData == null) {
        _logger.w('Armtek API вернул пустой ответ для артикула $articleNumber');
        return [];
      }

      final prices = response.responseData ?? [];
      _logger.i('Получено ${prices.length} предложений для артикула $articleNumber');

      return prices.map((item) {
        return PartPriceModel(
          article: item.articleNumber ?? articleNumber,
          brand: item.brand ?? brand ?? '',
          name: item.name ?? '',
          price: item.price ?? 0.0,
          quantity: item.quantity ?? 0,
          deliveryDays: item.deliveryTime ?? 0,
          supplierName: supplierName,
          originalArticle: item.additionalData?['originalNumber'] as String?,
          comment: item.additionalData?['comment'] as String?,
          priceUpdatedAt: _parseDateTime(item.additionalData?['priceDate']),
          additionalProperties: {
            'store': item.additionalData?['store'],
            'availability': item.additionalData?['availability'],
            'manager': item.additionalData?['manager'],
            'currency': item.additionalData?['currency'] ?? 'RUB',
            'supplier': item.supplier,
          },
        );
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Ошибка при получении цен от Armtek для артикула $articleNumber',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Вспомогательные методы для парсинга данных
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  @override
  Future<bool> checkConnection() async {
    try {
      // Используем наш метод pingService вместо прямого запроса
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

  // --- Методы для проверки сервиса (ServicePing) ---

  /// Проверяет доступность сервиса Armtek
  Future<ArmtekResponseWrapper<PingResponse>> pingService() async {
    _logger.i('Проверка доступности сервиса Armtek...');
    try {
      final response = await _client.pingService();

      final pingData = response.responseData;
      if (pingData != null) {
        _logger.i('Сервис Armtek доступен. IP: ${pingData.ip}, '
            'Время выполнения: ${pingData.time}');
      } else {
        _logger.i('Сервис Armtek доступен, но данные отсутствуют.');
      }

      return response;
    } catch (e, stackTrace) {
      _logger.e('Ошибка при проверке сервиса Armtek',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // --- Методы специфичные для Armtek API (из ServiceUser) ---

  Future<ArmtekResponseWrapper<List<UserVkorg>>> getUserVkorgList() async {
    return _client.getUserVkorgList();
  }

  Future<ArmtekResponseWrapper<UserInfoResponse>> getUserInfo(
      UserInfoRequest request) async {
    _logger.i('Getting user info for VKORG: ${request.vkorg}, structure: ${request.structure}, ftpData: ${request.ftpData}');
    _logger.d('Current base URL: $_effectiveBaseUrl');
    
    try {
      final response = await _client.getUserInfo(
        vkorg: request.vkorg,
        structure: request.structure,
        ftpData: request.ftpData,
      );
      
      _logger.i('getUserInfo response status: ${response.status}');
      return response;
    } catch (e, stackTrace) {
      _logger.e('Error in getUserInfo', error: e, stackTrace: stackTrace);
      
      // Если это DioException, давайте посмотрим на детали
      if (e is DioException) {
        _logger.e('DioException details:');
        _logger.e('- Status code: ${e.response?.statusCode}');
        _logger.e('- Status message: ${e.response?.statusMessage}');
        _logger.e('- Response data: ${e.response?.data}');
        _logger.e('- Request data: ${e.requestOptions.data}');
        _logger.e('- Request headers: ${e.requestOptions.headers}');
        _logger.e('- Request URI: ${e.requestOptions.uri}');
      }
      
      rethrow;
    }
  }

  // Добавляем метод getBrandList
  Future<ArmtekResponseWrapper<List<BrandItem>>> getBrandList(
      String vkorg) async {
    // _logger.i('Getting brand list for VKORG: $vkorg');
    // _logger.d('Making request to: $_effectiveBaseUrl/ws_user/getBrandList');
    try {
      // Попробуем получить сырой ответ через Dio с полным URL
      final response = await _dio.get(
        '$_effectiveBaseUrl/ws_user/getBrandList',
        queryParameters: {
          'VKORG': vkorg,
          'format': 'json',
        },
      );
      
      
      // Парсим ответ вручную
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap = response.data;
        final int status = responseMap['STATUS'] ?? 500;
        final List<dynamic> respData = responseMap['RESP'] ?? [];
        
        // _logger.d('getBrandList response status: $status');
        // _logger.d('getBrandList RESP length: ${respData.length}');
        // if (respData.isNotEmpty) {
        //   _logger.d('First RESP item: ${respData.first}');
        // }
        
        final List<ArmtekMessage> messages = (responseMap['MESSAGES'] as List<dynamic>?)
            ?.map((e) => e is Map<String, dynamic> 
                ? ArmtekMessage.fromJson(e)
                : ArmtekMessage(type: 'INFO', text: e.toString(), date: DateTime.now().toIso8601String()))
            .toList() ?? [];
        
        
        // Обрабатываем данные в основном потоке (без изолята для упрощения)
        List<BrandItem> brandItems = [];
        for (var item in respData) {
          try {
            if (item is String) {
              brandItems.add(BrandItem.fromString(item));
            } else if (item is Map<String, dynamic>) {
              brandItems.add(BrandItem.fromJson(item));
            } else if (item == null) {
              _logger.w('Null item in brandList, skipping');
              continue;
            } else {
              brandItems.add(BrandItem.fromString(item.toString()));
            }
          } catch (e) {
            _logger.w('Error parsing brand item: $item, error: $e');
            continue;
          }
        }
        
        // _logger.i('Successfully parsed ${brandItems.length} brands');
        
        return ArmtekResponseWrapper<List<BrandItem>>(
          status: status,
          responseData: brandItems,
          messages: messages,
        );
      } else {
        _logger.e('Unexpected response format in getBrandList');
        return ArmtekResponseWrapper<List<BrandItem>>(
          status: 500,
          responseData: <BrandItem>[],
          messages: [ArmtekMessage(type: 'ERROR', text: 'Unexpected response format', date: DateTime.now().toIso8601String())],
        );
      }
    } catch (e, stackTrace) {
      _logger.e('Error in getBrandList', error: e, stackTrace: stackTrace);
      
      // Добавляем более детальную информацию об ошибке
      String errorDetails = 'Error: ${e.toString()}';
      if (e.toString().contains('type cast')) {
        errorDetails += ' - Possible null value in API response';
      }
      
      return ArmtekResponseWrapper<List<BrandItem>>(
        status: 500,
        responseData: <BrandItem>[],
        messages: [ArmtekMessage(type: 'ERROR', text: errorDetails, date: DateTime.now().toIso8601String())],
      );
    }
  }

  // Добавляем метод getStoreList
  Future<ArmtekResponseWrapper<List<StoreItem>>> getStoreList(
      String vkorg) async {
    // _logger.i('Getting store list for VKORG: $vkorg');
    // Преобразуем VKORG в число
    final vkorgNum = int.parse(vkorg);
    // _logger.d('Sending getStoreList request with VKORG: $vkorgNum (type: ${vkorgNum.runtimeType})');
    
    try {
      // Попробуем получить сырой ответ через Dio с полным URL
      final response = await _dio.post(
        '$_effectiveBaseUrl/ws_user/getStoreList',
        data: {'VKORG': vkorgNum},
      );
      
      
      // Парсим ответ вручную
      if (response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseMap = response.data;
        final int status = responseMap['STATUS'] ?? 500;
        final List<dynamic> respData = responseMap['RESP'] ?? [];
        final List<ArmtekMessage> messages = (responseMap['MESSAGES'] as List<dynamic>?)
            ?.map((e) => e is Map<String, dynamic> 
                ? ArmtekMessage.fromJson(e)
                : ArmtekMessage(type: 'INFO', text: e.toString(), date: DateTime.now().toIso8601String()))
            .toList() ?? [];
        
        
        // Обрабатываем данные в основном потоке (без изолята для упрощения)
        List<StoreItem> storeItems = [];
        for (var item in respData) {
          try {
            if (item is String) {
              storeItems.add(StoreItem.fromString(item));
            } else if (item is Map<String, dynamic>) {
              storeItems.add(StoreItem.fromJson(item));
            } else if (item == null) {
              _logger.w('Null item in storeList, skipping');
              continue;
            } else {
              storeItems.add(StoreItem.fromString(item.toString()));
            }
          } catch (e) {
            _logger.w('Error parsing store item: $item, error: $e');
            continue;
          }
        }
        
        // _logger.i('Successfully parsed ${storeItems.length} stores');
        
        return ArmtekResponseWrapper<List<StoreItem>>(
          status: status,
          responseData: storeItems,
          messages: messages,
        );
      } else {
        _logger.e('Unexpected response format in getStoreList');
        return ArmtekResponseWrapper<List<StoreItem>>(
          status: 500,
          responseData: <StoreItem>[],
          messages: [ArmtekMessage(type: 'ERROR', text: 'Unexpected response format', date: DateTime.now().toIso8601String())],
        );
      }
    } catch (e, stackTrace) {
      _logger.e('Error in getStoreList', error: e, stackTrace: stackTrace);
      
      
      return ArmtekResponseWrapper<List<StoreItem>>(
        status: 500,
        responseData: <StoreItem>[],
        messages: [ArmtekMessage(type: 'ERROR', text: 'Error: ${e.toString()}', date: DateTime.now().toIso8601String())],
      );
    }
  }


  /// Поиск запчастей по артикулу (расширенный поиск)
  Future<List<PartPriceModel>> searchPartsByArticle(String articleNumber,
      {String? brand}) async {
    if (_vkorg == null) {
      throw Exception('VKORG not configured for Armtek API client');
    }

    _logger.i('Поиск запчастей: $articleNumber (бренд: ${brand ?? "любой"})');
    
    try {
      final response = await _client.searchParts(
        vkorg: _vkorg,
        articleNumber: articleNumber,
        brand: brand,
      );

      if (response.status != 200 || response.responseData == null) {
        _logger.w('Armtek поиска вернул пустой ответ для артикула $articleNumber');
        return [];
      }

      final searchResults = response.responseData ?? [];
      _logger.i('Найдено ${searchResults.length} вариантов для артикула $articleNumber');

      return searchResults.map((item) {
        return PartPriceModel(
          article: item.articleNumber ?? articleNumber,
          brand: item.brand ?? brand ?? '',
          name: item.name ?? '',
          price: item.price ?? 0.0,
          quantity: item.quantity ?? 0,
          deliveryDays: item.deliveryTime ?? 0,
          supplierName: supplierName,
          originalArticle: item.additionalData?['originalNumber'] as String?,
          comment: item.additionalData?['comment'] as String?,
          priceUpdatedAt: _parseDateTime(item.additionalData?['priceDate']),
          additionalProperties: {
            'store': item.additionalData?['store'],
            'availability': item.additionalData?['availability'],
            'manager': item.additionalData?['manager'],
            'currency': item.additionalData?['currency'] ?? 'RUB',
            'supplier': item.supplier,
          },
        );
      }).toList();
    } catch (e, stackTrace) {
      _logger.e('Ошибка при поиске запчастей Armtek для артикула $articleNumber',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
