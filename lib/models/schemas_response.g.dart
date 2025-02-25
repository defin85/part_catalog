// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchemasResponseImpl _$$SchemasResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SchemasResponseImpl(
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SchemaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SchemasResponseImplToJson(
        _$SchemasResponseImpl instance) =>
    <String, dynamic>{
      'group': instance.group,
      'list': instance.list,
    };
