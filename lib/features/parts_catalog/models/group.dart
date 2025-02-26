import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// {@template group}
/// Модель данных для группы.
/// {@endtemplate}
@freezed
class Group with _$Group {
  /// {@macro group}
  factory Group({
    /// Идентификатор группы.
    @JsonKey(name: 'id') required String id,

    /// Идентификатор родительской группы (может быть null).
    @JsonKey(name: 'parentId') String? parentId,

    /// Признак наличия подгрупп.
    @JsonKey(name: 'hasSubgroups') bool? hasSubgroups,

    /// Признак наличия деталей в группе.
    @JsonKey(name: 'hasParts') bool? hasParts,

    /// Название группы.
    @JsonKey(name: 'name') required String name,

    /// Изображение группы.
    @JsonKey(name: 'img') String? img,

    /// Описание группы.
    @JsonKey(name: 'description') String? description,
  }) = _Group;

  /// Преобразует JSON в объект [Group].
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
