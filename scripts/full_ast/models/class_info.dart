import 'ast_node.dart';
import 'declaration_info.dart';
import 'function_info.dart';

/// Модель для хранения информации о классе
class ClassInfo {
  /// Имя класса
  final String name;

  /// Документация класса
  final String? documentation;

  /// Является ли класс абстрактным
  final bool isAbstract;

  /// Родительский класс (от которого наследуется)
  final String? superclass;

  /// Реализуемые интерфейсы
  final List<String> interfaces;

  /// Используемые миксины
  final List<String> mixins;

  /// Ограничения типа (для миксинов с 'on')
  final List<String> onTypes;

  /// Параметры типа (generic-параметры)
  final List<String> typeParameters;

  /// Модификаторы класса
  final List<String> modifiers;

  /// Поля класса
  final List<FieldInfo> fields;

  /// Методы класса
  final List<MethodInfo> methods;

  /// Конструкторы класса
  final List<ConstructorInfo> constructors;

  /// Является ли класс миксином
  final bool isMixin;

  /// Является ли класс перечислением
  final bool isEnum;

  /// Является ли класс расширением
  final bool isExtension;

  /// Тип, для которого создано расширение (если класс - расширение)
  final String? onType;

  /// Константы перечисления (если класс - enum)
  final List<Map<String, dynamic>>? enumConstants;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создает информацию о классе
  ClassInfo({
    required this.name,
    this.documentation,
    this.isAbstract = false,
    this.superclass,
    this.interfaces = const [],
    this.mixins = const [],
    this.onTypes = const [],
    this.typeParameters = const [],
    this.modifiers = const [],
    this.fields = const [],
    this.methods = const [],
    this.constructors = const [],
    this.isMixin = false,
    this.isEnum = false,
    this.isExtension = false,
    this.onType,
    this.enumConstants,
    this.location,
  });

  /// Преобразует информацию о классе в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'documentation': documentation,
      'isAbstract': isAbstract,
      'superclass': superclass,
      'interfaces': interfaces,
      'mixins': mixins,
      'onTypes': isMixin ? onTypes : null,
      'typeParameters': typeParameters,
      'modifiers': modifiers,
      'fields': fields.map((field) => field.toJson()).toList(),
      'methods': methods.map((method) => method.toJson()).toList(),
      'constructors':
          constructors.map((constructor) => constructor.toJson()).toList(),
      'isMixin': isMixin,
      'isEnum': isEnum,
      'isExtension': isExtension,
      'onType': isExtension ? onType : null,
      'enumConstants': enumConstants,
      'location': location?.toJson(),
    };
  }

  /// Создает объект информации о классе из JSON
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      name: json['name'] as String,
      documentation: json['documentation'] as String?,
      isAbstract: json['isAbstract'] as bool? ?? false,
      superclass: json['superclass'] as String?,
      interfaces: (json['interfaces'] as List<dynamic>?)?.cast<String>() ?? [],
      mixins: (json['mixins'] as List<dynamic>?)?.cast<String>() ?? [],
      onTypes: (json['onTypes'] as List<dynamic>?)?.cast<String>() ?? [],
      typeParameters:
          (json['typeParameters'] as List<dynamic>?)?.cast<String>() ?? [],
      modifiers: (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? [],
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      methods: (json['methods'] as List<dynamic>?)
              ?.map((e) => MethodInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      constructors: (json['constructors'] as List<dynamic>?)
              ?.map((e) => ConstructorInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isMixin: json['isMixin'] as bool? ?? false,
      isEnum: json['isEnum'] as bool? ?? false,
      isExtension: json['isExtension'] as bool? ?? false,
      onType: json['onType'] as String?,
      enumConstants: (json['enumConstants'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Информация о поле класса
class FieldInfo {
  /// Имя поля
  final String name;

  /// Тип поля
  final String type;

  /// Является ли поле статическим
  final bool isStatic;

  /// Является ли поле final
  final bool isFinal;

  /// Является ли поле const
  final bool isConst;

  /// Является ли поле late
  final bool isLate;

  /// Документация поля
  final String? documentation;

  /// Инициализатор поля (если есть)
  final String? initializer;

  /// Модификаторы поля
  final List<String> modifiers;

  /// Является ли поле публичным
  final bool isPublic;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создает информацию о поле
  FieldInfo({
    required this.name,
    required this.type,
    this.isStatic = false,
    this.isFinal = false,
    this.isConst = false,
    this.isLate = false,
    this.documentation,
    this.initializer,
    this.modifiers = const [],
    this.isPublic = true,
    this.location,
  });

  /// Преобразует информацию о поле в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'isStatic': isStatic,
      'isFinal': isFinal,
      'isConst': isConst,
      'isLate': isLate,
      'documentation': documentation,
      'initializer': initializer,
      'modifiers': modifiers,
      'isPublic': isPublic,
      'location': location?.toJson(),
    };
  }

  /// Создает объект информации о поле из JSON
  factory FieldInfo.fromJson(Map<String, dynamic> json) {
    return FieldInfo(
      name: json['name'] as String,
      type: json['type'] as String,
      isStatic: json['isStatic'] as bool? ?? false,
      isFinal: json['isFinal'] as bool? ?? false,
      isConst: json['isConst'] as bool? ?? false,
      isLate: json['isLate'] as bool? ?? false,
      documentation: json['documentation'] as String?,
      initializer: json['initializer'] as String?,
      modifiers: (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? [],
      isPublic: json['isPublic'] as bool? ?? true,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Информация о методе класса
class MethodInfo {
  /// Имя метода
  final String name;

  /// Возвращаемый тип
  final String returnType;

  /// Параметры метода
  final List<ParameterInfo> parameters;

  /// Является ли метод статическим
  final bool isStatic;

  /// Является ли метод getter
  final bool isGetter;

  /// Является ли метод setter
  final bool isSetter;

  /// Является ли метод абстрактным
  final bool isAbstract;

  /// Является ли метод внешним (external)
  final bool isExternal;

  /// Является ли метод асинхронным
  final bool isAsynchronous;

  /// Является ли метод генератором
  final bool isGenerator;

  /// Сложность метода (цикломатическая)
  final int? complexity;

  /// Документация метода
  final String? documentation;

  /// Тело метода
  final String? body;

  /// Модификаторы метода
  final List<String> modifiers;

  /// Является ли метод переопределенным (override)
  final bool isOverride;

  /// Параметры типа метода (generic-параметры)
  final List<String>? typeParameters;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создает информацию о методе
  MethodInfo({
    required this.name,
    required this.returnType,
    required this.parameters,
    this.isStatic = false,
    this.isGetter = false,
    this.isSetter = false,
    this.isAbstract = false,
    this.isExternal = false,
    this.isAsynchronous = false,
    this.isGenerator = false,
    this.complexity,
    this.documentation,
    this.body,
    this.modifiers = const [],
    this.isOverride = false,
    this.typeParameters,
    this.location,
  });

  /// Преобразует информацию о методе в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'returnType': returnType,
      'parameters': parameters.map((param) => param.toJson()).toList(),
      'isStatic': isStatic,
      'isGetter': isGetter,
      'isSetter': isSetter,
      'isAbstract': isAbstract,
      'isExternal': isExternal,
      'isAsynchronous': isAsynchronous,
      'isGenerator': isGenerator,
      'complexity': complexity,
      'documentation': documentation,
      'body': body,
      'modifiers': modifiers,
      'isOverride': isOverride,
      'typeParameters': typeParameters,
      'location': location?.toJson(),
    };
  }

  /// Создает объект информации о методе из JSON
  factory MethodInfo.fromJson(Map<String, dynamic> json) {
    return MethodInfo(
      name: json['name'] as String,
      returnType: json['returnType'] as String,
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ParameterInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      isStatic: json['isStatic'] as bool? ?? false,
      isGetter: json['isGetter'] as bool? ?? false,
      isSetter: json['isSetter'] as bool? ?? false,
      isAbstract: json['isAbstract'] as bool? ?? false,
      isExternal: json['isExternal'] as bool? ?? false,
      isAsynchronous: json['isAsynchronous'] as bool? ?? false,
      isGenerator: json['isGenerator'] as bool? ?? false,
      complexity: json['complexity'] as int?,
      documentation: json['documentation'] as String?,
      body: json['body'] as String?,
      modifiers: (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? [],
      isOverride: json['isOverride'] as bool? ?? false,
      typeParameters:
          (json['typeParameters'] as List<dynamic>?)?.cast<String>(),
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Информация о конструкторе класса
class ConstructorInfo {
  /// Имя конструктора (пустая строка для безымянного конструктора)
  final String name;

  /// Параметры конструктора
  final List<ParameterInfo> parameters;

  /// Инициализаторы конструктора
  final List<String> initializers;

  /// Является ли конструктор константным
  final bool isConst;

  /// Является ли конструктор factory
  final bool isFactory;

  /// Является ли конструктор external
  final bool isExternal;

  /// Документация конструктора
  final String? documentation;

  /// Тело конструктора
  final String? body;

  /// Модификаторы конструктора
  final List<String> modifiers;

  /// Перенаправленный конструктор (если есть)
  final String? redirectedConstructor;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Создает информацию о конструкторе
  ConstructorInfo({
    required this.name,
    required this.parameters,
    this.initializers = const [],
    this.isConst = false,
    this.isFactory = false,
    this.isExternal = false,
    this.documentation,
    this.body,
    this.modifiers = const [],
    this.redirectedConstructor,
    this.location,
  });

  /// Преобразует информацию о конструкторе в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parameters': parameters.map((param) => param.toJson()).toList(),
      'initializers': initializers,
      'isConst': isConst,
      'isFactory': isFactory,
      'isExternal': isExternal,
      'documentation': documentation,
      'body': body,
      'modifiers': modifiers,
      'redirectedConstructor': redirectedConstructor,
      'location': location?.toJson(),
    };
  }

  /// Создает объект информации о конструкторе из JSON
  factory ConstructorInfo.fromJson(Map<String, dynamic> json) {
    return ConstructorInfo(
      name: json['name'] as String,
      parameters: (json['parameters'] as List<dynamic>)
          .map((e) => ParameterInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      initializers:
          (json['initializers'] as List<dynamic>?)?.cast<String>() ?? [],
      isConst: json['isConst'] as bool? ?? false,
      isFactory: json['isFactory'] as bool? ?? false,
      isExternal: json['isExternal'] as bool? ?? false,
      documentation: json['documentation'] as String?,
      body: json['body'] as String?,
      modifiers: (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? [],
      redirectedConstructor: json['redirectedConstructor'] as String?,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Модель для информации о константе перечисления
class EnumConstantInfo {
  /// Имя константы
  final String name;

  /// Документация константы
  final String? documentation;

  /// Аннотации константы
  final List<AnnotationInfo> annotations;

  /// Местоположение в коде
  final SourceLocation? location;

  /// Аргументы конструктора (если есть)
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
      'location': location?.toJson(),
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
          [],
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      constructorArguments: json['constructorArguments'] as String?,
    );
  }
}
