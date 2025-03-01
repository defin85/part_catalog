import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

/// {@template car}
/// Модель данных для представления автомобиля.
/// {@endtemplate}
@JsonSerializable()
class CarModel {
  /// {@macro car}
  CarModel({
    required this.id, //test
    required this.clientId,
    required this.vin,
    required this.make,
    required this.model,
    required this.year,
    this.licensePlate,
    this.additionalInfo,
  });

  /// Уникальный идентификатор автомобиля.
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор клиента-владельца.
  @JsonKey(name: 'clientId')
  final String clientId;

  /// VIN-код.
  @JsonKey(name: 'vin')
  final String vin;

  /// Марка автомобиля.
  @JsonKey(name: 'make')
  final String make;

  /// Модель автомобиля.
  @JsonKey(name: 'model')
  final String model;

  /// Год выпуска.
  @JsonKey(name: 'year')
  final int year;

  /// Номерной знак.
  @JsonKey(name: 'licensePlate')
  final String? licensePlate;

  /// Дополнительная информация.
  @JsonKey(name: 'additionalInfo')
  final String? additionalInfo;

  /// Преобразование JSON в объект `Car`.
  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  /// Преобразование объекта `Car` в JSON.
  Map<String, dynamic> toJson() => _$CarModelToJson(this);
}
