import 'package:freezed_annotation/freezed_annotation.dart';

import 'armtek_message.dart'; // Модель для сообщений

part 'armtek_response_wrapper.freezed.dart';
part 'armtek_response_wrapper.g.dart';

@Freezed(
    genericArgumentFactories:
        true) // Важно для поддержки дженерика T при генерации fromJson
abstract class ArmtekResponseWrapper<T> with _$ArmtekResponseWrapper<T> {
  const factory ArmtekResponseWrapper({
    @JsonKey(name: 'STATUS') required int status,
    @JsonKey(name: 'MESSAGES') List<ArmtekMessage>? messages,
    @JsonKey(name: 'RESP') T? responseData, // Полезная нагрузка
  }) = _ArmtekResponseWrapper<T>;

  factory ArmtekResponseWrapper.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ArmtekResponseWrapperFromJson<T>(json, fromJsonT);
}