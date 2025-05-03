import 'package:json_annotation/json_annotation.dart';

part 'supplier.g.dart';

/// {@template supplier}
/// Модель данных для представления поставщика.
/// {@endtemplate}
@JsonSerializable()
class Supplier {
  /// {@macro supplier}
  Supplier({
    required this.id,
    required this.name,
    required this.contactInfo,
  });

  /// Уникальный идентификатор поставщика.
  @JsonKey(name: 'id')
  final String id;

  /// Название поставщика.
  @JsonKey(name: 'name')
  final String name;

  /// Контактная информация.
  @JsonKey(name: 'contactInfo')
  final String contactInfo;

  /// Преобразование JSON в объект `Supplier`.
  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);

  /// Преобразование объекта `Supplier` в JSON.
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}
