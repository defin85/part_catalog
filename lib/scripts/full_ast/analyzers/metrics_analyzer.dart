import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:part_catalog/scripts/full_ast/models/class_info.dart';

import '../models/ast_node.dart';
import '../utils/logger.dart';

/// Анализатор для расчета метрик кода
class MetricsAnalyzer {
  /// Логгер для класса
  final _logger = setupLogger('MetricsAnalyzer');

  /// Анализирует файл и рассчитывает метрики кода
  Future<FileNode> analyzeFile(
      FileNode fileNode, ParseStringResult parseResult) async {
    try {
      _logger.d('Расчет метрик для файла: ${fileNode.path}');

      // Инициализация метрик или использование существующих
      CodeMetrics metrics = fileNode.metrics ?? const CodeMetrics();

      // Рассчитываем базовые метрики
      final basicMetrics = _calculateBasicMetrics(parseResult);

      // Рассчитываем метрики сложности кода
      final complexityMetrics = _calculateComplexityMetrics(parseResult);

      // Анализируем текстовые метрики
      final textMetrics = _analyzeTextMetrics(parseResult);

      // Рассчитываем метрики для классов
      final classMetricsMap = _calculateClassMetrics(fileNode);

      // Создаем новый объект метрик со всеми обновленными значениями
      metrics = metrics.copyWith(
        totalLines: basicMetrics['totalLines'] as int,
        codeLines: basicMetrics['codeLines'] as int,
        commentLines: basicMetrics['commentLines'] as int,
        blankLines: basicMetrics['blankLines'] as int,
        commentDensity: basicMetrics['commentDensity'] as double,
        complexity: complexityMetrics['complexity'] as int,
        cognitiveComplexity: complexityMetrics['cognitiveComplexity'] as int,
        maxNestingLevel: complexityMetrics['maxNestingLevel'] as int,
        averageMethodLength: complexityMetrics['averageMethodLength'] as double,
        maxMethodLength: complexityMetrics['maxMethodLength'] as int,
        characterCount: textMetrics['characterCount'] as int,
        averageLineLength: textMetrics['averageLineLength'] as double,
        todoCount: textMetrics['todoCount'] as int,
        fixmeCount: textMetrics['fixmeCount'] as int,
        classCount: fileNode.classes.length,
        methodCount: classMetricsMap['methodCount'] as int,
        fieldCount: classMetricsMap['fieldCount'] as int,
        averageMethodsPerClass:
            classMetricsMap['averageMethodsPerClass'] as double,
        classMetrics:
            classMetricsMap['classMetrics'] as Map<String, ClassMetrics>,
      );

      _logger.d('Метрики для файла ${fileNode.path} рассчитаны: '
          'сложность=${metrics.complexity}, '
          'LOC=${metrics.codeLines}');

      // Создаем новый FileNode с обновленными метриками
      return fileNode.copyWith(metrics: metrics);
    } catch (e, stackTrace) {
      _logger.e('Ошибка при расчете метрик для файла ${fileNode.path}',
          error: e, stackTrace: stackTrace);
      // В случае ошибки возвращаем исходный узел
      return fileNode;
    }
  }

  /// Рассчитывает базовые метрики файла
  Map<String, dynamic> _calculateBasicMetrics(ParseStringResult parseResult) {
    final content = parseResult.content;
    final lines = content.split('\n');

    // Локальные переменные для метрик
    final totalLines = lines.length;
    int codeLines = 0;
    int commentLines = 0;
    int blankLines = 0;
    double commentDensity = 0.0;

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

    // Расчет плотности комментариев
    if (codeLines > 0) {
      commentDensity = commentLines / codeLines;
    }

    return {
      'totalLines': totalLines,
      'codeLines': codeLines,
      'commentLines': commentLines,
      'blankLines': blankLines,
      'commentDensity': commentDensity,
    };
  }

  /// Рассчитывает метрики сложности кода
  Map<String, dynamic> _calculateComplexityMetrics(
      ParseStringResult parseResult) {
    final visitor = _ComplexityVisitor();
    parseResult.unit.accept(visitor);

    // Средняя длина методов
    double averageMethodLength = 0.0;
    if (visitor.methodCount > 0) {
      averageMethodLength =
          visitor.totalMethodLines / visitor.methodCount.toDouble();
    }

    return {
      'complexity': visitor.complexity,
      'cognitiveComplexity': visitor.cognitiveComplexity,
      'maxNestingLevel': visitor.maxNestingLevel,
      'averageMethodLength': averageMethodLength,
      'maxMethodLength': visitor.maxMethodLength,
      'methodCount': visitor.methodCount,
    };
  }

  /// Анализирует текстовые метрики кода
  Map<String, dynamic> _analyzeTextMetrics(ParseStringResult parseResult) {
    final content = parseResult.content;
    final lines = content.split('\n');

    // Количество символов
    final characterCount = content.length;

    // Средняя длина строки
    double averageLineLength = 0.0;
    if (lines.isNotEmpty) {
      int totalLength = lines.fold(0, (sum, line) => sum + line.length);
      averageLineLength = totalLength / lines.length;
    }

    // Количество TODOs
    final todoPattern =
        RegExp(r'//\s*TODO:|/\*\s*TODO:|^\s*#\s*TODO:', multiLine: true);
    final todos = todoPattern.allMatches(content);
    final todoCount = todos.length;

    // Количество FIXMEs
    final fixmePattern =
        RegExp(r'//\s*FIXME:|/\*\s*FIXME:|^\s*#\s*FIXME:', multiLine: true);
    final fixmes = fixmePattern.allMatches(content);
    final fixmeCount = fixmes.length;

    return {
      'characterCount': characterCount,
      'averageLineLength': averageLineLength,
      'todoCount': todoCount,
      'fixmeCount': fixmeCount,
    };
  }

  /// Рассчитывает метрики для классов
  Map<String, dynamic> _calculateClassMetrics(FileNode fileNode) {
    // Инициализируем карту метрик классов
    final classMetricsMap = <String, ClassMetrics>{};

    // Подсчет общего количества методов и полей
    int totalMethods = 0;
    int totalFields = 0;

    for (final classInfo in fileNode.classes) {
      totalMethods += classInfo.methods.length;
      totalFields += classInfo.fields.length;

      // Сложность класса (LCOM - Lack of Cohesion of Methods)
      final classMetrics = _calculateLCOM(classInfo);
      classMetricsMap[classInfo.name] = classMetrics;
    }

    // Среднее количество методов на класс
    double averageMethodsPerClass = 0.0;
    if (fileNode.classes.isNotEmpty) {
      averageMethodsPerClass =
          totalMethods / fileNode.classes.length.toDouble();
    }

    return {
      'methodCount': totalMethods,
      'fieldCount': totalFields,
      'averageMethodsPerClass': averageMethodsPerClass,
      'classMetrics': classMetricsMap,
    };
  }

  /// Рассчитывает LCOM (Lack of Cohesion of Methods) для класса
  ClassMetrics _calculateLCOM(ClassInfo classInfo) {
    // Создаем метрику для класса
    ClassMetrics metrics = ClassMetrics(
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
    double lcom = 0.0;
    if (classInfo.methods.isNotEmpty && classInfo.fields.isNotEmpty) {
      int fieldAccessSum = 0;

      for (final fieldAccess in methodFieldAccess.values) {
        fieldAccessSum += fieldAccess.length;
      }

      final double avgFieldAccess = fieldAccessSum / classInfo.methods.length;
      // Защита от деления на ноль
      if (classInfo.fields.isNotEmpty) {
        lcom = (1 - avgFieldAccess / classInfo.fields.length).clamp(0, 1);
      } else {
        lcom = 1.0; // Максимальная несвязность, если нет полей
      }
    }

    // Возвращаем обновленный объект с правильным LCOM
    return metrics.copyWith(lcom: lcom);
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
    // Код посетителя оставляем без изменений, так как он не нарушает иммутабельность объектов
    complexity++;
    cognitiveComplexity += 1 + _currentNestingLevel;
    _currentNestingLevel++;
    maxNestingLevel = _currentNestingLevel > maxNestingLevel
        ? _currentNestingLevel
        : maxNestingLevel;
    super.visitIfStatement(node);
    _currentNestingLevel--;
  }

  // Остальные методы посетителя остаются без изменений...
}
