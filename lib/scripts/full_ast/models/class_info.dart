import 'package:freezed_annotation/freezed_annotation.dart';
import 'annotation_info.dart';
import 'source_location.dart';
import 'declaration_info.dart';

part 'class_info.freezed.dart';
part 'class_info.g.dart';

/// {@template class_info}
/// Модель для хранения информации о классе
/// {@endtemplate}
@freezed
class ClassInfo with _$ClassInfo {
  const ClassInfo._();

  /// {@macro class_info}
  const factory ClassInfo({
    /// Имя класса
    @JsonKey(name: 'name') required String name,

    /// Документация класса
    @JsonKey(name: 'documentation') String? documentation,

    /// Является ли класс абстрактным
    @JsonKey(name: 'is_abstract') @Default(false) bool isAbstract,

    /// Родительский класс (от которого наследуется)
    @JsonKey(name: 'superclass') String? superclass,

    /// Реализуемые интерфейсы
    @JsonKey(name: 'interfaces') @Default([]) List<String> interfaces,

    /// Используемые миксины
    @JsonKey(name: 'mixins') @Default([]) List<String> mixins,

    /// Ограничения типа (для миксинов с 'on')
    @JsonKey(name: 'on_types') @Default([]) List<String> onTypes,

    /// Параметры типа (generic-параметры)
    @JsonKey(name: 'type_parameters') @Default([]) List<String> typeParameters,

    /// Модификаторы класса
    @JsonKey(name: 'modifiers') @Default([]) List<String> modifiers,

    /// Поля класса
    @JsonKey(name: 'fields') @Default([]) List<FieldInfo> fields,

    /// Методы класса
    @JsonKey(name: 'methods') @Default([]) List<MethodInfo> methods,

    /// Конструкторы класса
    @JsonKey(name: 'constructors')
    @Default([])
    List<ConstructorInfo> constructors,

    /// Является ли класс миксином
    @JsonKey(name: 'is_mixin') @Default(false) bool isMixin,

    /// Является ли класс перечислением
    @JsonKey(name: 'is_enum') @Default(false) bool isEnum,

    /// Является ли класс расширением
    @JsonKey(name: 'is_extension') @Default(false) bool isExtension,

    /// Тип, для которого создано расширение (если класс - расширение)
    @JsonKey(name: 'on_type') String? onType,

    /// Константы перечисления (если класс - enum)
    @JsonKey(name: 'enum_constants') List<ClassEnumConstInfo>? enumConstants,

    /// Местоположение в коде
    @JsonKey(name: 'location') required SourceLocation location,

    /// Путь к файлу, содержащему класс
    @JsonKey(name: 'file_path') String? filePath,

    /// Является ли класс публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,

    /// Имя родительского элемента
    @JsonKey(name: 'parent_name') String? parentName,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _ClassInfo;

  /// Создает объект из JSON
  factory ClassInfo.fromJson(Map<String, dynamic> json) =>
      _$ClassInfoFromJson(json);

  /// Тип узла
  String get nodeType => 'class';

  /// Возвращает полное квалифицированное имя класса
  String get qualifiedName => parentName != null ? '$parentName.$name' : name;

  /// Возвращает тип класса в строковом представлении
  String get classType {
    if (isEnum) return 'enum';
    if (isMixin) return 'mixin';
    if (isExtension) return 'extension';
    return isAbstract ? 'abstract class' : 'class';
  }

  /// Реализация DeclarationInfo.returnType
  String? get returnType => null;

  /// Реализация DeclarationInfo.type
  String get type => classType;

  /// Параметры типа для реализации DeclarationInfo.typeParameters
  List<String>? get effectiveTypeParameters =>
      super.typeParameters.isEmpty ? null : super.typeParameters;

  /// Метод для преобразования в DeclarationInfo
  /// Используется для совместимости с другими частями приложения
  DeclarationInfo toDeclarationInfo() {
    return DeclarationInfo(
      name: name,
      type: classType,
      isPublic: isPublic,
      location: location,
      parentName: parentName,
      filePath: filePath,
      attributes: {
        ...?attributes,
        if (superclass != null) 'superclass': superclass,
        if (interfaces.isNotEmpty) 'interfaces': interfaces,
        if (mixins.isNotEmpty) 'mixins': mixins,
        if (typeParameters.isNotEmpty) 'typeParameters': typeParameters,
      },
    );
  }
}

/// {@template field_info}
/// Информация о поле класса
/// {@endtemplate}
@freezed
class FieldInfo with _$FieldInfo {
  const FieldInfo._();

  /// {@macro field_info}
  const factory FieldInfo({
    /// Имя поля
    @JsonKey(name: 'name') required String name,

    /// Тип поля
    @JsonKey(name: 'type') required String type,

    /// Является ли поле статическим
    @JsonKey(name: 'is_static') @Default(false) bool isStatic,

    /// Является ли поле final
    @JsonKey(name: 'is_final') @Default(false) bool isFinal,

    /// Является ли поле const
    @JsonKey(name: 'is_const') @Default(false) bool isConst,

    /// Является ли поле late
    @JsonKey(name: 'is_late') @Default(false) bool isLate,

    /// Документация поля
    @JsonKey(name: 'documentation') String? documentation,

    /// Инициализатор поля (если есть)
    @JsonKey(name: 'initializer') String? initializer,

    /// Модификаторы поля
    @JsonKey(name: 'modifiers') @Default([]) List<String> modifiers,

    /// Является ли поле публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Аннотации поля
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,
  }) = _FieldInfo;

  /// Создает объект из JSON
  factory FieldInfo.fromJson(Map<String, dynamic> json) =>
      _$FieldInfoFromJson(json);

  /// Строковое представление модификаторов поля
  String get modifiersString {
    final mods = <String>[];
    if (isStatic) mods.add('static');
    if (isConst) mods.add('const');
    if (isFinal) mods.add('final');
    if (isLate) mods.add('late');
    return mods.join(' ');
  }
}

/// {@template method_info}
/// Информация о методе класса
/// {@endtemplate}
@freezed
class MethodInfo with _$MethodInfo {
  const MethodInfo._();

  /// {@macro method_info}
  const factory MethodInfo({
    /// Имя метода
    @JsonKey(name: 'name') required String name,

    /// Возвращаемый тип
    @JsonKey(name: 'return_type') required String returnType,

    /// Параметры метода
    @JsonKey(name: 'parameters') @Default([]) List<ParameterInfo> parameters,

    /// Является ли метод статическим
    @JsonKey(name: 'is_static') @Default(false) bool isStatic,

    /// Является ли метод getter
    @JsonKey(name: 'is_getter') @Default(false) bool isGetter,

    /// Является ли метод setter
    @JsonKey(name: 'is_setter') @Default(false) bool isSetter,

    /// Является ли метод абстрактным
    @JsonKey(name: 'is_abstract') @Default(false) bool isAbstract,

    /// Является ли метод внешним (external)
    @JsonKey(name: 'is_external') @Default(false) bool isExternal,

    /// Является ли метод асинхронным
    @JsonKey(name: 'is_asynchronous') @Default(false) bool isAsynchronous,

    /// Является ли метод генератором
    @JsonKey(name: 'is_generator') @Default(false) bool isGenerator,

    /// Сложность метода (цикломатическая)
    @JsonKey(name: 'complexity') int? complexity,

    /// Документация метода
    @JsonKey(name: 'documentation') String? documentation,

    /// Тело метода
    @JsonKey(name: 'body') String? body,

    /// Модификаторы метода
    @JsonKey(name: 'modifiers') @Default([]) List<String> modifiers,

    /// Является ли метод переопределенным (override)
    @JsonKey(name: 'is_override') @Default(false) bool isOverride,

    /// Параметры типа метода (generic-параметры)
    @JsonKey(name: 'type_parameters') List<String>? typeParameters,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Аннотации метода
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,
  }) = _MethodInfo;

  /// Создает объект из JSON
  factory MethodInfo.fromJson(Map<String, dynamic> json) =>
      _$MethodInfoFromJson(json);

  /// Строковое представление метода
  String get signature {
    final prefix = <String>[];
    if (isStatic) prefix.add('static');
    if (isAbstract) prefix.add('abstract');

    final modifier = prefix.join(' ');
    final async = isAsynchronous ? ' async' : '';
    final sync = isGenerator ? (isAsynchronous ? '*' : ' sync*') : '';

    final paramStr = parameters.isNotEmpty
        ? parameters.map((p) => p.toString()).join(', ')
        : '';

    if (isGetter) {
      return '$modifier $returnType get $name$async$sync';
    } else if (isSetter) {
      return '$modifier void set $name($paramStr)$async$sync';
    } else {
      return '$modifier $returnType $name($paramStr)$async$sync';
    }
  }
}

/// {@template constructor_info}
/// Информация о конструкторе класса
/// {@endtemplate}
@freezed
class ConstructorInfo with _$ConstructorInfo {
  const ConstructorInfo._();

  /// {@macro constructor_info}
  const factory ConstructorInfo({
    /// Имя конструктора (пустая строка для безымянного конструктора)
    @JsonKey(name: 'name') required String name,

    /// Параметры конструктора
    @JsonKey(name: 'parameters') @Default([]) List<ParameterInfo> parameters,

    /// Инициализаторы конструктора
    @JsonKey(name: 'initializers') @Default([]) List<String> initializers,

    /// Является ли конструктор константным
    @JsonKey(name: 'is_const') @Default(false) bool isConst,

    /// Является ли конструктор factory
    @JsonKey(name: 'is_factory') @Default(false) bool isFactory,

    /// Является ли конструктор external
    @JsonKey(name: 'is_external') @Default(false) bool isExternal,

    /// Документация конструктора
    @JsonKey(name: 'documentation') String? documentation,

    /// Тело конструктора
    @JsonKey(name: 'body') String? body,

    /// Модификаторы конструктора
    @JsonKey(name: 'modifiers') @Default([]) List<String> modifiers,

    /// Перенаправленный конструктор (если есть)
    @JsonKey(name: 'redirected_constructor') String? redirectedConstructor,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Аннотации конструктора
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,
  }) = _ConstructorInfo;

  /// Создает объект из JSON
  factory ConstructorInfo.fromJson(Map<String, dynamic> json) =>
      _$ConstructorInfoFromJson(json);

  /// Строковое представление конструктора
  String get signature {
    final prefix = <String>[];
    if (isConst) prefix.add('const');
    if (isFactory) prefix.add('factory');
    if (isExternal) prefix.add('external');

    final modifier = prefix.join(' ');
    final constructorName = name.isEmpty ? '' : '.$name';
    final paramStr = parameters.isNotEmpty
        ? parameters.map((p) => p.toString()).join(', ')
        : '';

    return '$modifier${modifier.isNotEmpty ? ' ' : ''}Constructor$constructorName($paramStr)';
  }
}

/// {@template enum_constant_info}
/// Информация о константе перечисления
/// {@endtemplate}
@freezed
class ClassEnumConstInfo with _$ClassEnumConstInfo {
  const ClassEnumConstInfo._();

  /// {@macro enum_constant_info}
  const factory ClassEnumConstInfo({
    /// Имя константы
    @JsonKey(name: 'name') required String name,

    /// Документация константы
    @JsonKey(name: 'documentation') String? documentation,

    /// Аннотации константы
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Аргументы конструктора (если есть)
    @JsonKey(name: 'constructor_arguments') String? constructorArguments,
  }) = _ClassEnumConstInfo;

  /// Создает объект из JSON
  factory ClassEnumConstInfo.fromJson(Map<String, dynamic> json) =>
      _$ClassEnumConstInfoFromJson(json);

  /// Строковое представление константы
  @override
  String toString() =>
      constructorArguments != null ? '$name($constructorArguments)' : name;
}
