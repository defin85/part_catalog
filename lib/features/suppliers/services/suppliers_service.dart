import 'package:part_catalog/core/utils/logger_config.dart';
import '../api/api_client_manager.dart';
import '../models/base/part_price_response.dart'; // Предполагается, что эта модель будет создана

class SuppliersService {
  final ApiClientManager _apiClientManager;
  final _logger = AppLoggers.suppliers;

  SuppliersService(this._apiClientManager);

  /// Получает цены от всех доступных поставщиков для указанного артикула.
  /// Алиас для getPricesFromAllSuppliers для обратной совместимости.
  Future<Map<String, List<PartPriceModel>>> getAllPricesByArticle(
    String articleNumber, {
    String? brand,
  }) async {
    return getPricesFromAllSuppliers(articleNumber, brand: brand);
  }

  /// Получает цены от всех доступных поставщиков для указанного артикула.
  Future<Map<String, List<PartPriceModel>>> getPricesFromAllSuppliers(
    String articleNumber, {
    String? brand,
  }) async {
    final results = <String, List<PartPriceModel>>{};
    final clients = _apiClientManager.getAllAvailableClients();

    // Выполняем запросы параллельно
    final futures = clients.map((client) async {
      try {
        _logger.i(
            'Fetching prices for "$articleNumber" from ${client.supplierName}');
        final prices =
            await client.getPricesByArticle(articleNumber, brand: brand);
        results[client.supplierName] = prices;
        _logger.i(
            'Received ${prices.length} price offers for "$articleNumber" from ${client.supplierName}');
      } catch (e, stackTrace) {
        // Логируем детали ошибки для отладки
        if (e.toString().contains('VKORG not configured') || 
            e.toString().contains('401') || 
            e.toString().contains('Unauthorized')) {
          _logger.w(
            'Authentication/configuration error for ${client.supplierName}: ${e.toString()}. '
            'Check API credentials and VKORG settings.',
          );
        } else {
          _logger.e(
            'Error fetching prices from ${client.supplierName} for article $articleNumber',
            error: e,
            stackTrace: stackTrace,
          );
        }
        results[client.supplierName] =
            []; // Возвращаем пустой список в случае ошибки
      }
    }).toList();

    await Future.wait(futures);
    _logger.i(
        'Finished fetching all prices for "$articleNumber". Found offers from ${results.keys.where((k) => results[k]!.isNotEmpty).length} suppliers.');
    return results;
  }

  /// Получает лучшие (например, самые дешевые или самые быстрые) предложения для артикула.
  /// Логика "лучшего" может быть сложной и настраиваемой.
  Future<List<PartPriceModel>> getBestPricesByArticle(
    String articleNumber, {
    String? brand,
    int limit = 5, // Ограничение на количество лучших предложений
  }) async {
    final allPricesMap =
        await getAllPricesByArticle(articleNumber, brand: brand);
    final allPricesList = allPricesMap.values.expand((list) => list).toList();

    if (allPricesList.isEmpty) {
      _logger.i(
          'No price offers found for "$articleNumber" to determine best prices.');
      return [];
    }

    // Сортируем по цене (возрастание), затем по сроку доставки (возрастание)
    allPricesList.sort((a, b) {
      final priceComparison = a.price.compareTo(b.price);
      if (priceComparison != 0) {
        return priceComparison;
      }
      return a.deliveryDays.compareTo(b.deliveryDays);
    });

    final bestPrices = allPricesList.take(limit).toList();
    _logger.i(
        'Determined ${bestPrices.length} best price offers for "$articleNumber".');
    return bestPrices;
  }

  // TODO: Добавить другие методы, например, для поиска по названию, получения деталей и т.д.
}
