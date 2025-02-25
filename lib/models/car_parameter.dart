import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_parameter.freezed.dart';
part 'car_parameter.g.dart';

/// {@template car_parameter}
/// Модель данных для параметра автомобиля.
/// {@endtemplate}
@freezed
class CarParameter with _$CarParameter {
  /// {@macro car_parameter}
  factory CarParameter({
    /// Hash ID параметра автомобиля.
    @JsonKey(name: 'idx') String? idx,

    /// Ключ параметра автомобиля.
    @JsonKey(name: 'key') String? key,

    /// Название параметра автомобиля.
    @JsonKey(name: 'name') String? name,

    /// Значение параметра автомобиля.
    @JsonKey(name: 'value') String? value,

    /// Порядок сортировки параметра автомобиля.
    @JsonKey(name: 'sortOrder') int? sortOrder,
  }) = _CarParameter;

  /// Преобразует JSON в объект [CarParameter].
  factory CarParameter.fromJson(Map<String, dynamic> json) =>
      _$CarParameterFromJson(json);
}
