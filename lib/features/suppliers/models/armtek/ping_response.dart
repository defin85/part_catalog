import 'package:freezed_annotation/freezed_annotation.dart';

part 'ping_response.freezed.dart';
part 'ping_response.g.dart';

/// {@template ping_response}
/// Модель ответа для метода index сервиса ws_ping
/// {@endtemplate}
@freezed
abstract class PingResponse with _$PingResponse {
  /// {@macro ping_response}
  const factory PingResponse({
    /// IP адрес клиента, с которого пришел запрос
    @JsonKey(name: 'IP') required String ip,

    /// Время выполнения скрипта на сервере (в секундах с микросекундами)
    @JsonKey(name: 'TIME') required double time,
  }) = _PingResponse;

  /// Создает [PingResponse] из JSON объекта
  factory PingResponse.fromJson(Map<String, dynamic> json) =>
      _$PingResponseFromJson(json);
}
