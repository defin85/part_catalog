import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_parameter_idx.freezed.dart';
part 'car_parameter_idx.g.dart';

/// {@template car_parameter_idx}
/// Модель данных для индекса параметра автомобиля.
/// {@endtemplate}
@freezed
abstract class CarParameterIdx with _$CarParameterIdx {
  /// {@macro car_parameter_idx}
  factory CarParameterIdx({
    /// Индекс параметра автомобиля.
    @JsonKey(name: 'idx') String? idx,
  }) = _CarParameterIdx;

  /// Преобразует JSON в объект [CarParameterIdx].
  factory CarParameterIdx.fromJson(Map<String, dynamic> json) =>
      _$CarParameterIdxFromJson(json);
}
