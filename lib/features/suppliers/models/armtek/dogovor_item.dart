// filepath: c:\FlutterProject\part_catalog\lib\features\suppliers\models\armtek\dogovor_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/core/utils/default_to_bool_converter.dart';

part 'dogovor_item.freezed.dart';
part 'dogovor_item.g.dart';

@freezed
abstract class DogovorItem with _$DogovorItem {
  const factory DogovorItem({
    @JsonKey(name: 'VBELN') String? vbeln,
    @JsonKey(name: 'BSTKD') String? bstkd,
    @JsonKey(name: 'BSTKDT') String? bstkdt,
    @JsonKey(name: 'BSTDK') String? bstdk,
    @JsonKey(name: 'DATBI') String? datbi,
    @DefaultToBoolConverter() @JsonKey(name: 'DEFAULT') bool? defaultFlag,
    @JsonKey(name: 'AUART') String? auart,
    @JsonKey(name: 'KLIMK') String? klimk,
    @JsonKey(name: 'KLIMKU') String? klimku,
    @JsonKey(name: 'OEIKW') String? oeikw,
    @JsonKey(name: 'WAERS') String? waers,
    @JsonKey(name: 'SCALE_TAB')
    List<dynamic>? scaleTab, // Структура неизвестна, пока dynamic
  }) = _DogovorItem;

  factory DogovorItem.fromJson(Map<String, dynamic> json) =>
      _$DogovorItemFromJson(json);
}
