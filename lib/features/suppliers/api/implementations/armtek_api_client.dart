import 'dart:convert'; // For base64Encode
import 'package:dio/dio.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
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
    "http://ws.armtek.ru"; // Можно вынести в конфигурацию

@RestApi(baseUrl: armtekBaseUrl)
abstract class ArmtekRestInterface {
  factory ArmtekRestInterface(Dio dio, {String baseUrl}) = _ArmtekRestInterface;

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

  // TODO: Добавить метод getBrandList
  // @GET("/ws_user/getBrandList")
  // Future<ArmtekResponseWrapper<List<BrandItem>>> getBrandList(...);

  // TODO: Добавить метод getStoreList
  // @GET("/ws_user/getStoreList")
  // Future<ArmtekResponseWrapper<List<StoreItem>>> getStoreList(...);

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

  ArmtekApiClient(this._dio,
      {String? username,
      String? password,
      String? baseUrl,
      String? proxyAuthToken}) // Сделали username и password опциональными
      : _client = ArmtekRestInterface(_dio, baseUrl: baseUrl ?? armtekBaseUrl) {
    // Добавляем Interceptor для Basic Authentication или Proxy Authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (baseUrl == null || baseUrl.contains('ws.armtek.ru')) {
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
        if (proxyAuthToken != null &&
            options.baseUrl == baseUrl /* baseUrl здесь будет URL прокси */) {
          options.headers['X-Proxy-Auth-Token'] =
              proxyAuthToken; // Пример заголовка для прокси
        }
        return handler.next(options);
      },
    ));
  }

  @override
  String get supplierName => 'Armtek';

  @override
  String get supplierCode => 'Armtek';

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
  Future<bool> checkConnection() {
    // TODO: Реализовать проверку соединения с Armtek API
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
        'checkConnection for Armtek is not yet implemented.');
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

  // TODO: Добавить обертки для getBrandList, getStoreList
}
