import 'package:freezed_annotation/freezed_annotation.dart';

part 'part_price_response.freezed.dart';
part 'part_price_response.g.dart';

@freezed
abstract class PartPriceModel with _$PartPriceModel {
  const factory PartPriceModel({
    required String article,
    required String brand,
    required String name,
    required double price,
    required int quantity, // Доступное количество или минимальная партия
    required int deliveryDays, // Срок поставки в днях
    required String
        supplierName, // Имя поставщика, от которого пришло предложение
    String? originalArticle, // Оригинальный артикул, если это замена
    String? comment, // Комментарий от поставщика
    DateTime? priceUpdatedAt, // Когда цена была обновлена у поставщика
    // Можно добавить другие общие поля, которые могут возвращать разные поставщики
    Map<String, dynamic>?
        additionalProperties, // Для специфичных данных поставщика
  }) = _PartPriceModel;

  factory PartPriceModel.fromJson(Map<String, dynamic> json) =>
      _$PartPriceModelFromJson(json);
}
