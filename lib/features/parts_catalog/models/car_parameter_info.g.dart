// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parameter_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarParameterInfo _$CarParameterInfoFromJson(Map<String, dynamic> json) =>
    _CarParameterInfo(
      key: json['key'] as String?,
      name: json['name'] as String?,
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => CarFilterValues.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CarParameterInfoToJson(_CarParameterInfo instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'values': instance.values,
      'sortOrder': instance.sortOrder,
    };

_CarFilterValues _$CarFilterValuesFromJson(Map<String, dynamic> json) =>
    _CarFilterValues(
      id: json['id'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$CarFilterValuesToJson(_CarFilterValues instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
    };
