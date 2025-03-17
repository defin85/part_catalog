import 'package:freezed_annotation/freezed_annotation.dart';

part 'metrics_info.freezed.dart';
part 'metrics_info.g.dart';

/// {@template code_metrics}
/// Класс для хранения метрик кода
/// {@endtemplate}
@freezed
class CodeMetrics with _$CodeMetrics {
  const CodeMetrics._();

  /// {@macro code_metrics}
  const factory CodeMetrics({
    /// Общее количество строк
    @JsonKey(name: 'total_lines') @Default(0) int totalLines,

    /// Количество строк с кодом
    @JsonKey(name: 'code_lines') @Default(0) int codeLines,

    /// Количество строк с комментариями
    @JsonKey(name: 'comment_lines') @Default(0) int commentLines,

    /// Количество пустых строк
    @JsonKey(name: 'blank_lines') @Default(0) int blankLines,

    /// Общее количество символов
    @JsonKey(name: 'character_count') @Default(0) int characterCount,

    /// Количество классов
    @JsonKey(name: 'class_count') @Default(0) int classCount,

    /// Количество методов
    @JsonKey(name: 'method_count') @Default(0) int methodCount,

    /// Количество функций (вне классов)
    @JsonKey(name: 'function_count') @Default(0) int functionCount,

    /// Количество полей
    @JsonKey(name: 'field_count') @Default(0) int fieldCount,

    /// Средняя длина метода (в строках)
    @JsonKey(name: 'average_method_length')
    @Default(0.0)
    double averageMethodLength,

    /// Максимальная длина метода (в строках)
    @JsonKey(name: 'max_method_length') @Default(0) int maxMethodLength,

    /// Среднее количество методов на класс
    @JsonKey(name: 'average_methods_per_class')
    @Default(0.0)
    double averageMethodsPerClass,

    /// Максимальная вложенность кода
    @JsonKey(name: 'max_nesting_level') @Default(0) int maxNestingLevel,

    /// Цикломатическая сложность
    @JsonKey(name: 'complexity') @Default(1) int complexity,

    /// Когнитивная сложность
    @JsonKey(name: 'cognitive_complexity') @Default(0) int cognitiveComplexity,

    /// Плотность комментариев (отношение строк комментариев к строкам кода)
    @JsonKey(name: 'comment_density') @Default(0.0) double commentDensity,

    /// Средняя длина строки кода
    @JsonKey(name: 'average_line_length')
    @Default(0.0)
    double averageLineLength,

    /// Количество TO DO комментариев
    @JsonKey(name: 'todo_count') @Default(0) int todoCount,

    /// Количество FIX ME комментариев
    @JsonKey(name: 'fixme_count') @Default(0) int fixmeCount,

    /// Дополнительные метрики для классов
    @JsonKey(name: 'class_metrics')
    @Default({})
    Map<String, ClassMetrics> classMetrics,
  }) = _CodeMetrics;

  /// Создает объект из JSON
  factory CodeMetrics.fromJson(Map<String, dynamic> json) =>
      _$CodeMetricsFromJson(json);

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
}

/// {@template class_metrics}
/// Класс для хранения метрик отдельного класса
/// {@endtemplate}
@freezed
class ClassMetrics with _$ClassMetrics {
  const ClassMetrics._();

  /// {@macro class_metrics}
  const factory ClassMetrics({
    /// Имя класса
    @JsonKey(name: 'class_name') required String className,

    /// Количество методов
    @JsonKey(name: 'method_count') @Default(0) int methodCount,

    /// Количество полей
    @JsonKey(name: 'field_count') @Default(0) int fieldCount,

    /// Отсутствие связности между методами (LCOM - Lack of Cohesion of Methods)
    /// Значение от 0 (полная связность) до 1 (отсутствие связности)
    @JsonKey(name: 'lcom') @Default(0.0) double lcom,

    /// Цикломатическая сложность класса (сумма сложностей методов)
    @JsonKey(name: 'complexity') @Default(0) int complexity,

    /// Глубина наследования (DIT - Depth of Inheritance Tree)
    @JsonKey(name: 'inheritance_depth') @Default(0) int inheritanceDepth,

    /// Количество дочерних классов (NOC - Number of Children)
    @JsonKey(name: 'children_count') @Default(0) int childrenCount,

    /// Метрики для методов класса
    @JsonKey(name: 'method_metrics')
    @Default({})
    Map<String, MethodMetrics> methodMetrics,
  }) = _ClassMetrics;

  /// Создает объект из JSON
  factory ClassMetrics.fromJson(Map<String, dynamic> json) =>
      _$ClassMetricsFromJson(json);

  /// Площадь наследования (наследование * дети)
  int get inheritanceArea => inheritanceDepth * (childrenCount + 1);
}

/// {@template method_metrics}
/// Класс для хранения метрик отдельного метода
/// {@endtemplate}
@freezed
class MethodMetrics with _$MethodMetrics {
  const MethodMetrics._();

  /// {@macro method_metrics}
  const factory MethodMetrics({
    /// Имя метода
    @JsonKey(name: 'method_name') required String methodName,

    /// Количество строк
    @JsonKey(name: 'lines') @Default(0) int lines,

    /// Цикломатическая сложность
    @JsonKey(name: 'complexity') @Default(1) int complexity,

    /// Количество параметров
    @JsonKey(name: 'parameter_count') @Default(0) int parameterCount,

    /// Количество локальных переменных
    @JsonKey(name: 'local_variables') @Default(0) int localVariables,

    /// Количество обращений к полям класса
    @JsonKey(name: 'field_accesses') @Default(0) int fieldAccesses,

    /// Количество вызовов других методов
    @JsonKey(name: 'method_calls') @Default(0) int methodCalls,

    /// Глубина вложенности
    @JsonKey(name: 'nesting_level') @Default(0) int nestingLevel,
  }) = _MethodMetrics;

  /// Создает объект из JSON
  factory MethodMetrics.fromJson(Map<String, dynamic> json) =>
      _$MethodMetricsFromJson(json);

  /// Сложность интерфейса метода (количество параметров)
  int get interfaceComplexity => parameterCount;
}
