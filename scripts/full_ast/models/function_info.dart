import 'ast_node.dart';
import 'declaration_info.dart';

/// Модель для представления функций и методов в AST
class FunctionInfo {
  /// Имя функции или метода
  final String name;

  /// Возвращаемый тип
  final String returnType;

  /// Параметры функции
  final List<ParameterInfo> parameters;

  /// Является ли функция асинхронной
  final bool isAsync;

  /// Является ли функция генератором
  final bool isGenerator;

  /// Является ли функция асинхронным генератором
  bool get isAsyncGenerator => isAsync && isGenerator;

  /// Документация к функции
  final String? documentation;

  /// Тело функции
  final String? body;

  /// Является ли функция геттером
  final bool isGetter;

  /// Является ли функция сеттером
  final bool isSetter;

  /// Является ли функция абстрактной
  final bool isAbstract;

  /// Является ли функция внешней (external)
  final bool isExternal;

  /// Является ли функция статической
  final bool isStatic;

  /// Является ли функция анонимной
  final bool isAnonymous;

  /// Является ли функция конструктором
  final bool isConstructor;

  /// Является ли конструктор константным
  final bool isConst;

  /// Является ли конструктор factory
  final bool isFactory;

  /// Имя класса, к которому принадлежит метод (если применимо)
  final String? classContext;

  /// Параметры типа (для дженериков)
  final List<String>? typeParameters;

  /// Является ли метод переопределением (override)
  final bool isOverride;

  /// Сложность функции по метрике цикломатической сложности
  final int? complexity;

  /// Модификаторы функции
  final List<String> modifiers;

  /// Инициализаторы (для конструкторов)
  final List<String>? initializers;

  /// Перенаправленный конструктор (для конструкторов, если есть)
  final String? redirectedConstructor;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создает информацию о функции
  FunctionInfo({
    required this.name,
    required this.returnType,
    required this.parameters,
    this.isAsync = false,
    this.isGenerator = false,
    this.documentation,
    this.body,
    this.isGetter = false,
    this.isSetter = false,
    this.isAbstract = false,
    this.isExternal = false,
    this.isStatic = false,
    this.isAnonymous = false,
    this.isConstructor = false,
    this.isConst = false,
    this.isFactory = false,
    this.classContext,
    this.typeParameters,
    this.isOverride = false,
    this.complexity,
    this.modifiers = const [],
    this.initializers,
    this.redirectedConstructor,
    this.location,
  });

  /// Преобразует информацию о функции в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'returnType': returnType,
      'parameters': parameters.map((param) => param.toJson()).toList(),
      'isAsync': isAsync,
      'isGenerator': isGenerator,
      'documentation': documentation,
      'body': body,
      'isGetter': isGetter,
      'isSetter': isSetter,
      'isAbstract': isAbstract,
      'isExternal': isExternal,
      'isStatic': isStatic,
      'isAnonymous': isAnonymous,
      'isConstructor': isConstructor,
      'isConst': isConst,
      'isFactory': isFactory,
      'classContext': classContext,
      'typeParameters': typeParameters,
      'isOverride': isOverride,
      'complexity': complexity,
      'modifiers': modifiers,
      'initializers': initializers,
      'redirectedConstructor': redirectedConstructor,
      'location': location?.toJson(),
    };
  }

  /// Создает объект информации о функции из JSON
  factory FunctionInfo.fromJson(Map<String, dynamic> json) {
    return FunctionInfo(
      name: json['name'] as String,
      returnType: json['returnType'] as String,
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ParameterInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAsync: json['isAsync'] as bool? ?? false,
      isGenerator: json['isGenerator'] as bool? ?? false,
      documentation: json['documentation'] as String?,
      body: json['body'] as String?,
      isGetter: json['isGetter'] as bool? ?? false,
      isSetter: json['isSetter'] as bool? ?? false,
      isAbstract: json['isAbstract'] as bool? ?? false,
      isExternal: json['isExternal'] as bool? ?? false,
      isStatic: json['isStatic'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      isConstructor: json['isConstructor'] as bool? ?? false,
      isConst: json['isConst'] as bool? ?? false,
      isFactory: json['isFactory'] as bool? ?? false,
      classContext: json['classContext'] as String?,
      typeParameters:
          (json['typeParameters'] as List<dynamic>?)?.cast<String>(),
      isOverride: json['isOverride'] as bool? ?? false,
      complexity: json['complexity'] as int?,
      modifiers:
          (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? const [],
      initializers: (json['initializers'] as List<dynamic>?)?.cast<String>(),
      redirectedConstructor: json['redirectedConstructor'] as String?,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Текстовое представление сигнатуры функции в стиле Dart
  String getSignature() {
    final buffer = StringBuffer();

    // Добавление модификаторов
    if (isStatic) buffer.write('static ');
    if (isAbstract) buffer.write('abstract ');
    if (isExternal) buffer.write('external ');

    // Добавление типа функции (getter/setter)
    if (isGetter) buffer.write('get ');
    if (isSetter) buffer.write('set ');

    // Добавление возвращаемого типа, если это не конструктор
    if (!isConstructor) {
      buffer.write('$returnType ');
    }

    // Добавление имени функции или метода
    buffer.write(name);

    // Добавление параметров типа
    if (typeParameters != null && typeParameters!.isNotEmpty) {
      buffer.write('<${typeParameters!.join(', ')}>');
    }

    // Добавление параметров
    buffer.write('(');

    final requiredPositional =
        parameters.where((p) => p.isPositional && p.isRequired).toList();

    final optionalPositional =
        parameters.where((p) => p.isPositional && !p.isRequired).toList();

    final namedParameters = parameters.where((p) => p.isNamed).toList();

    // Добавление обязательных позиционных параметров
    if (requiredPositional.isNotEmpty) {
      buffer.write(
          requiredPositional.map((p) => '${p.type} ${p.name}').join(', '));

      if (optionalPositional.isNotEmpty || namedParameters.isNotEmpty) {
        buffer.write(', ');
      }
    }

    // Добавление необязательных позиционных параметров
    if (optionalPositional.isNotEmpty) {
      buffer.write('[');
      buffer.write(optionalPositional.map((p) {
        final defaultValue =
            p.defaultValue != null ? ' = ${p.defaultValue}' : '';
        return '${p.type} ${p.name}$defaultValue';
      }).join(', '));
      buffer.write(']');

      if (namedParameters.isNotEmpty) {
        buffer.write(', ');
      }
    }

    // Добавление именованных параметров
    if (namedParameters.isNotEmpty) {
      buffer.write('{');
      buffer.write(namedParameters.map((p) {
        final required = p.isRequired ? 'required ' : '';
        final defaultValue =
            p.defaultValue != null ? ' = ${p.defaultValue}' : '';
        return '$required${p.type} ${p.name}$defaultValue';
      }).join(', '));
      buffer.write('}');
    }

    buffer.write(')');

    // Добавление модификаторов асинхронности
    if (isAsync && isGenerator) {
      buffer.write(' async*');
    } else if (isAsync) {
      buffer.write(' async');
    } else if (isGenerator) {
      buffer.write(' sync*');
    }

    return buffer.toString();
  }
}
