import 'ast_node.dart';

/// Информация о зависимости между компонентами кода
class DependencyInfo {
  /// Имя исходного компонента
  final String sourceName;

  /// Тип исходного компонента (класс, метод, функция и т.д.)
  final String sourceType;

  /// Имя целевого компонента
  final String targetName;

  /// Тип целевого компонента (класс, метод, функция и т.д.)
  final String targetType;

  /// Тип зависимости (наследование, реализация, использование и т.д.)
  final String dependencyType;

  /// Файл исходного компонента
  final String? sourceFile;

  /// Файл целевого компонента (если известен)
  final String? targetFile;

  /// Местоположение в исходном коде
  final SourceLocation? location;

  /// Дополнительные атрибуты зависимости
  final Map<String, dynamic>? attributes;

  /// Конструктор для создания информации о зависимости
  DependencyInfo({
    required this.sourceName,
    required this.sourceType,
    required this.targetName,
    required this.targetType,
    required this.dependencyType,
    this.sourceFile,
    this.targetFile,
    this.location,
    this.attributes,
  });

  /// Создает объект зависимости из JSON
  factory DependencyInfo.fromJson(Map<String, dynamic> json) {
    return DependencyInfo(
      sourceName: json['sourceName'] as String,
      sourceType: json['sourceType'] as String,
      targetName: json['targetName'] as String,
      targetType: json['targetType'] as String,
      dependencyType: json['dependencyType'] as String,
      sourceFile: json['sourceFile'] as String?,
      targetFile: json['targetFile'] as String?,
      location: json['location'] != null
          ? SourceLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      attributes: json['attributes'] as Map<String, dynamic>?,
    );
  }

  /// Преобразует объект зависимости в JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceName': sourceName,
      'sourceType': sourceType,
      'targetName': targetName,
      'targetType': targetType,
      'dependencyType': dependencyType,
      if (sourceFile != null) 'sourceFile': sourceFile,
      if (targetFile != null) 'targetFile': targetFile,
      if (location != null) 'location': location!.toJson(),
      if (attributes != null) 'attributes': attributes,
    };
  }

  /// Строковое представление зависимости
  @override
  String toString() {
    return '$sourceType: $sourceName --> $targetType: $targetName ($dependencyType)';
  }
}

/// Специализированная информация о зависимости наследования
class InheritanceDependency extends DependencyInfo {
  InheritanceDependency({
    required super.sourceName,
    required super.targetName,
    super.sourceFile,
    super.targetFile,
    super.location,
    super.attributes,
  }) : super(
          sourceType: 'class',
          targetType: 'class',
          dependencyType: 'extends',
        );
}

/// Специализированная информация о зависимости реализации интерфейса
class ImplementsDependency extends DependencyInfo {
  ImplementsDependency({
    required super.sourceName,
    required super.targetName,
    super.sourceFile,
    super.targetFile,
    super.location,
    super.attributes,
  }) : super(
          sourceType: 'class',
          targetType: 'interface',
          dependencyType: 'implements',
        );
}

/// Специализированная информация о зависимости использования миксина
class WithDependency extends DependencyInfo {
  WithDependency({
    required super.sourceName,
    required super.targetName,
    super.sourceFile,
    super.targetFile,
    super.location,
    super.attributes,
  }) : super(
          sourceType: 'class',
          targetType: 'mixin',
          dependencyType: 'with',
        );
}

/// Специализированная информация о зависимости вызова метода
class MethodCallDependency extends DependencyInfo {
  MethodCallDependency({
    required super.sourceName,
    required super.targetName,
    required super.sourceType,
    super.sourceFile,
    super.targetFile,
    super.location,
    super.attributes,
  }) : super(
          targetType: 'method',
          dependencyType: 'calls',
        );
}

/// Специализированная информация о зависимости создания экземпляра класса
class InstantiateDependency extends DependencyInfo {
  InstantiateDependency({
    required super.sourceName,
    required super.sourceType,
    required super.targetName,
    super.sourceFile,
    super.targetFile,
    super.location,
    super.attributes,
  }) : super(
          targetType: 'class',
          dependencyType: 'instantiates',
        );
}

/// Специализированная информация о зависимости использования поля
class FieldAccessDependency extends DependencyInfo {
  FieldAccessDependency({
    required super.sourceName,
    required super.sourceType,
    required String targetName,
    required String targetClassName,
    super.sourceFile,
    super.targetFile,
    super.location,
    super.attributes,
  }) : super(
          targetName: '$targetClassName.$targetName',
          targetType: 'field',
          dependencyType: 'accesses',
        );
}

/// Специализированная информация о зависимости использования типа
class TypeUsageDependency extends DependencyInfo {
  TypeUsageDependency({
    required super.sourceName,
    required super.sourceType,
    required super.targetName,
    super.sourceFile,
    super.targetFile,
    super.location,
    Map<String, dynamic>? attributes,
    String usageContext = 'declaration',
  }) : super(
          targetType: 'type',
          dependencyType: 'uses',
          attributes: {
            ...?attributes,
            'usageContext': usageContext,
          },
        );
}

/// Тип взаимосвязи между зависимостями
enum DependencyRelation {
  /// Одностороннее использование
  oneWay,

  /// Взаимное использование (циклическая зависимость)
  mutual,

  /// Сильная связь (высокая степень связанности)
  strong,

  /// Слабая связь (низкая степень связанности)
  weak,
}

/// Информация о внутренних зависимостях между компонентами
class InternalDependency {
  /// Тип исходного компонента (класс, интерфейс, метод и т.д.)
  final String sourceType;

  /// Имя исходного компонента
  final String sourceName;

  /// Тип целевого компонента (класс, интерфейс, метод и т.д.)
  final String targetType;

  /// Имя целевого компонента
  final String targetName;

  /// Тип зависимости (extends, implements, calls, uses и т.д.)
  final String dependencyType;

  /// Вес зависимости (для количественной оценки)
  final int weight;

  /// Конструктор для создания информации о внутренней зависимости
  InternalDependency({
    required this.sourceType,
    required this.sourceName,
    required this.targetType,
    required this.targetName,
    required this.dependencyType,
    this.weight = 1,
  });

  /// Преобразует объект внутренней зависимости в JSON
  Map<String, dynamic> toJson() {
    return {
      'sourceType': sourceType,
      'sourceName': sourceName,
      'targetType': targetType,
      'targetName': targetName,
      'dependencyType': dependencyType,
      'weight': weight,
    };
  }

  /// Создает объект внутренней зависимости из JSON
  factory InternalDependency.fromJson(Map<String, dynamic> json) {
    return InternalDependency(
      sourceType: json['sourceType'] as String,
      sourceName: json['sourceName'] as String,
      targetType: json['targetType'] as String,
      targetName: json['targetName'] as String,
      dependencyType: json['dependencyType'] as String,
      weight: json['weight'] as int? ?? 1,
    );
  }

  /// Строковое представление внутренней зависимости
  @override
  String toString() {
    return '$sourceType:$sourceName $dependencyType $targetType:$targetName';
  }
}
