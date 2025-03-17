import 'package:analyzer/dart/ast/ast.dart' as analyzer;
import 'package:freezed_annotation/freezed_annotation.dart';

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

    /// Номер начальной строки
    @JsonKey(name: 'start_line') int? startLine,

    /// Номер конечной строки
    @JsonKey(name: 'end_line') int? endLine,

    /// Имя файла
    @JsonKey(name: 'file_name') String? fileName,
  }) = _SourceLocation;

  /// Приватный конструктор для методов
  const SourceLocation._();

  /// Создает объект из JSON
  factory SourceLocation.fromJson(Map<String, dynamic> json) =>
      _$SourceLocationFromJson(json);

  /// Создает объект на основе узла АСТ
  factory SourceLocation.fromNode(analyzer.AstNode node, {String? fileName}) {
    final offset = node.offset;
    final length = node.length;

    // Получаем информацию о строке и колонке
    final lineInfo = (node.root as analyzer.CompilationUnit?)?.lineInfo;

    if (lineInfo != null) {
      final startLocation = lineInfo.getLocation(offset);
      final endLocation = lineInfo.getLocation(offset + length);

      return SourceLocation(
        offset: offset,
        length: length,
        line: startLocation.lineNumber,
        column: startLocation.columnNumber,
        startLine: startLocation.lineNumber,
        endLine: endLocation.lineNumber,
        fileName: fileName,
      );
    } else {
      // Если информация о строках недоступна, используем заглушку
      return SourceLocation(
        offset: offset,
        length: length,
        line: 0,
        column: 0,
        startLine: 0,
        endLine: 0,
        fileName: fileName,
      );
    }
  }

  /// Возвращает строковое представление в формате "file:line:column"
  String get locationString {
    final name = fileName;
    return name != null ? '$name:$line:$column' : '$line:$column';
  }

  /// Возвращает строковое представление диапазона
  String get range => 'offset=$offset length=$length';

  /// Возвращает полную информацию о местоположении
  String get fullInfo {
    final locString = locationString;
    return '$locString ($range)';
  }

  /// Проверяет, содержит ли данная локация указанную позицию
  bool contains(int position) {
    return position >= offset && position < (offset + length);
  }

  /// Создаёт новую локацию, объединённую с указанной
  SourceLocation merge(SourceLocation other) {
    final startOffset = offset < other.offset ? offset : other.offset;
    final endOffset = (offset + length) > (other.offset + other.length)
        ? (offset + length)
        : (other.offset + other.length);

    return SourceLocation(
      offset: startOffset,
      length: endOffset - startOffset,
      line: line < other.line ? line : other.line,
      column: line < other.line
          ? column
          : (line == other.line && column < other.column
              ? column
              : other.column),
      fileName: fileName ?? other.fileName,
    );
  }
}
