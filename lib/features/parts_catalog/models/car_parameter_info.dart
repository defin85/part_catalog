import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_parameter_info.freezed.dart';
part 'car_parameter_info.g.dart';

/// {@template car_parameter_info}
/// Модель данных для информации о параметре автомобиля.
/// {@endtemplate}
@freezed
abstract class CarParameterInfo with _$CarParameterInfo {
  /// {@macro car_parameter_info}
  factory CarParameterInfo({
    /// Ключ параметра.
    @JsonKey(name: 'key') String? key,

    /// Название параметра.
    @JsonKey(name: 'name') String? name,

    /// Список значений параметра.
    @JsonKey(name: 'values') List<CarFilterValues>? values,

    /// Порядок сортировки параметра.
    @JsonKey(name: 'sortOrder') int? sortOrder,
  }) = _CarParameterInfo;

  /// Преобразует JSON в объект [CarParameterInfo].
  factory CarParameterInfo.fromJson(Map<String, dynamic> json) =>
      _$CarParameterInfoFromJson(json);
}

/// {@template car_filter_values}
/// Модель данных для значений фильтра автомобиля.
/// {@endtemplate}
@freezed
abstract class CarFilterValues with _$CarFilterValues {
  /// {@macro car_filter_values}
  factory CarFilterValues({
    /// Идентификатор значения.
    @JsonKey(name: 'id') String? id,

    /// Текст значения.
    @JsonKey(name: 'text') String? text,
  }) = _CarFilterValues;

  /// Преобразует JSON в объект [CarFilterValues].
  factory CarFilterValues.fromJson(Map<String, dynamic> json) =>
      _$CarFilterValuesFromJson(json);
}
