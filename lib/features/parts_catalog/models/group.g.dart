// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      hasSubgroups: json['hasSubgroups'] as bool?,
      hasParts: json['hasParts'] as bool?,
      name: json['name'] as String,
      img: json['img'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'hasSubgroups': instance.hasSubgroups,
      'hasParts': instance.hasParts,
      'name': instance.name,
      'img': instance.img,
      'description': instance.description,
    };
