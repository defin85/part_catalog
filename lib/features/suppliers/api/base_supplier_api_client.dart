import '../models/base/part_price_response.dart'; // Предполагается, что эта модель будет создана

/// Базовый интерфейс для всех клиентов API поставщиков.
abstract class BaseSupplierApiClient {
  /// Возвращает название поставщика.
  String get supplierName;
  String get supplierCode;

  Future<bool> checkConnection(); // Пример метода

  /// Получает цены на запчасть по артикулу.
  ///
  /// [articleNumber] - артикул запчасти.
  /// [brand] - опциональный бренд для уточнения поиска.
  Future<List<PartPriceModel>> getPricesByArticle(String articleNumber,
      {String? brand});

  // TODO: Добавить другие общие методы, если они будут определены, например:
  // Future<List<PartInfoModel>> searchPartsByName(String name);
  // Future<PartDetailModel?> getPartDetails(String articleNumber, String brand);
}

// Базовая модель для ответа по ценам (нужно будет создать)
// Пример в lib/features/suppliers/models/base/part_price_response.dart
// @freezed
// class PartPriceModel with _$PartPriceModel {
//   const factory PartPriceModel({
//     required String article,
//     required String brand,
//     required String name,
//     required double price,
//     required int quantity,
//     required int deliveryDays,
//     required String supplier,
//     // ... другие общие поля
//   }) = _PartPriceModel;
//   factory PartPriceModel.fromJson(Map<String, dynamic> json) => _$PartPriceModelFromJson(json);
// }
