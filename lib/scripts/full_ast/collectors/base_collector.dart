import 'package:analyzer/dart/ast/ast.dart' as analyzer;
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/scripts/full_ast/models/annotation_info.dart';
import 'package:part_catalog/scripts/full_ast/models/source_location.dart';

import '../models/declaration_info.dart';
import '../utils/logger.dart';

/// Базовый класс для всех коллекторов информации об AST.
///
/// Предоставляет общую функциональность и свойства для сбора
/// информации о структуре кода из AST. Все специализированные коллекторы
/// должны наследоваться от этого класса.
abstract class BaseCollector extends GeneralizingAstVisitor<void> {
  /// Логгер для класса
  final Logger _logger;

  /// Информация о строках в исходном файле
  LineInfo? lineInfo;

  /// Название коллектора для логирования
  final String collectorName;

  /// Список собранных деклараций
  // Используем setter и getter для управления коллекцией в иммутабельном стиле
  List<DeclarationInfo> _declarations = [];

  /// Создаёт экземпляр базового коллектора с указанным именем.
  BaseCollector({required this.collectorName})
      : _logger = setupLogger('AST.$collectorName');

  /// Возвращает список собранных деклараций
  List<DeclarationInfo> get declarations => List.unmodifiable(_declarations);

  /// Добавляет декларацию в список собранных деклараций
  void addDeclaration(DeclarationInfo declaration) {
    final updatedDeclarations = List<DeclarationInfo>.from(_declarations)
      ..add(declaration);
    _declarations = updatedDeclarations;
    _logger
        .d('Добавлена декларация: ${declaration.name} (${declaration.type})');
  }

  /// Добавляет список деклараций в общий список
  void addDeclarations(List<DeclarationInfo> newDeclarations) {
    if (newDeclarations.isEmpty) return;

    final updatedDeclarations = List<DeclarationInfo>.from(_declarations)
      ..addAll(newDeclarations);
    _declarations = updatedDeclarations;
    _logger.d('Добавлено ${newDeclarations.length} деклараций');
  }

  /// Заменяет список деклараций
  void setDeclarations(List<DeclarationInfo> declarations) {
    _declarations = List<DeclarationInfo>.from(declarations);
  }

  /// Извлекает документацию из узла AST
  String? extractDocumentation(analyzer.AnnotatedNode? node) {
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
  SourceLocation createSourceLocation(analyzer.AstNode node) {
    if (lineInfo == null) {
      _logger.w('LineInfo не установлена в коллекторе $collectorName. '
          'Местоположение будет неполным.');
      return SourceLocation(
        offset: node.offset,
        length: node.length,
        line: 0,
        column: 0,
      );
    }

    final location = lineInfo!.getLocation(node.offset);
    return SourceLocation(
      offset: node.offset,
      length: node.length,
      line: location.lineNumber,
      column: location.columnNumber,
    );
  }

  /// Извлекает информацию об аннотациях узла
  List<AnnotationInfo> collectAnnotations(
      List<analyzer.Annotation> annotations) {
    return annotations
        .map((annotation) => AnnotationInfo(
              name: annotation.name.toString(),
              arguments: annotation.arguments?.toString(),
            ))
        .toList();
  }

  /// Вспомогательный метод для форматирования типа
  String formatTypeAsString(analyzer.TypeAnnotation? type) {
    if (type == null) {
      return 'dynamic';
    }
    return type.toString();
  }

  /// Метод для инициализации коллектора перед началом обхода AST
  void initialize() {
    if (lineInfo != null) {
      _logger.d('LineInfo установлен для коллектора $collectorName');
    } else {
      _logger.w(
          'LineInfo не предоставлен при инициализации коллектора $collectorName');
    }
    _logger.d('Инициализация коллектора $collectorName');
    _declarations = [];
  }

  /// Метод для завершения работы коллектора после обхода AST
  void finalize() {
    _logger.d(
        'Завершение работы коллектора $collectorName. Собрано ${_declarations.length} деклараций');
  }

  /// Вычисляет уровень сложности кода для метода или функции
  /// на основе вложенности управляющих конструкций.
  int calculateComplexity(analyzer.FunctionBody body) {
    if (body is analyzer.EmptyFunctionBody) {
      return 1; // Минимальная сложность для пустого тела функции
    }

    final ComplexityCalculator calculator = ComplexityCalculator();
    body.accept(calculator);
    return calculator.complexity;
  }

  /// Извлекает имя из узла с опциональной проверкой приватности
  String extractName(analyzer.SimpleIdentifier identifier) {
    final name = identifier.name;
    return name;
  }

  /// Определяет, является ли элемент публичным (не начинается с подчеркивания)
  bool isPublic(String name) {
    return !name.startsWith('_');
  }

  /// Извлекает модификаторы из узла декларации метода
  List<String> extractModifiers(analyzer.MethodDeclaration node) {
    final modifiers = <String>[];

    if (node.isAbstract) modifiers.add('abstract');
    if (node.isStatic) modifiers.add('static');

    // Проверяем свойства тела функции для определения async/sync модификаторов
    if (node.body is analyzer.BlockFunctionBody) {
      final body = node.body as analyzer.BlockFunctionBody;
      if (body.isAsynchronous) {
        if (body.isGenerator) {
          modifiers.add('async*');
        } else {
          modifiers.add('async');
        }
      } else if (body.isGenerator) {
        modifiers.add('sync*');
      }
    }

    // Проверяем наличие external ключевого слова
    if (node.externalKeyword != null) modifiers.add('external');

    if (node.isGetter) modifiers.add('getter');
    if (node.isSetter) modifiers.add('setter');
    if (node.isOperator) modifiers.add('operator');

    return modifiers;
  }
}

/// Вспомогательный класс для вычисления цикломатической сложности кода
class ComplexityCalculator extends RecursiveAstVisitor<void> {
  /// Текущая сложность кода
  int complexity = 1; // Начальная сложность

  @override
  void visitIfStatement(analyzer.IfStatement node) {
    complexity += 1;
    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(analyzer.ForStatement node) {
    complexity += 1;
    // Проверяем, является ли это циклом for-each
    if (node.forLoopParts is analyzer.ForEachParts) {
      // Это цикл for-each (for-in)
      complexity += 1; // Дополнительная сложность для for-each, если необходимо
    }
    super.visitForStatement(node);
  }

  @override
  void visitForElement(analyzer.ForElement node) {
    complexity += 1;
    super.visitForElement(node);
  }

  @override
  void visitWhileStatement(analyzer.WhileStatement node) {
    complexity += 1;
    super.visitWhileStatement(node);
  }

  @override
  void visitDoStatement(analyzer.DoStatement node) {
    complexity += 1;
    super.visitDoStatement(node);
  }

  @override
  void visitSwitchCase(analyzer.SwitchCase node) {
    complexity += 1;
    super.visitSwitchCase(node);
  }

  @override
  void visitBinaryExpression(analyzer.BinaryExpression node) {
    // Логические выражения увеличивают сложность
    if (node.operator.lexeme == '&&' || node.operator.lexeme == '||') {
      complexity += 1;
    }
    super.visitBinaryExpression(node);
  }

  @override
  void visitConditionalExpression(analyzer.ConditionalExpression node) {
    complexity += 1; // Тернарный оператор
    super.visitConditionalExpression(node);
  }

  @override
  void visitCatchClause(analyzer.CatchClause node) {
    complexity += 1;
    super.visitCatchClause(node);
  }

  @override
  void visitSwitchPatternCase(analyzer.SwitchPatternCase node) {
    complexity += 1; // Увеличиваем сложность для каждого pattern case
    super.visitSwitchPatternCase(node);
  }

  @override
  void visitPatternAssignment(analyzer.PatternAssignment node) {
    complexity += 1; // Паттерны в присваиваниях также увеличивают сложность
    super.visitPatternAssignment(node);
  }
}
