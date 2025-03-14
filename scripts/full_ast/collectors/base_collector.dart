import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:logger/logger.dart';

import '../models/ast_node.dart';
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
  String? extractDocumentation(AnnotatedNode? node) {
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
  SourceLocation createSourceLocation(AstNode node) {
    return SourceLocation(
      offset: node.offset,
      length: node.length,
      startLine: node.beginToken.location.lineNumber,
      endLine: node.endToken.location.lineNumber,
    );
  }

  /// Извлекает информацию об аннотациях узла
  List<AnnotationInfo> collectAnnotations(List<Annotation> annotations) {
    return annotations
        .map((annotation) => AnnotationInfo(
              name: annotation.name.toString(),
              arguments: annotation.arguments?.toString(),
            ))
        .toList();
  }

  /// Вспомогательный метод для форматирования типа
  String formatTypeAsString(TypeAnnotation? type) {
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
  int calculateComplexity(FunctionBody body) {
    if (body is EmptyFunctionBody) {
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
  void visitIfStatement(IfStatement node) {
    complexity += 1;
    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    complexity += 1;
    super.visitForStatement(node);
  }

  @override
  void visitForEachStatement(ForEachStatement node) {
    complexity += 1;
    super.visitForEachStatement(node);
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
