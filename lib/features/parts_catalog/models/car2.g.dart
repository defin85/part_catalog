// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Car2 _$Car2FromJson(Map<String, dynamic> json) => _Car2(
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

Map<String, dynamic> _$Car2ToJson(_Car2 instance) => <String, dynamic>{
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

_CarParameter _$CarParameterFromJson(Map<String, dynamic> json) =>
    _CarParameter(
      idx: json['idx'] as String?,
      key: json['key'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CarParameterToJson(_CarParameter instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'key': instance.key,
      'name': instance.name,
      'value': instance.value,
      'sortOrder': instance.sortOrder,
    };
