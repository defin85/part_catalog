import 'package:freezed_annotation/freezed_annotation.dart';
import 'source_location.dart';

part 'annotation_info.freezed.dart';
part 'annotation_info.g.dart';

/// {@template annotation_info}
/// Информация об аннотации
/// {@endtemplate}
@freezed
class AnnotationInfo with _$AnnotationInfo {
  const AnnotationInfo._();

  /// {@macro annotation_info}
  const factory AnnotationInfo({
    /// Имя аннотации
    @JsonKey(name: 'name') required String name,

    /// Аргументы аннотации
    @JsonKey(name: 'arguments') String? arguments,

    /// Местоположение в коде
    @JsonKey(name: 'location') SourceLocation? location,
  }) = _AnnotationInfo;

  /// Создает объект информации об аннотации из JSON
  factory AnnotationInfo.fromJson(Map<String, dynamic> json) =>
      _$AnnotationInfoFromJson(json);

  @override
  String toString() => arguments != null ? '$name($arguments)' : name;
}
