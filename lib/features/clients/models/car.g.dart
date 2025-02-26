// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      vin: json['vin'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      licensePlate: json['licensePlate'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'vin': instance.vin,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'licensePlate': instance.licensePlate,
      'additionalInfo': instance.additionalInfo,
    };
