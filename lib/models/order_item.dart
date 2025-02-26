import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

/// {@template order_item}
/// Модель данных для представления позиции в заказ-наряде.
/// {@endtemplate}
@JsonSerializable()
class OrderItem {
  /// {@macro order_item}
  OrderItem({
    required this.id,
    required this.orderId,
    required this.partNumber,
    required this.partName,
    required this.quantity,
    required this.price,
    required this.supplier,
    required this.deliveryTime,
  });

  /// Уникальный идентификатор позиции.
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор заказ-наряда.
  @JsonKey(name: 'orderId')
  final String orderId;

  /// Артикул запчасти.
  @JsonKey(name: 'partNumber')
  final String partNumber;

  /// Название запчасти.
  @JsonKey(name: 'partName')
  final String partName;

  /// Количество.
  @JsonKey(name: 'quantity')
  final int quantity;

  /// Цена за единицу.
  @JsonKey(name: 'price')
  final double price;

  /// Поставщик.
  @JsonKey(name: 'supplier')
  final String supplier;

  /// Срок поставки.
  @JsonKey(name: 'deliveryTime')
  final String deliveryTime;

  /// Преобразование JSON в объект `OrderItem`.
  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// Преобразование объекта `OrderItem` в JSON.
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
