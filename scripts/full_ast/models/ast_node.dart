import 'dart:convert';
import 'package:analyzer/dart/ast/ast.dart';

import 'class_info.dart';
import 'declaration_info.dart';
import 'function_info.dart';
import 'metrics_info.dart';
import 'variable_info.dart';

// Экспортируем классы из metrics_info.dart
export 'metrics_info.dart' show CodeMetrics, ClassMetrics, MethodMetrics;

/// Базовый класс для всех узлов AST в нашей модели
abstract class AstNode {
  /// Имя узла
  String get name;

  /// Тип узла
  String get nodeType;

  /// Исходное местоположение узла
  SourceLocation? get location;

  /// Документация к узлу (если есть)
  String? get documentation;

  /// Преобразование в JSON
  Map<String, dynamic> toJson();

  /// Строковое представление
  @override
  String toString() => jsonEncode(toJson());
}

/// Представление местоположения в исходном коде
class SourceLocation {
  /// Начальная позиция (смещение от начала файла)
  final int offset;

  /// Длина узла
  final int length;

  /// Номер строки
  final int line;

  /// Позиция в строке
  final int column;

  /// Конструктор
  SourceLocation({
    required this.offset,
    required this.length,
    required this.line,
    required this.column,
  });

  /// Создание из JSON
  factory SourceLocation.fromJson(Map<String, dynamic> json) {
    return SourceLocation(
      offset: json['offset'],
      length: json['length'],
      line: json['line'],
      column: json['column'],
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'length': length,
      'line': line,
      'column': column,
    };
  }

  @override
  String toString() => '$line:$column';
}

/// Представление информации о файле
class FileNode implements AstNode {
  /// Путь к файлу
  final String path;

  /// Имя файла
  @override
  final String name;

  /// Размер файла в байтах
  final int size;

  /// Дата последнего изменения
  final DateTime lastModified;

  /// Классы в файле
  List<ClassInfo> classes = [];

  /// Функции в файле
  List<FunctionInfo> functions = [];

  /// Типы в файле
  List<TypeInfo> types = [];

  /// Декларации в файле
  List<DeclarationInfo> declarations = [];

  /// Импорты в файле
  List<ImportInfo> imports = [];

  /// Экспорты из файла
  List<ExportInfo> exports = [];

  /// Части файла (part директивы)
  List<String> parts = [];

  /// Ошибки при парсинге
  List<ParseErrorInfo>? parseErrors;

  /// Наличие ошибки при обработке
  bool hasError = false;

  /// Сообщение об ошибке
  String? errorMessage;

  /// Стек вызовов ошибки
  String? errorStackTrace;

  /// Метрики кода
  CodeMetrics? metrics;

  /// Информация о зависимостях
  DependencyInfo? dependencies;

  /// Документация к файлу
  @override
  String? documentation;

  /// Теги в файле
  List<String> tags = [];

  /// Переменные верхнего уровня
  List<VariableInfo> topLevelVariables = [];

  /// Конструктор
  FileNode({
    required this.path,
    required this.name,
    required this.size,
    required this.lastModified,
    this.hasError = false,
    this.errorMessage,
    this.errorStackTrace,
  });

  @override
  String get nodeType => 'file';

  @override
  SourceLocation? get location => null;

  @override
  Map<String, dynamic> toJson() {
    return {
      'nodeType': nodeType,
      'path': path,
      'name': name,
      'size': size,
      'lastModified': lastModified.toIso8601String(),
      'classes': classes.map((cls) => cls.toJson()).toList(),
      'functions': functions.map((func) => func.toJson()).toList(),
      'types': types.map((type) => type.toJson()).toList(),
      'imports': imports.map((imp) => imp.toJson()).toList(),
      'exports': exports.map((exp) => exp.toJson()).toList(),
      'parts': parts,
      if (documentation != null) 'documentation': documentation,
      if (metrics != null) 'metrics': metrics!.toJson(),
      if (dependencies != null) 'dependencies': dependencies!.toJson(),
      if (hasError) ...{
        'hasError': true,
        'errorMessage': errorMessage,
        if (errorStackTrace != null) 'errorStackTrace': errorStackTrace,
      },
      if (parseErrors != null && parseErrors!.isNotEmpty)
        'parseErrors': parseErrors!.map((e) => e.toJson()).toList(),
      if (topLevelVariables.isNotEmpty)
        'topLevelVariables': topLevelVariables.map((v) => v.toJson()).toList(),
    };
  }
}

// Остальное содержимое файла ast_node.dart без изменений
// ...

/// Информация об импорте
class ImportInfo {
  /// URI импорта
  final String uri;

  /// Префикс импорта (если есть)
  final String? prefix;

  /// Позиция импорта в файле
  final SourceLocation? location;

  /// Является ли импорт отложенным
  final bool isDeferred;

  /// Скрытые идентификаторы
  final List<String> hiddenNames;

  /// Показанные идентификаторы
  final List<String> shownNames;

  /// Конструктор
  ImportInfo({
    required this.uri,
    this.prefix,
    this.location,
    this.isDeferred = false,
    this.hiddenNames = const [],
    this.shownNames = const [],
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      if (prefix != null) 'prefix': prefix,
      if (location != null) 'location': location!.toJson(),
      'isDeferred': isDeferred,
      if (hiddenNames.isNotEmpty) 'hiddenNames': hiddenNames,
      if (shownNames.isNotEmpty) 'shownNames': shownNames,
    };
  }
}

/// Информация об экспорте
class ExportInfo {
  /// URI экспортируемого файла
  final String uri;

  /// Позиция экспорта в файле
  final SourceLocation? location;

  /// Скрытые идентификаторы
  final List<String> hiddenNames;

  /// Показанные идентификаторы
  final List<String> shownNames;

  /// Конструктор
  ExportInfo({
    required this.uri,
    this.location,
    this.hiddenNames = const [],
    this.shownNames = const [],
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      if (location != null) 'location': location!.toJson(),
      if (hiddenNames.isNotEmpty) 'hiddenNames': hiddenNames,
      if (shownNames.isNotEmpty) 'shownNames': shownNames,
    };
  }
}

/// Информация об ошибке парсинга
class ParseErrorInfo {
  /// Сообщение об ошибке
  final String message;

  /// Смещение от начала файла
  final int offset;

  /// Длина проблемного участка
  final int length;

  /// Тяжесть ошибки
  final String severity;

  /// Конструктор
  ParseErrorInfo({
    required this.message,
    required this.offset,
    required this.length,
    required this.severity,
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'offset': offset,
      'length': length,
      'severity': severity,
    };
  }
}

/// Информация о зависимостях
class DependencyInfo {
  /// Импорты
  final List<ImportDependency> imports;

  /// Экспорты
  final List<ExportDependency> exports;

  /// Внутренние зависимости
  final List<InternalDependency> internalDependencies;

  /// Внешние пакеты
  final Map<String, int> externalPackages;

  /// Конструктор
  DependencyInfo({
    required this.imports,
    required this.exports,
    required this.internalDependencies,
    required this.externalPackages,
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'imports': imports.map((imp) => imp.toJson()).toList(),
      'exports': exports.map((exp) => exp.toJson()).toList(),
      'internalDependencies':
          internalDependencies.map((dep) => dep.toJson()).toList(),
      'externalPackages': externalPackages,
    };
  }
}

/// Импортная зависимость
class ImportDependency {
  /// Исходный файл
  final String sourceFile;

  /// Целевой файл
  final String targetFile;

  /// Отложенный импорт
  final bool isDeferred;

  /// Конструктор
  ImportDependency({
    required this.sourceFile,
    required this.targetFile,
    this.isDeferred = false,
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceFile': sourceFile,
      'targetFile': targetFile,
      'isDeferred': isDeferred,
    };
  }
}

/// Экспортная зависимость
class ExportDependency {
  /// Исходный файл
  final String sourceFile;

  /// Целевой файл
  final String targetFile;

  /// Конструктор
  ExportDependency({
    required this.sourceFile,
    required this.targetFile,
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceFile': sourceFile,
      'targetFile': targetFile,
    };
  }
}

/// Внутренняя зависимость
class InternalDependency {
  /// Тип исходного компонента
  final String sourceType;

  /// Имя исходного компонента
  final String sourceName;

  /// Тип целевого компонента
  final String targetType;

  /// Имя целевого компонента
  final String targetName;

  /// Тип зависимости
  final String dependencyType;

  /// Конструктор
  InternalDependency({
    required this.sourceType,
    required this.sourceName,
    required this.targetType,
    required this.targetName,
    required this.dependencyType,
  });

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceType': sourceType,
      'sourceName': sourceName,
      'targetType': targetType,
      'targetName': targetName,
      'dependencyType': dependencyType,
    };
  }
}
