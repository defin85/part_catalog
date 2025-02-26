import 'package:json_annotation/json_annotation.dart';

part 'price_offer.g.dart';

/// {@template price_offer}
/// Модель данных для представления предложения цены.
/// {@endtemplate}
@JsonSerializable()
class PriceOffer {
  /// {@macro price_offer}
  PriceOffer({
    required this.partNumber,
    required this.price,
    required this.deliveryTime,
    required this.supplierId,
  });

  /// Артикул запчасти.
  @JsonKey(name: 'partNumber')
  final String partNumber;

  /// Цена.
  @JsonKey(name: 'price')
  final double price;

  /// Срок поставки.
  @JsonKey(name: 'deliveryTime')
  final String deliveryTime;

  /// Идентификатор поставщика.
  @JsonKey(name: 'supplierId')
  final String supplierId;

  /// Преобразование JSON в объект `PriceOffer`.
  factory PriceOffer.fromJson(Map<String, dynamic> json) =>
      _$PriceOfferFromJson(json);

  /// Преобразование объекта `PriceOffer` в JSON.
  Map<String, dynamic> toJson() => _$PriceOfferToJson(this);
}
