// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Parts _$PartsFromJson(Map<String, dynamic> json) => _Parts(
      img: json['img'] as String?,
      imgDescription: json['imgDescription'] as String?,
      partGroups: (json['partGroups'] as List<dynamic>?)
          ?.map((e) => PartsGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => Position.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PartsToJson(_Parts instance) => <String, dynamic>{
      'img': instance.img,
      'imgDescription': instance.imgDescription,
      'partGroups': instance.partGroups,
      'positions': instance.positions,
    };

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

_Position _$PositionFromJson(Map<String, dynamic> json) => _Position(
      number: json['number'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$PositionToJson(_Position instance) => <String, dynamic>{
      'number': instance.number,
      'coordinates': instance.coordinates,
    };
