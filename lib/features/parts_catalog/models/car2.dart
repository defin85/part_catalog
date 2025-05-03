import 'package:freezed_annotation/freezed_annotation.dart';

part 'car2.freezed.dart';
part 'car2.g.dart';

/// {@template car2}
/// Модель данных для автомобиля (Car2).
/// {@endtemplate}
@freezed
abstract class Car2 with _$Car2 {
  /// {@macro car2}
  factory Car2({
    /// Идентификатор автомобиля.
    @JsonKey(name: 'id') required String id,

    /// Идентификатор каталога.
    @JsonKey(name: 'catalogId') required String catalogId,

    /// Название автомобиля.
    @JsonKey(name: 'name') required String name,

    /// Описание автомобиля.
    @JsonKey(name: 'description') String? description,

    /// Идентификатор модели автомобиля.
    @JsonKey(name: 'modelId') String? modelId,

    /// Название модели автомобиля.
    @JsonKey(name: 'modelName') String? modelName,

    /// URL изображения модели автомобиля.
    @JsonKey(name: 'modelImg') String? modelImg,

    /// VIN автомобиля.
    @JsonKey(name: 'vin') String? vin,

    /// FRAME автомобиля.
    @JsonKey(name: 'frame') String? frame,

    /// Критерии для фильтрации групп и запчастей.
    @JsonKey(name: 'criteria') String? criteria,

    /// Бренд автомобиля.
    @JsonKey(name: 'brand') String? brand,

    /// Флаг доступности дерева групп.
    @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,

    /// Параметры автомобиля.
    @JsonKey(name: 'parameters') List<CarParameter>? parameters,
  }) = _Car2;

  /// Преобразует JSON в объект [Car2].
  factory Car2.fromJson(Map<String, dynamic> json) => _$Car2FromJson(json);
}

/// {@template car_parameter}
/// Модель данных для параметра автомобиля.
/// {@endtemplate}
@freezed
abstract class CarParameter with _$CarParameter {
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
