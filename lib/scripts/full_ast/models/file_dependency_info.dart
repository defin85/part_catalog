import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/scripts/full_ast/models/component_dependency_info.dart';

import '../models/ast_node.dart';

part 'file_dependency_info.freezed.dart';
part 'file_dependency_info.g.dart';

/// {@template file_dependency_info}
/// Класс для хранения информации о зависимостях файла
/// {@endtemplate}
@freezed
class FileDependencyInfo with _$FileDependencyInfo {
  const FileDependencyInfo._();

  /// {@macro file_dependency_info}
  const factory FileDependencyInfo({
    /// Импорты файла
    @JsonKey(name: 'imports') @Default([]) List<ImportDependency> imports,

    /// Экспорты файла
    @JsonKey(name: 'exports') @Default([]) List<ExportDependency> exports,

    /// Внутренние зависимости между компонентами
    @JsonKey(name: 'internal_dependencies')
    @Default([])
    List<InternalDependency> internalDependencies,

    /// Внешние пакеты с количеством использований
    @JsonKey(name: 'external_packages')
    @Default({})
    Map<String, int> externalPackages,
  }) = _FileDependencyInfo;

  /// Создает объект из JSON
  factory FileDependencyInfo.fromJson(Map<String, dynamic> json) =>
      _$FileDependencyInfoFromJson(json);

  /// Преобразует FileDependencyInfo в ast.FileDependencySummary
  FileDependencySummary toDependencyInfo() {
    return FileDependencySummary(
      directDependencies: imports.map((imp) => imp.targetFile).toSet().toList(),
      directClients: [], // Эти данные нужно получить из внешнего анализа
      dependencyGraph: {}, // Граф зависимостей формируется на более высоком уровне
    );
  }

  /// Создает FileDependencyInfo из ComponentDependencyInfo
  static FileDependencyInfo fromDependencyInfo(ComponentDependencyInfo info) {
    final attrs = info.attributes ?? {};

    return FileDependencyInfo(
      imports: _parseImports(attrs['imports']),
      exports: _parseExports(attrs['exports']),
      internalDependencies:
          _parseInternalDependencies(attrs['internal_dependencies']),
      externalPackages: Map<String, int>.from(attrs['external_packages'] ?? {}),
    );
  }

  /// Служебный метод для парсинга импортов из атрибутов
  static List<ImportDependency> _parseImports(dynamic imports) {
    if (imports == null) return [];
    try {
      return (imports as List)
          .map((e) => ImportDependency.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Служебный метод для парсинга экспортов из атрибутов
  static List<ExportDependency> _parseExports(dynamic exports) {
    if (exports == null) return [];
    try {
      return (exports as List)
          .map((e) => ExportDependency.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Служебный метод для парсинга внутренних зависимостей из атрибутов
  static List<InternalDependency> _parseInternalDependencies(
      dynamic dependencies) {
    if (dependencies == null) return [];
    try {
      return (dependencies as List)
          .map((e) => InternalDependency.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

/// {@template import_dependency}
/// Информация о зависимости импорта
/// {@endtemplate}
@freezed
class ImportDependency with _$ImportDependency {
  const ImportDependency._();

  /// {@macro import_dependency}
  const factory ImportDependency({
    /// Путь к исходному файлу
    @JsonKey(name: 'source_file') required String sourceFile,

    /// Путь к целевому файлу
    @JsonKey(name: 'target_file') required String targetFile,

    /// Флаг отложенного импорта
    @JsonKey(name: 'is_deferred') @Default(false) bool isDeferred,
  }) = _ImportDependency;

  /// Создает объект из JSON
  factory ImportDependency.fromJson(Map<String, dynamic> json) =>
      _$ImportDependencyFromJson(json);
}

/// {@template export_dependency}
/// Информация о зависимости экспорта
/// {@endtemplate}
@freezed
class ExportDependency with _$ExportDependency {
  const ExportDependency._();

  /// {@macro export_dependency}
  const factory ExportDependency({
    /// Путь к исходному файлу
    @JsonKey(name: 'source_file') required String sourceFile,

    /// Путь к целевому файлу
    @JsonKey(name: 'target_file') required String targetFile,
  }) = _ExportDependency;

  /// Создает объект из JSON
  factory ExportDependency.fromJson(Map<String, dynamic> json) =>
      _$ExportDependencyFromJson(json);
}
