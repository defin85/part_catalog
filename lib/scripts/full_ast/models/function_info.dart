import 'package:freezed_annotation/freezed_annotation.dart';
import 'declaration_info.dart';
import 'source_location.dart';

part 'function_info.freezed.dart';
part 'function_info.g.dart';

/// {@template function_info}
/// Модель для представления функций и методов в AST
/// {@endtemplate}
@freezed
class FunctionInfo with _$FunctionInfo {
  const FunctionInfo._();

  /// {@macro function_info}
  const factory FunctionInfo({
    /// Имя функции или метода
    @JsonKey(name: 'name') required String name,

    /// Возвращаемый тип
    @JsonKey(name: 'return_type') required String returnType,

    /// Параметры функции
    @JsonKey(name: 'parameters') @Default([]) List<ParameterInfo> parameters,

    /// Является ли функция асинхронной
    @JsonKey(name: 'is_async') @Default(false) bool isAsync,

    /// Является ли функция генератором
    @JsonKey(name: 'is_generator') @Default(false) bool isGenerator,

    /// Документация к функции
    @JsonKey(name: 'documentation') String? documentation,

    /// Тело функции
    @JsonKey(name: 'body') String? body,

    /// Является ли функция геттером
    @JsonKey(name: 'is_getter') @Default(false) bool isGetter,

    /// Является ли функция сеттером
    @JsonKey(name: 'is_setter') @Default(false) bool isSetter,

    /// Является ли функция абстрактной
    @JsonKey(name: 'is_abstract') @Default(false) bool isAbstract,

    /// Является ли функция внешней (external)
    @JsonKey(name: 'is_external') @Default(false) bool isExternal,

    /// Является ли функция статической
    @JsonKey(name: 'is_static') @Default(false) bool isStatic,

    /// Является ли функция анонимной
    @JsonKey(name: 'is_anonymous') @Default(false) bool isAnonymous,

    /// Является ли функция конструктором
    @JsonKey(name: 'is_constructor') @Default(false) bool isConstructor,

    /// Является ли конструктор константным
    @JsonKey(name: 'is_const') @Default(false) bool isConst,

    /// Является ли конструктор factory
    @JsonKey(name: 'is_factory') @Default(false) bool isFactory,

    /// Имя класса, к которому принадлежит метод (если применимо)
    @JsonKey(name: 'class_context') String? classContext,

    /// Параметры типа (для дженериков)
    @JsonKey(name: 'type_parameters') List<String>? typeParameters,

    /// Является ли метод переопределением (override)
    @JsonKey(name: 'is_override') @Default(false) bool isOverride,

    /// Сложность функции по метрике цикломатической сложности
    @JsonKey(name: 'complexity') int? complexity,

    /// Модификаторы функции
    @JsonKey(name: 'modifiers') @Default([]) List<String> modifiers,

    /// Инициализаторы (для конструкторов)
    @JsonKey(name: 'initializers') List<String>? initializers,

    /// Перенаправленный конструктор (для конструкторов, если есть)
    @JsonKey(name: 'redirected_constructor') String? redirectedConstructor,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Имя родительского элемента (для методов класса)
    @JsonKey(name: 'parent_name') String? parentName,

    /// Путь к файлу, содержащему функцию
    @JsonKey(name: 'file_path') String? filePath,

    /// Является ли функция публичной
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _FunctionInfo;

  /// Создает объект из JSON
  factory FunctionInfo.fromJson(Map<String, dynamic> json) =>
      _$FunctionInfoFromJson(json);

  /// Является ли функция асинхронным генератором
  bool get isAsyncGenerator => isAsync && isGenerator;

  /// Тип узла для декларации
  String get nodeType => isConstructor ? 'constructor' : 'function';

  /// Тип декларации для реализации DeclarationInfo
  String get type => isConstructor ? 'constructor' : 'function';

  /// Возвращает полное квалифицированное имя функции
  String get qualifiedName {
    if (parentName != null) {
      return isConstructor
          ? '$parentName${name.isNotEmpty ? ".$name" : ""}'
          : '$parentName.$name';
    }
    return name;
  }

  /// Преобразует функцию в DeclarationInfo
  DeclarationInfo toDeclarationInfo() {
    return DeclarationInfo(
      name: name,
      type: type,
      isPublic: isPublic,
      location:
          location ?? SourceLocation(offset: 0, length: 0, line: 0, column: 0),
      parentName: parentName ?? classContext,
      filePath: filePath,
      attributes: {
        ...?attributes,
        'returnType': returnType,
        if (typeParameters != null) 'typeParameters': typeParameters,
        'isAsync': isAsync,
        'isGenerator': isGenerator,
        'isStatic': isStatic,
        'isConstructor': isConstructor,
      },
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

/// Расширение для преобразования FunctionInfo в DeclarationInfo
extension FunctionInfoAsDeclarationInfo on FunctionInfo {
  /// Преобразует FunctionInfo в тип T (DeclarationInfo)
  ///
  /// Пример использования:
  /// ```dart
  /// DeclarationInfo declaration = functionInfo.as<DeclarationInfo>();
  /// ```
  T as<T>() {
    if (T == DeclarationInfo) {
      return toDeclarationInfo() as T;
    }
    throw ArgumentError('Cannot convert FunctionInfo to $T');
  }
}
