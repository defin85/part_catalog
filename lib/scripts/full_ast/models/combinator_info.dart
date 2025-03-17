import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/scripts/full_ast/models/source_location.dart';

part 'combinator_info.freezed.dart';
part 'combinator_info.g.dart';

/// {@template combinator_info}
/// Информация о комбинаторе импорта (show/hide).
///
/// Комбинаторы используются в директивах импорта для контроля видимости
/// импортируемых символов.
/// {@endtemplate}
@freezed
class CombinatorInfo with _$CombinatorInfo {
  /// {@macro combinator_info}
  const factory CombinatorInfo({
    /// Тип комбинатора:
    /// - "show" - показать только указанные символы
    /// - "hide" - скрыть указанные символы
    @JsonKey(name: 'type') required String type,

    /// Имена символов, к которым применяется комбинатор
    @JsonKey(name: 'names') required List<String> names,

    /// Начальная позиция комбинатора в файле
    @JsonKey(name: 'offset', includeIfNull: false) int? offset,

    /// Позиция в исходном коде
    @JsonKey(name: 'location', includeIfNull: false) SourceLocation? location,
  }) = _CombinatorInfo;

  /// Создает объект из JSON
  factory CombinatorInfo.fromJson(Map<String, dynamic> json) =>
      _$CombinatorInfoFromJson(json);
}

/// Вспомогательное расширение для работы с комбинаторами
extension CombinatorInfoExtension on CombinatorInfo {
  /// Проверяет, является ли комбинатор типа 'show'
  bool get isShow => type == 'show';

  /// Проверяет, является ли комбинатор типа 'hide'
  bool get isHide => type == 'hide';

  /// Создает строковое представление комбинатора в формате Dart
  String toDartCode() {
    return '$type ${names.join(', ')}';
  }
}
