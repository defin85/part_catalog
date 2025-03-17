import 'package:freezed_annotation/freezed_annotation.dart';
import 'source_location.dart';

part 'declaration_info.freezed.dart';
part 'declaration_info.g.dart';

/// Модель для представления информации о декларациях в исходном коде
@freezed
class DeclarationInfo with _$DeclarationInfo {
  const DeclarationInfo._();

  /// Создаёт информацию о декларации
  const factory DeclarationInfo({
    /// Имя декларации
    @JsonKey(name: 'name') required String name,

    /// Тип декларации ('class', 'function', 'method', 'typedef', 'enum', etc.)
    @JsonKey(name: 'type') required String type,

    /// Является ли декларация публичной (не начинается с символа подчеркивания)
    @JsonKey(name: 'is_public') required bool isPublic,

    /// Расположение декларации в исходном коде
    @JsonKey(name: 'location') required SourceLocation location,

    /// Имя класса-владельца (для методов, полей и т.д., если применимо)
    @JsonKey(name: 'parent_name') String? parentName,

    /// Файл, в котором объявлена декларация
    @JsonKey(name: 'file_path') String? filePath,

    /// Дополнительные атрибуты декларации
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _DeclarationInfo;

  /// Создает объект из JSON
  factory DeclarationInfo.fromJson(Map<String, dynamic> json) =>
      _$DeclarationInfoFromJson(json);

  /// Тип узла для декларации
  String get nodeType => type;

  /// Возвращает полное квалифицированное имя декларации
  String get qualifiedName => parentName != null ? '$parentName.$name' : name;

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
@freezed
class ParameterInfo with _$ParameterInfo {
  const ParameterInfo._();

  /// Создаёт информацию о параметре
  const factory ParameterInfo({
    /// Имя параметра
    @JsonKey(name: 'name') required String name,

    /// Тип параметра
    @JsonKey(name: 'type') required String type,

    /// Значение по умолчанию (если есть)
    @JsonKey(name: 'default_value') String? defaultValue,

    /// Является ли параметр именованным
    @JsonKey(name: 'is_named') @Default(false) bool isNamed,

    /// Является ли параметр обязательным
    @JsonKey(name: 'is_required') @Default(true) bool isRequired,

    /// Является ли параметр позиционным
    @JsonKey(name: 'is_positional') @Default(true) bool isPositional,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,
  }) = _ParameterInfo;

  /// Создает объект из JSON
  factory ParameterInfo.fromJson(Map<String, dynamic> json) =>
      _$ParameterInfoFromJson(json);

  /// Возвращает строковое представление параметра в синтаксисе Dart
  @override
  String toString() {
    final buffer = StringBuffer();

    if (isNamed) {
      if (isRequired) buffer.write('required ');
      buffer.write('$type $name');
      if (defaultValue != null) buffer.write(' = $defaultValue');
    } else if (!isRequired && isPositional) {
      buffer.write('[$type $name');
      if (defaultValue != null) buffer.write(' = $defaultValue');
      buffer.write(']');
    } else {
      buffer.write('$type $name');
    }

    return buffer.toString();
  }
}
