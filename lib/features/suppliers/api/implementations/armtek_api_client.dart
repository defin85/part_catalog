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

  // --- ServiceSearch ---
  // TODO: Добавить методы для поиска (например, getSearch)
  // @POST("/ws_search/search")
  // @FormUrlEncoded()
  // Future<ArmtekResponseWrapper<SearchResponse>> searchParts(...);
}

class ArmtekApiClient implements BaseSupplierApiClient {
  final Dio _dio;
  final ArmtekRestInterface _client;
  final _logger = AppLoggers.suppliers;
  final String _effectiveBaseUrl;

  ArmtekApiClient(this._dio,
      {String? username,
      String? password,
      String? baseUrl,
      String? proxyAuthToken})
      : _effectiveBaseUrl = baseUrl ?? armtekBaseUrl, // Инициализируем поле
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
    // TODO: Реализовать получение цен через метод поиска Armtek API (ServiceSearch)
    // Это потребует создания моделей запроса и ответа для поиска,
    // а затем маппинга ответа Armtek в унифицированную модель PartPriceModel.
    // Пример:
    // final searchRequest = SearchRequest(article: articleNumber, brand: brand, ...);
    // final response = await _client.searchParts(request: searchRequest);
    // if (response.status == 200 && response.responseData != null) {
    //   return response.responseData.items.map((item) => PartPriceModel(
    //     article: item.article,
    //     brand: item.brand,
    //     name: item.name,
    //     price: item.price,
    //     quantity: item.quantity,
    //     deliveryDays: item.deliveryDays,
    //     supplierName: supplierName,
    //   )).toList();
    // }
    throw UnimplementedError(
        'getPricesByArticle for Armtek is not yet implemented.');
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
}
