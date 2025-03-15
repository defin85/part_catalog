import 'package:freezed_annotation/freezed_annotation.dart';
import 'ast_node.dart';
import 'declaration_info.dart';
import 'source_location.dart';

part 'variable_info.freezed.dart';
part 'variable_info.g.dart';

/// {@template variable_info}
/// Информация о переменной в коде.
/// {@endtemplate}
@freezed
class VariableInfo with _$VariableInfo implements DeclarationInfo {
  /// {@macro variable_info}
  const factory VariableInfo({
    /// Имя переменной
    @JsonKey(name: 'name') required String name,

    /// Тип переменной
    @JsonKey(name: 'type') required String type,

    /// Является ли константой
    @JsonKey(name: 'is_const', defaultValue: false)
    @Default(false)
    bool isConst,

    /// Является ли final
    @JsonKey(name: 'is_final', defaultValue: false)
    @Default(false)
    bool isFinal,

    /// Является ли static
    @JsonKey(name: 'is_static', defaultValue: false)
    @Default(false)
    bool isStatic,

    /// Имеет ли модификатор late
    @JsonKey(name: 'is_late', defaultValue: false) @Default(false) bool isLate,

    /// Начальное значение переменной (если есть)
    @JsonKey(name: 'initial_value') String? initialValue,

    /// Документация к переменной
    @JsonKey(name: 'documentation') String? documentation,

    /// Положение в коде
    @JsonKey(name: 'location') SourceLocation? location,

    /// Аннотации переменной
    @JsonKey(name: 'annotations', defaultValue: [])
    @Default([])
    List<String> annotations,

    /// Путь к файлу, содержащему переменную
    @JsonKey(name: 'file_path') String? filePath,

    /// Является ли переменная публичной
    @JsonKey(name: 'is_public', defaultValue: true)
    @Default(true)
    bool isPublic,

    /// Атрибуты переменной
    @JsonKey(name: 'attributes', defaultValue: {})
    @Default({})
    Map<String, dynamic> attributes,
  }) = _VariableInfo;

  /// Создает экземпляр из JSON
  factory VariableInfo.fromJson(Map<String, dynamic> json) =>
      _$VariableInfoFromJson(json);

  const VariableInfo._();

  /// Тип узла
  @override
  @JsonKey(ignore: true)
  String get nodeType => 'variable';
}
