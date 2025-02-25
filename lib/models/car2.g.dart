// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Car2Impl _$$Car2ImplFromJson(Map<String, dynamic> json) => _$Car2Impl(
      id: json['id'] as String,
      catalogId: json['catalogId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      modelId: json['modelId'] as String?,
      modelName: json['modelName'] as String?,
      modelImg: json['modelImg'] as String?,
      vin: json['vin'] as String?,
      frame: json['frame'] as String?,
      criteria: json['criteria'] as String?,
      brand: json['brand'] as String?,
      groupsTreeAvailable: json['groupsTreeAvailable'] as bool?,
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => CarParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$Car2ImplToJson(_$Car2Impl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'catalogId': instance.catalogId,
      'name': instance.name,
      'description': instance.description,
      'modelId': instance.modelId,
      'modelName': instance.modelName,
      'modelImg': instance.modelImg,
      'vin': instance.vin,
      'frame': instance.frame,
      'criteria': instance.criteria,
      'brand': instance.brand,
      'groupsTreeAvailable': instance.groupsTreeAvailable,
      'parameters': instance.parameters,
    };

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
