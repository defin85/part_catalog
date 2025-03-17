import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/scripts/full_ast/models/annotation_info.dart';
import 'package:part_catalog/scripts/full_ast/models/combinator_info.dart';
import 'package:part_catalog/scripts/full_ast/models/component_dependency_info.dart';
import 'package:part_catalog/scripts/full_ast/models/metrics_info.dart';
import 'package:part_catalog/scripts/full_ast/models/part_info.dart';
import 'package:part_catalog/scripts/full_ast/models/source_location.dart';
import 'dart:io';

import '../models/ast_node.dart' as ast;
import 'logger.dart';

/// Утилиты для работы с AST (Abstract Syntax Tree)
class AstUtils {
  /// Логгер для данного класса
  static final Logger _logger = setupLogger('AST.Utils');

  /// Парсит файл Dart и возвращает CompilationUnit (верхний узел AST)
  ///
  /// Принимает файл и опционально уровень возможностей языка Dart
  static Future<CompilationUnit?> parseFile(
    File file, {
    FeatureSet? featureSet,
  }) async {
    try {
      final content = await file.readAsString();
      return parseString(
        content: content,
        path: file.path,
        featureSet: featureSet ?? FeatureSet.latestLanguageVersion(),
      ).unit;
    } catch (e, stackTrace) {
      _logger.e('Ошибка парсинга файла ${file.path}',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Извлекает имя идентификатора из различных типов узлов AST
  static String? extractIdentifierName(AstNode node) {
    if (node is SimpleIdentifier) {
      return node.name;
    } else if (node is PrefixedIdentifier) {
      return '${node.prefix.name}.${node.identifier.name}';
    } else if (node is NamedType) {
      if (node.importPrefix != null) {
        return '${node.importPrefix!.name}.${node.name2.lexeme}';
      }
      return node.name2.lexeme;
    } else if (node is MethodInvocation) {
      return node.methodName.name;
    } else if (node is ConstructorName) {
      if (node.name != null) {
        return '${node.type.name2.lexeme}.${node.name!.name}';
      }
      return node.type.name2.lexeme;
    } else if (node is ClassDeclaration) {
      return node.name.lexeme;
    } else if (node is FunctionDeclaration) {
      return node.name.lexeme;
    }
    return null;
  }

  /// Извлекает все импорты из компиляционного модуля
  static List<ast.ImportInfo> extractImports(CompilationUnit unit) {
    final imports = <ast.ImportInfo>[];

    for (var directive in unit.directives) {
      if (directive is ImportDirective) {
        final combinators = <CombinatorInfo>[];

        for (var combinator in directive.combinators) {
          if (combinator is ShowCombinator) {
            combinators.add(CombinatorInfo(
              type: 'show',
              names: combinator.shownNames.map((e) => e.name).toList(),
            ));
          } else if (combinator is HideCombinator) {
            combinators.add(CombinatorInfo(
              type: 'hide',
              names: combinator.hiddenNames.map((e) => e.name).toList(),
            ));
          }
        }

        imports.add(ast.ImportInfo(
          uri: directive.uri.stringValue ?? '',
          prefix: directive.prefix?.name,
          isDeferred: directive.deferredKeyword != null,
          combinators: combinators,
          location: SourceLocation.fromNode(directive),
        ));
      }
    }

    return imports;
  }

  /// Извлекает все экспорты из компиляционного модуля
  static List<ast.ExportInfo> extractExports(CompilationUnit unit) {
    final exports = <ast.ExportInfo>[];

    for (var directive in unit.directives) {
      if (directive is ExportDirective) {
        final combinators = <CombinatorInfo>[];

        for (var combinator in directive.combinators) {
          if (combinator is ShowCombinator) {
            combinators.add(CombinatorInfo(
              type: 'show',
              names: combinator.shownNames.map((e) => e.name).toList(),
            ));
          } else if (combinator is HideCombinator) {
            combinators.add(CombinatorInfo(
              type: 'hide',
              names: combinator.hiddenNames.map((e) => e.name).toList(),
            ));
          }
        }

        exports.add(ast.ExportInfo(
          uri: directive.uri.stringValue ?? '',
          combinators: combinators,
          location: SourceLocation.fromNode(directive),
        ));
      }
    }

    return exports;
  }

  /// Извлекает все part/part-of директивы из компиляционного модуля
  static List<PartInfo> extractParts(
      CompilationUnit unit, String sourceFilePath) {
    final parts = <PartInfo>[];

    for (var directive in unit.directives) {
      if (directive is PartDirective) {
        final uri = directive.uri.stringValue ?? '';
        parts.add(PartInfo(
          sourceFile: sourceFilePath,
          targetFile: uri, // Используем URI как путь к целевому файлу
          uri: uri,
          offset: directive.offset,
          length: directive.length,
        ));
      } else if (directive is PartOfDirective) {
        final uri = directive.uri?.stringValue ?? '';

        parts.add(PartInfo(
          sourceFile: sourceFilePath,
          targetFile: uri, // Используем URI как целевой файл
          uri: uri,
          offset: directive.offset,
          length: directive.length,
        ));
      }
    }

    return parts;
  }

  /// Извлекает документацию из узла AST
  static String? extractDocumentation(AnnotatedNode? node) {
    if (node == null || node.documentationComment == null) {
      return null;
    }

    // Удаление маркеров комментариев и форматирование
    return node.documentationComment!
        .toString()
        .replaceAll(RegExp(r'^/// ?', multiLine: true), '')
        .replaceAll(RegExp(r'^/\*\* ?| ?\*/$'), '')
        .replaceAll(RegExp(r'^\* ?', multiLine: true), '')
        .trim();
  }

  /// Создаёт информацию о местоположении узла в исходном коде
  static SourceLocation createSourceLocation(AstNode node) {
    return SourceLocation.fromNode(node);
  }

  /// Извлекает информацию об аннотациях узла
  static List<AnnotationInfo> collectAnnotations(List<Annotation> annotations) {
    return annotations
        .map((annotation) => AnnotationInfo(
              name: annotation.name.toString(),
              arguments: annotation.arguments?.toString(),
            ))
        .toList();
  }

  /// Проверяет, является ли узел публичным (не начинается с подчеркивания)
  static bool isPublic(String name) {
    return !name.startsWith('_');
  }

  /// Извлекает тип возвращаемого значения функции (метода, геттера)
  static String extractReturnType(AstNode node) {
    if (node is MethodDeclaration) {
      return node.returnType?.toString() ?? 'dynamic';
    } else if (node is FunctionDeclaration) {
      return node.returnType?.toString() ?? 'dynamic';
    } else if (node is ConstructorDeclaration) {
      // Конструкторы возвращают их класс
      final className = node.parent is ClassDeclaration
          ? (node.parent as ClassDeclaration).name.lexeme
          : 'dynamic';
      return className;
    }
    return 'dynamic';
  }

  /// Определяет, является ли узел переопределением метода
  static bool isOverride(AstNode node) {
    if (node is MethodDeclaration) {
      return node.metadata.any((meta) => meta.name.name == 'override');
    }
    return false;
  }

  /// Извлекает внутренние зависимости между компонентами кода
  static List<InternalDependency> extractInternalDependencies(
      CompilationUnit unit) {
    final dependencies = <InternalDependency>[];
    final dependencyVisitor = _DependencyVisitor(dependencies);
    unit.accept(dependencyVisitor);
    return dependencies;
  }

  /// Подсчитывает количество строк различных категорий в коде
  static CodeMetrics calculateCodeMetrics(String source) {
    final lines = source.split('\n');
    var metrics = CodeMetrics(
      totalLines: lines.length,
      characterCount: source.length,
    );

    var inMultilineComment = false;
    var blankLines = 0;
    var commentLines = 0;
    var codeLines = 0;
    var todoCount = 0;
    var fixmeCount = 0;

    for (var line in lines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) {
        blankLines++;
        continue;
      }

      // Проверка TO DO и FIX ME комментариев
      if (trimmedLine.contains('TODO')) todoCount++;
      if (trimmedLine.contains('FIXME')) fixmeCount++;

      // Многострочный комментарий
      if (inMultilineComment) {
        commentLines++;
        if (trimmedLine.contains('*/')) {
          inMultilineComment = false;
        }
        continue;
      }

      // Начало многострочного комментария
      if (trimmedLine.startsWith('/*') || trimmedLine.contains('/*')) {
        commentLines++;
        if (!trimmedLine.contains('*/')) {
          inMultilineComment = true;
        }
        continue;
      }

      // Однострочный комментарий
      if (trimmedLine.startsWith('//')) {
        commentLines++;
        continue;
      }

      // Строка кода с комментарием
      if (trimmedLine.contains('//')) {
        commentLines++;
        codeLines++;
        continue;
      }

      // Обычная строка кода
      codeLines++;
    }

    // Создаем новый объект с подсчитанными значениями
    metrics = metrics.copyWith(
      blankLines: blankLines,
      commentLines: commentLines,
      codeLines: codeLines,
      todoCount: todoCount,
      fixmeCount: fixmeCount,
    );

    // Вычисление дополнительных метрик
    double commentDensity = 0.0;
    double averageLineLength = 0.0;

    if (metrics.codeLines > 0) {
      commentDensity = metrics.commentLines / metrics.codeLines;
    }

    if (metrics.totalLines > 0) {
      averageLineLength = metrics.characterCount / metrics.totalLines;
    }

    // Возвращаем финальный объект со всеми метриками
    return metrics.copyWith(
      commentDensity: commentDensity,
      averageLineLength: averageLineLength,
    );
  }

  /// Вычисляет цикломатическую сложность кода
  static int calculateComplexity(AstNode node) {
    final complexityVisitor = _ComplexityVisitor();
    node.accept(complexityVisitor);
    return complexityVisitor.complexity;
  }

  /// Вычисляет максимальный уровень вложенности кода
  static int calculateMaxNestingLevel(AstNode node) {
    final nestingVisitor = _NestingLevelVisitor();
    node.accept(nestingVisitor);
    return nestingVisitor.maxNestingLevel;
  }
}

/// Посетитель для извлечения зависимостей между компонентами кода
class _DependencyVisitor extends RecursiveAstVisitor<void> {
  final List<InternalDependency> dependencies;
  String? currentClass;
  String? currentMethod;

  _DependencyVisitor(this.dependencies);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final className = node.name.lexeme;
    currentClass = className;

    // Регистрация наследования
    if (node.extendsClause != null) {
      dependencies.add(InternalDependency(
        sourceType: 'class',
        sourceName: className,
        targetType: 'class',
        targetName: node.extendsClause!.superclass.name2.lexeme,
        dependencyType: 'extends',
      ));
    }

    // Регистрация реализации интерфейсов
    if (node.implementsClause != null) {
      for (var interface in node.implementsClause!.interfaces) {
        dependencies.add(InternalDependency(
          sourceType: 'class',
          sourceName: className,
          targetType: 'interface',
          targetName: interface.name2.lexeme,
          dependencyType: 'implements',
        ));
      }
    }

    // Регистрация использования миксинов
    if (node.withClause != null) {
      for (var mixin in node.withClause!.mixinTypes) {
        dependencies.add(InternalDependency(
          sourceType: 'class',
          sourceName: className,
          targetType: 'mixin',
          targetName: mixin.name2.lexeme,
          dependencyType: 'with',
        ));
      }
    }

    super.visitClassDeclaration(node);
    currentClass = null;
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (currentClass != null) {
      currentMethod = node.name.lexeme;
    }

    super.visitMethodDeclaration(node);
    currentMethod = null;
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (currentClass != null && currentMethod != null) {
      final targetMethod = node.methodName.name;
      final targetClass =
          node.target is Identifier ? (node.target as Identifier).name : null;

      if (targetClass != null) {
        dependencies.add(InternalDependency(
          sourceType: 'method',
          sourceName: '$currentClass.$currentMethod',
          targetType: 'method',
          targetName: '$targetClass.$targetMethod',
          dependencyType: 'calls',
        ));
      }
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (currentClass != null) {
      final constructedType = node.constructorName.type.name2.lexeme;

      dependencies.add(InternalDependency(
        sourceType: currentMethod != null ? 'method' : 'class',
        sourceName: currentMethod != null
            ? '$currentClass.$currentMethod'
            : currentClass!,
        targetType: 'class',
        targetName: constructedType,
        dependencyType: 'instantiates',
      ));
    }

    super.visitInstanceCreationExpression(node);
  }
}

/// Посетитель для вычисления цикломатической сложности кода
class _ComplexityVisitor extends GeneralizingAstVisitor<void> {
  int complexity = 1;

  @override
  void visitIfStatement(IfStatement node) {
    complexity += 1;
    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    // ForStatement обрабатывает все типы циклов for,
    // включая обычные for и for-in (for-each)
    complexity += 1;
    super.visitForStatement(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    complexity += 1;
    super.visitWhileStatement(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    complexity += 1;
    super.visitDoStatement(node);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    complexity += 1;
    super.visitSwitchCase(node);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    // Дополнительно учитываем default case
    complexity += 1;
    super.visitSwitchDefault(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    // Логические выражения увеличивают сложность
    if (node.operator.lexeme == '&&' || node.operator.lexeme == '||') {
      complexity += 1;
    }
    super.visitBinaryExpression(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    complexity += 1; // Тернарный оператор
    super.visitConditionalExpression(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    complexity += 1;
    super.visitCatchClause(node);
  }
}

/// Посетитель для вычисления максимального уровня вложенности кода
class _NestingLevelVisitor extends GeneralizingAstVisitor<void> {
  int _currentNestingLevel = 0;
  int maxNestingLevel = 0;

  void _increaseNestingLevel() {
    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;
  }

  void _decreaseNestingLevel() {
    _currentNestingLevel--;
  }

  @override
  void visitBlock(Block node) {
    _increaseNestingLevel();
    super.visitBlock(node);
    _decreaseNestingLevel();
  }

  @override
  void visitIfStatement(IfStatement node) {
    // Сначала посещаем условие
    node.expression.accept(this);

    // Затем тело if
    if (node.thenStatement is! Block) {
      _increaseNestingLevel();
      node.thenStatement.accept(this);
      _decreaseNestingLevel();
    } else {
      node.thenStatement.accept(this);
    }

    // И тело else, если есть
    if (node.elseStatement != null && node.elseStatement is! Block) {
      _increaseNestingLevel();
      node.elseStatement!.accept(this);
      _decreaseNestingLevel();
    } else if (node.elseStatement != null) {
      node.elseStatement!.accept(this);
    }
  }

  @override
  void visitForStatement(ForStatement node) {
    // ForStatement обрабатывает все типы for-циклов,
    // включая обычные for и for-in (for-each)
    _increaseNestingLevel();
    super.visitForStatement(node);
    _decreaseNestingLevel();
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _increaseNestingLevel();
    super.visitWhileStatement(node);
    _decreaseNestingLevel();
  }

  @override
  void visitDoStatement(DoStatement node) {
    _increaseNestingLevel();
    super.visitDoStatement(node);
    _decreaseNestingLevel();
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _increaseNestingLevel();
    super.visitSwitchStatement(node);
    _decreaseNestingLevel();
  }

  @override
  void visitTryStatement(TryStatement node) {
    _increaseNestingLevel();
    super.visitTryStatement(node);
    _decreaseNestingLevel();
  }
}
