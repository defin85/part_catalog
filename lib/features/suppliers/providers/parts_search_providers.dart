import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';
import 'package:part_catalog/features/suppliers/services/suppliers_service.dart';

/// Провайдер для ApiClientManager
final apiClientManagerProvider = Provider<ApiClientManager>((ref) {
  return locator<ApiClientManager>();
});

/// Провайдер для SuppliersService
final suppliersServiceProvider = Provider<SuppliersService>((ref) {
  return locator<SuppliersService>();
});

/// Провайдер для поиска запчастей
final partsSearchProvider = FutureProvider.family<List<PartPriceModel>, PartsSearchParams>((ref, params) async {
  final suppliersService = ref.read(suppliersServiceProvider);
  
  if (params.articleNumber.isEmpty) {
    return [];
  }
  
  // Получаем цены от всех доступных поставщиков
  final results = await suppliersService.getPricesFromAllSuppliers(
    params.articleNumber,
    brand: params.brand,
  );
  
  // Объединяем результаты от всех поставщиков
  final allPrices = <PartPriceModel>[];
  for (final supplierResults in results.values) {
    allPrices.addAll(supplierResults);
  }
  
  // Сортируем по цене
  allPrices.sort((a, b) => a.price.compareTo(b.price));
  
  return allPrices;
});

/// Параметры для поиска запчастей
class PartsSearchParams {
  final String articleNumber;
  final String? brand;
  
  const PartsSearchParams({
    required this.articleNumber,
    this.brand,
  });
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartsSearchParams &&
          runtimeType == other.runtimeType &&
          articleNumber == other.articleNumber &&
          brand == other.brand;

  @override
  int get hashCode => articleNumber.hashCode ^ brand.hashCode;
}

/// Провайдер для состояния поиска (текущие параметры)
final partsSearchStateProvider = StateProvider<PartsSearchParams?>((ref) => null);