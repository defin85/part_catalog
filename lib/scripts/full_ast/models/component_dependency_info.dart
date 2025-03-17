import 'package:freezed_annotation/freezed_annotation.dart';
import 'source_location.dart';

part 'component_dependency_info.freezed.dart';
part 'component_dependency_info.g.dart';

/// {@template dependency_info}
/// Информация о зависимости между компонентами кода
/// {@endtemplate}
@freezed
class ComponentDependencyInfo with _$ComponentDependencyInfo {
  const ComponentDependencyInfo._();

  /// {@macro dependency_info}
  const factory ComponentDependencyInfo({
    /// Имя исходного компонента
    @JsonKey(name: 'source_name') required String sourceName,

    /// Тип исходного компонента (класс, метод, функция и т.д.)
    @JsonKey(name: 'source_type') required String sourceType,

    /// Имя целевого компонента
    @JsonKey(name: 'target_name') required String targetName,

    /// Тип целевого компонента (класс, метод, функция и т.д.)
    @JsonKey(name: 'target_type') required String targetType,

    /// Тип зависимости (наследование, реализация, использование и т.д.)
    @JsonKey(name: 'dependency_type') required String dependencyType,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента (если известен)
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты зависимости
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _ComponentDependencyInfo;

  /// Создает объект зависимости из JSON
  factory ComponentDependencyInfo.fromJson(Map<String, dynamic> json) =>
      _$ComponentDependencyInfoFromJson(json);

  /// Строковое представление зависимости
  @override
  String toString() =>
      '$sourceType: $sourceName --> $targetType: $targetName ($dependencyType)';
}

/// {@template inheritance_dependency}
/// Специализированная информация о зависимости наследования
/// {@endtemplate}
@freezed
class InheritanceDependency with _$InheritanceDependency {
  const InheritanceDependency._();

  /// {@macro inheritance_dependency}
  const factory InheritanceDependency({
    /// Имя исходного класса
    @JsonKey(name: 'source_name') required String sourceName,

    /// Имя целевого класса
    @JsonKey(name: 'target_name') required String targetName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _InheritanceDependency;

  /// Создает объект из JSON
  factory InheritanceDependency.fromJson(Map<String, dynamic> json) =>
      _$InheritanceDependencyFromJson(json);

  /// Тип исходного компонента (всегда 'class')
  String get sourceType => 'class';

  /// Тип целевого компонента (всегда 'class')
  String get targetType => 'class';

  /// Тип зависимости (всегда 'extends')
  String get dependencyType => 'extends';
}

/// {@template implements_dependency}
/// Специализированная информация о зависимости реализации интерфейса
/// {@endtemplate}
@freezed
class ImplementsDependency with _$ImplementsDependency {
  const ImplementsDependency._();

  /// {@macro implements_dependency}
  const factory ImplementsDependency({
    /// Имя исходного класса
    @JsonKey(name: 'source_name') required String sourceName,

    /// Имя целевого интерфейса
    @JsonKey(name: 'target_name') required String targetName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _ImplementsDependency;

  /// Создает объект из JSON
  factory ImplementsDependency.fromJson(Map<String, dynamic> json) =>
      _$ImplementsDependencyFromJson(json);

  /// Тип исходного компонента (всегда 'class')
  String get sourceType => 'class';

  /// Тип целевого компонента (всегда 'interface')
  String get targetType => 'interface';

  /// Тип зависимости (всегда 'implements')
  String get dependencyType => 'implements';
}

/// {@template with_dependency}
/// Специализированная информация о зависимости использования миксина
/// {@endtemplate}
@freezed
class WithDependency with _$WithDependency {
  const WithDependency._();

  /// {@macro with_dependency}
  const factory WithDependency({
    /// Имя исходного класса
    @JsonKey(name: 'source_name') required String sourceName,

    /// Имя целевого миксина
    @JsonKey(name: 'target_name') required String targetName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _WithDependency;

  /// Создает объект из JSON
  factory WithDependency.fromJson(Map<String, dynamic> json) =>
      _$WithDependencyFromJson(json);

  /// Тип исходного компонента (всегда 'class')
  String get sourceType => 'class';

  /// Тип целевого компонента (всегда 'mixin')
  String get targetType => 'mixin';

  /// Тип зависимости (всегда 'with')
  String get dependencyType => 'with';
}

/// {@template method_call_dependency}
/// Специализированная информация о зависимости вызова метода
/// {@endtemplate}
@freezed
class MethodCallDependency with _$MethodCallDependency {
  const MethodCallDependency._();

  /// {@macro method_call_dependency}
  const factory MethodCallDependency({
    /// Имя исходного компонента
    @JsonKey(name: 'source_name') required String sourceName,

    /// Тип исходного компонента
    @JsonKey(name: 'source_type') required String sourceType,

    /// Имя целевого метода
    @JsonKey(name: 'target_name') required String targetName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _MethodCallDependency;

  /// Создает объект из JSON
  factory MethodCallDependency.fromJson(Map<String, dynamic> json) =>
      _$MethodCallDependencyFromJson(json);

  /// Тип целевого компонента (всегда 'method')
  String get targetType => 'method';

  /// Тип зависимости (всегда 'calls')
  String get dependencyType => 'calls';
}

/// {@template instantiate_dependency}
/// Специализированная информация о зависимости создания экземпляра класса
/// {@endtemplate}
@freezed
class InstantiateDependency with _$InstantiateDependency {
  const InstantiateDependency._();

  /// {@macro instantiate_dependency}
  const factory InstantiateDependency({
    /// Имя исходного компонента
    @JsonKey(name: 'source_name') required String sourceName,

    /// Тип исходного компонента
    @JsonKey(name: 'source_type') required String sourceType,

    /// Имя создаваемого класса
    @JsonKey(name: 'target_name') required String targetName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _InstantiateDependency;

  /// Создает объект из JSON
  factory InstantiateDependency.fromJson(Map<String, dynamic> json) =>
      _$InstantiateDependencyFromJson(json);

  /// Тип целевого компонента (всегда 'class')
  String get targetType => 'class';

  /// Тип зависимости (всегда 'instantiates')
  String get dependencyType => 'instantiates';
}

/// {@template field_access_dependency}
/// Специализированная информация о зависимости использования поля
/// {@endtemplate}
@freezed
class FieldAccessDependency with _$FieldAccessDependency {
  const FieldAccessDependency._();

  /// {@macro field_access_dependency}
  const factory FieldAccessDependency({
    /// Имя исходного компонента
    @JsonKey(name: 'source_name') required String sourceName,

    /// Тип исходного компонента
    @JsonKey(name: 'source_type') required String sourceType,

    /// Имя поля
    @JsonKey(name: 'field_name') required String fieldName,

    /// Имя класса, которому принадлежит поле
    @JsonKey(name: 'target_class_name') required String targetClassName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _FieldAccessDependency;

  /// Создает объект из JSON
  factory FieldAccessDependency.fromJson(Map<String, dynamic> json) =>
      _$FieldAccessDependencyFromJson(json);

  /// Тип целевого компонента (всегда 'field')
  String get targetType => 'field';

  /// Тип зависимости (всегда 'accesses')
  String get dependencyType => 'accesses';

  /// Полное имя поля, включая класс
  String get targetName => '$targetClassName.$fieldName';
}

/// {@template type_usage_dependency}
/// Специализированная информация о зависимости использования типа
/// {@endtemplate}
@freezed
class TypeUsageDependency with _$TypeUsageDependency {
  const TypeUsageDependency._();

  /// {@macro type_usage_dependency}
  const factory TypeUsageDependency({
    /// Имя исходного компонента
    @JsonKey(name: 'source_name') required String sourceName,

    /// Тип исходного компонента
    @JsonKey(name: 'source_type') required String sourceType,

    /// Имя используемого типа
    @JsonKey(name: 'target_name') required String targetName,

    /// Файл исходного компонента
    @JsonKey(name: 'source_file') String? sourceFile,

    /// Файл целевого компонента
    @JsonKey(name: 'target_file') String? targetFile,

    /// Местоположение в исходном коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Контекст использования типа
    @JsonKey(name: 'usage_context') @Default('declaration') String usageContext,

    /// Дополнительные атрибуты
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _TypeUsageDependency;

  /// Создает объект из JSON
  factory TypeUsageDependency.fromJson(Map<String, dynamic> json) =>
      _$TypeUsageDependencyFromJson(json);

  /// Тип целевого компонента (всегда 'type')
  String get targetType => 'type';

  /// Тип зависимости (всегда 'uses')
  String get dependencyType => 'uses';
}

/// Тип взаимосвязи между зависимостями
enum DependencyRelation {
  /// Одностороннее использование
  @JsonValue('one_way')
  oneWay,

  /// Взаимное использование (циклическая зависимость)
  @JsonValue('mutual')
  mutual,

  /// Сильная связь (высокая степень связанности)
  @JsonValue('strong')
  strong,

  /// Слабая связь (низкая степень связанности)
  @JsonValue('weak')
  weak,
}

/// {@template internal_dependency}
/// Информация о внутренних зависимостях между компонентами
/// {@endtemplate}
@freezed
class InternalDependency with _$InternalDependency {
  const InternalDependency._();

  /// {@macro internal_dependency}
  const factory InternalDependency({
    /// Тип исходного компонента (класс, интерфейс, метод и т.д.)
    @JsonKey(name: 'source_type') required String sourceType,

    /// Имя исходного компонента
    @JsonKey(name: 'source_name') required String sourceName,

    /// Тип целевого компонента (класс, интерфейс, метод и т.д.)
    @JsonKey(name: 'target_type') required String targetType,

    /// Имя целевого компонента
    @JsonKey(name: 'target_name') required String targetName,

    /// Тип зависимости (extends, implements, calls, uses и т.д.)
    @JsonKey(name: 'dependency_type') required String dependencyType,

    /// Вес зависимости (для количественной оценки)
    @JsonKey(name: 'weight') @Default(1) int weight,
  }) = _InternalDependency;

  /// Создает объект из JSON
  factory InternalDependency.fromJson(Map<String, dynamic> json) =>
      _$InternalDependencyFromJson(json);

  /// Строковое представление внутренней зависимости
  @override
  String toString() =>
      '$sourceType:$sourceName $dependencyType $targetType:$targetName';
}
