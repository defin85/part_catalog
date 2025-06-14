// filepath: c:\FlutterProject\part_catalog\lib\features\suppliers\models\armtek\exw_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exw_item.freezed.dart';
part 'exw_item.g.dart';

@freezed
abstract class ExwItem with _$ExwItem {
  const factory ExwItem({
    @JsonKey(name: 'ID') String? id,
    @JsonKey(name: 'NAME') String? name,
  }) = _ExwItem;

  factory ExwItem.fromJson(Map<String, dynamic> json) =>
      _$ExwItemFromJson(json);
}
