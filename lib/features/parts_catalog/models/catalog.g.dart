// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Catalog _$CatalogFromJson(Map<String, dynamic> json) => _Catalog(
      id: json['id'] as String,
      name: json['name'] as String,
      modelsCount: (json['models_count'] as num).toInt(),
    );

Map<String, dynamic> _$CatalogToJson(_Catalog instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'models_count': instance.modelsCount,
    };
