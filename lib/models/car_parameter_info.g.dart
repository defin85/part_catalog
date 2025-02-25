// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parameter_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarParameterInfoImpl _$$CarParameterInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$CarParameterInfoImpl(
      key: json['key'] as String?,
      name: json['name'] as String?,
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => CarFilterValues.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CarParameterInfoImplToJson(
        _$CarParameterInfoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'values': instance.values,
      'sortOrder': instance.sortOrder,
    };

_$CarFilterValuesImpl _$$CarFilterValuesImplFromJson(
        Map<String, dynamic> json) =>
    _$CarFilterValuesImpl(
      id: json['id'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$CarFilterValuesImplToJson(
        _$CarFilterValuesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
    };
