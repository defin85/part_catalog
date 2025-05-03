import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggest.freezed.dart';
part 'suggest.g.dart';

/// {@template suggest}
/// Модель данных для подсказки.
/// {@endtemplate}
@freezed
abstract class Suggest with _$Suggest {
  /// {@macro suggest}
  factory Suggest({
    /// Идентификатор поиска.
    @JsonKey(name: 'sid') String? sid,

    /// Название.
    @JsonKey(name: 'name') String? name,
  }) = _Suggest;

  /// Преобразует JSON в объект [Suggest].
  factory Suggest.fromJson(Map<String, dynamic> json) =>
      _$SuggestFromJson(json);
}
