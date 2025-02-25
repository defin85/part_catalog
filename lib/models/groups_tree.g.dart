// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupsTreeImpl _$$GroupsTreeImplFromJson(Map<String, dynamic> json) =>
    _$GroupsTreeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      subGroups: (json['subGroups'] as List<dynamic>?)
              ?.map((e) => GroupsTree.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupsTreeImplToJson(_$GroupsTreeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'subGroups': instance.subGroups,
    };
