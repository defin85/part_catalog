import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

part 'source_location.freezed.dart';
part 'source_location.g.dart';

/// {@template source_location}
/// Информация о расположении узла в исходном коде.
/// {@endtemplate}
@freezed
class SourceLocation with _$SourceLocation {
  /// {@macro source_location}
  factory SourceLocation({
    /// Начальная позиция (смещение от начала файла) в символах
    @JsonKey(name: 'offset') required int offset,

    /// Длина узла в символах
    @JsonKey(name: 'length') required int length,

    /// Номер строки (1-based)
    @JsonKey(name: 'line') required int line,

    /// Позиция в строке (1-based)
    @JsonKey(name: 'column') required int column,

    /// Имя файла
    @JsonKey(name: 'file_name') String? fileName,
  }) = _SourceLocation;

  /// Создает объект из JSON
  factory SourceLocation.fromJson(Map<String, dynamic> json) =>
      _$SourceLocationFromJson(json);
}
