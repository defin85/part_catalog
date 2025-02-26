import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

/// {@template model}
/// Модель данных для модели автомобиля.
/// {@endtemplate}
@freezed
class Model with _$Model {
  /// {@macro model}
  factory Model({
    /// Идентификатор модели.
    @JsonKey(name: 'id') required String id,

    /// Название модели.
    @JsonKey(name: 'name') required String name,

    /// URL изображения модели.
    @JsonKey(name: 'img') String? img,
  }) = _Model;

  /// Преобразует JSON в объект [Model].
  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
}
