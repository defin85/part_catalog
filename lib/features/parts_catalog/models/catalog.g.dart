// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogImpl _$$CatalogImplFromJson(Map<String, dynamic> json) =>
    _$CatalogImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      modelsCount: (json['models_count'] as num).toInt(),
    );

Map<String, dynamic> _$$CatalogImplToJson(_$CatalogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'models_count': instance.modelsCount,
    };
