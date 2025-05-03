// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartsGroup _$PartsGroupFromJson(Map<String, dynamic> json) => _PartsGroup(
      name: json['name'] as String?,
      number: json['number'] as String?,
      positionNumber: json['positionNumber'] as String?,
      description: json['description'] as String?,
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PartsGroupToJson(_PartsGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'positionNumber': instance.positionNumber,
      'description': instance.description,
      'parts': instance.parts,
    };
