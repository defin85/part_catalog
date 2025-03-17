import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'source_location.dart';
import 'class_info.dart';
import 'combinator_info.dart';
import 'declaration_info.dart';
import 'function_info.dart';
import 'metrics_info.dart';
import 'variable_info.dart';

// Экспортируем классы из metrics_info.dart и combinator_info.dart
export 'metrics_info.dart' show CodeMetrics, ClassMetrics, MethodMetrics;
export 'combinator_info.dart' show CombinatorInfo;

part 'ast_node.freezed.dart';
part 'ast_node.g.dart';

/// {@template ast_node}
/// Базовый класс для всех узлов AST в нашей модели
/// {@endtemplate}
@freezed
class AstNode with _$AstNode {
  const AstNode._();

  /// Создает класс-наследник для представления корневого узла проекта
  const factory AstNode.project({
    /// Путь к корневой директории проекта
    @JsonKey(name: 'path') required String path,

    /// Имя проекта (обычно совпадает с именем директории)
    @JsonKey(name: 'name') required String name,

    /// Список файлов в проекте
    @JsonKey(name: 'files')
    @FileNodeConverter()
    @Default([])
    List<FileNode> files,

    /// Список директорий в проекте
    @JsonKey(name: 'directories')
    @DirectoryNodeConverter()
    @Default([])
    List<DirectoryNode> directories,

    /// Метрики проекта
    @JsonKey(name: 'metrics') CodeMetrics? metrics,

    /// Зависимости проекта
    @JsonKey(name: 'dependencies') FileDependencySummary? dependencies,
  }) = ProjectNode;

  /// Создает класс-наследник для представления директории в проекте
  const factory AstNode.directory({
    /// Путь к директории
    @JsonKey(name: 'path') required String path,

    /// Имя директории
    @JsonKey(name: 'name') required String name,

    /// Список файлов в директории
    @JsonKey(name: 'files')
    @FileNodeConverter()
    @Default([])
    List<FileNode> files,

    /// Список поддиректорий
    @JsonKey(name: 'directories')
    @DirectoryNodeConverter()
    @Default([])
    List<DirectoryNode> directories,

    /// Документация к директории (если есть)
    @JsonKey(name: 'documentation') String? documentation,
  }) = DirectoryNode;

  /// {@macro ast_node}
  /// Файловый узел, содержащий информацию о файле и его содержимом
  const factory AstNode.file({
    /// Путь к файлу
    @JsonKey(name: 'path') required String path,

    /// Имя файла
    @JsonKey(name: 'name') required String name,

    /// Размер файла в байтах
    @JsonKey(name: 'size') required int size,

    /// Дата последнего изменения
    @JsonKey(name: 'last_modified') required DateTime lastModified,

    /// Классы в файле
    @JsonKey(name: 'classes') @Default([]) List<ClassInfo> classes,

    /// Функции в файле
    @JsonKey(name: 'functions') @Default([]) List<FunctionInfo> functions,

    /// Декларации в файле
    @JsonKey(name: 'declarations')
    @Default([])
    List<DeclarationInfo> declarations,

    /// Импорты в файле
    @JsonKey(name: 'imports')
    @ImportInfoConverter()
    @Default([])
    List<ImportInfo> imports,

    /// Экспорты из файла
    @JsonKey(name: 'exports')
    @ExportInfoConverter()
    @Default([])
    List<ExportInfo> exports,

    /// Части файла (part директивы)
    @JsonKey(name: 'parts') @Default([]) List<String> parts,

    /// Переменные верхнего уровня
    @JsonKey(name: 'top_level_variables')
    @Default([])
    List<VariableInfo> topLevelVariables,

    /// Ошибки при парсинге
    @JsonKey(name: 'parse_errors')
    @ParseErrorInfoConverter()
    List<ParseErrorInfo>? parseErrors,

    /// Наличие ошибки при обработке
    @JsonKey(name: 'has_error') @Default(false) bool hasError,

    /// Сообщение об ошибке
    @JsonKey(name: 'error_message') String? errorMessage,

    /// Стек вызовов ошибки
    @JsonKey(name: 'error_stack_trace') String? errorStackTrace,

    /// Метрики кода
    @JsonKey(name: 'metrics') CodeMetrics? metrics,

    /// Информация о зависимостях
    @JsonKey(name: 'dependencies') FileDependencySummary? dependencies,

    /// Документация к файлу
    @JsonKey(name: 'documentation') String? documentation,

    /// Теги в файле
    @JsonKey(name: 'tags') @Default([]) List<String> tags,
  }) = FileNode;

  /// Создает класс-наследник для представления узла импорта
  ///
  /// Импорт может содержать комбинаторы (show/hide), которые определяют
  /// видимость имен из импортируемого файла.
  /// `combinators` - основной способ хранения этих данных, а поля
  /// `hiddenNames` и `shownNames` предоставлены для удобства доступа
  /// и обратной совместимости.
  const factory AstNode.import({
    /// URI импорта
    @JsonKey(name: 'uri') required String uri,

    /// Префикс импорта (если есть)
    @JsonKey(name: 'prefix') String? prefix,

    /// Позиция импорта в файле
    @JsonKey(name: 'location') SourceLocation? location,

    /// Является ли импорт отложенным
    @JsonKey(name: 'is_deferred') @Default(false) bool isDeferred,

    /// Комбинаторы импорта
    /// Полное представление всех комбинаторов show/hide с их позициями в коде
    @JsonKey(name: 'combinators') @Default([]) List<CombinatorInfo> combinators,
  }) = ImportInfo;

  /// Создает класс-наследник для представления узла экспорта
  const factory AstNode.export({
    /// URI экспортируемого файла
    @JsonKey(name: 'uri') required String uri,

    /// Позиция экспорта в файле
    @JsonKey(name: 'location') SourceLocation? location,

    /// Комбинаторы экспорта
    /// Полное представление всех комбинаторов show/hide с их позициями в коде
    @JsonKey(name: 'combinators') @Default([]) List<CombinatorInfo> combinators,
  }) = ExportInfo;

  /// Создает класс-наследник для представления ошибки парсинга
  const factory AstNode.parseError({
    /// Сообщение об ошибке
    @JsonKey(name: 'message') required String message,

    /// Смещение от начала файла
    @JsonKey(name: 'offset') required int offset,

    /// Длина проблемного участка
    @JsonKey(name: 'length') required int length,

    /// Тяжесть ошибки
    @JsonKey(name: 'severity') required String severity,

    /// Позиция в коде
    @JsonKey(name: 'location') SourceLocation? location,
  }) = ParseErrorInfo;

  /// Создает объект из JSON
  factory AstNode.fromJson(Map<String, dynamic> json) =>
      _$AstNodeFromJson(json);

  /// Имя узла
  String get name => map(
        file: (node) => node.name,
        import: (node) => node.uri,
        export: (node) => node.uri,
        parseError: (node) => 'Error at ${node.offset}',
        project: (node) => node.name,
        directory: (node) => node.name,
      );

  /// Тип узла
  String get nodeType => map(
        file: (_) => 'file',
        import: (_) => 'import',
        export: (_) => 'export',
        parseError: (_) => 'parse_error',
        project: (_) => 'project',
        directory: (_) => 'directory',
      );

  /// Исходное местоположение узла
  SourceLocation? get location => map(
        file: (_) => null,
        import: (node) => node.location,
        export: (node) => node.location,
        parseError: (node) => node.location,
        project: (_) => null,
        directory: (_) => null,
      );

  /// Документация к узлу (если есть)
  String? get documentation => map(
        file: (node) => node.documentation,
        import: (_) => null,
        export: (_) => null,
        parseError: (_) => null,
        project: (_) => null,
        directory: (node) => node.documentation,
      );

  /// Преобразование в строку в формате JSON
  @override
  String toString() => jsonEncode(toJson());
}

/// Расширение для работы с комбинаторами ImportInfo
extension ImportInfoExtension on ImportInfo {
  /// Получить список имен, которые скрыты комбинатором hide
  List<String> get computedHiddenNames => combinators
      .where((c) => c.type == 'hide')
      .expand((c) => c.names)
      .toList();

  /// Получить список имен, которые показаны комбинатором show
  List<String> get computedShownNames => combinators
      .where((c) => c.type == 'show')
      .expand((c) => c.names)
      .toList();

  /// Проверка наличия комбинаторов
  bool get hasCombinators => combinators.isNotEmpty;
}

/// {@template file_dependency_summary}
/// Информация о зависимостях файла (высокоуровневая сводка)
/// {@endtemplate}
@freezed
class FileDependencySummary with _$FileDependencySummary {
  const FileDependencySummary._();

  /// {@macro file_dependency_summary}
  const factory FileDependencySummary({
    /// Прямые зависимости
    @JsonKey(name: 'direct_dependencies')
    @Default([])
    List<String> directDependencies,

    /// Прямые клиенты (файлы, зависящие от этого)
    @JsonKey(name: 'direct_clients') @Default([]) List<String> directClients,

    /// Весь граф зависимостей
    @JsonKey(name: 'dependency_graph')
    @Default({})
    Map<String, List<String>> dependencyGraph,
  }) = _FileDependencySummary;

  /// Создает объект из JSON
  factory FileDependencySummary.fromJson(Map<String, dynamic> json) =>
      _$FileDependencySummaryFromJson(json);
}

/// Конвертер для FileNode, необходим для корректной десериализации циклических ссылок
class FileNodeConverter
    implements JsonConverter<FileNode, Map<String, dynamic>> {
  const FileNodeConverter();

  @override
  FileNode fromJson(Map<String, dynamic> json) {
    return AstNode.fromJson(json) as FileNode;
  }

  @override
  Map<String, dynamic> toJson(FileNode object) {
    return object.toJson();
  }
}

/// Конвертер для DirectoryNode, необходим для корректной десериализации циклических ссылок
class DirectoryNodeConverter
    implements JsonConverter<DirectoryNode, Map<String, dynamic>> {
  const DirectoryNodeConverter();

  @override
  DirectoryNode fromJson(Map<String, dynamic> json) {
    return AstNode.fromJson(json) as DirectoryNode;
  }

  @override
  Map<String, dynamic> toJson(DirectoryNode object) {
    return object.toJson();
  }
}

/// Конвертер для ImportInfo, необходим для корректной десериализации
class ImportInfoConverter
    implements JsonConverter<ImportInfo, Map<String, dynamic>> {
  const ImportInfoConverter();

  @override
  ImportInfo fromJson(Map<String, dynamic> json) {
    return AstNode.fromJson(json) as ImportInfo;
  }

  @override
  Map<String, dynamic> toJson(ImportInfo object) {
    return object.toJson();
  }
}

/// Конвертер для ExportInfo, необходим для корректной десериализации
class ExportInfoConverter
    implements JsonConverter<ExportInfo, Map<String, dynamic>> {
  const ExportInfoConverter();

  @override
  ExportInfo fromJson(Map<String, dynamic> json) {
    return AstNode.fromJson(json) as ExportInfo;
  }

  @override
  Map<String, dynamic> toJson(ExportInfo object) {
    return object.toJson();
  }
}

/// Конвертер для ParseErrorInfo, необходим для корректной десериализации
class ParseErrorInfoConverter
    implements JsonConverter<ParseErrorInfo, Map<String, dynamic>> {
  const ParseErrorInfoConverter();

  @override
  ParseErrorInfo fromJson(Map<String, dynamic> json) {
    return AstNode.fromJson(json) as ParseErrorInfo;
  }

  @override
  Map<String, dynamic> toJson(ParseErrorInfo object) {
    return object.toJson();
  }
}
