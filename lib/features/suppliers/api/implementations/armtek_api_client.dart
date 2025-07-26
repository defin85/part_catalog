import 'dart:convert'; // For base64Encode
import 'package:dio/dio.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/suppliers/config/supported_suppliers.dart';
import 'package:part_catalog/features/suppliers/models/armtek/brand_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/ping_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:retrofit/retrofit.dart';
import 'package:part_catalog/features/suppliers/api/base_supplier_api_client.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/armtek_response_wrapper.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_vkorg.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
// TODO: Импортировать модели для getBrandList и getStoreList, когда они будут созданы

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

  // Добавляем метод getStoreList
  @GET("/ws_user/getStoreList")
  Future<ArmtekResponseWrapper<List<StoreItem>>> getStoreList({
    @Query("VKORG") required String vkorg,
    @Query("format") String format = "json",
  });

  /// Получение статуса обработки прайса по ключу
  @POST("/ws_user/getPriceStatusByKey")
  @FormUrlEncoded()
  Future<ArmtekResponseWrapper<Map<String, dynamic>>> getPriceStatusByKey({
    @Field("KEY") required String key,
    @Field("format") String format = "json",
  });

  // --- ServiceSearch ---
  /// Поиск запчастей по артикулу и бренду
  @POST("/ws_search/search")
  @FormUrlEncoded()
  Future<ArmtekResponseWrapper<List<Map<String, dynamic>>>> searchParts({
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
  Future<ArmtekResponseWrapper<List<Map<String, dynamic>>>> getPrices({
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
  Future<ArmtekResponseWrapper<Map<String, dynamic>>> createTestOrder({
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
        // Используем _effectiveBaseUrl для проверки, так как options.baseUrl может быть изменен Dio
        if (_effectiveBaseUrl == armtekBaseUrl ||
            _effectiveBaseUrl.contains('ws.armtek.ru')) {
          // Если это прямой запрос к Armtek
          if (username != null && password != null) {
            final basicAuth =
                'Basic ${base64Encode(utf8.encode('$username:$password'))}';
            options.headers['Authorization'] = basicAuth;
          } else if (proxyAuthToken == null) {
            // Логика для случая, когда это прямой запрос, но нет username/password
            // Возможно, здесь стоит выбросить ошибку конфигурации, если они ожидаются
            _logger.w(
                'ArmtekApiClient: Direct request but no credentials provided.');
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
        }
        return handler.next(options);
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
        vkorg: _vkorg!,
        articleNumber: articleNumber,
        brand: brand,
      );

      if (response.status != 200 || response.responseData == null) {
        _logger.w('Armtek API вернул пустой ответ для артикула $articleNumber');
        return [];
      }

      final prices = response.responseData!;
      _logger.i('Получено ${prices.length} предложений для артикула $articleNumber');

      return prices.map((item) {
        return PartPriceModel(
          article: item['number'] as String? ?? articleNumber,
          brand: item['brand'] as String? ?? brand ?? '',
          name: item['name'] as String? ?? '',
          price: _parseDouble(item['price']),
          quantity: _parseInt(item['quantity']),
          deliveryDays: _parseInt(item['deliveryDays']) ?? _parseInt(item['delivery']) ?? 0,
          supplierName: supplierName,
          originalArticle: item['originalNumber'] as String?,
          comment: item['comment'] as String?,
          priceUpdatedAt: _parseDateTime(item['priceDate']),
          additionalProperties: {
            'store': item['store'],
            'availability': item['availability'],
            'manager': item['manager'],
            'currency': item['currency'] ?? 'RUB',
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
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

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
        _logger.i('API Armtek доступно. IP: ${response.responseData!.ip}, '
            'Время выполнения: ${response.responseData!.time}');
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
    return _client.getUserInfo(
      vkorg: request.vkorg,
      structure: request.structure,
      ftpData: request.ftpData,
    );
  }

  // Добавляем метод getBrandList
  Future<ArmtekResponseWrapper<List<BrandItem>>> getBrandList(
      String vkorg) async {
    _logger.i('Getting brand list for VKORG: $vkorg');
    return _client.getBrandList(vkorg: vkorg);
  }

  // Добавляем метод getStoreList
  Future<ArmtekResponseWrapper<List<StoreItem>>> getStoreList(
      String vkorg) async {
    _logger.i('Getting store list for VKORG: $vkorg');
    return _client.getStoreList(vkorg: vkorg);
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
        vkorg: _vkorg!,
        articleNumber: articleNumber,
        brand: brand,
      );

      if (response.status != 200 || response.responseData == null) {
        _logger.w('Armtek поиска вернул пустой ответ для артикула $articleNumber');
        return [];
      }

      final searchResults = response.responseData!;
      _logger.i('Найдено ${searchResults.length} вариантов для артикула $articleNumber');

      return searchResults.map((item) {
        return PartPriceModel(
          article: item['number'] as String? ?? articleNumber,
          brand: item['brand'] as String? ?? brand ?? '',
          name: item['name'] as String? ?? '',
          price: _parseDouble(item['price']),
          quantity: _parseInt(item['quantity']),
          deliveryDays: _parseInt(item['deliveryDays']) ?? _parseInt(item['delivery']) ?? 0,
          supplierName: supplierName,
          originalArticle: item['originalNumber'] as String?,
          comment: item['comment'] as String?,
          priceUpdatedAt: _parseDateTime(item['priceDate']),
          additionalProperties: {
            'store': item['store'],
            'availability': item['availability'],
            'manager': item['manager'],
            'currency': item['currency'] ?? 'RUB',
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
