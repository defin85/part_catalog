// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartsImpl _$$PartsImplFromJson(Map<String, dynamic> json) => _$PartsImpl(
      img: json['img'] as String?,
      imgDescription: json['imgDescription'] as String?,
      partGroups: (json['partGroups'] as List<dynamic>?)
          ?.map((e) => PartsGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => Position.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PartsImplToJson(_$PartsImpl instance) =>
    <String, dynamic>{
      'img': instance.img,
      'imgDescription': instance.imgDescription,
      'partGroups': instance.partGroups,
      'positions': instance.positions,
    };

_$PartsGroupImpl _$$PartsGroupImplFromJson(Map<String, dynamic> json) =>
    _$PartsGroupImpl(
      name: json['name'] as String?,
      number: json['number'] as String?,
      positionNumber: json['positionNumber'] as String?,
      description: json['description'] as String?,
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PartsGroupImplToJson(_$PartsGroupImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'positionNumber': instance.positionNumber,
      'description': instance.description,
      'parts': instance.parts,
    };

_$PositionImpl _$$PositionImplFromJson(Map<String, dynamic> json) =>
    _$PositionImpl(
      number: json['number'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$PositionImplToJson(_$PositionImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'coordinates': instance.coordinates,
    };
