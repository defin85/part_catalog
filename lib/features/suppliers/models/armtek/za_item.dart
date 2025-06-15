// filepath: c:\FlutterProject\part_catalog\lib\features\suppliers\models\armtek\za_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/core/utils/default_to_bool_converter.dart';

part 'za_item.freezed.dart';
part 'za_item.g.dart';

@freezed
abstract class ZaItem with _$ZaItem {
  const factory ZaItem({
    @JsonKey(name: 'KUNNR') String? kunnr,
    @DefaultToBoolConverter() @JsonKey(name: 'DEFAULT') bool? defaultFlag,
    @JsonKey(name: 'SNAME') String? sname,
    @JsonKey(name: 'FNAME') String? fname,
    @JsonKey(name: 'ADRESS') String? adress,
    @JsonKey(name: 'PHONE') String? phone,
  }) = _ZaItem;

  factory ZaItem.fromJson(Map<String, dynamic> json) => _$ZaItemFromJson(json);
}
