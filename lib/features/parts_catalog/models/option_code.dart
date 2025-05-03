import 'package:freezed_annotation/freezed_annotation.dart';

part 'option_code.freezed.dart';
part 'option_code.g.dart';

/// {@template option_code}
/// Модель данных для кода опции автомобиля.
/// {@endtemplate}
@freezed
abstract class OptionCode with _$OptionCode {
  /// {@macro option_code}
  factory OptionCode({
    /// Код опции.
    @JsonKey(name: 'code') String? code,

    /// Описание опции.
    @JsonKey(name: 'description') String? description,
  }) = _OptionCode;

  /// Преобразует JSON в объект [OptionCode].
  factory OptionCode.fromJson(Map<String, dynamic> json) =>
      _$OptionCodeFromJson(json);
}
