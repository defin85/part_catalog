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
import 'package:part_catalog/features/suppliers/models/armtek/store_item.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_request.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_info_response.dart';
import 'package:part_catalog/features/suppliers/models/armtek/user_vkorg.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/utils/user_friendly_exception.dart';

const String armtekBaseUrl = "http://ws.armtek.ru/api";

/// Оптимизированный клиент Armtek API с отказоустойчивостью, кэшированием и мониторингом
class OptimizedArmtekApiClient implements BaseSupplierApiClient {
  final ResilientApiClient _resilientClient;
  final _logger = AppLoggers.suppliers;
  final String? _vkorg;
  final String? _kunnrRg;
  final bool _searchWithCross;
  final bool _exactSearch;
  // final String? _username; // Сохранено для будущего использования
  // final String? _password; // Сохранено для будущего использования

  OptimizedArmtekApiClient._({
    required ResilientApiClient resilientClient,
    String? vkorg,
    String? kunnrRg,
    bool searchWithCross = true,
    bool exactSearch = false,
  })  : _resilientClient = resilientClient,
        _vkorg = vkorg,
        _kunnrRg = kunnrRg,
        _searchWithCross = searchWithCross,
        _exactSearch = exactSearch;

  /// Фабричный метод для создания оптимизированного Armtek API клиента
  static Future<OptimizedArmtekApiClient> create({
    required ApiConnectionMode connectionMode,
    String? username,
    String? password,
    String? vkorg,
    String? kunnrRg,
    String? proxyUrl,
    String? proxyAuthToken,
    bool searchWithCross = true,
    bool exactSearch = false,
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
      kunnrRg: kunnrRg,
      searchWithCross: searchWithCross,
      exactSearch: exactSearch,
    );
  }

  @override
  String get supplierName => SupplierCode.armtek.name;

  @override
  String get supplierCode => SupplierCode.armtek.code;

  /// Получает базовый URL клиента
  String get baseUrl => _resilientClient.config.baseUrl;

  /// Получает статистику производительности
  Future<Map<String, dynamic>?> getMetrics() => _resilientClient.getMetrics();

  /// Получает статистику кеша
  Future<Map<String, dynamic>?> getCacheStats() =>
      _resilientClient.getCacheStats();

  /// Получает статус circuit breaker
  Future<Map<String, dynamic>> getCircuitBreakerStatus() =>
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
    // Для соответствия документации используем /ws_search/search
    return searchPartsByArticle(articleNumber, brand: brand);
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
      throw UserFriendlyException(
        'Armtek: не настроен VKORG. Откройте настройки поставщика и укажите организацию (VKORG).',
        details: 'VKORG not configured for Armtek API client',
      );
    }
    if ((_kunnrRg ?? '').isEmpty) {
      throw UserFriendlyException(
        'Armtek: не указан код покупателя (KUNNR). Укажите корректный KUNNR_RG в настройках поставщика.',
        details: 'KUNNR_RG (customerCode) not configured for Armtek',
      );
    }

    // Определяем тип поиска: 2 — с кроссами, 1 — точный, null — по умолчанию
    String? queryType;
    if (_searchWithCross) {
      queryType = '2';
    } else if (_exactSearch) {
      queryType = '1';
    }

    _logger.i(
        'Armtek search: PIN=$articleNumber, BRAND=${brand ?? "-"}, VKORG=$_vkorg, KUNNR_RG=$_kunnrRg, QUERY_TYPE=${queryType ?? "-"}');

    try {
      final payload = <String, dynamic>{
        'VKORG': _vkorg,
        'KUNNR_RG': _kunnrRg,
        'PIN': articleNumber,
        if (brand != null && brand.isNotEmpty) 'BRAND': brand,
        if (queryType != null) 'QUERY_TYPE': queryType,
        'format': 'json',
      };

      final response = await _resilientClient.post(
        '/ws_search/search',
        data: payload,
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        _logger.w('Неожиданный формат ответа от Armtek search API');
        return [];
      }

      // Обработка бизнес-сообщений Armtek (MESSAGES)
      final messages = (data['MESSAGES'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();

      final status = data['STATUS'] as int? ?? 500;
      if (status != 200) {
        _logger.w('Armtek search API вернул ошибку: $status');
        return [];
      }

      // Если есть сообщения об ошибке (TYPE == 'E'), формируем понятное сообщение для пользователя
      final errorMsgs = messages
          .where((m) => (m['TYPE']?.toString().toUpperCase() ?? '') == 'E')
          .map((m) => m['TEXT']?.toString() ?? '')
          .where((text) => text.isNotEmpty)
          .toList();

      if (errorMsgs.isNotEmpty) {
        final combined = errorMsgs.join('\n');
        // Дополнительные подсказки по известным кейсам
        String hint = '';
        if (combined.contains('Покупатель не может быть установлен')) {
          hint =
              '\nПодсказка: проверьте соответствие VKORG и KUNNR в настройках поставщика.';
        }
        throw UserFriendlyException('Armtek: $combined$hint');
      }

      final respData = data['RESP'] as List<dynamic>? ?? [];
      _logger.i(
          'Найдено ${respData.length} вариантов для артикула $articleNumber');

      return respData.map<PartPriceModel>((item) {
        if (item is Map<String, dynamic>) {
          // Пытаемся извлечь поля согласно Armtek ServiceSearch
          final pin =
              (item['PIN'] ?? articleNumber)?.toString() ?? articleNumber;
          final itemBrand = (item['BRAND'] ?? brand ?? '').toString();
          final name = (item['NAME'] ?? '').toString();
          final priceRaw = item['PRICE'];
          final price = priceRaw is num
              ? priceRaw.toDouble()
              : double.tryParse(priceRaw?.toString() ?? '') ?? 0.0;
          final rvalueRaw = item['RVALUE'];
          final quantity = rvalueRaw is num
              ? rvalueRaw.toInt()
              : int.tryParse(rvalueRaw?.toString() ?? '') ?? 0;
          // DELIVERY_DAY или расчет из DLVDT (yyyyMMddHHmmss)
          int deliveryDays = 0;
          final ddayRaw = item['DELIVERY_DAY'];
          if (ddayRaw != null) {
            deliveryDays = ddayRaw is num
                ? ddayRaw.toInt()
                : int.tryParse(ddayRaw.toString()) ?? 0;
          } else if (item['DLVDT'] != null) {
            final s = item['DLVDT'].toString();
            DateTime? dt;
            try {
              // Simple parse: yyyyMMddHHmmss
              dt = DateTime.parse(
                  '${s.substring(0, 4)}-${s.substring(4, 6)}-${s.substring(6, 8)}');
              final diff = dt.difference(DateTime.now()).inDays;
              deliveryDays = diff < 0 ? 0 : diff;
            } catch (_) {}
          }

          return PartPriceModel(
            article: pin,
            brand: itemBrand,
            name: name,
            price: price,
            quantity: quantity,
            deliveryDays: deliveryDays,
            supplierName: supplierName,
            originalArticle: null,
            comment: null,
            priceUpdatedAt: null,
            additionalProperties: {
              'WAERS': item['WAERS'],
              'KEYZAK': item['KEYZAK'],
              'PARNR': item['PARNR'],
              'RDPRF': item['RDPRF'],
              'MINBM': item['MINBM'],
              'RETDAYS': item['RETDAYS'],
              'ANALOG': item['ANALOG'],
              'DLVDT': item['DLVDT'],
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
      if (e is UserFriendlyException) {
        // Для пользовательских ошибок логируем только краткую информацию
        _logger.w('Armtek search failed for $articleNumber: ${e.message}');
      } else {
        // Для системных ошибок - полное логирование
        _logger.e(
            'Ошибка при поиске запчастей Armtek для артикула $articleNumber',
            error: e,
            stackTrace: stackTrace);
      }
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
