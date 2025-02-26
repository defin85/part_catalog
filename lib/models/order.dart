import 'package:json_annotation/json_annotation.dart';
import 'package:part_catalog/models/order_item.dart';

part 'order.g.dart';

/// {@template order}
/// Модель данных для представления заказ-наряда.
/// {@endtemplate}
@JsonSerializable()
class Order {
  /// {@macro order}
  Order({
    required this.id,
    required this.clientId,
    required this.carId,
    required this.date,
    required this.description,
    required this.workItems,
    required this.orderItems,
    required this.totalCost,
    required this.status,
  });

  /// Уникальный идентификатор заказ-наряда.
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор клиента.
  @JsonKey(name: 'clientId')
  final String clientId;

  /// Идентификатор автомобиля.
  @JsonKey(name: 'carId')
  final String carId;

  /// Дата создания заказ-наряда.
  @JsonKey(name: 'date')
  final String date;

  /// Описание проблемы.
  @JsonKey(name: 'description')
  final String description;

  /// Список работ (описание и стоимость).
  @JsonKey(name: 'workItems')
  final List<WorkItem> workItems;

  /// Список запчастей (с ценами и сроками поставки).
  @JsonKey(name: 'orderItems')
  final List<OrderItem> orderItems;

  /// Общая стоимость.
  @JsonKey(name: 'totalCost')
  final double totalCost;

  /// Статус заказ-наряда (created, inProgress, completed).
  @JsonKey(name: 'status')
  final String status;

  /// Преобразование JSON в объект `Order`.
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Преобразование объекта `Order` в JSON.
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

/// {@template work_item}
/// Модель данных для представления работы в заказ-наряде.
/// {@endtemplate}
@JsonSerializable()
class WorkItem {
  /// {@macro work_item}
  WorkItem({
    required this.description,
    required this.cost,
  });

  /// Описание работы.
  @JsonKey(name: 'description')
  final String description;

  /// Стоимость работы.
  @JsonKey(name: 'cost')
  final double cost;

  /// Преобразование JSON в объект `WorkItem`.
  factory WorkItem.fromJson(Map<String, dynamic> json) =>
      _$WorkItemFromJson(json);

  /// Преобразование объекта `WorkItem` в JSON.
  Map<String, dynamic> toJson() => _$WorkItemToJson(this);
}
