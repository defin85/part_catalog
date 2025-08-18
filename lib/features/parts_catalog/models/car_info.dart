import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/parts_catalog/models/car_parameter.dart';
import 'package:part_catalog/features/parts_catalog/models/option_code.dart';

part 'car_info.freezed.dart';
part 'car_info.g.dart';

/// {@template car_info}
/// Модель данных для информации об автомобиле.
/// {@endtemplate}
@freezed
abstract class CarInfo with _$CarInfo {
  /// {@macro car_info}
  factory CarInfo({
    /// Заголовок.
    @JsonKey(name: 'title') String? title,

    /// Идентификатор каталога.
    @JsonKey(name: 'catalogId') String? catalogId,

    /// Бренд автомобиля.
    @JsonKey(name: 'brand') String? brand,

    /// Идентификатор модели автомобиля.
    @JsonKey(name: 'modelId') String? modelId,

    /// Идентификатор автомобиля.
    @JsonKey(name: 'carId') String? carId,

    /// Критерии для поиска.
    @JsonKey(name: 'criteria') String? criteria,

    /// VIN автомобиля.
    @JsonKey(name: 'vin') String? vin,

    /// FRAME автомобиля.
    @JsonKey(name: 'frame') String? frame,

    /// Название модели автомобиля.
    @JsonKey(name: 'modelName') String? modelName,

    /// Описание автомобиля.
    @JsonKey(name: 'description') String? description,

    /// Флаг доступности дерева групп.
    @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,

    /// Список кодов опций автомобиля.
    @JsonKey(name: 'optionCodes') List<OptionCode>? optionCodes,

    /// Список параметров автомобиля.
    @JsonKey(name: 'parameters') List<CarParameter>? parameters,
  }) = _CarInfo;

  /// Преобразует JSON в объект [CarInfo].
  factory CarInfo.fromJson(Map<String, dynamic> json) =>
      _$CarInfoFromJson(json);
}