import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/scripts/full_ast/models/component_dependency_info.dart';
import 'package:path/path.dart' as path;

import '../models/ast_node.dart';
import '../models/file_dependency_info.dart';
import '../utils/logger.dart';

/// Анализатор зависимостей между файлами и компонентами кода
class DependencyAnalyzer {
  /// Логгер для класса
  final Logger _logger = setupLogger('DependencyAnalyzer');

  /// Анализирует зависимости для файла и создает обновленный FileNode
  Future<FileNode> analyzeFile(
      FileNode fileNode, ParseStringResult parseResult) async {
    try {
      _logger.d('Анализ зависимостей в файле: ${fileNode.path}');

      // Создаем объект для хранения зависимостей файла
      final FileDependencyInfo dependencies;

      if (fileNode.dependencies is FileDependencyInfo) {
        dependencies = fileNode.dependencies as FileDependencyInfo;
      } else {
        dependencies = const FileDependencyInfo(
          imports: [],
          exports: [],
          internalDependencies: [],
          externalPackages: {},
        );
      }

      // Анализируем зависимости и создаем новый объект зависимостей
      final updatedDependencies =
          await _analyzeDependencies(fileNode, parseResult, dependencies);

      // Анализ внутренних зависимостей между компонентами
      final withInternalDeps = await _analyzeInternalDependencies(
          fileNode, parseResult, updatedDependencies);

      // Анализ использования внешних пакетов
      final finalDependencies =
          await _analyzeExternalPackages(fileNode, withInternalDeps);

      _logger.d('Найдено ${finalDependencies.imports.length} импортов и '
          '${finalDependencies.internalDependencies.length} внутренних зависимостей в ${fileNode.name}');

      // Используем метод toDependencyInfo, который теперь возвращает ast.DependencyInfo
      final FileDependencySummary dependencyInfo =
          finalDependencies.toDependencyInfo();

      // Создаем новый FileNode с обновленными зависимостями
      return fileNode.copyWith(dependencies: dependencyInfo);
    } catch (e, stackTrace) {
      _logger.e('Ошибка при анализе зависимостей для ${fileNode.path}',
          error: e, stackTrace: stackTrace);
      return fileNode; // Возвращаем исходный файл в случае ошибки
    }
  }

  /// Анализирует зависимости на основе импортов и экспортов
  Future<FileDependencyInfo> _analyzeDependencies(FileNode fileNode,
      ParseStringResult parseResult, FileDependencyInfo dependencies) async {
    // Сначала копируем существующие зависимости
    final List<ImportDependency> imports = [...dependencies.imports];
    final List<ExportDependency> exports = [...dependencies.exports];
    final Map<String, int> externalPackages = {
      ...dependencies.externalPackages
    };

    // Добавляем информацию из импортов
    for (final import in fileNode.imports) {
      final uri = import.uri;

      if (uri.startsWith('package:')) {
        // Внешний пакет
        final packageName = _extractPackageName(uri);
        externalPackages[packageName] =
            (externalPackages[packageName] ?? 0) + 1;
      } else if (uri.startsWith('dart:')) {
        // Стандартная библиотека Dart
        externalPackages[uri] = (externalPackages[uri] ?? 0) + 1;
      } else {
        // Внутренний импорт
        imports.add(ImportDependency(
          sourceFile: fileNode.path,
          targetFile: _resolveRelativePath(fileNode.path, uri),
          isDeferred: import.isDeferred,
        ));
      }
    }

    // Добавляем информацию из экспортов
    for (final export in fileNode.exports) {
      final uri = export.uri;

      if (!uri.startsWith('package:') && !uri.startsWith('dart:')) {
        // Внутренний экспорт
        exports.add(ExportDependency(
          sourceFile: fileNode.path,
          targetFile: _resolveRelativePath(fileNode.path, uri),
        ));
      }
    }

    // Возвращаем новый объект FileDependencyInfo с обновленными данными
    return dependencies.copyWith(
      imports: imports,
      exports: exports,
      externalPackages: externalPackages,
    );
  }

  /// Анализирует внутренние зависимости между компонентами в файле
  Future<FileDependencyInfo> _analyzeInternalDependencies(FileNode fileNode,
      ParseStringResult parseResult, FileDependencyInfo dependencies) async {
    final visitor = _DependencyVisitor(fileNode);
    parseResult.unit.accept(visitor);

    // Создаем список с существующими и новыми зависимостями
    final List<InternalDependency> internalDependencies = [
      ...dependencies.internalDependencies,
      ...visitor.internalDependencies
    ];

    // Возвращаем новый объект с обновленными внутренними зависимостями
    return dependencies.copyWith(
      internalDependencies: internalDependencies,
    );
  }

  /// Выделяет имя пакета из URI импорта
  String _extractPackageName(String uri) {
    if (uri.startsWith('package:')) {
      final parts = uri.substring(8).split('/');
      return parts.isNotEmpty ? parts.first : '';
    }
    return uri;
  }

  /// Анализирует использование внешних пакетов
  Future<FileDependencyInfo> _analyzeExternalPackages(
      FileNode fileNode, FileDependencyInfo dependencies) async {
    // Дополнительная логика анализа внешних пакетов, если необходима
    // В текущей реализации большая часть этой логики уже есть в _analyzeDependencies

    // Здесь можно добавить дополнительную обработку пакетов
    // Например, группирование по категориям, вычисление метрик и т.д.

    // Пока просто возвращаем существующие зависимости
    return dependencies;
  }

  /// Разрешает относительный путь к файлу
  String _resolveRelativePath(String sourcePath, String relativePath) {
    final sourceDir = path.dirname(sourcePath);

    if (relativePath.endsWith('.dart')) {
      return path.normalize(path.join(sourceDir, relativePath));
    } else {
      return path.normalize(path.join(sourceDir, '$relativePath.dart'));
    }
  }
}

/// Вспомогательный класс для сбора внутренних зависимостей
class _DependencyVisitor extends RecursiveAstVisitor<void> {
  final FileNode fileNode;
  final List<InternalDependency> internalDependencies = [];

  // Текущий контекст анализа (класс, метод и т.д.)
  String? currentClassName;
  String? currentMethodName;

  _DependencyVisitor(this.fileNode);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final previousClassName = currentClassName;
    currentClassName = node.name.lexeme;

    // Анализ наследования
    if (node.extendsClause != null) {
      internalDependencies.add(InternalDependency(
        sourceType: 'class',
        sourceName: currentClassName!,
        targetType: 'class',
        targetName: node.extendsClause!.superclass.name2.lexeme,
        dependencyType: 'extends',
      ));
    }

    // Анализ интерфейсов
    if (node.implementsClause != null) {
      for (final interface in node.implementsClause!.interfaces) {
        internalDependencies.add(InternalDependency(
          sourceType: 'class',
          sourceName: currentClassName!,
          targetType: 'interface',
          targetName: interface.name2.lexeme,
          dependencyType: 'implements',
        ));
      }
    }

    // Анализ миксинов
    if (node.withClause != null) {
      for (final mixin in node.withClause!.mixinTypes) {
        internalDependencies.add(InternalDependency(
          sourceType: 'class',
          sourceName: currentClassName!,
          targetType: 'mixin',
          targetName: mixin.name2.lexeme,
          dependencyType: 'with',
        ));
      }
    }

    super.visitClassDeclaration(node);
    currentClassName = previousClassName;
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final previousMethodName = currentMethodName;

    if (currentClassName != null) {
      currentMethodName = '${currentClassName!}.${node.name.lexeme}';
    } else {
      currentMethodName = node.name.lexeme;
    }

    // Анализ возвращаемого типа
    if (node.returnType != null) {
      final returnType = node.returnType.toString();
      if (!_isBasicType(returnType)) {
        internalDependencies.add(InternalDependency(
          sourceType: 'method',
          sourceName: currentMethodName!,
          targetType: 'type',
          targetName: returnType,
          dependencyType: 'returns',
        ));
      }
    }

    super.visitMethodDeclaration(node);
    currentMethodName = previousMethodName;
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    // Анализ типов полей
    if (node.fields.type != null) {
      final fieldType = node.fields.type.toString();
      if (!_isBasicType(fieldType)) {
        for (final variable in node.fields.variables) {
          final fieldName = currentClassName != null
              ? '${currentClassName!}.${variable.name.lexeme}'
              : variable.name.lexeme;

          internalDependencies.add(InternalDependency(
            sourceType: 'field',
            sourceName: fieldName,
            targetType: 'type',
            targetName: fieldType,
            dependencyType: 'has_type',
          ));
        }
      }
    }

    super.visitFieldDeclaration(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Анализ вызовов методов
    if (currentMethodName != null) {
      final targetName = node.methodName.name;

      // Исключаем вызовы стандартных методов и операторов
      if (!_isBasicMethod(targetName)) {
        String targetClassName = '';

        // Определяем класс целевого метода, если возможно
        if (node.target is SimpleIdentifier) {
          targetClassName = (node.target as SimpleIdentifier).name;
        }

        internalDependencies.add(InternalDependency(
          sourceType: 'method',
          sourceName: currentMethodName!,
          targetType: 'method',
          targetName: targetClassName.isEmpty
              ? targetName
              : '$targetClassName.$targetName',
          dependencyType: 'calls',
        ));
      }
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Анализ создания экземпляров классов
    if (currentMethodName != null) {
      // Используем name2 вместо name
      final targetName = node.constructorName.type.name2.lexeme;

      internalDependencies.add(InternalDependency(
        sourceType: 'method',
        sourceName: currentMethodName!,
        targetType: 'class',
        targetName: targetName,
        dependencyType: 'instantiates',
      ));
    }

    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    // Анализ доступа к свойствам объектов
    if (currentMethodName != null && node.target is SimpleIdentifier) {
      final targetClassName = (node.target as SimpleIdentifier).name;
      final propertyName = node.propertyName.name;

      // Проверяем, не является ли это вызовом метода (уже обработано в visitMethodInvocation)
      if (!_isBasicProperty(propertyName)) {
        internalDependencies.add(InternalDependency(
          sourceType: 'method',
          sourceName: currentMethodName!,
          targetType: 'field',
          targetName: '$targetClassName.$propertyName',
          dependencyType: 'accesses',
          weight: 1,
        ));
      }
    }

    super.visitPropertyAccess(node);
  }

  /// Проверяет, является ли тип базовым (встроенным) типом Dart
  bool _isBasicType(String typeName) {
    final basicTypes = [
      'int',
      'double',
      'num',
      'bool',
      'String',
      'dynamic',
      'void',
      'Object',
      'Function',
      'List',
      'Map',
      'Set',
      'Future',
      'Stream',
      'Iterable',
    ];

    // Проверяем базовые типы
    if (basicTypes.contains(typeName)) {
      return true;
    }

    // Проверяем параметризованные базовые типы (List<String>, Map<String, int> и т.д.)
    for (final type in basicTypes) {
      if (typeName.startsWith('$type<')) {
        return true;
      }
    }

    return false;
  }

  /// Проверяет, является ли метод базовым (встроенным) методом Dart
  bool _isBasicMethod(String methodName) {
    final basicMethods = [
      'toString',
      'hashCode',
      '==',
      'compareTo',
      'noSuchMethod',
      'add',
      'remove',
      'contains',
      'forEach',
      'map',
      'where',
      'firstWhere',
      'length',
      'isEmpty',
      'isNotEmpty',
    ];

    return basicMethods.contains(methodName);
  }

  /// Проверяет, является ли свойство базовым (встроенным) свойством Dart
  bool _isBasicProperty(String propertyName) {
    final basicProperties = [
      'length',
      'isEmpty',
      'isNotEmpty',
      'first',
      'last',
      'hashCode',
      'runtimeType',
    ];

    return basicProperties.contains(propertyName);
  }
}
