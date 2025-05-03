// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
