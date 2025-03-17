import 'package:freezed_annotation/freezed_annotation.dart';
import 'declaration_info.dart';
import 'source_location.dart';

part 'variable_info.freezed.dart';
part 'variable_info.g.dart';

/// {@template variable_info}
/// Информация о переменной в коде.
/// {@endtemplate}
@freezed
class VariableInfo with _$VariableInfo {
  const VariableInfo._();

  /// {@macro variable_info}
  const factory VariableInfo({
    /// Имя переменной
    @JsonKey(name: 'name') required String name,

    /// Тип переменной
    @JsonKey(name: 'type') required String type,

    /// Является ли константой
    @JsonKey(name: 'is_const') @Default(false) bool isConst,

    /// Является ли final
    @JsonKey(name: 'is_final') @Default(false) bool isFinal,

    /// Является ли static
    @JsonKey(name: 'is_static') @Default(false) bool isStatic,

    /// Имеет ли модификатор late
    @JsonKey(name: 'is_late') @Default(false) bool isLate,

    /// Начальное значение переменной (если есть)
    @JsonKey(name: 'initial_value') String? initialValue,

    /// Документация к переменной
    @JsonKey(name: 'documentation') String? documentation,

    /// Положение в коде
    @JsonKey(name: 'location') required SourceLocation location,

    /// Аннотации переменной
    @JsonKey(name: 'annotations') @Default([]) List<String> annotations,

    /// Путь к файлу, содержащему переменную
    @JsonKey(name: 'file_path') String? filePath,

    /// Является ли переменная публичной
    @JsonKey(name: 'is_public') @Default(true) bool isPublic,

    /// Имя родительского элемента (класс, миксин и т.д.)
    @JsonKey(name: 'parent_name') String? parentName,

    /// Дополнительные атрибуты переменной
    @JsonKey(name: 'attributes') Map<String, dynamic>? attributes,
  }) = _VariableInfo;

  /// Создает экземпляр из JSON
  factory VariableInfo.fromJson(Map<String, dynamic> json) =>
      _$VariableInfoFromJson(json);

  /// Преобразует переменную в базовую информацию о декларации
  DeclarationInfo toDeclarationInfo() {
    return DeclarationInfo(
      name: name,
      type: 'variable',
      isPublic: isPublic,
      location: location,
      parentName: parentName,
      filePath: filePath,
      attributes: {
        ...?attributes,
        'isConst': isConst,
        'isFinal': isFinal,
        'isStatic': isStatic,
        'isLate': isLate,
        'initialValue': initialValue,
        'varType': type,
      },
    );
  }

  /// Тип узла для переменной
  String get nodeType => 'variable';

  /// Возвращает полное квалифицированное имя переменной
  String get qualifiedName => parentName != null ? '$parentName.$name' : name;

  /// Параметры типа (для дженериков)
  List<String>? get typeParameters =>
      attributes != null && attributes!.containsKey('typeParameters')
          ? List<String>.from(attributes!['typeParameters'])
          : null;

  /// Возвращаемый тип (для совместимости с DeclarationInfo)
  String? get returnType =>
      attributes != null ? attributes!['returnType'] as String? : null;
}

/// Расширение для обеспечения совместимости с интерфейсом DeclarationInfo
extension VariableInfoAsDeclarationInfo on VariableInfo {
  /// Преобразует VariableInfo в DeclarationInfo
  T as<T>() {
    if (T == DeclarationInfo) {
      return toDeclarationInfo() as T;
    }
    throw ArgumentError('Cannot convert VariableInfo to $T');
  }
}
