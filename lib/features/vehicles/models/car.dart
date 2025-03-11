import 'package:freezed_annotation/freezed_annotation.dart';

part 'car.freezed.dart';
part 'car.g.dart';

/// {@template car}
/// Модель данных для представления автомобиля.
/// {@endtemplate}
@freezed
class CarModel with _$CarModel {
  /// {@macro car}
  const factory CarModel({
    /// Уникальный идентификатор автомобиля.
    required String id,

    /// Идентификатор клиента-владельца.
    required String clientId,

    /// VIN-код.
    required String vin,

    /// Марка автомобиля.
    required String make,

    /// Модель автомобиля.
    required String model,

    /// Год выпуска.
    required int year,

    /// Номерной знак.
    String? licensePlate,

    /// Дополнительная информация.
    String? additionalInfo,
  }) = _CarModel;

  /// Преобразование JSON в объект `CarModel`.
  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);
}
