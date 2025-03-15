import 'dart:convert';

/// Класс для хранения метрик кода
class CodeMetrics {
  /// Общее количество строк
  int totalLines = 0;

  /// Количество строк с кодом
  int codeLines = 0;

  /// Количество строк с комментариями
  int commentLines = 0;

  /// Количество пустых строк
  int blankLines = 0;

  /// Общее количество символов
  int characterCount = 0;

  /// Количество классов
  int classCount = 0;

  /// Количество методов
  int methodCount = 0;

  /// Количество функций (вне классов)
  int functionCount = 0;

  /// Количество полей
  int fieldCount = 0;

  /// Средняя длина метода (в строках)
  double averageMethodLength = 0;

  /// Максимальная длина метода (в строках)
  int maxMethodLength = 0;

  /// Среднее количество методов на класс
  double averageMethodsPerClass = 0;

  /// Максимальная вложенность кода
  int maxNestingLevel = 0;

  /// Цикломатическая сложность
  int complexity = 1;

  /// Когнитивная сложность
  int cognitiveComplexity = 0;

  /// Плотность комментариев (отношение строк комментариев к строкам кода)
  double commentDensity = 0;

  /// Средняя длина строки кода
  double averageLineLength = 0;

  /// Количество TODO комментариев
  int todoCount = 0;

  /// Количество FIXME комментариев
  int fixmeCount = 0;

  /// Дополнительные метрики для классов
  Map<String, ClassMetrics> classMetrics = {};

  /// Конструктор с значениями по умолчанию
  CodeMetrics();

  /// Конструктор из JSON
  CodeMetrics.fromJson(Map<String, dynamic> json) {
    totalLines = json['totalLines'] ?? 0;
    codeLines = json['codeLines'] ?? 0;
    commentLines = json['commentLines'] ?? 0;
    blankLines = json['blankLines'] ?? 0;
    characterCount = json['characterCount'] ?? 0;
    classCount = json['classCount'] ?? 0;
    methodCount = json['methodCount'] ?? 0;
    functionCount = json['functionCount'] ?? 0;
    fieldCount = json['fieldCount'] ?? 0;
    averageMethodLength = json['averageMethodLength']?.toDouble() ?? 0.0;
    maxMethodLength = json['maxMethodLength'] ?? 0;
    averageMethodsPerClass = json['averageMethodsPerClass']?.toDouble() ?? 0.0;
    maxNestingLevel = json['maxNestingLevel'] ?? 0;
    complexity = json['complexity'] ?? 1;
    cognitiveComplexity = json['cognitiveComplexity'] ?? 0;
    commentDensity = json['commentDensity']?.toDouble() ?? 0.0;
    averageLineLength = json['averageLineLength']?.toDouble() ?? 0.0;
    todoCount = json['todoCount'] ?? 0;
    fixmeCount = json['fixmeCount'] ?? 0;

    if (json['classMetrics'] != null) {
      final Map<String, dynamic> classMetricsMap = json['classMetrics'];
      classMetricsMap.forEach((key, value) {
        classMetrics[key] = ClassMetrics.fromJson(value);
      });
    }
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'totalLines': totalLines,
      'codeLines': codeLines,
      'commentLines': commentLines,
      'blankLines': blankLines,
      'characterCount': characterCount,
      'classCount': classCount,
      'methodCount': methodCount,
      'functionCount': functionCount,
      'fieldCount': fieldCount,
      'averageMethodLength': averageMethodLength,
      'maxMethodLength': maxMethodLength,
      'averageMethodsPerClass': averageMethodsPerClass,
      'maxNestingLevel': maxNestingLevel,
      'complexity': complexity,
      'cognitiveComplexity': cognitiveComplexity,
      'commentDensity': commentDensity,
      'averageLineLength': averageLineLength,
      'todoCount': todoCount,
      'fixmeCount': fixmeCount,
    };

    if (classMetrics.isNotEmpty) {
      data['classMetrics'] = {};
      classMetrics.forEach((key, value) {
        data['classMetrics'][key] = value.toJson();
      });
    }

    return data;
  }

  /// Расчёт процента комментариев от общего кода
  double get commentPercentage =>
      codeLines > 0 ? (commentLines / codeLines) * 100 : 0;

  /// Получение категории сложности кода
  String get complexityCategory {
    if (complexity <= 5) return 'Низкая';
    if (complexity <= 10) return 'Умеренная';
    if (complexity <= 20) return 'Высокая';
    return 'Очень высокая';
  }

  /// Строковое представление
  @override
  String toString() => jsonEncode(toJson());
}

/// Класс для хранения метрик отдельного класса
class ClassMetrics {
  /// Имя класса
  final String className;

  /// Количество методов
  int methodCount = 0;

  /// Количество полей
  int fieldCount = 0;

  /// Отсутствие связности между методами (LCOM - Lack of Cohesion of Methods)
  /// Значение от 0 (полная связность) до 1 (отсутствие связности)
  double lcom = 0;

  /// Цикломатическая сложность класса (сумма сложностей методов)
  int complexity = 0;

  /// Глубина наследования (DIT - Depth of Inheritance Tree)
  int inheritanceDepth = 0;

  /// Количество дочерних классов (NOC - Number of Children)
  int childrenCount = 0;

  /// Площадь наследования (наследование * дети)
  int get inheritanceArea => inheritanceDepth * (childrenCount + 1);

  /// Метрики для методов класса
  Map<String, MethodMetrics> methodMetrics = {};

  /// Конструктор
  ClassMetrics({
    required this.className,
    this.methodCount = 0,
    this.fieldCount = 0,
    this.lcom = 0,
    this.complexity = 0,
    this.inheritanceDepth = 0,
    this.childrenCount = 0,
  });

  /// Конструктор из JSON
  ClassMetrics.fromJson(Map<String, dynamic> json)
      : className = json['className'] ?? 'Unknown' {
    methodCount = json['methodCount'] ?? 0;
    fieldCount = json['fieldCount'] ?? 0;
    lcom = json['lcom']?.toDouble() ?? 0.0;
    complexity = json['complexity'] ?? 0;
    inheritanceDepth = json['inheritanceDepth'] ?? 0;
    childrenCount = json['childrenCount'] ?? 0;

    if (json['methodMetrics'] != null) {
      final Map<String, dynamic> methodMetricsMap = json['methodMetrics'];
      methodMetricsMap.forEach((key, value) {
        methodMetrics[key] = MethodMetrics.fromJson(value);
      });
    }
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'className': className,
      'methodCount': methodCount,
      'fieldCount': fieldCount,
      'lcom': lcom,
      'complexity': complexity,
      'inheritanceDepth': inheritanceDepth,
      'childrenCount': childrenCount,
    };

    if (methodMetrics.isNotEmpty) {
      data['methodMetrics'] = {};
      methodMetrics.forEach((key, value) {
        data['methodMetrics'][key] = value.toJson();
      });
    }

    return data;
  }
}

/// Класс для хранения метрик отдельного метода
class MethodMetrics {
  /// Имя метода
  final String methodName;

  /// Количество строк
  int lines = 0;

  /// Цикломатическая сложность
  int complexity = 1;

  /// Количество параметров
  int parameterCount = 0;

  /// Количество локальных переменных
  int localVariables = 0;

  /// Количество обращений к полям класса
  int fieldAccesses = 0;

  /// Количество вызовов других методов
  int methodCalls = 0;

  /// Глубина вложенности
  int nestingLevel = 0;

  /// Сложность интерфейса метода (количество параметров)
  int get interfaceComplexity => parameterCount;

  /// Конструктор
  MethodMetrics(this.methodName);

  /// Конструктор из JSON
  MethodMetrics.fromJson(Map<String, dynamic> json)
      : methodName = json['methodName'] ?? 'Unknown' {
    lines = json['lines'] ?? 0;
    complexity = json['complexity'] ?? 1;
    parameterCount = json['parameterCount'] ?? 0;
    localVariables = json['localVariables'] ?? 0;
    fieldAccesses = json['fieldAccesses'] ?? 0;
    methodCalls = json['methodCalls'] ?? 0;
    nestingLevel = json['nestingLevel'] ?? 0;
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'methodName': methodName,
      'lines': lines,
      'complexity': complexity,
      'parameterCount': parameterCount,
      'localVariables': localVariables,
      'fieldAccesses': fieldAccesses,
      'methodCalls': methodCalls,
      'nestingLevel': nestingLevel,
    };
  }
}
