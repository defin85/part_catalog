import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../models/ast_node.dart';
import '../utils/logger.dart';

/// Анализатор для расчета метрик кода
class MetricsAnalyzer {
  /// Логгер для класса
  final _logger = setupLogger('MetricsAnalyzer');

  /// Анализирует файл и рассчитывает метрики кода
  Future<void> analyzeFile(
      FileNode fileNode, ParseStringResult parseResult) async {
    try {
      _logger.d('Расчет метрик для файла: ${fileNode.path}');

      // Инициализация метрик или использование существующих
      fileNode.metrics ??= CodeMetrics();

      // Расчет базовых метрик файла
      _calculateBasicMetrics(fileNode, parseResult);

      // Расчет сложности кода
      _calculateComplexityMetrics(fileNode, parseResult);

      // Анализ текстовых метрик
      _analyzeTextMetrics(fileNode, parseResult);

      // Расчет метрик для классов
      _calculateClassMetrics(fileNode, parseResult);

      _logger.d('Метрики для файла ${fileNode.path} рассчитаны: '
          'сложность=${fileNode.metrics!.complexity}, '
          'LOC=${fileNode.metrics!.codeLines}');
    } catch (e, stackTrace) {
      _logger.e('Ошибка при расчете метрик для файла ${fileNode.path}',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Рассчитывает базовые метрики файла
  void _calculateBasicMetrics(
      FileNode fileNode, ParseStringResult parseResult) {
    final content = parseResult.content;
    final lines = content.split('\n');

    // Подсчет общего количества строк
    fileNode.metrics.totalLines = lines.length;

    // Подсчет строк кода (без пустых строк и комментариев)
    int codeLines = 0;
    int commentLines = 0;
    int blankLines = 0;

    bool inMultilineComment = false;

    for (final line in lines) {
      final trimmedLine = line.trim();

      if (trimmedLine.isEmpty) {
        blankLines++;
        continue;
      }

      // Проверка на многострочные комментарии
      if (inMultilineComment) {
        commentLines++;
        if (trimmedLine.contains('*/')) {
          inMultilineComment = false;
          // Если после закрытия комментария есть код
          if (trimmedLine
              .substring(trimmedLine.indexOf('*/') + 2)
              .trim()
              .isNotEmpty) {
            codeLines++;
          }
        }
        continue;
      }

      // Начало многострочного комментария
      if (trimmedLine.contains('/*')) {
        commentLines++;
        inMultilineComment = true;
        // Если перед комментарием есть код
        if (trimmedLine
            .substring(0, trimmedLine.indexOf('/*'))
            .trim()
            .isNotEmpty) {
          codeLines++;
        }
        // Если комментарий закрывается на той же строке
        if (trimmedLine.contains('*/')) {
          inMultilineComment = false;
          // Если после закрытия комментария есть код
          if (trimmedLine
              .substring(trimmedLine.indexOf('*/') + 2)
              .trim()
              .isNotEmpty) {
            codeLines++;
          }
        }
        continue;
      }

      // Однострочные комментарии
      if (trimmedLine.startsWith('//')) {
        commentLines++;
        continue;
      }

      // Строки с кодом и комментариями
      if (trimmedLine.contains('//')) {
        // Проверяем, что // не является частью строки
        bool isRealComment = true;
        int index = trimmedLine.indexOf('//');

        // Простая проверка наличия нечетного числа кавычек перед //
        int quotes = trimmedLine.substring(0, index).split('"').length - 1;
        if (quotes % 2 == 1) {
          isRealComment = false;
        }

        if (isRealComment) {
          codeLines++;
          commentLines++;
        } else {
          codeLines++;
        }
        continue;
      }

      // Строки только с кодом
      codeLines++;
    }

    fileNode.metrics.codeLines = codeLines;
    fileNode.metrics.commentLines = commentLines;
    fileNode.metrics.blankLines = blankLines;

    // Расчет плотности комментариев
    if (codeLines > 0) {
      fileNode.metrics.commentDensity = commentLines / codeLines;
    }
  }

  /// Рассчитывает метрики сложности кода
  void _calculateComplexityMetrics(
      FileNode fileNode, ParseStringResult parseResult) {
    final visitor = _ComplexityVisitor();
    parseResult.unit.accept(visitor);

    // Цикломатическая сложность
    fileNode.metrics.complexity = visitor.complexity;

    // Когнитивная сложность
    fileNode.metrics.cognitiveComplexity = visitor.cognitiveComplexity;

    // Глубина вложенности
    fileNode.metrics.maxNestingLevel = visitor.maxNestingLevel;

    // Средняя длина методов
    if (visitor.methodCount > 0) {
      fileNode.metrics.averageMethodLength =
          visitor.totalMethodLines / visitor.methodCount;
    }

    // Максимальная длина метода
    fileNode.metrics.maxMethodLength = visitor.maxMethodLength;
  }

  /// Анализирует текстовые метрики кода
  void _analyzeTextMetrics(FileNode fileNode, ParseStringResult parseResult) {
    final content = parseResult.content;

    // Количество символов
    fileNode.metrics.characterCount = content.length;

    // Средняя длина строки
    final lines = content.split('\n');
    if (lines.isNotEmpty) {
      int totalLength = lines.fold(0, (sum, line) => sum + line.length);
      fileNode.metrics.averageLineLength = totalLength / lines.length;
    }

    // Количество TODOs
    final todoPattern =
        RegExp(r'//\s*TODO:|/\*\s*TODO:|^\s*#\s*TODO:', multiLine: true);
    final todos = todoPattern.allMatches(content);
    fileNode.metrics.todoCount = todos.length;

    // Количество FIXMEs
    final fixmePattern =
        RegExp(r'//\s*FIXME:|/\*\s*FIXME:|^\s*#\s*FIXME:', multiLine: true);
    final fixmes = fixmePattern.allMatches(content);
    fileNode.metrics.fixmeCount = fixmes.length;
  }

  /// Рассчитывает метрики для классов
  void _calculateClassMetrics(
      FileNode fileNode, ParseStringResult parseResult) {
    // Метрики по классам
    fileNode.metrics.classCount = fileNode.classes.length;

    // Подсчет общего количества методов и полей
    int totalMethods = 0;
    int totalFields = 0;

    for (final classInfo in fileNode.classes) {
      totalMethods += classInfo.methods?.length ?? 0;
      totalFields += classInfo.fields?.length ?? 0;

      // Сложность класса (LCOM - Lack of Cohesion of Methods)
      if (classInfo.methods != null && classInfo.fields != null) {
        _calculateLCOM(classInfo, fileNode.metrics.classMetrics);
      }
    }

    fileNode.metrics.methodCount = totalMethods;
    fileNode.metrics.fieldCount = totalFields;

    // Среднее количество методов на класс
    if (fileNode.metrics.classCount > 0) {
      fileNode.metrics.averageMethodsPerClass =
          totalMethods / fileNode.metrics.classCount;
    }
  }

  /// Рассчитывает LCOM (Lack of Cohesion of Methods) для класса
  void _calculateLCOM(
      ClassInfo classInfo, Map<String, ClassMetrics> classMetricsMap) {
    // Создаем метрику для класса
    final metrics = ClassMetrics(
      className: classInfo.name,
      methodCount: classInfo.methods.length,
      fieldCount: classInfo.fields.length,
      complexity: 0,
      lcom: 0,
    );

    // Метод доступа к полям для каждого метода
    final methodFieldAccess = <String, Set<String>>{};

    // Заполняем данные о доступе к полям (упрощенно, в реальности нужен более детальный анализ)
    for (final method in classInfo.methods) {
      final fieldAccess = <String>{};

      // Простая эвристика: если в теле метода есть имя поля, считаем, что метод обращается к полю
      // В реальной реализации нужен полноценный анализатор обращений к полям
      // Более точная эвристика для определения обращений к полям
      for (final field in classInfo.fields) {
        // Ищем обращения к полю в формате this.fieldName или просто fieldName
        final fieldPattern = RegExp(r'(\b|this\.)' + field.name + r'\b');
        if (method.body != null && fieldPattern.hasMatch(method.body!)) {
          fieldAccess.add(field.name);
        }
      }

      methodFieldAccess[method.name] = fieldAccess;
    }

    // Вычисляем LCOM (Henderson-Sellers version)
    if (classInfo.methods.isNotEmpty && classInfo.fields.isNotEmpty) {
      int fieldAccessSum = 0;

      for (final fieldAccess in methodFieldAccess.values) {
        fieldAccessSum += fieldAccess.length;
      }

      final double avgFieldAccess = fieldAccessSum / classInfo.methods.length;
      // Защита от деления на ноль
      if (classInfo.fields.length > 0) {
        metrics.lcom =
            (1 - avgFieldAccess / classInfo.fields.length).clamp(0, 1);
      } else {
        metrics.lcom = 1.0; // Максимальная несвязность, если нет полей
      }
    }

    // Добавляем метрику в общую коллекцию
    classMetricsMap[classInfo.name] = metrics;
  }
}

/// Посетитель для подсчета сложности кода
class _ComplexityVisitor extends RecursiveAstVisitor<void> {
  /// Цикломатическая сложность
  int complexity = 1;

  /// Когнитивная сложность
  int cognitiveComplexity = 0;

  /// Текущий уровень вложенности
  int _currentNestingLevel = 0;

  /// Максимальный уровень вложенности
  int maxNestingLevel = 0;

  /// Счетчик методов
  int methodCount = 0;

  /// Общая длина методов в строках
  int totalMethodLines = 0;

  /// Максимальная длина метода в строках
  int maxMethodLength = 0;

  @override
  void visitIfStatement(IfStatement node) {
    // Увеличиваем цикломатическую сложность
    complexity++;

    // Увеличиваем когнитивную сложность с учетом вложенности
    cognitiveComplexity += 1 + _currentNestingLevel;

    // Увеличиваем уровень вложенности
    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitIfStatement(node);

    // Уменьшаем уровень вложенности
    _currentNestingLevel--;
  }

  @override
  void visitForStatement(ForStatement node) {
    complexity++;
    cognitiveComplexity += 1 + _currentNestingLevel;

    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitForStatement(node);

    _currentNestingLevel--;
  }

  @override
  void visitForEachStatement(ForEachStatement node) {
    complexity++;
    cognitiveComplexity += 1 + _currentNestingLevel;

    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitForEachStatement(node);

    _currentNestingLevel--;
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    complexity++;
    cognitiveComplexity += 1 + _currentNestingLevel;

    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitWhileStatement(node);

    _currentNestingLevel--;
  }

  @override
  void visitDoStatement(DoStatement node) {
    complexity++;
    cognitiveComplexity += 1 + _currentNestingLevel;

    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitDoStatement(node);

    _currentNestingLevel--;
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    // Для каждой ветки switch увеличиваем сложность
    complexity += node.members.whereType<SwitchCase>().length;
    cognitiveComplexity += 1 + _currentNestingLevel;

    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitSwitchStatement(node);

    _currentNestingLevel--;
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    // Логические операторы увеличивают сложность
    if (node.operator.lexeme == '&&' || node.operator.lexeme == '||') {
      complexity++;
      cognitiveComplexity++;
    }

    super.visitBinaryExpression(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    // Инкремент счетчика методов
    methodCount++;

    // Подсчет строк в методе
    final startLine =
        node.beginToken.lineInfo.getLocation(node.offset).lineNumber;
    final endLine = node.endToken.lineInfo.getLocation(node.end).lineNumber;
    final methodLines = endLine - startLine + 1;

    totalMethodLines += methodLines;

    // Обновление максимальной длины метода
    if (methodLines > maxMethodLength) {
      maxMethodLength = methodLines;
    }

    super.visitMethodDeclaration(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    complexity++;
    cognitiveComplexity++;

    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;

    super.visitCatchClause(node);

    _currentNestingLevel--;
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    complexity++;
    cognitiveComplexity++;

    super.visitConditionalExpression(node);
  }
}
