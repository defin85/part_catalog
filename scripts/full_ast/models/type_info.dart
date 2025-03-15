import 'ast_node.dart';
import 'declaration_info.dart';

/// Модель для хранения информации о типах данных
/// (enum, typedef, class, mixin, extension и т.д.)
class TypeInfo {
  /// Имя типа
  final String name;

  /// Вид типа (enum, typedef, class, extensionType, etc.)
  final String kind;

  /// Является ли тип публичным
  final bool isPublic;

  /// Документация типа
  final String? documentation;

  /// Аннотации типа
  final List<AnnotationInfo> annotations;

  /// Константы перечисления (для enum)
  final List<EnumConstantInfo>? enumConstants;

  /// Реализуемые интерфейсы
  final List<String>? interfaces;

  /// Используемые миксины (для классов)
  final List<String>? mixins;

  /// Параметры типа (generic)
  final List<String>? typeParameters;

  /// Определение типа (для typedef)
  final String? typeDefinition;

  /// Параметры функционального typedef
  final List<String>? functionParameters;

  /// Возвращаемый тип (для функциональных typedef)
  final String? returnType;

  /// Тип представления (для extension types)
  final String? representationType;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создаёт информацию о типе
  TypeInfo({
    required this.name,
    required this.kind,
    required this.isPublic,
    this.documentation,
    this.annotations = const [],
    this.enumConstants,
    this.interfaces,
    this.mixins,
    this.typeParameters,
    this.typeDefinition,
    this.functionParameters,
    this.returnType,
    this.representationType,
    this.location,
  });

  /// Преобразует информацию о типе в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'kind': kind,
      'isPublic': isPublic,
      'documentation': documentation,
      'annotations': annotations.map((a) => a.toJson()).toList(),
      if (enumConstants != null)
        'enumConstants': enumConstants!.map((c) => c.toJson()).toList(),
      if (interfaces != null) 'interfaces': interfaces,
      if (mixins != null) 'mixins': mixins,
      if (typeParameters != null) 'typeParameters': typeParameters,
      if (typeDefinition != null) 'typeDefinition': typeDefinition,
      if (functionParameters != null) 'functionParameters': functionParameters,
      if (returnType != null) 'returnType': returnType,
      if (representationType != null) 'representationType': representationType,
      if (location != null) 'location': location!.toJson(),
    };
  }

  /// Создаёт информацию о типе из JSON
  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    return TypeInfo(
      name: json['name'] as String,
      kind: json['kind'] as String,
      isPublic: json['isPublic'] as bool,
      documentation: json['documentation'] as String?,
      annotations: (json['annotations'] as List<dynamic>?)
              ?.map((e) => AnnotationInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enumConstants: (json['enumConstants'] as List<dynamic>?)
          ?.map((e) => EnumConstantInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      interfaces: (json['interfaces'] as List<dynamic>?)?.cast<String>(),
      mixins: (json['mixins'] as List<dynamic>?)?.cast<String>(),
      typeParameters:
          (json['typeParameters'] as List<dynamic>?)?.cast<String>(),
      typeDefinition: json['typeDefinition'] as String?,
      functionParameters:
          (json['functionParameters'] as List<dynamic>?)?.cast<String>(),
      returnType: json['returnType'] as String?,
      representationType: json['representationType'] as String?,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Возвращает строковое представление типа данных
  @override
  String toString() {
    return '$kind $name';
  }

  /// Проверяет, является ли тип enum
  bool get isEnum => kind == 'enum';

  /// Проверяет, является ли тип typedef
  bool get isTypedef => kind == 'typedef' || kind == 'functionTypedef';

  /// Проверяет, является ли тип extension type
  bool get isExtensionType => kind == 'extensionType';

  /// Создаёт копию типа с измененными параметрами
  TypeInfo copyWith({
    String? name,
    String? kind,
    bool? isPublic,
    String? documentation,
    List<AnnotationInfo>? annotations,
    List<EnumConstantInfo>? enumConstants,
    List<String>? interfaces,
    List<String>? mixins,
    List<String>? typeParameters,
    String? typeDefinition,
    List<String>? functionParameters,
    String? returnType,
    String? representationType,
    SourceLocation? location,
  }) {
    return TypeInfo(
      name: name ?? this.name,
      kind: kind ?? this.kind,
      isPublic: isPublic ?? this.isPublic,
      documentation: documentation ?? this.documentation,
      annotations: annotations ?? this.annotations,
      enumConstants: enumConstants ?? this.enumConstants,
      interfaces: interfaces ?? this.interfaces,
      mixins: mixins ?? this.mixins,
      typeParameters: typeParameters ?? this.typeParameters,
      typeDefinition: typeDefinition ?? this.typeDefinition,
      functionParameters: functionParameters ?? this.functionParameters,
      returnType: returnType ?? this.returnType,
      representationType: representationType ?? this.representationType,
      location: location ?? this.location,
    );
  }
}

/// Модель для представления информации о generic-типах
class GenericTypeInfo {
  /// Имя типового параметра
  final String name;

  /// Ограничение типа (extends)
  final String? bound;

  /// Является ли параметр ковариантным (covariant)
  final bool isCovariant;

  /// Создаёт информацию о generic-типе
  GenericTypeInfo({
    required this.name,
    this.bound,
    this.isCovariant = false,
  });

  /// Преобразует информацию о generic-типе в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bound': bound,
      'isCovariant': isCovariant,
    };
  }

  /// Создаёт информацию о generic-типе из JSON
  factory GenericTypeInfo.fromJson(Map<String, dynamic> json) {
    return GenericTypeInfo(
      name: json['name'] as String,
      bound: json['bound'] as String?,
      isCovariant: json['isCovariant'] as bool? ?? false,
    );
  }

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

/// Модель для информации о записи типа данных (record type)
class RecordTypeInfo {
  /// Поля записи
  final List<RecordFieldInfo> fields;

  /// Создаёт информацию о записи типа данных
  RecordTypeInfo({
    required this.fields,
  });

  /// Преобразует информацию о записи типа данных в JSON
  Map<String, dynamic> toJson() {
    return {
      'fields': fields.map((f) => f.toJson()).toList(),
    };
  }

  /// Создаёт информацию о записи типа данных из JSON
  factory RecordTypeInfo.fromJson(Map<String, dynamic> json) {
    return RecordTypeInfo(
      fields: (json['fields'] as List<dynamic>)
          .map((e) => RecordFieldInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Возвращает строковое представление записи типа данных
  @override
  String toString() {
    final fieldStrings = fields.map((f) => f.toString()).join(', ');
    return '($fieldStrings)';
  }
}

/// Модель для информации о поле записи типа данных
class RecordFieldInfo {
  /// Имя поля (может быть пустым для позиционных полей)
  final String? name;

  /// Тип поля
  final String type;

  /// Является ли поле именованным
  final bool isNamed;

  /// Создаёт информацию о поле записи типа данных
  RecordFieldInfo({
    this.name,
    required this.type,
    this.isNamed = false,
  });

  /// Преобразует информацию о поле записи типа данных в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'isNamed': isNamed,
    };
  }

  /// Создаёт информацию о поле записи типа данных из JSON
  factory RecordFieldInfo.fromJson(Map<String, dynamic> json) {
    return RecordFieldInfo(
      name: json['name'] as String?,
      type: json['type'] as String,
      isNamed: json['isNamed'] as bool? ?? false,
    );
  }

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

/// Модель для информации о перечисляемом типе (enum)
class EnumInfo extends TypeInfo {
  /// Создаёт информацию о перечисляемом типе
  EnumInfo({
    required super.name,
    super.documentation,
    super.annotations = const [],
    super.enumConstants,
    super.interfaces,
    super.mixins,
    super.location,
    super.isPublic = true,
  }) : super(kind: 'enum');

  /// Создаёт информацию о перечисляемом типе из JSON
  factory EnumInfo.fromJson(Map<String, dynamic> json) {
    return EnumInfo(
      name: json['name'] as String,
      documentation: json['documentation'] as String?,
      annotations: (json['annotations'] as List<dynamic>?)
              ?.map((e) => AnnotationInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enumConstants: (json['enumConstants'] as List<dynamic>?)
          ?.map((e) => EnumConstantInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      interfaces: (json['interfaces'] as List<dynamic>?)?.cast<String>(),
      mixins: (json['mixins'] as List<dynamic>?)?.cast<String>(),
      isPublic: json['isPublic'] as bool? ?? true,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Модель для информации о типе-псевдониме (typedef)
class TypedefInfo extends TypeInfo {
  /// Создаёт информацию о типе-псевдониме
  TypedefInfo({
    required super.name,
    super.documentation,
    super.annotations = const [],
    super.typeParameters,
    super.typeDefinition,
    super.functionParameters,
    super.returnType,
    super.location,
    super.isPublic = true,
    bool isFunction = false,
  }) : super(kind: isFunction ? 'functionTypedef' : 'typedef');

  /// Создаёт информацию о типе-псевдониме из JSON
  factory TypedefInfo.fromJson(Map<String, dynamic> json) {
    final isFunction = json['kind'] == 'functionTypedef';
    return TypedefInfo(
      name: json['name'] as String,
      documentation: json['documentation'] as String?,
      annotations: (json['annotations'] as List<dynamic>?)
              ?.map((e) => AnnotationInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      typeParameters:
          (json['typeParameters'] as List<dynamic>?)?.cast<String>(),
      typeDefinition: json['typeDefinition'] as String?,
      functionParameters:
          (json['functionParameters'] as List<dynamic>?)?.cast<String>(),
      returnType: json['returnType'] as String?,
      isPublic: json['isPublic'] as bool? ?? true,
      isFunction: isFunction,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Модель для информации о расширенном типе (extension type)
class ExtensionTypeInfo extends TypeInfo {
  /// Создаёт информацию о расширенном типе
  ExtensionTypeInfo({
    required super.name,
    super.documentation,
    super.annotations = const [],
    super.typeParameters,
    super.representationType,
    super.interfaces,
    super.location,
    super.isPublic = true,
  }) : super(kind: 'extensionType');

  /// Создаёт информацию о расширенном типе из JSON
  factory ExtensionTypeInfo.fromJson(Map<String, dynamic> json) {
    return ExtensionTypeInfo(
      name: json['name'] as String,
      documentation: json['documentation'] as String?,
      annotations: (json['annotations'] as List<dynamic>?)
              ?.map((e) => AnnotationInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      typeParameters:
          (json['typeParameters'] as List<dynamic>?)?.cast<String>(),
      representationType: json['representationType'] as String?,
      interfaces: (json['interfaces'] as List<dynamic>?)?.cast<String>(),
      isPublic: json['isPublic'] as bool? ?? true,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}
