import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/part.dart';

part 'parts_group.freezed.dart';
part 'parts_group.g.dart';

/// {@template parts_group}
/// Модель данных для группы запчастей.
/// {@endtemplate}
@freezed
abstract class PartsGroup with _$PartsGroup {
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
