import 'package:freezed_annotation/freezed_annotation.dart';

part 'part_info.freezed.dart';
part 'part_info.g.dart';

/// {@template part_info}
/// Информация о директиве part в Dart файле
/// {@endtemplate}
@freezed
class PartInfo with _$PartInfo {
  const PartInfo._();

  /// {@macro part_info}
  const factory PartInfo({
    /// Путь к исходному файлу, содержащему директиву part
    @JsonKey(name: 'source_file') required String sourceFile,

    /// Путь к целевому файлу, на который указывает директива part
    @JsonKey(name: 'target_file') required String targetFile,

    /// Оригинальный URI директивы part
    @JsonKey(name: 'uri') required String uri,

    /// Смещение директивы в исходном коде (позиция начала в символах)
    @JsonKey(name: 'offset') int? offset,

    /// Длина директивы в исходном коде (количество символов)
    @JsonKey(name: 'length') int? length,
  }) = _PartInfo;

  /// Создает объект из JSON
  factory PartInfo.fromJson(Map<String, dynamic> json) =>
      _$PartInfoFromJson(json);
}
