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
  final List<DeclarationInfo> _declarations = [];

  /// Создаёт экземпляр базового коллектора с указанным именем.
  BaseCollector({required this.collectorName})
      : _logger = setupLogger('AST.$collectorName');

  /// Возвращает список собранных деклараций
  List<DeclarationInfo> get declarations => List.unmodifiable(_declarations);

  /// Добавляет декларацию в список собранных деклараций
  void addDeclaration(DeclarationInfo declaration) {
    _declarations.add(declaration);
    _logger
        .d('Добавлена декларация: ${declaration.name} (${declaration.type})');
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
    return SourceLocation.fromNode(node);
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
    _logger.d('Инициализация коллектора $collectorName');
    _declarations.clear();
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
}
