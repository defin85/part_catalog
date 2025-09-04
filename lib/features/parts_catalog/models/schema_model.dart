import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:part_catalog/features/parts_catalog/models/part_name.dart';

part 'schema_model.freezed.dart';
part 'schema_model.g.dart';

/// {@template schema_model}
/// Модель данных для схемы.
/// {@endtemplate}
@freezed
abstract class SchemaModel with _$SchemaModel {
  /// {@macro schema_model}
  factory SchemaModel({
    /// Идентификатор группы.
    @JsonKey(name: 'groupId') required String groupId,

    /// URL изображения.
    @JsonKey(name: 'img') String? img,

    /// Название.
    @JsonKey(name: 'name') required String name,

    /// Описание.
    @JsonKey(name: 'description') String? description,

    /// Список названий деталей.
    @JsonKey(name: 'partNames') List<PartName>? partNames,
  }) = _SchemaModel;

  /// Преобразует JSON в объект [SchemaModel].
  factory SchemaModel.fromJson(Map<String, dynamic> json) =>
      _$SchemaModelFromJson(json);
}
