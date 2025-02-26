import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:part_catalog/models/catalog.dart';
import 'package:part_catalog/models/model.dart';
import 'package:part_catalog/models/car2.dart';
import 'package:part_catalog/models/car_parameter_info.dart';
import 'package:part_catalog/models/group.dart';
import 'package:part_catalog/models/car_info.dart';
import 'package:part_catalog/models/parts.dart';
import 'package:part_catalog/models/suggest.dart';
import 'package:part_catalog/models/example_prices_response.dart';
import 'package:part_catalog/models/groups_tree_response.dart';
import 'package:part_catalog/models/schemas_response.dart';

part 'api_client_parts_catalogs.g.dart';

/// {@template api_client_parts_catalogs}
/// Клиент для взаимодействия с API каталогов.
/// {@endtemplate}
@RestApi(baseUrl: "https://api.parts-catalogs.com/v1")
abstract class ApiClientPartsCatalogs {
  /// {@macro api_client_parts_catalogs}
  factory ApiClientPartsCatalogs(Dio dio) = _ApiClientPartsCatalogs;

  /// Получает список доступных каталогов.
  ///
  /// Параметры:
  ///   - apiKey: Ключ API для авторизации.
  ///   - language: Язык, на котором нужно получить данные.
  @GET("/catalogs/")
  Future<List<Catalog>> getCatalogs(@Header("Authorization") String apiKey,
      @Header("Accept-Language") String language);

  /// Получает список моделей автомобилей для указанного каталога.
  @GET("/catalogs/{catalogId}/models/")
  Future<List<Model>> getModels(
    @Path("catalogId") String catalogId,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает список автомобилей для указанного каталога и модели.
  @GET("/catalogs/{catalogId}/cars2/")
  Future<List<Car2>> getCars2(
    @Path("catalogId") String catalogId,
    @Query("modelId") String modelId,
    @Query("parameter") List<List<String>>? parameter,
    @Query("page") int? page,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает информацию об автомобиле по ID.
  @GET("/catalogs/{catalogId}/cars2/{carId}")
  Future<Car2> getCarsById2(
    @Path("catalogId") String catalogId,
    @Path("carId") String carId,
    @Query("criteria") String? criteria,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает параметры фильтрации автомобилей для указанного каталога.
  @GET("/catalogs/{catalogId}/cars-parameters/")
  Future<List<CarParameterInfo>> getCarsParameters(
    @Path("catalogId") String catalogId,
    @Query("modelId") String modelId,
    @Query("parameter") List<List<String>>? parameter,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает список групп для указанного каталога и автомобиля.
  @GET("/catalogs/{catalogId}/groups2/")
  Future<List<Group>> getGroups(
    @Path("catalogId") String catalogId,
    @Query("carId") String carId,
    @Query("groupId") String? groupId,
    @Query("criteria") String? criteria,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает информацию об автомобиле по VIN или FRAME.
  @GET("/car/info")
  Future<List<CarInfo>> getCarInfo(
    @Query("q") String q,
    @Query("catalogs") String? catalogs,
    @Header("Authorization") String apiKey, // Added Authorization header
    @Header("Accept-Language") String language,
  );

  /// Получает список запчастей для указанного каталога, автомобиля и группы.
  @GET("/catalogs/{catalogId}/parts2")
  Future<Parts> getParts2(
    @Path("catalogId") String catalogId,
    @Query("carId") String carId,
    @Query("groupId") String groupId,
    @Query("criteria") String? criteria,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
    @Header("x-redirect-template") String? xRedirectTemplate,
  );

  /// Получает список предложений для поиска групп.
  @GET("/catalogs/{catalogId}/groups-suggest")
  Future<List<Suggest>> getGroupsSuggest(
    @Path("catalogId") String catalogId,
    @Query("q") String q,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает список групп по ID поиска.
  @GET("/catalogs/{catalogId}/groups-by-sid")
  Future<List<Group>> getGroupsBySid(
    @Path("catalogId") String catalogId,
    @Query("sid") String sid,
    @Query("carId") String carId,
    @Query("criteria") String? criteria,
    @Query("text") String? text,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает пример цен на запчасти.
  @GET("/example/prices")
  Future<List<ExamplePricesResponse>> getExamplePrices(
    @Query("code") String code,
    @Query("brand") String brand,
    @Header("Authorization") String apiKey,
  );

  /// Получает дерево групп.
  @GET("/catalogs/{catalogId}/groups-tree")
  Future<List<GroupsTreeResponse>> getGroupsTree(
    @Path("catalogId") String catalogId,
    @Query("carId") String? carId,
    @Query("criteria") String? criteria,
    @Query("cached") bool? cached,
    @Header("Authorization") String apiKey,
  );

  /// Получает схемы, ведущие к страницам деталей.
  @GET("/catalogs/{catalogId}/schemas")
  Future<SchemasResponse> getSchemas(
    @Path("catalogId") String catalogId,
    @Query("carId") String carId,
    @Query("branchId") String? branchId,
    @Query("criteria") String? criteria,
    @Query("page") int? page,
    @Query("partNameIds") String? partNameIds,
    @Query("partName") String? partName,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );
  // Другие endpoints
}
