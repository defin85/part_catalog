import 'package:freezed_annotation/freezed_annotation.dart';

part 'part.freezed.dart';
part 'part.g.dart';

/// {@template part}
/// Модель данных для детали.
/// {@endtemplate}
@freezed
class Part with _$Part {
  /// {@macro part}
  factory Part({
    /// Идентификатор детали.
    @JsonKey(name: 'id') String? id,

    /// Идентификатор названия детали (может быть null).
    @JsonKey(name: 'nameId') String? nameId,

    /// Название детали.
    @JsonKey(name: 'name') String? name,

    /// Номер детали.
    @JsonKey(name: 'number') String? number,

    /// Примечание к детали.
    @JsonKey(name: 'notice') String? notice,

    /// Описание детали.
    @JsonKey(name: 'description') String? description,

    /// Номер позиции на изображении группы.
    @JsonKey(name: 'positionNumber') String? positionNumber,

    /// URL для поиска результатов.
    @JsonKey(name: 'url') String? url,
  }) = _Part;

  /// Преобразует JSON в объект [Part].
  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
}
