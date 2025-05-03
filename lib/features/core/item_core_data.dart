import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/core/base_item_type.dart';

part 'item_core_data.freezed.dart';
part 'item_core_data.g.dart';

/// Базовые данные для всех элементов табличных частей
@freezed
abstract class ItemCoreData with _$ItemCoreData {
  const factory ItemCoreData({
    required String uuid,
    required String name,
    required BaseItemType itemType,
    @Default(0) int lineNumber,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
  }) = _ItemCoreData;

  factory ItemCoreData.fromJson(Map<String, dynamic> json) =>
      _$ItemCoreDataFromJson(json);
}
