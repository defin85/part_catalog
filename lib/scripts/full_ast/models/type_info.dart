import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/scripts/full_ast/models/annotation_info.dart';
import 'package:part_catalog/scripts/full_ast/models/enum_constant_info.dart';

import 'source_location.dart';

part 'type_info.freezed.dart';
part 'type_info.g.dart';

/// {@template type_info}
/// Модель для хранения информации о типах данных
/// (typedef, enum, class, mixin, extension и т.д.)
/// {@endtemplate}
@freezed
class TypeInfo with _$TypeInfo {
  const TypeInfo._();

  /// {@macro type_info}
  const factory TypeInfo({
    /// Имя типа
    @JsonKey(name: 'name') required String name,

    /// Вид типа (enum, typedef, class, extensionType и т.д.)
    @JsonKey(name: 'kind') required String kind,

    /// Является ли тип публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,

    /// Документация типа
    @JsonKey(name: 'documentation') String? documentation,

    /// Аннотации типа
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Константы перечисления (для enum)
    @JsonKey(name: 'enum_constants')
    @Default([])
    List<EnumConstantInfo> enumConstants,

    /// Реализуемые интерфейсы
    @JsonKey(name: 'interfaces') List<String>? interfaces,

    /// Используемые миксины (для классов)
    @JsonKey(name: 'mixins') List<String>? mixins,

    /// Параметры типа (generic)
    @JsonKey(name: 'type_parameters') List<String>? typeParameters,

    /// Определение типа (для typedef)
    @JsonKey(name: 'type_definition') String? typeDefinition,

    /// Параметры функционального typedef
    @JsonKey(name: 'function_parameters') List<String>? functionParameters,

    /// Возвращаемый тип (для функциональных typedef)
    @JsonKey(name: 'return_type') String? returnType,

    /// Тип представления (для extension types)
    @JsonKey(name: 'representation_type') String? representationType,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,
  }) = _TypeInfo;

  /// Создаёт информацию о типе из JSON
  factory TypeInfo.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoFromJson(json);

  /// Проверяет, является ли тип enum
  bool get isEnum => kind == 'enum';

  /// Проверяет, является ли тип typedef
  bool get isTypedef => kind == 'typedef' || kind == 'functionTypedef';

  /// Проверяет, является ли тип extension type
  bool get isExtensionType => kind == 'extensionType';

  /// Возвращает строковое представление типа данных
  @override
  String toString() => '$kind $name';
}

/// {@template generic_type_info}
/// Модель для представления информации о generic-типах
/// {@endtemplate}
@freezed
class GenericTypeInfo with _$GenericTypeInfo {
  const GenericTypeInfo._();

  /// {@macro generic_type_info}
  const factory GenericTypeInfo({
    /// Имя типового параметра
    @JsonKey(name: 'name') required String name,

    /// Ограничение типа (extends)
    @JsonKey(name: 'bound') String? bound,

    /// Является ли параметр ковариантным (covariant)
    @JsonKey(name: 'is_covariant') @Default(false) bool isCovariant,
  }) = _GenericTypeInfo;

  /// Создаёт информацию о generic-типе из JSON
  factory GenericTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$GenericTypeInfoFromJson(json);

  /// Возвращает строковое представление generic-типа
  @override
  String toString() {
    final result = StringBuffer(name);
    if (bound != null) {
      result.write(' extends $bound');
    }
    return result.toString();
  }
}

/// {@template record_type_info}
/// Модель для информации о записи типа данных (record type)
/// {@endtemplate}
@freezed
class RecordTypeInfo with _$RecordTypeInfo {
  const RecordTypeInfo._();

  /// {@macro record_type_info}
  const factory RecordTypeInfo({
    /// Поля записи
    @JsonKey(name: 'fields') required List<RecordFieldInfo> fields,
  }) = _RecordTypeInfo;

  /// Создаёт информацию о записи типа данных из JSON
  factory RecordTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$RecordTypeInfoFromJson(json);

  /// Возвращает строковое представление записи типа данных
  @override
  String toString() {
    final fieldStrings = fields.map((f) => f.toString()).join(', ');
    return '($fieldStrings)';
  }
}

/// {@template record_field_info}
/// Модель для информации о поле записи типа данных
/// {@endtemplate}
@freezed
class RecordFieldInfo with _$RecordFieldInfo {
  const RecordFieldInfo._();

  /// {@macro record_field_info}
  const factory RecordFieldInfo({
    /// Имя поля (может быть пустым для позиционных полей)
    @JsonKey(name: 'name') String? name,

    /// Тип поля
    @JsonKey(name: 'type') required String type,

    /// Является ли поле именованным
    @JsonKey(name: 'is_named') @Default(false) bool isNamed,
  }) = _RecordFieldInfo;

  /// Создаёт информацию о поле записи типа данных из JSON
  factory RecordFieldInfo.fromJson(Map<String, dynamic> json) =>
      _$RecordFieldInfoFromJson(json);

  /// Возвращает строковое представление поля записи типа данных
  @override
  String toString() {
    if (isNamed && name != null) {
      return '$type $name';
    } else {
      return type;
    }
  }
}

/// {@template enum_info}
/// Модель для информации о перечисляемом типе (enum)
/// {@endtemplate}
@freezed
class EnumInfo with _$EnumInfo {
  const EnumInfo._();

  /// {@macro enum_info}
  const factory EnumInfo({
    /// Имя типа
    @JsonKey(name: 'name') required String name,

    /// Документация типа
    @JsonKey(name: 'documentation') String? documentation,

    /// Аннотации типа
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Константы перечисления (для enum)
    @JsonKey(name: 'enum_constants') List<EnumConstantInfo>? enumConstants,

    /// Реализуемые интерфейсы
    @JsonKey(name: 'interfaces') List<String>? interfaces,

    /// Используемые миксины (для классов)
    @JsonKey(name: 'mixins') List<String>? mixins,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Является ли тип публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,
  }) = _EnumInfo;

  /// Создаёт информацию о перечисляемом типе из JSON
  factory EnumInfo.fromJson(Map<String, dynamic> json) =>
      _$EnumInfoFromJson(json);

  /// Возвращает тип узла
  String get kind => 'enum';
}

/// {@template typedef_info}
/// Модель для информации о типе-псевдониме (typedef)
/// {@endtemplate}
@freezed
class TypedefInfo with _$TypedefInfo {
  const TypedefInfo._();

  /// {@macro typedef_info}
  /// Создаёт информацию о типе-псевдониме общего вида
  const factory TypedefInfo({
    /// Имя типа
    @JsonKey(name: 'name') required String name,

    /// Документация типа
    @JsonKey(name: 'documentation') String? documentation,

    /// Аннотации типа
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Параметры типа (generic)
    @JsonKey(name: 'type_parameters') List<String>? typeParameters,

    /// Определение типа
    @JsonKey(name: 'type_definition') String? typeDefinition,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Является ли тип публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,
  }) = _TypedefInfo;

  /// Создаёт информацию о функциональном типе-псевдониме
  @FreezedUnionValue('functionTypedef')
  const factory TypedefInfo.function({
    /// Имя типа
    @JsonKey(name: 'name') required String name,

    /// Документация типа
    @JsonKey(name: 'documentation') String? documentation,

    /// Аннотации типа
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Параметры типа (generic)
    @JsonKey(name: 'type_parameters') List<String>? typeParameters,

    /// Параметры функции
    @JsonKey(name: 'function_parameters') List<String>? functionParameters,

    /// Возвращаемый тип
    @JsonKey(name: 'return_type') String? returnType,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Является ли тип публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,
  }) = FunctionTypedefInfo;

  /// Создаёт информацию о типе-псевдониме из JSON
  factory TypedefInfo.fromJson(Map<String, dynamic> json) =>
      _$TypedefInfoFromJson(json);

  /// Возвращает тип узла
  String get kind => when(
        (name, documentation, annotations, typeParameters, typeDefinition,
                location, isPublic) =>
            'typedef',
        function: (name, documentation, annotations, typeParameters,
                functionParameters, returnType, location, isPublic) =>
            'functionTypedef',
      );
}

/// {@template extension_type_info}
/// Модель для информации о расширенном типе (extension type)
/// {@endtemplate}
@freezed
class ExtensionTypeInfo with _$ExtensionTypeInfo {
  const ExtensionTypeInfo._();

  /// {@macro extension_type_info}
  const factory ExtensionTypeInfo({
    /// Имя типа
    @JsonKey(name: 'name') required String name,

    /// Документация типа
    @JsonKey(name: 'documentation') String? documentation,

    /// Аннотации типа
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Параметры типа (generic)
    @JsonKey(name: 'type_parameters') List<String>? typeParameters,

    /// Тип представления
    @JsonKey(name: 'representation_type') String? representationType,

    /// Реализуемые интерфейсы
    @JsonKey(name: 'interfaces') List<String>? interfaces,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Является ли тип публичным
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,
  }) = _ExtensionTypeInfo;

  /// Создаёт информацию о расширенном типе из JSON
  factory ExtensionTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$ExtensionTypeInfoFromJson(json);

  /// Возвращает тип узла
  String get kind => 'extensionType';
}
