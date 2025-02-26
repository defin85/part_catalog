// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String,
      type: const ClientTypeConverter().fromJson(json['type'] as String),
      name: json['name'] as String,
      contactInfo: json['contactInfo'] as String,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'type': const ClientTypeConverter().toJson(instance.type),
      'name': instance.name,
      'contactInfo': instance.contactInfo,
      'additionalInfo': instance.additionalInfo,
    };
