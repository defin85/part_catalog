import 'package:freezed_annotation/freezed_annotation.dart';

part 'part_name.freezed.dart';
part 'part_name.g.dart';

/// {@template part_name}
/// Модель данных для названия детали.
/// {@endtemplate}
@freezed
abstract class PartName with _$PartName {
  /// {@macro part_name}
  factory PartName({
    /// Идентификатор.
    @JsonKey(name: 'id') required String id,

    /// Название.
    @JsonKey(name: 'name') required String name,
  }) = _PartName;

  /// Преобразует JSON в объект [PartName].
  factory PartName.fromJson(Map<String, dynamic> json) =>
      _$PartNameFromJson(json);
}
