// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchemasResponse _$SchemasResponseFromJson(Map<String, dynamic> json) =>
    _SchemasResponse(
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SchemaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchemasResponseToJson(_SchemasResponse instance) =>
    <String, dynamic>{
      'group': instance.group,
      'list': instance.list,
    };
