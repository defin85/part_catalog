import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_specific_data.freezed.dart';
part 'car_specific_data.g.dart';

/// {@template car_specific_data}
/// Специфичные данные для сущности "Автомобиль".
/// Содержит поля, уникальные для автомобилей.
/// {@endtemplate}
@freezed
abstract class CarSpecificData with _$CarSpecificData {
  /// {@macro car_specific_data}
  const factory CarSpecificData({
    /// Идентификатор клиента-владельца (UUID).
    @JsonKey(name: 'clientId') required String clientId,

    /// VIN-код. Должен быть уникальным.
    @JsonKey(name: 'vin') required String vin,

    /// Марка автомобиля.
    @JsonKey(name: 'make') required String make,

    /// Модель автомобиля.
    @JsonKey(name: 'model') required String model,

    /// Год выпуска.
    @JsonKey(name: 'year') required int year,

    /// Номерной знак (опционально).
    @JsonKey(name: 'licensePlate') String? licensePlate,

    /// Дополнительная информация (опционально).
    @JsonKey(name: 'additionalInfo') String? additionalInfo,
  }) = _CarSpecificData;

  /// Преобразование JSON в объект `CarSpecificData`.
  factory CarSpecificData.fromJson(Map<String, dynamic> json) =>
      _$CarSpecificDataFromJson(json);
}
