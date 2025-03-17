import 'package:freezed_annotation/freezed_annotation.dart';
import 'annotation_info.dart';
import 'source_location.dart';

part 'enum_constant_info.freezed.dart';
part 'enum_constant_info.g.dart';

/// {@template enum_constant_info}
/// Информация о константе перечисления (элементе enum).
/// {@endtemplate}
@freezed
class EnumConstantInfo with _$EnumConstantInfo {
  const EnumConstantInfo._();

  /// {@macro enum_constant_info}
  const factory EnumConstantInfo({
    /// Имя константы перечисления
    @JsonKey(name: 'name') required String name,

    /// Значение константы (если указано в enum с явными значениями)
    @JsonKey(name: 'value') String? value,

    /// Документация для константы
    @JsonKey(name: 'documentation') String? documentation,

    /// Имя родительского перечисления
    @JsonKey(name: 'parent_name') required String parentName,

    /// Положение константы в коде
    @JsonKey(name: 'location') required SourceLocation location,

    /// Аннотации константы
    @JsonKey(name: 'annotations') @Default([]) List<AnnotationInfo> annotations,

    /// Путь к файлу, содержащему константу
    @JsonKey(name: 'file_path') String? filePath,

    /// Индекс константы в перечислении (порядковый номер)
    @JsonKey(name: 'index') required int index,

    /// Дополнительные метаданные константы
    @JsonKey(name: 'metadata') @Default({}) Map<String, dynamic> metadata,
  }) = _EnumConstantInfo;

  /// Создает экземпляр из JSON
  factory EnumConstantInfo.fromJson(Map<String, dynamic> json) =>
      _$EnumConstantInfoFromJson(json);

  /// Получает строковое представление константы
  @override
  String toString() {
    final result = StringBuffer(name);

    if (value != null) {
      result.write(' = $value');
    }

    return result.toString();
  }

  /// Возвращает полное квалифицированное имя константы
  String get qualifiedName => '$parentName.$name';
}
