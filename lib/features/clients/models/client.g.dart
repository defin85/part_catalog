// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientModelImpl _$$ClientModelImplFromJson(Map<String, dynamic> json) =>
    _$ClientModelImpl(
      id: (json['id'] as num).toInt(),
      type: $enumDecode(_$ClientTypeEnumMap, json['type']),
      name: json['name'] as String,
      contactInfo: json['contactInfo'] as String,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$$ClientModelImplToJson(_$ClientModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ClientTypeEnumMap[instance.type]!,
      'name': instance.name,
      'contactInfo': instance.contactInfo,
      'additionalInfo': instance.additionalInfo,
    };

const _$ClientTypeEnumMap = {
  ClientType.physical: 'physical',
  ClientType.legal: 'legal',
  ClientType.individualEntrepreneur: 'individualEntrepreneur',
  ClientType.other: 'other',
};
