// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Group _$GroupFromJson(Map<String, dynamic> json) => _Group(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      hasSubgroups: json['hasSubgroups'] as bool?,
      hasParts: json['hasParts'] as bool?,
      name: json['name'] as String,
      img: json['img'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$GroupToJson(_Group instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'hasSubgroups': instance.hasSubgroups,
      'hasParts': instance.hasParts,
      'name': instance.name,
      'img': instance.img,
      'description': instance.description,
    };
