import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as path;

import '../models/ast_node.dart'
    as ast; // Используем alias для разрешения конфликта имен
import '../models/dependency_info.dart';
import '../utils/logger.dart';

/// Анализатор зависимостей между файлами и компонентами кода
class DependencyAnalyzer {
  /// Логгер для класса
  final _logger = setupLogger('DependencyAnalyzer');

  /// Анализирует зависимости для файла и добавляет их в FileNode
  Future<void> analyzeFile(
      ast.FileNode fileNode, ParseStringResult parseResult) async {
    try {
      _logger.d('Анализ зависимостей в файле: ${fileNode.path}');

      // Создаем объект для хранения зависимостей файла
      fileNode.dependencies ??= ast.DependencyInfo(
        imports: [],
        exports: [],
        internalDependencies: [],
        externalPackages: {},
      );

      // Анализ импортов и экспортов
      await _analyzeDependencies(fileNode, parseResult);

      // Анализ внутренних зависимостей между компонентами
      await _analyzeInternalDependencies(fileNode, parseResult);

      // Анализ использования внешних пакетов
      await _analyzeExternalPackages(fileNode);

      _logger.d(
          'Найдено ${fileNode.dependencies?.imports.length ?? 0} импортов и '
          '${fileNode.dependencies?.internalDependencies.length ?? 0} внутренних зависимостей в ${fileNode.name}');
    } catch (e, stackTrace) {
      _logger.e('Ошибка при анализе зависимостей в файле ${fileNode.path}',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Анализирует зависимости на основе импортов и экспортов
  Future<void> _analyzeDependencies(
      ast.FileNode fileNode, ParseStringResult parseResult) async {
    // Проверка, что объект зависимостей уже создан
    fileNode.dependencies ??= ast.DependencyInfo(
      imports: [],
      exports: [],
      internalDependencies: [],
      externalPackages: {},
    );

    // Добавляем информацию из импортов
    for (final import in fileNode.imports) {
      final uri = import.uri;

      if (uri.startsWith('package:')) {
        // Внешний пакет
        final packageName = _extractPackageName(uri);
        fileNode.dependencies?.externalPackages[packageName] =
            (fileNode.dependencies?.externalPackages[packageName] ?? 0) + 1;
      } else if (uri.startsWith('dart:')) {
        // Стандартная библиотека Dart
        fileNode.dependencies?.externalPackages[uri] =
            (fileNode.dependencies?.externalPackages[uri] ?? 0) + 1;
      } else {
        // Внутренний импорт
        fileNode.dependencies?.imports.add(ast.ImportDependency(
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
        fileNode.dependencies?.exports.add(ast.ExportDependency(
          sourceFile: fileNode.path,
          targetFile: _resolveRelativePath(fileNode.path, uri),
        ));
      }
    }
  }

  /// Анализирует внутренние зависимости между компонентами в файле
  Future<void> _analyzeInternalDependencies(
      ast.FileNode fileNode, ParseStringResult parseResult) async {
    final visitor = _DependencyVisitor(fileNode);
    parseResult.unit.accept(visitor);

    // Добавляем найденные внутренние зависимости
    fileNode.dependencies?.internalDependencies.addAll(
        visitor.internalDependencies.map((dep) => ast.InternalDependency(
              sourceType: dep.sourceType,
              sourceName: dep.sourceName,
              targetType: dep.targetType,
              targetName: dep.targetName,
              dependencyType: dep.dependencyType,
            )));
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
  Future<void> _analyzeExternalPackages(ast.FileNode fileNode) async {
    // Этот метод уже частично реализован в _analyzeDependencies
    // Здесь можно добавить дополнительную логику, если требуется
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
  final ast.FileNode fileNode;
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
          targetType: 'class',
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
}
