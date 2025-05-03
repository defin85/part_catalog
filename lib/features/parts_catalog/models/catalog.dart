import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog.freezed.dart';
part 'catalog.g.dart';

/// {@template catalog}
/// Модель данных для каталога.
/// {@endtemplate}
@freezed
abstract class Catalog with _$Catalog {
  /// {@macro catalog}
  factory Catalog({
    /// Идентификатор каталога.
    @JsonKey(name: 'id') required String id,

    /// Название каталога.
    @JsonKey(name: 'name') required String name,

    /// Количество моделей в каталоге.
    @JsonKey(name: 'models_count') required int modelsCount,
  }) = _Catalog;

  /// Преобразует JSON в объект [Catalog].
  factory Catalog.fromJson(Map<String, dynamic> json) =>
      _$CatalogFromJson(json);
}
