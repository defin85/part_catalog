import 'ast_node.dart';

/// Модель для представления информации о декларациях (классы, функции, методы и т.д.)
/// в исходном коде
class DeclarationInfo {
  /// Имя декларации
  final String name;

  /// Тип декларации ('class', 'function', 'method', 'typedef', 'enum', и т.д.)
  final String type;

  /// Является ли декларация публичной (не начинается с символа подчеркивания)
  final bool isPublic;

  /// Расположение декларации в исходном коде
  final SourceLocation location;

  /// Имя класса-владельца (для методов, полей и т.д., если применимо)
  final String? parentName;

  /// Файл, в котором объявлена декларация
  final String? filePath;

  /// Дополнительные атрибуты декларации
  final Map<String, dynamic>? attributes;

  /// Создаёт информацию о декларации
  DeclarationInfo({
    required this.name,
    required this.type,
    required this.isPublic,
    required this.location,
    this.parentName,
    this.filePath,
    this.attributes,
  });

  /// Преобразует информацию о декларации в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'isPublic': isPublic,
      'location': location.toJson(),
      'parentName': parentName,
      'filePath': filePath,
      'attributes': attributes,
    };
  }

  /// Создаёт информацию о декларации из JSON
  factory DeclarationInfo.fromJson(Map<String, dynamic> json) {
    return DeclarationInfo(
      name: json['name'] as String,
      type: json['type'] as String,
      isPublic: json['isPublic'] as bool,
      location:
          SourceLocation.fromJson(json['location'] as Map<String, dynamic>),
      parentName: json['parentName'] as String?,
      filePath: json['filePath'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
    );
  }

  /// Возвращает полное квалифицированное имя декларации
  String get qualifiedName {
    return parentName != null ? '$parentName.$name' : name;
  }

  /// Возвращает строковое представление декларации
  @override
  String toString() {
    return '${isPublic ? "public" : "private"} $type $qualifiedName';
  }

  /// Параметры типа (для дженериков)
  List<String>? get typeParameters =>
      attributes != null && attributes!.containsKey('typeParameters')
          ? List<String>.from(attributes!['typeParameters'])
          : null;

  /// Возвращаемый тип (для функций и методов)
  String? get returnType =>
      attributes != null ? attributes!['returnType'] as String? : null;
}

/// Модель для представления параметров функций и методов
class ParameterInfo {
  /// Имя параметра
  final String name;

  /// Тип параметра
  final String type;

  /// Значение по умолчанию (если есть)
  final String? defaultValue;

  /// Является ли параметр именованным
  final bool isNamed;

  /// Является ли параметр обязательным
  final bool isRequired;

  /// Является ли параметр позиционным
  final bool isPositional;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создаёт информацию о параметре
  ParameterInfo({
    required this.name,
    required this.type,
    this.defaultValue,
    this.isNamed = false,
    this.isRequired = true,
    this.isPositional = true,
    this.location,
  });

  /// Преобразует информацию о параметре в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'defaultValue': defaultValue,
      'isNamed': isNamed,
      'isRequired': isRequired,
      'isPositional': isPositional,
      'location': location?.toJson(),
    };
  }

  /// Создаёт информацию о параметре из JSON
  factory ParameterInfo.fromJson(Map<String, dynamic> json) {
    return ParameterInfo(
      name: json['name'] as String,
      type: json['type'] as String,
      defaultValue: json['defaultValue'] as String?,
      isNamed: json['isNamed'] as bool? ?? false,
      isRequired: json['isRequired'] as bool? ?? true,
      isPositional: json['isPositional'] as bool? ?? true,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Возвращает строковое представление параметра в синтаксисе Dart
  @override
  String toString() {
    final buffer = StringBuffer();

    // Для именованных параметров
    if (isNamed) {
      if (isRequired) {
        buffer.write('required ');
      }
      buffer.write('$type $name');
      if (defaultValue != null) {
        buffer.write(' = $defaultValue');
      }
    }
    // Для позиционных необязательных параметров
    else if (!isRequired && isPositional) {
      buffer.write('[$type $name');
      if (defaultValue != null) {
        buffer.write(' = $defaultValue');
      }
      buffer.write(']');
    }
    // Для обязательных позиционных параметров
    else {
      buffer.write('$type $name');
    }

    return buffer.toString();
  }
}

/// Модель для представления информации о типе данных
class TypeInfo {
  /// Имя типа
  final String name;

  /// Вид типа (enum, typedef, class, etc.)
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
}

/// Модель для информации о константе перечисления
class EnumConstantInfo {
  /// Имя константы перечисления
  final String name;

  /// Документация константы (если есть)
  final String? documentation;

  /// Аннотации константы
  final List<AnnotationInfo> annotations;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Аргументы конструктора (для enum с параметрами в Dart 2.17+)
  final String? constructorArguments;

  /// Создает информацию о константе перечисления
  EnumConstantInfo({
    required this.name,
    this.documentation,
    this.annotations = const [],
    this.location,
    this.constructorArguments,
  });

  /// Преобразует информацию о константе в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'documentation': documentation,
      'annotations': annotations.map((a) => a.toJson()).toList(),
      if (location != null) 'location': location!.toJson(),
      if (constructorArguments != null)
        'constructorArguments': constructorArguments,
    };
  }

  /// Создает объект информации о константе из JSON
  factory EnumConstantInfo.fromJson(Map<String, dynamic> json) {
    return EnumConstantInfo(
      name: json['name'] as String,
      documentation: json['documentation'] as String?,
      annotations: (json['annotations'] as List<dynamic>?)
              ?.map((e) => AnnotationInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      constructorArguments: json['constructorArguments'] as String?,
    );
  }
}
