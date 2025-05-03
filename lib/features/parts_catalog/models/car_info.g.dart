// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarInfo _$CarInfoFromJson(Map<String, dynamic> json) => _CarInfo(
      title: json['title'] as String?,
      catalogId: json['catalogId'] as String?,
      brand: json['brand'] as String?,
      modelId: json['modelId'] as String?,
      carId: json['carId'] as String?,
      criteria: json['criteria'] as String?,
      vin: json['vin'] as String?,
      frame: json['frame'] as String?,
      modelName: json['modelName'] as String?,
      description: json['description'] as String?,
      groupsTreeAvailable: json['groupsTreeAvailable'] as bool?,
      optionCodes: (json['optionCodes'] as List<dynamic>?)
          ?.map((e) => OptionCode.fromJson(e as Map<String, dynamic>))
          .toList(),
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => CarParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CarInfoToJson(_CarInfo instance) => <String, dynamic>{
      'title': instance.title,
      'catalogId': instance.catalogId,
      'brand': instance.brand,
      'modelId': instance.modelId,
      'carId': instance.carId,
      'criteria': instance.criteria,
      'vin': instance.vin,
      'frame': instance.frame,
      'modelName': instance.modelName,
      'description': instance.description,
      'groupsTreeAvailable': instance.groupsTreeAvailable,
      'optionCodes': instance.optionCodes,
      'parameters': instance.parameters,
    };
