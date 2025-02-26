import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/part.dart';

part 'parts.freezed.dart';
part 'parts.g.dart';

/// {@template parts}
/// Модель данных для списка запчастей.
/// {@endtemplate}
@freezed
class Parts with _$Parts {
  /// {@macro parts}
  factory Parts({
    /// URL изображения группы запчастей.
    @JsonKey(name: 'img') String? img,

    /// Описание изображения группы запчастей.
    @JsonKey(name: 'imgDescription') String? imgDescription,

    /// Список групп запчастей.
    @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,

    /// Список позиций блоков с номерами на изображении.
    @JsonKey(name: 'positions') List<Position>? positions,
  }) = _Parts;

  /// Преобразует JSON в объект [Parts].
  factory Parts.fromJson(Map<String, dynamic> json) => _$PartsFromJson(json);
}

/// {@template parts_group}
/// Модель данных для группы запчастей.
/// {@endtemplate}
@freezed
class PartsGroup with _$PartsGroup {
  /// {@macro parts_group}
  factory PartsGroup({
    /// Название запчасти.
    @JsonKey(name: 'name') String? name,

    /// Номер группы запчастей.
    @JsonKey(name: 'number') String? number,

    /// Номер позиции группы запчастей на изображении.
    @JsonKey(name: 'positionNumber') String? positionNumber,

    /// Описание группы запчастей.
    @JsonKey(name: 'description') String? description,

    /// Список деталей в группе.
    @JsonKey(name: 'parts') List<Part>? parts,
  }) = _PartsGroup;

  /// Преобразует JSON в объект [PartsGroup].
  factory PartsGroup.fromJson(Map<String, dynamic> json) =>
      _$PartsGroupFromJson(json);
}

/// {@template position}
/// Модель данных для позиции блока с номером на изображении.
/// {@endtemplate}
@freezed
class Position with _$Position {
  /// {@macro position}
  factory Position({
    /// Номер на изображении.
    @JsonKey(name: 'number') String? number,

    /// Координаты блока с номером на изображении (X, Y, H, W).
    @JsonKey(name: 'coordinates') List<double>? coordinates,
  }) = _Position;

  /// Преобразует JSON в объект [Position].
  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}
