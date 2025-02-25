// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarParameterImpl _$$CarParameterImplFromJson(Map<String, dynamic> json) =>
    _$CarParameterImpl(
      idx: json['idx'] as String?,
      key: json['key'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CarParameterImplToJson(_$CarParameterImpl instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'key': instance.key,
      'name': instance.name,
      'value': instance.value,
      'sortOrder': instance.sortOrder,
    };
