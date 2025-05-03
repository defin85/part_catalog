// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchemaModel _$SchemaModelFromJson(Map<String, dynamic> json) => _SchemaModel(
      groupId: json['groupId'] as String,
      img: json['img'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      partNames: (json['partNames'] as List<dynamic>?)
          ?.map((e) => PartName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SchemaModelToJson(_SchemaModel instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'img': instance.img,
      'name': instance.name,
      'description': instance.description,
      'partNames': instance.partNames,
    };
