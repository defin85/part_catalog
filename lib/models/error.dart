import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.freezed.dart';
part 'error.g.dart';

/// {@template error}
/// Модель данных для ошибки.
/// {@endtemplate}
@freezed
class Error with _$Error {
  /// {@macro error}
  factory Error({
    /// Код ошибки.
    @JsonKey(name: 'code') int? code,

    /// Код ошибки (строковый).
    @JsonKey(name: 'errorCode') String? errorCode,

    /// Сообщение об ошибке.
    @JsonKey(name: 'message') String? message,
  }) = _Error;

  /// Преобразует JSON в объект [Error].
  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
}
