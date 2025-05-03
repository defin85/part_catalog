// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Part _$PartFromJson(Map<String, dynamic> json) => _Part(
      id: json['id'] as String?,
      nameId: json['nameId'] as String?,
      name: json['name'] as String?,
      number: json['number'] as String?,
      notice: json['notice'] as String?,
      description: json['description'] as String?,
      positionNumber: json['positionNumber'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PartToJson(_Part instance) => <String, dynamic>{
      'id': instance.id,
      'nameId': instance.nameId,
      'name': instance.name,
      'number': instance.number,
      'notice': instance.notice,
      'description': instance.description,
      'positionNumber': instance.positionNumber,
      'url': instance.url,
    };
