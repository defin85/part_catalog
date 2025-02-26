// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchemaModelImpl _$$SchemaModelImplFromJson(Map<String, dynamic> json) =>
    _$SchemaModelImpl(
      groupId: json['groupId'] as String,
      img: json['img'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      partNames: (json['partNames'] as List<dynamic>?)
          ?.map((e) => PartName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SchemaModelImplToJson(_$SchemaModelImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'img': instance.img,
      'name': instance.name,
      'description': instance.description,
      'partNames': instance.partNames,
    };
