// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_tree_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupsTreeResponse _$GroupsTreeResponseFromJson(Map<String, dynamic> json) =>
    _GroupsTreeResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      subGroups: (json['subGroups'] as List<dynamic>?)
          ?.map((e) => GroupsTree.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupsTreeResponseToJson(_GroupsTreeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'subGroups': instance.subGroups,
    };
