import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_core_data.freezed.dart';
part 'entity_core_data.g.dart';

/// Базовые данные для всех сущностей
@freezed
abstract class EntityCoreData with _$EntityCoreData {
  const factory EntityCoreData({
    required String uuid,
    required String code,
    required String displayName,
    required DateTime createdAt,
    DateTime? modifiedAt,
    DateTime? deletedAt,
    @Default(false) bool isDeleted,
  }) = _EntityCoreData;

  factory EntityCoreData.fromJson(Map<String, dynamic> json) =>
      _$EntityCoreDataFromJson(json);
}
