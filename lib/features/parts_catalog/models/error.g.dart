// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorImpl _$$ErrorImplFromJson(Map<String, dynamic> json) => _$ErrorImpl(
      code: (json['code'] as num?)?.toInt(),
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ErrorImplToJson(_$ErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };
