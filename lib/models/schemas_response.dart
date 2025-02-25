import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/models/group.dart';
import 'package:part_catalog/models/schema_model.dart';

part 'schemas_response.freezed.dart';
part 'schemas_response.g.dart';

/// {@template schemas_response}
/// Модель данных для ответа со схемами.
/// {@endtemplate}
@freezed
class SchemasResponse with _$SchemasResponse {
  /// {@macro schemas_response}
  factory SchemasResponse({
    /// Группа (может быть null).
    @JsonKey(name: 'group') Group? group,

    /// Список схем.
    @JsonKey(name: 'list') List<SchemaModel>? list,
  }) = _SchemasResponse;

  /// Преобразует JSON в объект [SchemasResponse].
  factory SchemasResponse.fromJson(Map<String, dynamic> json) =>
      _$SchemasResponseFromJson(json);
}
